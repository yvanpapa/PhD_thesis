#!/bin/bash
#SBATCH -a 139-188
#SBATCH --job-name=bwa_array_lib6
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=2-6:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/050607_bwa_alignement/TARdnV2P_lib1_to_6/job_20210208_lib6_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/050607_bwa_alignement/TARdnV2P_lib1_to_6/job_20210208_lib6_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Use this script if you'd rather submit each sample as an array to use less resources at the same time

REF=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta

read_dir1=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/archived_results/190326_AGRF_lib1/
##27 files
read_dir2=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib2/results/
##7 files
read_dir3=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib3/results/
##7 files
read_dir4=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib4/results/
##6 files #0-46
read_dir5=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib5/results/
#92 files  #47-138
read_dir6=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib6/results/
#50 files #139-188

names=("091_NT17031" "093_NT17033" "109_NT17049" "1121_WAI050" \
"1125_WAI054" "1127_WAI056" "1161_SPGB006" "1165_SPGB010" \
"1212_SPEC027" "1214_SPEC029" "1223_SPCC008" "1237_SPCC022" \
"1246_SPCC031" "1252_SPCC037" "1255_SPCC040" "1281_SPWCSI006" \
"1285_SPWCSI010" "1298_SPWCSI023" "1311_SPWCSI036" "1326_SPWCSI051" \
"1329_SPWCSI054" "1331_SPWCSI056" "1334_SPWCSI059" "1335_SPWCSI060" \
"275_ENLD035" "480_WGTN025" "530_FRDL015" \
"1795_UWCNI061" "1796_UWCNI062" "1797_UWCNI063" "1801_UWCNI069" \
"1802_UWCNI070" "1816_ENHG002" "1817_ENHG003" \
"1605_GB19001_K" "1606_GB19002" "1610_GB19006" "1818_ENHG004" \
"1819_ENHG005" "1822_ENHG008" "320_KTAR020" \
"1614_GB19010" "1633_WGTN19001" "1637_WGTN19005" "1694_TBGB102" \
"1695_TBGB103" "1696_TBGB104" \
"1086_WAI015" "1087_WAI016" "1149_FRDL052" "1220_SPCC005" \
"1613_GB19_009" "1615_GB19_011" "1616_GB19_012" "1617_GB19_013" \
"1618_GB19_014" "1620_GB19_016" "1634_WGTN19_002" "1636_WGTN19_004" \
"1638_WGTN19_006" "1639_WGTN19_007" "1642_WGTN19_010" "1643_NAP19_001" \
"1646_NAP19_004" "1647_NAP19_005" "1648_NAP19_006" "1649_NAP19_007" \
"1650_NAP19_008" "1655_TBGBJ_063" "1657_TBGBJ_065" "1658_TBGBJ_066" \
"1662_TBGB_070" "1663_TBGB_071" "1665_TBGB_073" "1667_TBGB_075" "1668_TBGB_076" \
"1669_TBGB_077" "1671_TBGB_079" "1706_TBGBJ_114" "1707_TBGBJ_115" "1780_WCSI_106" \
"1781_WCSI_107" "1782_WCSI_108" "1783_WCSI_109" "1785_WCSI_111" "1790_WCSI_116" \
"1792_WCSI_118" "1794_WCSI_120" "1805_UWCNI_071" "1808_UWCNI_074" "1811_UWCNI_077" \
"1812_UWCNI_078" "1813_UWCNI_079" "1824_ENHG_010" "1826_ENHG_012" "1828_ENHG_014" \
"1830_ENHG_016" "1832_ENHG_018" "1836_EC_063" "1838_EC_066" "1839_EC_067" \
"1840_EC_069" "1842_EC_073" "1855_ENLD_061" "1858_ENLD_064" "1859_ENLD_065" \
"1862_ENLD_068" "1863_ENLD_069" "1864_ENLD_070" "1866_ENLD_072" "1867_ENLD_073" \
"1869_ENLD_075" "1878_TARA_004" "1879_TARA_005" "1881_TARA_007" "1884_TARA_010" \
"1885_TARA_011" "1886_TARA_012" "1895_AU_001" "1897_AU_003" "1900_AU_006" \
"1901_AU_007" "1902_AU_008" "1903_AU_009" "1904_AU_010" "1905_AU_011" \
"1906_AU_012" "1908_AU_014" "303_KTAR003" "306_KTAR006" "327_KTAR027" \
"328_KTAR028" "330_KTAR030" "331_KTAR031" "332_KTAR032" "334_KTAR034" \
"339_KTAR039" "400_CHAT060" "534_FRDL019" \
"022_HB17022" "1608_GB19_004" "1623_GB19_019" "1624_GB19_020" "1652_TBGB_060" \
"1700_TBGB_108" "1775_WCSI_101" "1777_WCSI_103" "1779_WCSI_105" "1809_UWCNI_075" \
"1810_UWCNI_076" "1840_EC_069" "1875_TARA_001" "1877_TARA_003" "1898_AU_004" \
"1914_AU_020" "1915_AU_021" "1917_AU_023" "1925_CHCH_056" "1926_CHCH_057" \
"1927_CHCH_058" "1929_CHCH_060" "1930_CHCH_061" "1931_CHCH_062" "1932_CHCH_063" \
"1933_CHCH_064" "1934_CHCH_065" "1935_CHCH_066" "1936_CHCH_067" "1937_CHCH_068" \
"1938_CHCH_069" "1939_CHCH_070" "1941_CHCH_072" "1942_CHCH_073" "1965_WGTN20_001" \
"1967_WGTN20_003" "1969_WGTN20_005" "1970_WGTN20_006" "1973_WGTN20_009" "1977_WGTN20_013" \
"1978_WGTN20_014" "1979_WGTN20_015" "1982_WGTN20_018" "1983_WGTN20_019" "1984_WGTN20_020" \
"1985_WGTN20_0021" "1986_WGTN20_022" "318_KTAR018" "335_KTAR035" "395_CHAT055")

