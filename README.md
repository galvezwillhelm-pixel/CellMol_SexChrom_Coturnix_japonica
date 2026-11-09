# Sex-Chromosome Dosage in Japanese Quail

## Project Overview

This project investigates sex-chromosome dosage in the Japanese quail (*Coturnix japonica*) using whole-genome sequencing (WGS) read depth.

The analysis combines:

- **NCBI** for genome assembly and sequencing metadata
- **Galaxy** for sequencing quality control, read alignment, and chromosome-level coverage analysis
- **R** for read-depth normalization and sex-chromosome dosage inference

## Study Question

Can whole-genome sequencing read depth distinguish the expected sex-chromosome complement of a Japanese quail (*Coturnix japonica*) with a ZZ/ZW sex-determination system?

---

## Selected Organism and Genome

- **Species:** *Coturnix japonica* (Japanese quail)
- **Sex-determination system:** ZZ/ZW
- **Assembly:** *Coturnix japonica* 2.1
- **Assembly accession:** GCF_001577835.2
- **Assembly BioSample:** SAMN03989050
- **WGS run:** SRR2162767
- **WGS BioSample:** SAMN03989050
- **Assembly/WGS donor:** Same BioSample
- **Recorded WGS donor sex:** Male

The Japanese quail has a ZZ/ZW sex-determination system. In this system, males are expected to be ZZ and females are expected to be ZW. Therefore, a male WGS sample should show approximately two copies of the Z chromosome relative to the autosomal haploid-equivalent depth, producing a Z:A ratio near 1.0.

---

## Research Principle

Sex-chromosome dosage was estimated from sequencing read depth rather than chromosome size.

For a normally diploid ZZ/ZW animal:

- **ZZ individual:** Z:A is expected to be approximately 1.0
- **ZW individual:** Z:A is expected to be approximately 0.5

The analysis therefore compares the median sequencing depth of selected autosomes with the mean depth of the Z chromosome.

The classroom R analysis uses:

- **Z/A ≥ 0.80:** ZZ-like
- **Z/A ≤ 0.65:** ZW-like
- **Between 0.65 and 0.80:** Ambiguous

These are classroom interpretation guidelines rather than diagnostic biological thresholds.

---

# Methods

## 1. NCBI Genome and WGS Selection

A chromosome-level *Coturnix japonica* genome assembly was selected from NCBI.

The selected assembly was:

**GCF_001577835.2 — *Coturnix japonica* 2.1**

The assembly is chromosome-level and contains annotated chromosome sequences, including the Z chromosome.

The WGS dataset was:

**SRR2162767**

The assembly and WGS reads have the same BioSample:

**SAMN03989050**

Therefore, the sequencing reads correspond to the same donor represented by the selected assembly.

---

## 2. Galaxy History

A Galaxy history named:

**Sex_Dosage_Coturnix_japonica**

was used for the analysis.

The reference genome and WGS reads were imported into Galaxy.

The WGS reads were analyzed individually rather than pooled with another individual.

---

## 3. Read Quality Control

FastQC was used to assess sequencing read quality before alignment.

The FastQC outputs were retained as part of the Galaxy analysis record.

The quality-control step was used to check the sequencing reads before downstream alignment and coverage analysis.

---

## 4. Read Alignment

The WGS reads were aligned to the same *Coturnix japonica* reference assembly using:

**BWA-MEM2**

The resulting alignment was retained as a BAM file.

The BAM alignment was used for downstream alignment statistics and chromosome-level coverage analysis.

---

## 5. Alignment Statistics

Samtools flagstat was used to summarize the alignment.

The analysis produced approximately:

- **148,638,429 total reads**
- **145,139,662 mapped reads**
- **97.65% mapped**
- **121,281,372 reads paired in sequencing**
- **85,763,038 properly paired reads**

These statistics indicate that the majority of the WGS reads successfully mapped to the reference genome.

---

## 6. Chromosome-Level Coverage

Samtools coverage was applied to the BAM alignment.

The following filtering parameters were used:

- Minimum mapping quality: **20**
- Minimum base quality: **20**
- Excluded unmapped reads
- Excluded non-primary alignments
- Excluded reads failing platform/vendor quality checks
- Excluded PCR or optical duplicates
- Tabular output

The resulting coverage table was downloaded as:

`chromosome_coverage.tsv`

