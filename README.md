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
`[Insert Galaxy history link here]`

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
7. Produces a chromosome-depth figure and
