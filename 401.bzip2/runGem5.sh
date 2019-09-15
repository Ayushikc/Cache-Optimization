# -- Benchmark 401.bzip2 --
export GEM5_DIR=/usr/local/gem5
export BENCHMARK=./src/benchmark
export ARGUMENT=./data/input.program


L1I=0
L1DAso=0
L1D=0
L1IAso=1
T=1						#Counter for No of simulations

# -- Array to set size of L1 Data Cache --
L1D_cachesize[1]=32
L1D_cachesize[2]=64
L1D_cachesize[3]=128

# -- Array to set size of L1 Instruction Cache --
L1I_cachesize[1]=32
L1I_cachesize[2]=64
L1I_cachesize[3]=128


# -- Array to set associativity of L1 Data Cache --
L1D_assocoativity[1]=1
L1D_assocoativity[2]=4
L1D_assocoativity[3]=8

# -- Array to set associativity of L1 Instruction Cache --
L1I_assocoativity[1]=1
L1I_assocoativity[2]=8

# -- Array to define Cache Block size --
SizeofBlock[0]=32
SizeofBlock[1]=64


for L1D in `seq 0 1 2`					#Loop for L1-D Cache size 
do 	
	((L1D++))
	

	for L1I in `seq 0 1 2`				#Loop for L1-I Cache size
	do	
		((L1I++))
	
		 
		for L1DAso in `seq 0 1 2`			#Loop for L1-D Associativity
		do 
			((L1DAso++))
			 
			for L1IAso in `seq 0 1 1`		#Loop for L1-I Associativity
			do
				((L1IAso++))
				
				for m in `seq 0 1 1`	#Loop for Cache Block Size
				do
				
					 $GEM5_DIR/build/X86/gem5.opt -d ./m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o "10" -o $ARGUMENT -I 500000000 --cpu-type=TimingSimpleCPU --caches --l2cache --l1d_size=${L1D_cachesize[$L1D]}kB --l1i_size=${L1I_cachesize[$L1I]}kB  --l2_size=1MB --l1d_assoc=${L1D_assocoativity[$L1DAso]} --l1i_assoc=${L1I_assocoativity[$L1IAso]} --l2_assoc=1 --cacheline_size=${SizeofBlock[$m]}
			
					# -- Creating Seperate Stats files and Config files for all Simulations --
					cp ./m5out/config.ini ./m5out/config_$T.ini				
					cp ./m5out/stats.txt ./m5out/stats_$T.txt
					
					# -- Writing desired parameters in the Output File
					echo "$T: L1 Cache D-size =${L1D_cachesize[$L1D]}kB, L1 Cache I-size=${L1I_cachesize[$L1I]}kB, L1 D-Asso=${L1D_assocoativity[$L1DAso]}, L1 I-Asso=${L1I_assocoativity[$L1IAso]}, Block_size = ${SizeofBlock[$m]}" >> ./m5out/output.txt
					egrep  "system.cpu.dcache.overall_miss_rate::total|system.cpu.icache.overall_miss_rate::total|system.l2.overall_miss_rate::total" ./m5out/stats_$T.txt >> ./m5out/output.txt
					
					if [ $m == 1 ]			
					then 
						m=0
					else	
						((m++))
					fi
					((T++))
				done
			done
		done
	done
done
