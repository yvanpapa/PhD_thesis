#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --partition=parallel
#SBATCH --time=7-6:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/050607_bwa_alignement/TARdnV2P_lib1_to_6/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/050607_bwa_alignement/TARdnV2P_lib1_to_6/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Use this script if you have enough resources available and run everything in bulk

REF=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta

read_dir1=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/archived_results/190326_AGRF_lib1/
read_dir2=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib2/results/
read_dir3=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib3/results/
read_dir4=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib4/results/
read_dir5=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib5/results/
read_dir6=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib6/results/

array1=("091_NT17031" "093_NT17033" "109_NT17049" "1121_WAI050" "1125_WAI054" "1127_WAI056" "1161_SPGB006" "1165_SPGB010" "1212_SPEC027" "1214_SPEC029" "1223_SPCC008" "1237_SPCC022" "1246_SPCC031" "1252_SPCC037" "1255_SPCC040" "1281_SPWCSI006" "1285_SPWCSI010" "1298_SPWCSI023" "1311_SPWCSI036" "1326_SPWCSI051" "1329_SPWCSI054" "1331_SPWCSI056" "1334_SPWCSI059" "1335_SPWCSI060" "275_ENLD035" "480_WGTN025" "530_FRDL015")
array2=("1795_UWCNI061" "1796_UWCNI062" "1797_UWCNI063" "1801_UWCNI069" "1802_UWCNI070" "1816_ENHG002" "1817_ENHG003")
array3=("1605_GB19001_K" "1606_GB19002" "1610_GB19006" "1818_ENHG004" "1819_ENHG005" "1822_ENHG008" "320_KTAR020")
array4=("1614_GB19010" "1633_WGTN19001" "1637_WGTN19005" "1694_TBGB102" "1695_TBGB103" "1696_TBGB104")
array5=("1086_WAI015" "1087_WAI016" "1149_FRDL052" "1220_SPCC005" "1613_GB19_009" "1615_GB19_011" "1616_GB19_012" "1617_GB19_013" "1618_GB19_014" "1620_GB19_016" "1634_WGTN19_002" "1636_WGTN19_004" "1638_WGTN19_006" "1639_WGTN19_007" "1642_WGTN19_010" "1643_NAP19_001" "1646_NAP19_004" "1647_NAP19_005" "1648_NAP19_006" "1649_NAP19_007" "1650_NAP19_008" "1655_TBGBJ_063" "1657_TBGBJ_065" "1658_TBGBJ_066" "1662_TBGB_070" "1663_TBGB_071" "1665_TBGB_073" "1667_TBGB_075" "1668_TBGB_076" "1669_TBGB_077" "1671_TBGB_079" "1706_TBGBJ_114" "1707_TBGBJ_115" "1780_WCSI_106" "1781_WCSI_107" "1782_WCSI_108" "1783_WCSI_109" "1785_WCSI_111" "1790_WCSI_116" "1792_WCSI_118" "1794_WCSI_120" "1805_UWCNI_071" "1808_UWCNI_074" "1811_UWCNI_077" "1812_UWCNI_078" "1813_UWCNI_079" "1824_ENHG_010" "1826_ENHG_012" "1828_ENHG_014" "1830_ENHG_016" "1832_ENHG_018" "1836_EC_063" "1838_EC_066" "1839_EC_067" "1840_EC_069" "1842_EC_073" "1855_ENLD_061" "1858_ENLD_064" "1859_ENLD_065" "1862_ENLD_068" "1863_ENLD_069" "1864_ENLD_070" "1866_ENLD_072" "1867_ENLD_073" "1869_ENLD_075" "1878_TARA_004" "1879_TARA_005" "1881_TARA_007" "1884_TARA_010" "1885_TARA_011" "1886_TARA_012" "1895_AU_001" "1897_AU_003" "1900_AU_006" "1901_AU_007" "1902_AU_008" "1903_AU_009" "1904_AU_010" "1905_AU_011" "1906_AU_012" "1908_AU_014" "303_KTAR003" "306_KTAR006" "327_KTAR027" "328_KTAR028" "330_KTAR030" "331_KTAR031" "332_KTAR032" "334_KTAR034" "339_KTAR039" "400_CHAT060" "534_FRDL019")
array6=("022_HB17022" "1608_GB19_004" "1623_GB19_019" "1624_GB19_020" "1652_TBGB_060" "1700_TBGB_108" "1775_WCSI_101" "1777_WCSI_103" "1779_WCSI_105" "1809_UWCNI_075" "1810_UWCNI_076" "1840_EC_069_2" "1875_TARA_001" "1877_TARA_003" "1898_AU_004" "1914_AU_020" "1915_AU_021" "1917_AU_023" "1925_CHCH_056" "1926_CHCH_057" "1927_CHCH_058" "1929_CHCH_060" "1930_CHCH_061" "1931_CHCH_062" "1932_CHCH_063" "1933_CHCH_064" "1934_CHCH_065" "1935_CHCH_066" "1936_CHCH_067" "1937_CHCH_068" "1938_CHCH_069" "1939_CHCH_070" "1941_CHCH_072" "1942_CHCH_073" "1965_WGTN20_001" "1967_WGTN20_003" "1969_WGTN20_005" "1970_WGTN20_006" "1973_WGTN20_009" "1977_WGTN20_013" "1978_WGTN20_014" "1979_WGTN20_015" "1982_WGTN20_018" "1983_WGTN20_019" "1984_WGTN20_020" "1985_WGTN20_0021" "1986_WGTN20_022" "318_KTAR018" "335_KTAR035" "395_CHAT055")

