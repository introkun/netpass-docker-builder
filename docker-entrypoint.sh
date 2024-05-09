#!/bin/bash

if [[ $# -eq 0 ]];then
    make clean codegen
    make cia
else
    # shellcheck disable=SC2068
    make $@
    $#
fi