The table contains chromosome identifiers and mean sequencing depth values.

---

## 7. Chromosome Grouping

The chromosome grouping file was created as:

`chromosome_groups.csv`

The first line follows the required format:

`rname,group`

Five autosomal chromosomes were selected:

- NC_029516.1 → A
- NC_029517.1 → A
- NC_029518.1 → A
- NC_029519.1 → A
- NC_029520.1 → A

The Z chromosome was identified as:

- NC_029547.1 → Z

The chromosome identifiers were taken directly from the reference/coverage data so that the names matched the BAM and Samtools coverage output.

Mitochondrial, unplaced, and alternate sequences were not used as autosomes.

---

# R Analysis

The analysis was performed using base R through:

`sex_depth_analysis.R`

The script:

1. Reads the chromosome coverage table.
2. Reads the chromosome grouping table.
3. Identifies the autosomal group and Z chromosome.
4. Calculates the median autosomal sequencing depth.
5. Calculates relative chromosome depth.
6. Calculates the Z:A ratio.
7. Classifies the dosage pattern as ZZ-like, ZW-like, or ambiguous.
8. Generates output files in the `results/` directory.

The complete R script is available in:

`sex_depth_analysis.R`

---

# Results

## Median Autosome Depth

**8.372**

The median depth across the five selected autosomes was 8.372.

## Z-Chromosome Depth

Mean Z-chromosome depth:

**9.13515**

## Z:A Ratio

**1.091**

Calculation:

**Z/A = 9.13515 / 8.372 ≈ 1.091**

## W:A Ratio

**NA**

No W chromosome was included in the reference chromosome grouping used for this analysis.

## Dosage Interpretation

**ZZ-like**

The observed Z:A ratio of 1.091 is close to the expected value of approximately 1.0 for a ZZ individual and is well above the classroom threshold for a ZW-like individual.

Therefore, the sequencing-depth evidence supports a:

**ZZ-like sex-chromosome complement**

---

# Chromosome Relative Depth

The R analysis produced the following normalized values:

| Chromosome | Group | Mean Depth | Relative Depth |
|---|---|---:|---:|
| NC_029516.1 | A | 8.37246 | 1.000 |
| NC_029517.1 | A | 9.67596 | 1.156 |
| NC_029518.1 | A | 8.26285 | 0.987 |
| NC_029519.1 | A | 8.40286 | 1.004 |
| NC_029520.1 | A | 8.24787 | 0.985 |
| NC_029547.1 | Z | 9.13515 | 1.091 |

The Z chromosome therefore shows a relative depth of approximately **1.09**, consistent with the expected dosage pattern of a ZZ individual.

---

# Comparison With Recorded Sex

The WGS BioSample is recorded as **male**.

The Japanese quail ZZ/ZW system predicts:

- Male → ZZ
- Female → ZW

The read-depth analysis produced a **ZZ-like** result.

Therefore, the sequence-based inference agrees with the recorded male sex of the WGS donor.

Because the assembly and WGS data share the same BioSample, the comparison is appropriate for this analysis.

---

# Answers to the Required Questions

## 1. What species did you choose, and what evidence supports a diploid ZZ/ZW system?

The selected species was the Japanese quail, *Coturnix japonica*. It has a ZZ/ZW sex-determination system in which males are ZZ and females are ZW. The selected NCBI genome assembly specifically identifies a Z chromosome, providing chromosome-level evidence for the sex-chromosome analysis.

## 2. What are your assembly accession, WGS run, and both BioSample accessions? Are the donors the same?

The assembly accession is **GCF_001577835.2** and the WGS run is **SRR2162767**.

The assembly BioSample is **SAMN03989050**, and the WGS BioSample is also **SAMN03989050**.

Therefore, the assembly and WGS data represent the **same BioSample/donor**.

## 3. Which sequences were used as autosomes and as Z? How did you verify their identities?

Five autosomes were used:

- NC_029516.1
- NC_029517.1
- NC_029518.1
- NC_029519.1
- NC_029520.1

The Z chromosome was:

- NC_029547.1

The chromosome identities were verified using the NCBI chromosome-level assembly information and the exact sequence identifiers appearing in the Galaxy Samtools coverage output. These exact `rname` values were then used in `chromosome_groups.csv`.

