# Sex-chromosome dosage from whole-genome DNA read depth
# Species: Coturnix japonica
# Sex system: ZZ/ZW

# ---------------------------------------------------------
# 1. Read Samtools coverage output
# ---------------------------------------------------------

cov <- read.delim(
  "chromosome_coverage.tsv",
  comment.char = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Accept "#rname" header
names(cov)[1] <- "rname"

if (!"meandepth" %in% names(cov)) {
  stop("Missing meandepth column")
}

# ---------------------------------------------------------
# 2. Read chromosome group labels
# ---------------------------------------------------------

key <- read.csv(
  "chromosome_groups.csv",
  stringsAsFactors = FALSE
)

if (!all(c("rname", "group") %in% names(key))) {
  stop("Bad key columns")
}

key$rname <- trimws(key$rname)
key$group <- toupper(trimws(key$group))

if (anyDuplicated(key$rname)) {
  stop("Repeated rname in key file")
}

if (!all(key$group %in% c("A", "X", "Y", "Z", "W"))) {
  stop("Use only A, X, Y, Z or W in the group column")
}

# ---------------------------------------------------------
# 3. Merge chromosome labels with coverage
# ---------------------------------------------------------

x <- merge(
  key,
  cov[, c("rname", "meandepth")],
  by = "rname",
  all.x = TRUE,
  sort = FALSE
)

x$meandepth <- suppressWarnings(as.numeric(x$meandepth))

if (anyNA(x$meandepth)) {
  stop("Missing depths: check rname matches")
}

if (any(x$meandepth < 0)) {
  stop("Negative depth is not valid")
}

if (sum(x$group == "A") < 5) {
  stop("Label at least 5 autosomes")
}

if ("X" %in% x$group && "Z" %in% x$group) {
  stop("Choose either an XY or a ZW species, not both")
}

# ---------------------------------------------------------
# 4. Determine sex-chromosome system
# ---------------------------------------------------------

if (sum(x$group == "X") == 1 && !any(x$group == "Z")) {

  target <- "X"
  one_copy <- "XY-like"
  two_copies <- "XX-like"

} else if (sum(x$group == "Z") == 1 && !any(x$group == "X")) {

  target <- "Z"
  one_copy <- "ZW-like"
  two_copies <- "ZZ-like"

} else {

  stop("Label exactly one X or exactly one Z chromosome")
}

# ---------------------------------------------------------
# 5. Calculate median autosomal depth
# ---------------------------------------------------------

A <- median(x$meandepth[x$group == "A"])

if (!is.finite(A) || A <= 0) {
  stop("No usable autosomal coverage")
}

# Relative depth of each chromosome
x$relative_depth <- x$meandepth / A

# ---------------------------------------------------------
# 6. Calculate Z:A or X:A ratio
# ---------------------------------------------------------

ratio <- x$relative_depth[x$group == target]

# ---------------------------------------------------------
# 7. Infer chromosome dosage
# ---------------------------------------------------------

if (ratio >= 0.80) {

  call <- two_copies

} else if (ratio <= 0.65) {

  call <- one_copy

} else {

  call <- "Ambiguous"
}

if (A < 1) {
  call <- "Inconclusive: very low autosomal depth"
}

# ---------------------------------------------------------
# 8. Check optional Y/W chromosome
# ---------------------------------------------------------

partner <- if (target == "X") "Y" else "W"

if (partner %in% x$group) {

  partner_ratio <- x$relative_depth[x$group == partner][1]

} else {

  partner_ratio <- NA_real_
}

# ---------------------------------------------------------
# 9. Create results folder
# ---------------------------------------------------------

dir.create(
  "results",
  showWarnings = FALSE
)

# ---------------------------------------------------------
# 10. Save chromosome relative-depth table
# ---------------------------------------------------------

write.csv(
  x,
  "results/chromosome_relative_depth.csv",
  row.names = FALSE
)

# ---------------------------------------------------------
# 11. Create figure
# ---------------------------------------------------------

png(
  "results/chromosome_depth.png",
  width = 1000,
  height = 580
)

par(
  mar = c(8, 4, 3, 1)
)

barplot(
  x$relative_depth,
  names.arg = x$rname,
  las = 2,
  ylab = "Depth relative to median autosome",
  main = "Autosomal and sex-chromosome depth",
  cex.names = 0.75
)

abline(
  h = c(0.5, 1.0),
  lty = 2
)

dev.off()

# ---------------------------------------------------------
# 12. Prepare summary
# ---------------------------------------------------------

summary <- c(
  paste(
    "Median autosome depth:",
    round(A, 3)
  ),

  paste(
    target,
    "/ A ratio:",
    round(ratio, 3)
  ),

  paste(
    partner,
    "/ A ratio:",
    round(partner_ratio, 3)
  ),

  paste(
    "Dosage interpretation:",
    call
  ),

  "Compare with BioSample sex and discuss limitations."
)

# ---------------------------------------------------------
# 13. Save inference text
# ---------------------------------------------------------

writeLines(
  summary,
  "results/sex_inference.txt"
)

# ---------------------------------------------------------
# 14. Print results in PowerShell
# ---------------------------------------------------------

cat(
  paste(summary, collapse = "\n"),
  "\n"
)