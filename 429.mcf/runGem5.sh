# -- Benchmark 429.mcf --
export GEM5_DIR=/usr/local/gem5
export BENCHMARK=./src/benchmark
export ARGUMENT=./data/inp.in


L1I=0
L1DAso=0
L1D=0
L1IAso=1
T=1

#LOOPS FOR SIMULATIONS

# --Setting L1 Data Cache Array size --
L1D_cachesize[1]=32
L1D_cachesize[2]=64
L1D_cachesize[3]=128

# -- Setting L1 Data Cache Array size --
L1I_datasize[1]=32
L1I_datasize[2]=64
L1I_datasize[3]=128


# --Setting L1 Data Cache Array associativity --
L1D_assosciativity[1]=1
L1D_assosciativity[2]=4
L1D_assosciativity[3]=8

# -- Setting L1 Instruction Cache Array associativity --
L1I_assosciativity[1]=1
L1I_assosciativity[2]=8

# -- Cache Block Size Array --
SizeofBlock[0]=32
SizeofBlock[1]=64


#L1-D Cache size Loop
for L1D in `seq 0 1 2`
do 	
	((L1D++))
	
#L1-I Cache size Loop
	for L1I in `seq 0 1 2`
	do	
		((L1I++))
	
#L1-D Associativity Loop
		for L1DAso in `seq 0 1 2`
		do 
			((L1DAso++))

#L1-I Associativity Loop
			for L1IAso in `seq 0 1 1`
			do
				((L1IAso++))

#Cache Block Size Loop
				for CBS in `seq 0 1 1`
				do
				
					time $GEM5_DIR/build/X86/gem5.opt -d ./m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT -I 500000000 --cpu-type=TimingSimpleCPU --caches --l2cache --l1d_size=${L1D_cachesize[$L1D]}kB --l1i_size=${L1I_datasize[$L1I]}kB  --l2_size=1MB --l1d_assoc=${L1D_assosciativity[$L1DAso]} --l1i_assoc=${L1I_assosciativity[$L1IAso]} --l2_assoc=1 --cacheline_size=${SizeofBlock[$CBS]}
			
					# -- Creating Seperate Stats files and Config files for all Simulations --
					mv ./m5out/config.ini ./m5out/config_$T.ini
					mv ./m5out/stats.txt ./m5out/stats_$T.txt
					
					# -- Writing desired parameters in the Output File
					echo "$T: L1 Cache D-size =${L1D_cachesize[$L1D]}kB, L1 Cache I-size=${L1I_datasize[$L1I]}kB, L1 D-Asso=${L1D_assosciativity[$L1DAso]}, L1 I-Asso=${L1I_assosciativity[$L1IAso]}, Block_size = ${SizeofBlock[$CBS]}" >> ./m5out/output.txt
					egrep  "system.cpu.dcache.overall_miss_rate::total|system.cpu.icache.overall_miss_rate::total|system.l2.overall_miss_rate::total" ./m5out/stats_$T.txt >> ./m5out/output.txt
					
					if [ $CBS == 1 ]
					then 
						CBS=0
					else	
						((CBS++))
					fi
					((T++))
				done
			done
		done
	done
done
