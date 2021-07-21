#!/bin/bash
module load clang
module load boost
if [ $# -eq 0 ]
then
        echo "node not specified, marvin by default"
        node="marvin"
else
        node=$1
fi

echo "Running on ${node}"


counter=0
saved_path=$LD_LIBRARY_PATH
eigendata_dir="/work/sshirzad/repos/EigenData"
results_dir="${eigendata_dir}/results_openmp"

matrix_sizes=(50 100 500 1000)
matrix_sizes=(5000)
thr=(1 2 3 4 5 6 7 8 10 12 16)
mkdir -p ${results_dir}
rm -rf ${results_dir}/*.dat
rm -rf ${results_dir}/info_${node}/
mkdir -p ${results_dir}/info_${node}/
date>> ${results_dir}/info_${node}/date.txt
cp ${eigendata_dir}/scripts/run_openmp.sh ${results_dir}/info_${node}/

for m_size in ${matrix_sizes[@]}
do
	echo "matrix size ${m_size}"
	for th in ${thr[@]}
		do
		echo "${th} threads"
	
	        OMP_NUM_THREADS=${th} ~/src/EigenTest/build_openmp/EigenTest ${m_size} 6 >>${results_dir}/${node}_openmp-eigentest_${th}_${m_size}.dat
		echo "Run for matrix size ${m_size}, on ${th} threads finished"			
	done
done

