#!/bin/sh

init="step3_input"
mini_prefix="step4.0_minimization"
equi_prefix="step4.1_equilibration"
prod_prefix="step5_production"
prod_step="step5"

gmx grompp -f "${mini_prefix}.mdp" -o "${mini_prefix}.tpr" -c "${init}.gro" -r "${init}.gro" -p topol.top -n index.ndx
gmx mdrun -v -deffnm "${mini_prefix}"


gmx grompp -f "${equi_prefix}.mdp" -o "${equi_prefix}.tpr" -c "${mini_prefix}.gro" -r "${init}.gro" -p topol.top -n index.ndx
gmx mdrun -v -deffnm "${equi_prefix}"


cnt=1
cntmax=10

while [ ${cnt} -le ${cntmax} ]
do
    pcnt=$((cnt - 1))
    istep="${prod_step}_${cnt}"
    pstep="${prod_step}_${pcnt}"

    if [ "$cnt" -eq 1 ]; then
        pstep="$equi_prefix"
        gmx grompp -f "${prod_prefix}.mdp" -o "${istep}.tpr" -c "${pstep}.gro" -p topol.top -n index.ndx
    else
        gmx grompp -f "${prod_prefix}.mdp" -o "${istep}.tpr" -c "${pstep}.gro" -t "${pstep}.cpt" -p topol.top -n index.ndx
    fi

    gmx mdrun -v -deffnm "$istep"
    cnt=$((cnt + 1))
done