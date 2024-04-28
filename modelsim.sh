#!/bin/bash

if [ -z $1 ]; then
    echo "USAGE: ./modelsim.sh <numero-etapa>"
    exit 1
fi

ETAPA=$1

RE='^[0-9]+([.][0-9]+)?$'
if ! [[ $ETAPA =~ $RE ]]; then
    echo "ERROR: numero-etapa ha de ser un número."
    exit 1
fi

VSIM=$(command -v vsim)

if [ -x "$VSIM" ]; then
    # Si tenemos vsim instalado en el path
    vsim -do "./Etapa $ETAPA/src/test_files/runsim.tcl"
else
    # Si no lo tenemos instalado, instalamos la imagen de docker de Alex Torregrossa
    sudo docker run\
        --rm\
        -ti\
        -v /tmp/.X11-unix:/tmp/.X11-unix:rw\
        -v "$(pwd)/Etapa $ETAPA/src":/home/usuari:rw\
        -e DISPLAY=$DISPLAY\
        -e LD_LIBRARY_PATH=/root/altera/13.0sp1/modelsim_ase/lib32\
        -e HOME=/home/usuari\
        --user=$(id -u):$(id -g)\
        --ipc=host --cap-add=SYS_PTRACE\
        --security-opt seccomp=unconfined\
        registry.gitlab.com/axtaor/practicas-ac2:latest\
        /root/altera/13.0sp1/modelsim_ase/linux/vsim -do /home/usuari/test_files/runsim.tcl
fi
