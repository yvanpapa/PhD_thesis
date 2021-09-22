#!/bin/bash
#SBATCH -a 2-188
#SBATCH --job-name=markdup
#SBATCH --cpus-per-task=16
#SBATCH --mem=256G
#SBATCH --partition=bigmem
#SBATCH --time=3:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/09_markdups/TARdnV2P_lib1_to_6/job_20210212_2_188_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/09_markdups/TARdnV2P_lib1_to_6/job_20210212_2_188_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#do not forget to change array number accordingly in the SBATCH header!

#module load picard/2.18.20

#Need at least 256G of memory, even if vuw-job-report doesnt report it

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
"1810_UWCNI_076" "1840_EC_069_2" "1875_TARA_001" "1877_TARA_003" "1898_AU_004" \
"1914_AU_020" "1915_AU_021" "1917_AU_023" "1925_CHCH_056" "1926_CHCH_057" \
"1927_CHCH_058" "1929_CHCH_060" "1930_CHCH_061" "1931_CHCH_062" "1932_CHCH_063" \
"1933_CHCH_064" "1934_CHCH_065" "1935_CHCH_066" "1936_CHCH_067" "1937_CHCH_068" \
"1938_CHCH_069" "1939_CHCH_070" "1941_CHCH_072" "1942_CHCH_073" "1965_WGTN20_001" \
"1967_WGTN20_003" "1969_WGTN20_005" "1970_WGTN20_006" "1973_WGTN20_009" "1977_WGTN20_013" \
"1978_WGTN20_014" "1979_WGTN20_015" "1982_WGTN20_018" "1983_WGTN20_019" "1984_WGTN20_020" \
"1985_WGTN20_0021" "1986_WGTN20_022" "318_KTAR018" "335_KTAR035" "395_CHAT055")

read_dir=/nfs/scratch/papayv/Tarakihi/popgen/050607_bwa_alignement/TARdnV2P_lib1_to_6/bamfiles/
output_dir=/nfs/scratch/papayv/Tarakihi/popgen/09_markdups/TARdnV2P_lib1_to_6



echo "marking sample ${names[${SLURM_ARRAY_TASK_ID}]}"
time java -jar -XX:-UseGCOverheadLimit -Xmx250000m /home/software/apps/picard/2.18.20/picard.jar MarkDuplicates \
      I=$read_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.bam \
      O=$output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bam \
      M=$output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.metrics.txt \
	  MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=100000 #ulimit -n=131072


#-Xmx=max memory

#cpt=32, mem=512G ~40min/sample, maxMem=511.60G 
#cpt=16, mem=256G ~30min/sample, maxMem= 256.61G 

##############################################

echo "Index the BAM files."
module purge #to avoid conflict with samtools
module load samtools/1.9


echo "indexing ${names[${SLURM_ARRAY_TASK_ID}]} .bam"
time samtools index $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bam
echo "${names[${SLURM_ARRAY_TASK_ID}]} BAM file indexed"

echo "all BAM files indexed"
#cpt=32, mem=512G 1-2 min/sample

###################################################

echo "computing stats"
module purge #to avoid conflict with samtools
module load samtools/1.9


echo "computing stats ${names[${SLURM_ARRAY_TASK_ID}]}.bam"
time samtools flagstat $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bam > $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.stats.txt
echo "${names[${SLURM_ARRAY_TASK_ID}]}.bam stats computed"

echo "all BAM stats computed"
##cpt=32, mem=512 1-2min / sample

##########

module load bamtools/2.5.1 

echo "computing BAM stats"

echo "computing stats ${names[${SLURM_ARRAY_TASK_ID}]}.bam"
time bamtools stats -in $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bam -insert > $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bamstats.txt
echo "${names[${SLURM_ARRAY_TASK_ID}]}.bam stats computed"

echo "all BAM stats computed"

##########

mkdir -p $output_dir/bamfiles
mkdir -p $output_dir/stats
mkdir -p $output_dir/bamstats
mkdir -p $output_dir/metrics

mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bam $output_dir/bamfiles
mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bam.bai $output_dir/bamfiles
mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.stats.txt $output_dir/stats/
mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.bamstats.txt $output_dir/bamstats/
mv $output_dir/aln_pe_${names[${SLURM_ARRAY_TASK_ID}]}.markdup.metrics.txt $output_dir/metrics/