output_dir=/nfs/scratch/papayv/Tarakihi/popgen/050607_bwa_alignement/TARdnV2P_lib1_to_6/

threads=30
mem=2000000000

###########
#need to do only once per genome
echo "creating bwa index of reference genome"
module purge #to avoid conflict with samtools
module load bwa-kit/0.7.15
time bwa index $REF
echo "bwa index completed"

###########
#need to do only once per genome
echo "creating sam index of reference genome"
module purge #to avoid conflict with samtools
module load samtools/1.9
time samtools faidx $REF
echo "sam index completed"
##########

echo "starting bwa alignments"

for f in "${array1[@]}" ; do
module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
echo "Aligning sample $f"
time bwa mem -a -M -t $threads $REF $read_dir1/$f.forward_paired.fq.gz $read_dir1/$f.reverse_paired.fq.gz > $output_dir/aln_pe_$f.sam
echo "sample $f aligned"
module purge #to avoid conflict with samtools
module load samtools/1.9
echo "converting sample $f to BAM"
time  samtools sort -m $mem -@ $threads $output_dir/aln_pe_$f.sam > $output_dir/aln_pe_$f.bam
rm $output_dir/aln_pe_$f.sam
echo "sample $f converted to BAM"
done
for f in "${array2[@]}" ; do
module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
echo "Aligning sample $f"
time bwa mem -a -M -t $threads $REF $read_dir2/$f.forward_paired.fq.gz $read_dir2/$f.reverse_paired.fq.gz > $output_dir/aln_pe_$f.sam
echo "sample $f aligned"
module purge #to avoid conflict with samtools
module load samtools/1.9
echo "converting sample $f to BAM"
time  samtools sort -m $mem -@ $threads $output_dir/aln_pe_$f.sam > $output_dir/aln_pe_$f.bam
rm $output_dir/aln_pe_$f.sam
echo "sample $f converted to BAM"
done
for f in "${array3[@]}" ; do
module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
echo "Aligning sample $f"
time bwa mem -a -M -t $threads $REF $read_dir3/$f.forward_paired.fq.gz $read_dir3/$f.reverse_paired.fq.gz > $output_dir/aln_pe_$f.sam
echo "sample $f aligned"
module purge #to avoid conflict with samtools
module load samtools/1.9
echo "converting sample $f to BAM"
time  samtools sort -m $mem -@ $threads $output_dir/aln_pe_$f.sam > $output_dir/aln_pe_$f.bam
rm $output_dir/aln_pe_$f.sam
echo "sample $f converted to BAM"
done
for f in "${array4[@]}" ; do
module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
echo "Aligning sample $f"
time bwa mem -a -M -t $threads $REF $read_dir4/$f.forward_paired.fq.gz $read_dir4/$f.reverse_paired.fq.gz > $output_dir/aln_pe_$f.sam
echo "sample $f aligned"
module purge #to avoid conflict with samtools
module load samtools/1.9
echo "converting sample $f to BAM"
time  samtools sort -m $mem -@ $threads $output_dir/aln_pe_$f.sam > $output_dir/aln_pe_$f.bam
rm $output_dir/aln_pe_$f.sam
echo "sample $f converted to BAM"
done
for f in "${array5[@]}" ; do
module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
echo "Aligning sample $f"
time bwa mem -a -M -t $threads $REF $read_dir5/$f.forward_paired.fq.gz $read_dir5/$f.reverse_paired.fq.gz > $output_dir/aln_pe_$f.sam
echo "sample $f aligned"
module purge #to avoid conflict with samtools
module load samtools/1.9
echo "converting sample $f to BAM"
time  samtools sort -m $mem -@ $threads $output_dir/aln_pe_$f.sam > $output_dir/aln_pe_$f.bam
rm $output_dir/aln_pe_$f.sam
echo "sample $f converted to BAM"
done
for f in "${array6[@]}" ; do
module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
echo "Aligning sample $f"
time bwa mem -a -M -t $threads $REF $read_dir6/$f.forward_paired.fq.gz $read_dir6/$f.reverse_paired.fq.gz > $output_dir/aln_pe_$f.sam
echo "sample $f aligned"
module purge #to avoid conflict with samtools
module load samtools/1.9
echo "converting sample $f to BAM"
time  samtools sort -m $mem -@ $threads $output_dir/aln_pe_$f.sam > $output_dir/aln_pe_$f.bam
rm $output_dir/aln_pe_$f.sam
echo "sample $f converted to BAM"
done
echo "all alignements completed, sam files sorted and converted to bam"
#cpt=32, mem=512 10-15min / sample