files=("$read_dir1/091_NT17031" "$read_dir1/093_NT17033" "$read_dir1/109_NT17049" "$read_dir1/1121_WAI050" \
"$read_dir1/1125_WAI054" "$read_dir1/1127_WAI056" "$read_dir1/1161_SPGB006" "$read_dir1/1165_SPGB010" \
"$read_dir1/1212_SPEC027" "$read_dir1/1214_SPEC029" "$read_dir1/1223_SPCC008" "$read_dir1/1237_SPCC022" \
"$read_dir1/1246_SPCC031" "$read_dir1/1252_SPCC037" "$read_dir1/1255_SPCC040" "$read_dir1/1281_SPWCSI006" \
"$read_dir1/1285_SPWCSI010" "$read_dir1/1298_SPWCSI023" "$read_dir1/1311_SPWCSI036" "$read_dir1/1326_SPWCSI051" \
"$read_dir1/1329_SPWCSI054" "$read_dir1/1331_SPWCSI056" "$read_dir1/1334_SPWCSI059" "$read_dir1/1335_SPWCSI060" \
"$read_dir1/275_ENLD035" "$read_dir1/480_WGTN025" "$read_dir1/530_FRDL015" \
"$read_dir2/1795_UWCNI061" "$read_dir2/1796_UWCNI062" "$read_dir2/1797_UWCNI063" "$read_dir2/1801_UWCNI069" \
"$read_dir2/1802_UWCNI070" "$read_dir2/1816_ENHG002" "$read_dir2/1817_ENHG003" \
"$read_dir3/1605_GB19001_K" "$read_dir3/1606_GB19002" "$read_dir3/1610_GB19006" "$read_dir3/1818_ENHG004" \
"$read_dir3/1819_ENHG005" "$read_dir3/1822_ENHG008" "$read_dir3/320_KTAR020" \
"$read_dir4/1614_GB19010" "$read_dir4/1633_WGTN19001" "$read_dir4/1637_WGTN19005" "$read_dir4/1694_TBGB102" \
"$read_dir4/1695_TBGB103" "$read_dir4/1696_TBGB104" \
"$read_dir5/1086_WAI015" "$read_dir5/1087_WAI016" "$read_dir5/1149_FRDL052" "$read_dir5/1220_SPCC005" \
"$read_dir5/1613_GB19_009" "$read_dir5/1615_GB19_011" "$read_dir5/1616_GB19_012" "$read_dir5/1617_GB19_013" \
"$read_dir5/1618_GB19_014" "$read_dir5/1620_GB19_016" "$read_dir5/1634_WGTN19_002" "$read_dir5/1636_WGTN19_004" \
"$read_dir5/1638_WGTN19_006" "$read_dir5/1639_WGTN19_007" "$read_dir5/1642_WGTN19_010" "$read_dir5/1643_NAP19_001" \
"$read_dir5/1646_NAP19_004" "$read_dir5/1647_NAP19_005" "$read_dir5/1648_NAP19_006" "$read_dir5/1649_NAP19_007" \
"$read_dir5/1650_NAP19_008" "$read_dir5/1655_TBGBJ_063" "$read_dir5/1657_TBGBJ_065" "$read_dir5/1658_TBGBJ_066" \
"$read_dir5/1662_TBGB_070" "$read_dir5/1663_TBGB_071" "$read_dir5/1665_TBGB_073" "$read_dir5/1667_TBGB_075" "$read_dir5/1668_TBGB_076" \
"$read_dir5/1669_TBGB_077" "$read_dir5/1671_TBGB_079" "$read_dir5/1706_TBGBJ_114" "$read_dir5/1707_TBGBJ_115" "$read_dir5/1780_WCSI_106" \
"$read_dir5/1781_WCSI_107" "$read_dir5/1782_WCSI_108" "$read_dir5/1783_WCSI_109" "$read_dir5/1785_WCSI_111" "$read_dir5/1790_WCSI_116" \
"$read_dir5/1792_WCSI_118" "$read_dir5/1794_WCSI_120" "$read_dir5/1805_UWCNI_071" "$read_dir5/1808_UWCNI_074" "$read_dir5/1811_UWCNI_077" \
"$read_dir5/1812_UWCNI_078" "$read_dir5/1813_UWCNI_079" "$read_dir5/1824_ENHG_010" "$read_dir5/1826_ENHG_012" "$read_dir5/1828_ENHG_014" \
"$read_dir5/1830_ENHG_016" "$read_dir5/1832_ENHG_018" "$read_dir5/1836_EC_063" "$read_dir5/1838_EC_066" "$read_dir5/1839_EC_067" \
"$read_dir5/1840_EC_069" "$read_dir5/1842_EC_073" "$read_dir5/1855_ENLD_061" "$read_dir5/1858_ENLD_064" "$read_dir5/1859_ENLD_065" \
"$read_dir5/1862_ENLD_068" "$read_dir5/1863_ENLD_069" "$read_dir5/1864_ENLD_070" "$read_dir5/1866_ENLD_072" "$read_dir5/1867_ENLD_073" \
"$read_dir5/1869_ENLD_075" "$read_dir5/1878_TARA_004" "$read_dir5/1879_TARA_005" "$read_dir5/1881_TARA_007" "$read_dir5/1884_TARA_010" \
"$read_dir5/1885_TARA_011" "$read_dir5/1886_TARA_012" "$read_dir5/1895_AU_001" "$read_dir5/1897_AU_003" "$read_dir5/1900_AU_006" \
"$read_dir5/1901_AU_007" "$read_dir5/1902_AU_008" "$read_dir5/1903_AU_009" "$read_dir5/1904_AU_010" "$read_dir5/1905_AU_011" \
"$read_dir5/1906_AU_012" "$read_dir5/1908_AU_014" "$read_dir5/303_KTAR003" "$read_dir5/306_KTAR006" "$read_dir5/327_KTAR027" \
"$read_dir5/328_KTAR028" "$read_dir5/330_KTAR030" "$read_dir5/331_KTAR031" "$read_dir5/332_KTAR032" "$read_dir5/334_KTAR034" \
"$read_dir5/339_KTAR039" "$read_dir5/400_CHAT060" "$read_dir5/534_FRDL019" \
"$read_dir6/022_HB17022" "$read_dir6/1608_GB19_004" "$read_dir6/1623_GB19_019" "$read_dir6/1624_GB19_020" "$read_dir6/1652_TBGB_060" \
"$read_dir6/1700_TBGB_108" "$read_dir6/1775_WCSI_101" "$read_dir6/1777_WCSI_103" "$read_dir6/1779_WCSI_105" "$read_dir6/1809_UWCNI_075" \
"$read_dir6/1810_UWCNI_076" "$read_dir6/1840_EC_069" "$read_dir6/1875_TARA_001" "$read_dir6/1877_TARA_003" "$read_dir6/1898_AU_004" \
"$read_dir6/1914_AU_020" "$read_dir6/1915_AU_021" "$read_dir6/1917_AU_023" "$read_dir6/1925_CHCH_056" "$read_dir6/1926_CHCH_057" \
"$read_dir6/1927_CHCH_058" "$read_dir6/1929_CHCH_060" "$read_dir6/1930_CHCH_061" "$read_dir6/1931_CHCH_062" "$read_dir6/1932_CHCH_063" \
"$read_dir6/1933_CHCH_064" "$read_dir6/1934_CHCH_065" "$read_dir6/1935_CHCH_066" "$read_dir6/1936_CHCH_067" "$read_dir6/1937_CHCH_068" \
"$read_dir6/1938_CHCH_069" "$read_dir6/1939_CHCH_070" "$read_dir6/1941_CHCH_072" "$read_dir6/1942_CHCH_073" "$read_dir6/1965_WGTN20_001" \
"$read_dir6/1967_WGTN20_003" "$read_dir6/1969_WGTN20_005" "$read_dir6/1970_WGTN20_006" "$read_dir6/1973_WGTN20_009" "$read_dir6/1977_WGTN20_013" \
"$read_dir6/1978_WGTN20_014" "$read_dir6/1979_WGTN20_015" "$read_dir6/1982_WGTN20_018" "$read_dir6/1983_WGTN20_019" "$read_dir6/1984_WGTN20_020" \
"$read_dir6/1985_WGTN20_0021" "$read_dir6/1986_WGTN20_022" "$read_dir6/318_KTAR018" "$read_dir6/335_KTAR035" "$read_dir6/395_CHAT055")

