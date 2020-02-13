source /usr/local/bin/thisroot.sh
export DISPLAY=localhost:0.0
export ROOTSYS=/usr/local/bin/root

# set haspect environment
export HSCODE=/work/HASPECT6
export HSEXP=$HSCODE/hsexperiments/clas12tool
export CLAS12ROOT=/work/clas12root_dg/
export USE_HIPO4=1
export HSFINAL=1
export PATH="$PATH":"$CLAS12ROOT/bin"
export HIPO=/work/hipo

# useful aliases
alias hadd="$ROOTSYS/bin/hadd"

