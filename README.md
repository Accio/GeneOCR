BioinfOCR to recognize gene symbols and names
===

# Background

Often gene names and symbols are part of a figure and we want to capture them for instance to use them in our own analysis. No out-of-the-box tool is good at this task. Therefore I build a small tool for this purpose.

# Method

We try tesseract for the purpose. 

```{bash ensemblGene}
wget ftp://ftp.ensembl.org/pub/release-94/gff3/homo_sapiens/Homo_sapiens.GRCh38.94.gff3.gz
## view gz file without uncompressing
zcat Homo_sapiens.GRCh38.94.gff3.gz | grep AKT1
## generate a list of gene names
 zcat Homo_sapiens.GRCh38.94.gff3.gz  | awk '$3=="gene"' | grep 'Name=' | sed 's/.*Name=//g' | sed 's/;.*//g' > ensembl-Hs-GRCh38.94.genes.txt
```