## 4. What are the median autosomal depth, Z:A ratio, and inferred sex-chromosome complement?

The median autosomal depth was **8.372**.

The Z chromosome had a mean depth of **9.13515**.

The resulting Z:A ratio was **1.091**.

This produces a **ZZ-like** dosage interpretation.

## 5. Does your result agree with the recorded sex of the WGS donor?

Yes.

The WGS BioSample is recorded as **male**, while the read-depth analysis produced a **ZZ-like** result.

This is biologically consistent with the ZZ/ZW sex-determination system because male Japanese quail are expected to have a ZZ sex-chromosome complement.

The result should still be interpreted as a read-depth inference rather than an absolute diagnostic determination.

## 6. Why is a chromosome-level assembly alone insufficient for reliable read-depth sex inference?

A chromosome-level assembly shows the organization and sequence representation of the reference genome, but it does not establish the chromosome complement of the individual whose DNA is being analyzed.

Sex-chromosome dosage requires sequencing reads from an individual to measure relative read depth across autosomes and the sex chromosome.

For example, a reference assembly may contain a Z chromosome regardless of whether the sequenced individual is ZZ or ZW. Therefore, the assembly alone cannot distinguish the individual's sex-chromosome complement.

Read-depth analysis provides individual-level evidence by measuring how many sequencing reads map to the Z chromosome relative to autosomes.

---

# Limitations

Several biological and technical factors can affect sex-chromosome read-depth estimates.

1. **Low sequencing depth** can increase sampling variation and make chromosome ratios less stable.
2. **Mapping bias** can alter the number of reads assigned to particular chromosomes.
3. **Repetitive sequences** may produce ambiguous alignments.
4. **Pseudoautosomal or homologous regions** may have different mapping behavior.
5. **Reference assembly errors** can influence chromosome-level coverage.
6. **Incomplete W chromosome representation** can make W-depth interpretation difficult.
7. The Z:A ratio is influenced by the quality and composition of the selected reference and sequencing data.
8. A near-zero W depth alone does not prove biological absence of a W chromosome.
9. The classroom cutoffs are guidelines for interpretation and are not diagnostic thresholds.
10. The analysis estimates chromosome dosage from sequencing depth; it does not replace cytogenetic or molecular validation.

The conclusion should therefore be stated as a **ZZ-like read-depth inference**, rather than an absolute cytogenetic determination.

---

# Files in This Repository

```text
CellMol_SexChrom_Coturnix_japonica/
│
├── README.md
├── chromosome_coverage.tsv
├── chromosome_groups.csv
├── sex_depth_analysis.R
│
├── results/
│   ├── chromosome_depth.png
│   ├── chromosome_relative_depth.csv
│   └── sex_inference.txt
│
└── screenshots/
    └── Coturnix_Galaxy_R_analysis_screenshots_compiled.png
```

Large raw sequencing and alignment files were not uploaded to GitHub.

---

# Reproducibility

The analysis can be reproduced using:

1. The same NCBI assembly accession.
2. The same WGS run accession.
3. The same chromosome grouping file.
4. The provided `chromosome_coverage.tsv`.
5. The provided `sex_depth_analysis.R` script.

The Galaxy workflow and analysis screenshots document the major computational steps used to generate the coverage data.

---

# Conclusion

Whole-genome sequencing read depth successfully distinguished a **ZZ-like sex-chromosome dosage pattern** in the selected Japanese quail sample.

The median autosomal depth was **8.372**, while the Z chromosome had a mean depth of **9.13515**, producing a **Z:A ratio of 1.091**.

This ratio is consistent with the expected approximately 1:1 Z-to-autosome dosage relationship of a **ZZ individual**. The inference agrees with the **male** sex recorded in the WGS BioSample.

Thus, the read-depth analysis supports the conclusion that the sequenced Japanese quail individual has a **ZZ-like sex-chromosome complement**.

---

# References

- NCBI Genome / Datasets — *Coturnix japonica* genome assembly.
- NCBI Sequence Read Archive (SRA) — WGS run SRR2162767.
- Galaxy Project — sequencing quality control and read-alignment workflow.
- Samtools — chromosome-level alignment and coverage statistics.
- R — base R statistical analysis and visualization.
- Course laboratory activity: **Sex-Chromosome Dosage in a Selected Animal Nuclear Genome Using NCBI, Galaxy, and R**.
