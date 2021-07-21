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
hpx_source_dir="/home/sshirzad/src/hpx"
hpx_build_dir="${hpx_source_dir}/build_release_clang_no_hpxmp_${node}_main"
hpx_bin_dir="${hpx_build_dir}/bin"
hpx_log_dir="${hpx_build_dir}/info/"
results_dir="${eigendata_dir}/results_hpx"

matrix_sizes=(50 100 500 1000 5000)
thr=(1 2 3 4 5 6 7 8 10 12 16)
mkdir -p ${results_dir}
rm -rf ${results_dir}/*.dat
rm -rf ${results_dir}/info_${node}/
mkdir -p ${results_dir}/info_${node}/hpx_info
date>> ${results_dir}/info_${node}/date.txt
cp ${eigendata_dir}/scripts/run_hpx.sh ${results_dir}/info_${node}/
cp -r $hpx_log_dir/* ${results_dir}/info_$node/hpx_info

for m_size in ${matrix_sizes[@]}
do
	echo "matrix size ${m_size}"
	for th in ${thr[@]}
		do
		echo "${th} threads"
	
		export OMP_NUM_THREADS=1
	
		~/src/EigenTest/build_hpx/EigenTest ${m_size} 6 --hpx:threads=${th} --hpx:queuing=static-priority>>${results_dir}/${node}_hpx-eigentest_${th}_${m_size}.dat
		echo "Run for matrix size ${m_size}, on ${th} threads finished"			
	done
done