output_dir=/nfs/scratch/papayv/Tarakihi/popgen/050607_bwa_alignement/TARdnV2P_lib1_to_6/

threads=7
mem=2000000000

###########
##need to do only once per genome
#echo "creating bwa index of reference genome"
#module purge #to avoid conflict with samtools
#module load bwa-kit/0.7.15
#time bwa index $REF
#echo "bwa index completed"

###########
##need to do only once per genome
#echo "creating sam index of reference genome"
#module purge #to avoid conflict with samtools
#module load samtools/1.9
#time samtools faidx $REF
#echo "sam index completed"
##########

echo "starting bwa alignments"

module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
echo "Aligning sample ${names[${SLURM_ARRAY_TASK_ID}]}"
time bwa mem -a -M -t $threads $REF ${files[${SLURM_ARRAY_TASK_ID}]}.forward_paired.fq.gz ${files[${SLURM_ARRAY_TASK_ID}]}.reverse_paired.fq.gz > $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.sam
echo "sample ${names[${SLURM_ARRAY_TASK_ID}]} aligned"

module purge #to avoid conflict with samtools
module load samtools/1.9
echo "converting sample ${names[${SLURM_ARRAY_TASK_ID}]} to BAM"
time  samtools sort -m $mem -@ $threads $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.sam > $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bam
rm $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.sam
echo "sample ${names[${SLURM_ARRAY_TASK_ID}]} converted to BAM"


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

