all: ensembl-user-words

ensembl-user-words: data/ensembl-Hs-GRCh38.94.genes.txt

data/Homo_sapiens.GRCh38.94.gff3.gz:
	wget ftp://ftp.ensembl.org/pub/release-94/gff3/homo_sapiens/Homo_sapiens.GRCh38.94.gff3.gz -O data/Homo_sapiens.GRCh38.94.gff3.gz

data/ensembl-Hs-GRCh38.94.genes.txt:data/Homo_sapiens.GRCh38.94.gff3.gz
	zcat $< | awk '$$3=="gene"' | grep 'Name=' | sed 's/.*Name=//g' | sed 's/;.*//g' > $@