####parameters:
# -a	Output all found alignments for single-end or unpaired paired-end reads. These alignments will be flagged as secondary alignments.
# -M	Mark shorter split hits as secondary (for Picard compatibility).
# -t INT	Number of threads [1]

##cpt=32, mem=512 3-4min / sample 

####parameters:
#-m INT Approximately the maximum required memory per thread, specified either in bytes or with a K, M, or G suffix. [768 MiB]
#-@ INT Set number of sorting and compression threads. By default, operation is single-threaded.

############
module purge #to avoid conflict with samtools
module load samtools/1.9
echo "Index the BAM files."

for f in "${array1[@]}" ; do
echo "indexing $f .bam"
time samtools index $output_dir/aln_pe_$f.bam
echo "$f BAM file indexed"
done
for f in "${array2[@]}" ; do
echo "indexing $f .bam"
time samtools index $output_dir/aln_pe_$f.bam
echo "$f BAM file indexed"
done
for f in "${array3[@]}" ; do
echo "indexing $f .bam"
time samtools index $output_dir/aln_pe_$f.bam
echo "$f BAM file indexed"
done
for f in "${array4[@]}" ; do
echo "indexing $f .bam"
time samtools index $output_dir/aln_pe_$f.bam
echo "$f BAM file indexed"
done
for f in "${array5[@]}" ; do
echo "indexing $f .bam"
time samtools index $output_dir/aln_pe_$f.bam
echo "$f BAM file indexed"
done
for f in "${array6[@]}" ; do
echo "indexing $f .bam"
time samtools index $output_dir/aln_pe_$f.bam
echo "$f BAM file indexed"
done
echo "all BAM files indexed"
##cpt=32, mem=512 1-2min / sample

