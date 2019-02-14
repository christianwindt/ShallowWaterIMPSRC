#!/bin/bash

#Set last time step as start

. ~/OpenFOAM/OpenFOAM-4.x/etc/bashrc

#reconstructPar -latestTime  > reconstruct.log
./CleanAll.sh
rm -r 0
cp -r zeroprep 0

cp  Wavemaker.dat constant/Wavemaker.dat
#Reset runtime
endTime=$(tail -n 2 Wavemaker.dat | cut -f 1 -d " " | head -n 1 | tr -d "(")
sed -i "/^endTime/ c\endTime $endTime\;" system/controlDict

decomposePar -force >preproc.log
for i in ./processor[0-9]; do cp constant/Wavemaker.dat $i/constant/ ;done
cp constant/Wavemaker.dat processor10/constant/
cp constant/Wavemaker.dat processor11/constant/
#cp constant/Wavemaker.dat processor10/constant/


mpirun -np 12 renumberMesh -parallel -overwrite >>preproc.log
mpirun -np 12 interDyMFoamUsrc -parallel>log
#interDyMFoamUsrc > log
cp postProcessing/waveprobes/0/alpha.water Elevation.mat
sed -i s/"#"/"%"/g Elevation.mat 


#interDyMFoamUsrc > log



