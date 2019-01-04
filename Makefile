all: ensembl-user-words

ensembl-user-words: data/ensembl-Hs-GRCh38.94.genes.txt

data/Homo_sapiens.GRCh38.94.gff3.gz:
	wget ftp://ftp.ensembl.org/pub/release-94/gff3/homo_sapiens/Homo_sapiens.GRCh38.94.gff3.gz -O data/Homo_sapiens.GRCh38.94.gff3.gz

data/ensembl-Hs-GRCh38.94.genes.txt:data/Homo_sapiens.GRCh38.94.gff3.gz
	zcat $< | awk '$$3=="gene"' | grep 'Name=' | sed 's/.*Name=//g' | sed 's/;.*//g' > $@

psms: output/fig1g-sub-tesseract-psm4.txt output/fig1g-sub-tesseract-psm6.txt

output/fig1g-sub-tesseract-psm4.txt: figures/fig1g-sub.png ensembl-user-words
	tesseract figures/fig1g-sub.png - --user-words data/ensembl-Hs-GRCh38.94.genes.txt -psm 4 > $@

output/fig1g-sub-tesseract-psm6.txt: figures/fig1g-sub.png ensembl-user-words
	tesseract figures/fig1g-sub.png - --user-words data/ensembl-Hs-GRCh38.94.genes.txt -psm 6 > $@

clean:
	rm -f *~

.PHONY: clean