###########

echo "computing flag stats"
for f in "${array1[@]}" ; do
echo "computing stats $f.bam"
time samtools flagstat $output_dir/aln_pe_$f.bam > $output_dir/aln_pe_$f.stats.txt
echo "$f.bam stats computed"
done
for f in "${array2[@]}" ; do
echo "computing stats $f.bam"
time samtools flagstat $output_dir/aln_pe_$f.bam > $output_dir/aln_pe_$f.stats.txt
echo "$f.bam stats computed"
done
for f in "${array3[@]}" ; do
echo "computing stats $f.bam"
time samtools flagstat $output_dir/aln_pe_$f.bam > $output_dir/aln_pe_$f.stats.txt
echo "$f.bam stats computed"
done
for f in "${array4[@]}" ; do
echo "computing stats $f.bam"
time samtools flagstat $output_dir/aln_pe_$f.bam > $output_dir/aln_pe_$f.stats.txt
echo "$f.bam stats computed"
done
for f in "${array5[@]}" ; do
echo "computing stats $f.bam"
time samtools flagstat $output_dir/aln_pe_$f.bam > $output_dir/aln_pe_$f.stats.txt
echo "$f.bam stats computed"
done
for f in "${array6[@]}" ; do
echo "computing stats $f.bam"
time samtools flagstat $output_dir/aln_pe_$f.bam > $output_dir/aln_pe_$f.stats.txt
echo "$f.bam stats computed"
done
echo "all BAM stats computed"
##cpt=32, mem=512 1-2min / sample

##########

module load bamtools/2.5.1 

echo "computing insert size BAM stats"
for f in "${array1[@]}" ; do
echo "computing stats $f.bam"
time bamtools stats -in $output_dir/aln_pe_$f.bam -insert > $output_dir/aln_pe_$f.bamstats.txt
echo "$f.bam stats computed"
done
for f in "${array2[@]}" ; do
echo "computing stats $f.bam"
time bamtools stats -in $output_dir/aln_pe_$f.bam -insert > $output_dir/aln_pe_$f.bamstats.txt
echo "$f.bam stats computed"
done
for f in "${array3[@]}" ; do
echo "computing stats $f.bam"
time bamtools stats -in $output_dir/aln_pe_$f.bam -insert > $output_dir/aln_pe_$f.bamstats.txt
echo "$f.bam stats computed"
done
for f in "${array4[@]}" ; do
echo "computing stats $f.bam"
time bamtools stats -in $output_dir/aln_pe_$f.bam -insert > $output_dir/aln_pe_$f.bamstats.txt
echo "$f.bam stats computed"
done
for f in "${array5[@]}" ; do
echo "computing stats $f.bam"
time bamtools stats -in $output_dir/aln_pe_$f.bam -insert > $output_dir/aln_pe_$f.bamstats.txt
echo "$f.bam stats computed"
done
for f in "${array6[@]}" ; do
echo "computing stats $f.bam"
time bamtools stats -in $output_dir/aln_pe_$f.bam -insert > $output_dir/aln_pe_$f.bamstats.txt
echo "$f.bam stats computed"
done
echo "all BAM stats computed"
##cpt=32, mem=512 1-2min / sample

###parameters:
# -in <BAM filename>                the input BAM file [stdin]
# -insert                           summarize insert size data


mkdir -p $output_dir/bamfiles
mkdir -p $output_dir/stats
mkdir -p $output_dir/bamstats

mv $output_dir/*.bam $output_dir/bamfiles
mv $output_dir/*.bai $output_dir/bamfiles
mv $output_dir/*.stats.txt $output_dir/stats
mv $output_dir/*.bamstats.txt $output_dir/bamstats

############


##cpt=32, mem=512, bwa mem threads=30: total run time= ~11h. Max Mem Used: 451.18G!!
##cpt=16, mem=256G, bwa mwm threads=15: total run time= ~18h. Max Mem Used: 230.47G
