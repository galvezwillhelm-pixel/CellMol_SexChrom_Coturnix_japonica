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
- **Recorded BioSample sex:** Male

The assembly is chromosome-level and contains chromosome sequences that were used as the reference for read mapping and coverage analysis.

---

## NCBI Genome Evidence

The NCBI assembly record identifies the selected genome as a chromosome-level assembly of *Coturnix japonica*. The assembly contains chromosome sequences including the Z chromosome.

For this analysis, the chromosome identifiers used in the coverage table were:

| Chromosome | NCBI sequence accession | Group |
|---|---|---|
| Chromosome 1 | NC_029516.1 | A |
| Chromosome 2 | NC_029517.1 | A |
| Chromosome 3 | NC_029518.1 | A |
| Chromosome 4 | NC_029519.1 | A |
| Chromosome 5 | NC_029520.1 | A |
| Z chromosome | NC_029547.1 | Z |

The five autosomes were used to estimate the baseline autosomal sequencing depth. The Z chromosome was then compared against this autosomal baseline.

The W chromosome was not included because the selected BioSample is male and therefore expected to have a ZZ complement.

---

## Galaxy Analysis

### Galaxy History

**Galaxy history:**  
(https://usegalaxy.org/u/galvezwillhelm/h/sex-dosage-coturnix-japonica)`

### Analysis workflow

The analysis was performed using the following sequence:

1. Imported the reference genome and WGS reads into Galaxy.
2. Performed **FastQC** on the sequencing reads.
3. Aligned the WGS reads to the selected *C. japonica* reference genome using **BWA-MEM2**.
4. Generated a mapped-read BAM file.
5. Used **Samtools flagstat** to summarize alignment statistics.
6. Used **Samtools idxstats** to examine mapped reads by reference sequence.
7. Used **Samtools coverage** to calculate chromosome-level sequencing depth.
8. Exported the coverage table as `chromosome_coverage.tsv`.
9. Used the exact reference sequence identifiers from the coverage output to construct `chromosome_groups.csv`.

### Alignment statistics

Samtools flagstat reported:

- Total reads: **1,486,384,290**
- Primary reads: **1,212,813,712**
- Mapped reads: **1,451,396,622**
- Mapping rate: **97.12%**
- Properly paired reads: **857,608,338**
- Properly paired percentage: **70.71%**

The high mapping percentage indicates that most sequencing reads aligned to the selected reference genome.

---

## Chromosome Grouping

The file `chromosome_groups.csv` assigns reference sequences to the groups required for the dosage analysis.

The grouping used:

```text
rname,group
NC_029516.1,A
NC_029517.1,A
NC_029518.1,A
NC_029519.1,A
NC_029520.1,A
NC_029547.1,Z
```

The five autosomes provide the autosomal depth baseline, while `NC_029547.1` represents the Z chromosome.

The analysis uses the exact sequence identifiers returned by Samtools coverage to prevent chromosome-name mismatches.

---

## R Analysis

The analysis was performed using base R through:

```text
Rscript sex_depth_analysis.R
```

The script:

1. Reads the chromosome coverage table.
2. Reads the chromosome-group assignments.
3. Calculates the median autosomal sequencing depth.
4. Calculates relative depth for each chromosome.
5. Calculates the Z-to-autosome depth ratio.
6. Classifies the sample as ZZ-like, ZW-like, or ambiguous.
7. Produces a chromosome-depth figure and result files.

### Dosage calculation

The autosomal baseline was calculated as the median mean depth of the chromosomes classified as autosomes.

The sex-chromosome dosage ratio was calculated as:

```text
Z/A = Z chromosome mean depth / median autosomal depth
```

---

## Results

### Chromosome-level depth

| Reference sequence | Group | Mean depth | Relative depth |
|---|---|---:|---:|
| NC_029516.1 | A | 8.37246 | 1.000 |
| NC_029517.1 | A | 9.67596 | 1.156 |
| NC_029518.1 | A | 8.26285 | 0.987 |
| NC_029519.1 | A | 8.40286 | 1.004 |
| NC_029520.1 | A | 8.24787 | 0.985 |
| NC_029547.1 | Z | 9.13515 | 1.091 |

### Main result

- **Median autosomal depth:** 8.372×
- **Z chromosome depth:** 9.135×
- **Z/A ratio:** **1.091**
- **W/A ratio:** NA
- **Dosage interpretation:** **ZZ-like**

The Z chromosome has approximately the same sequencing depth as the autosomal baseline. A Z:A ratio near 1 is expected for a ZZ individual because a male ZZ individual carries two copies of the Z chromosome.

The observed ratio of **1.091** therefore supports a **ZZ-like chromosome complement**.

---

## Comparison With BioSample Metadata

The WGS BioSample is recorded as **male**.

The read-depth analysis independently produced a **ZZ-like** dosage interpretation.

These two observations are concordant:

```text
BioSample metadata → Male
        ↓
Expected complement → ZZ
        ↓
Observed Z/A ratio → 1.091
        ↓
Read-depth inference → ZZ-like
```

The metadata therefore provides independent validation of the sequence-based inference.

---

## Interpretation

The analysis supports the conclusion that the selected Japanese quail WGS sample has a **ZZ-like sex-chromosome complement**.

The Z chromosome had a relative sequencing depth of approximately **1.09× the autosomal baseline**, rather than approximately 0.5×. This is consistent with the presence of two Z chromosomes in a ZZ individual.

The absence of a W/A estimate (`NA`) is not interpreted as evidence of a particular dosage by itself. The selected sample is recorded as male, and the analysis focused on Z dosage.

---

## Answers to the Laboratory Questions

### 1. What evidence supports the species and sex-determination system?

The selected organism is *Coturnix japonica* (Japanese quail), using the NCBI chromosome-level genome assembly *Coturnix japonica* 2.1. Japanese quail uses a ZZ/ZW sex-determination system. The analysis therefore uses the Z chromosome as the sex chromosome of interest.

### 2. What are the assembly and WGS accessions, and are they from the same donor?

The assembly accession is **GCF_001577835.2**, with assembly BioSample **SAMN03989050**. The WGS run is **SRR2162767**, with WGS BioSample **SAMN03989050**. Because both use the same BioSample accession, the assembly and WGS data represent the same recorded donor.

The BioSample records the individual as **male**.

### 3. Which chromosome sequences were used and how were they verified?

The analysis used five autosomal reference sequences:

- NC_029516.1
- NC_029517.1
- NC_029518.1
- NC_029519.1
- NC_029520.1

The Z chromosome was:

- NC_029547.1

These identifiers were taken from the reference/coverage sequence names and used exactly in `chromosome_groups.csv` to ensure that the grouping matched the BAM/coverage reference names.

### 4. What was the median autosomal depth and Z:A ratio?

The median autosomal depth was **8.372×**.

The Z chromosome had a mean depth of **9.135×**.

Therefore:

```text
Z/A = 9.13515 / 8.37246
    = 1.091
```

The resulting dosage interpretation was **ZZ-like**.

### 5. Does the read-depth result agree with the recorded sex?

Yes. The BioSample records the individual as **male**, while the sequencing read-depth analysis produces a **ZZ-like** interpretation.

For a ZZ/ZW system, a male is expected to have two Z chromosomes. The observed Z:A ratio of 1.091 is therefore consistent with the recorded sex.

### 6. Why is assembly information alone insufficient to infer the individual's sex?

An assembly represents a reference genome and does not by itself establish the sex of every individual whose reads are later analyzed. Sex-chromosome dosage must be evaluated using sequencing evidence from the actual WGS sample.

In this analysis, chromosome-level read depth provides quantitative evidence from the WGS data. The Z:A ratio is therefore more informative for determining the chromosome complement of the sequenced individual than simply observing that a Z chromosome exists in the reference assembly.

---

## Limitations

Several biological and technical factors can affect sex-chromosome read-depth inference:

- Low sequencing depth can increase stochastic variation.
- Repetitive sequences can produce mapping bias.
- Differences in chromosome composition can affect alignment efficiency.
- Pseudoautosomal or homologous regions may complicate interpretation.
- Poorly differentiated sex chromosomes can reduce the distinction between sex-chromosome and autosomal coverage.
- Missing or poorly assembled sex-chromosome regions can alter the estimated depth.
- Reference-genome errors can influence mapping and coverage.
- Unusual karyotypes or structural variation may produce unexpected ratios.

The classroom dosage thresholds are guidelines rather than diagnostic thresholds. Therefore, the result should be interpreted together with the sequencing data, reference assembly, and BioSample metadata.

---

## Files

```text
CellMol_SexChrom_Coturnix_japonica/
├── README.md
├── chromosome_coverage.tsv
├── chromosome_groups.csv
├── sex_depth_analysis.R
└── results/
    ├── chromosome_depth.png
    ├── chromosome_relative_depth.csv
    └── sex_inference.txt
```

### Results folder

`chromosome_depth.png`  
Chromosome-level sequencing-depth visualization.

`chromosome_relative_depth.csv`  
Mean and relative sequencing depth used for dosage inference.

`sex_inference.txt`  
Summary of the calculated autosomal depth, Z:A ratio, and dosage interpretation.

Large raw sequencing and alignment files such as FASTQ, FASTA, BAM, and CRAM files were not uploaded to GitHub.

---

## Conclusion

Whole-genome sequencing read depth successfully supported the expected sex-chromosome complement of the selected *Coturnix japonica* sample.

The median autosomal depth was **8.372×**, while the Z chromosome had a depth of **9.135×**, producing a **Z:A ratio of 1.091**. This resulted in a **ZZ-like** dosage interpretation.

The sequence-based result agrees with the **male BioSample metadata**, providing concordant evidence that the analyzed individual has a ZZ-like sex-chromosome complement.
