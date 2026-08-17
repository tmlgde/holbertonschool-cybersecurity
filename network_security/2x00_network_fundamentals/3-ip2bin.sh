#!/bin/bash
set -- ${1//./ }; printf "%08d.%08d.%08d.%08d\n" $(echo "obase=2;$1" | bc) $(echo "obase=2;$2" | bc) $(echo "obase=2;$3" | bc) $(echo "obase=2;$4" | bc)
