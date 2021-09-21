#This is an interactive script, you have to run it in the command line instead of submitting a bash script

screen -S mrbayes #to create new screen session
screen -ls #to list
screen -r #to reattach


dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/21_mrbayes
align_fasta_file=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder_pipeline2/outputs_dataset2_July21/6_concatenated_alignement/alignement.fasta
align_nexus_file=$dir/all_teleosts_aln.nex

### Convert fasta to nexus
### You need to do that part only once per input file:
module load seqmagick/0.8.0
seqmagick convert --output-format nexus --alphabet dna $align_fasta_file $align_nexus_file
###

srun --pty --cpus-per-task=24 --mem=32G  --time=10-00:00:00 \
--partition=parallel bash
module load MrBayes/3.2.7-mpi
cd /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/21_mrbayes

###NEVER USE THE MOLETTE OR YOU GONNA HAVE TO RESTART FROM THE START....

#Start mrBayes multithreaded (mpi)
# mpiexec -np 8 mb does not work. You have to ask mpi to use all of the available cores or it wont do the job properly
mpiexec --oversubscribe -np 12 mb
#ALSO: ask for only half of the number of sbatch cores. if you ask for all the 24 cores with mem=32G, you get a mem limit error

#1.Read the nexus data file
execute all_teleosts_aln.nex   #~1h on CDS alnmt

#2. Set the evolutionary model
# We want the GTR+I+G4 model
####http://mrbayes.sourceforge.net/wiki/index.php?title=Evolutionary_Models_Implemented_in_MrBayes_3&oldid=5249

lset nst=6  #means GTR #the widely used General Time Reversible (GTR) model has six substitution types (lset nst=6), one for each pair of nucleotides. 
#~1h on CDS alnmt
lset rates=invgamma #The proportion of invariable sites model can be combined with the gamma model using lset rates=invgamma.
#~1h on CDS alnmt
showmodel
#3. Run the analyses
mcmc ngen=40000 samplefreq=100 printfreq=100 diagnfreq=1000 Nchains=6
#Here we will do 40,000 iterations, sampled and printed every 100 (so we get 200 samples from the posterior probability distribution),
#and diagnostics are calculated every 1,000 generations 
#For larger data sets you probably want to run the analysis longer and
#sample less frequently. The default sample and print frequency is 500, the default
#diagnostic frequency is 5,000, and the default run length is 1,000,000. You can
#find the predicted remaining time to completion of the analysis in the last column
#printed to screen.

#Also I had to change Nchains to 6 because "Error in command "Mcmc"  There must be at least as many chains as MPI processors "

#e.g.: https://www.biostars.org/p/79305/
#By default, Nchains is set to 4,

#If the standard deviation of split frequencies is below 0.01 after 30,000
#generations, stop the run by answering no when the program asks Continue the
#analysis? (yes/no).
no
#4. summarize the samples
sump 
#to summarize the parameter values using the same burn-in as the diagnostics in the mcmc command
sumt
#to summarize the trees using the same burn-in as the mcmc command