echo "indexing ${names[${SLURM_ARRAY_TASK_ID}]}.bam"
time samtools index $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bam
echo "${names[${SLURM_ARRAY_TASK_ID}]} BAM file indexed"
##cpt=32, mem=512 1-2min / sample

###########

echo "computing stats ${names[${SLURM_ARRAY_TASK_ID}]}.bam"
time samtools flagstat $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bam > $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.stats.txt
echo "${names[${SLURM_ARRAY_TASK_ID}]}.bam stats computed"
##cpt=32, mem=512 1-2min / sample

##########

module load bamtools/2.5.1 

echo "computing stats ${names[${SLURM_ARRAY_TASK_ID}]}.bam"
time bamtools stats -in $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bam -insert > $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bamstats.txt
echo "${names[${SLURM_ARRAY_TASK_ID}]}.bam stats computed"
##cpt=32, mem=512 1-2min / sample

###parameters:
# -in <BAM filename>                the input BAM file [stdin]
# -insert                           summarize insert size data


mkdir -p $output_dir/bamfiles
mkdir -p $output_dir/stats
mkdir -p $output_dir/bamstats

mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bam $output_dir/bamfiles/
mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bam.bai $output_dir/bamfiles/
mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.stats.txt $output_dir/stats/
mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bamstats.txt $output_dir/bamstats/

############

##cpt=32, mem=512, bwa mem threads=30: total run time= ~11h. Max Mem Used: 451.18G!!
##cpt=16, mem=256G, bwa mwm threads=15: total run time= ~18h. Max Mem Used: 230.47G
