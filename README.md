BioinfOCR to recognize gene symbols and names
===

# Background

Often gene names and symbols are part of a figure and we want to capture them for instance to use them in our own analysis. No out-of-the-box tool is good at this task. Therefore I try to hack an existing OCR tool, tesseract, for this task.

# Methods

## Example

We use figure 1d and 1g of [Haney *et al.*](https://doi.org/10.1038/s41588-018-0254-1) to try the tools.

## Software tools

Tesseract is open-source software and can be installed following the [instruction](https://github.com/tesseract-ocr/tesseract). For the current experiment, tesseract 3.04.01 was used.

## Extract gene symbols as user words.

We provide the list of possible genes to the tesseract program so that it can recognize them correctly. We do this by downloading the GFF3 file from the ENSEMBL FTP site and parsing gene symbols.

```{bash}
make ensembl-user-words
```

## Recognize gene symbols automatically from the cropped figure

From a cropped, high-resolution figure of gene symbols aligned to the right side of a heatmap ([fig1g-sub](./figures/fig1g-sub.png]), we try to recognize the gene symbols.

Tesseract provides many page segmentation modes. For the given task, mode 1, 3, 4, 5 and 6 may fit.

```{bash}
for i in 1 3 4 5 6; do
    echo "===psm mode ${i}==="
    tesseract figures/fig1g-sub.png - --user-words data/ensembl-Hs-GRCh38.94.genes.txt -psm ${i}
done
```
It turns out the psm mode 6 is the best for this purpose (assume a single uniform block of text), with an error rate of 10% (3 out of 30 genes were wrong), followed by mode 4 (assume a single column of text of variable sizes), with an error rate of 60%. Other modes are not suitable.

```{bash psm6}
make psms
diff  output/fig1g-sub-tesseract-psm4.txt figures/fig1g-sub-correctNames.txt | grep '^>' | wc
diff  output/fig1g-sub-tesseract-psm6.txt figures/fig1g-sub-correctNames.txt | grep '^>' | wc
```

It means that if the text is well aligned (such as the case in most heatmaps), tesseract with its default setting can capture the gene names well if the gene symbol candidates are passed as user words.

## Recognize gene symbols from an uncropped figure

I tried to run the tesseract with different modes on the whole figure 1g with the heatmap and many unrelevant visual elements. The results are not useable. It seems that currently it makes most sense to focus on cropped texts.

## Next steps

1. Iteratively improve the performance of OCR by giving weights to the genes in the word list.
2. Use simulations to understand the performance of the program.
3. Automatically recognize the text part from a heatmap
4. Allow user to provide gene name candidates.