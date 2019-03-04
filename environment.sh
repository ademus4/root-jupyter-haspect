source /usr/local/bin/thisroot.sh
export DISPLAY=localhost:0.0
export ROOTSYS=/usr/local/bin/root

# set haspect environment
export HSCODE=/work/HASPECT6
export HSEXP=$HSCODE/hsexperiments/clastools
export CLAS12TOOL=/work/Clas12Tool/

# clas12tool
alias ll="ls -l"
alias clas12reader="root -l $CLAS12TOOL/RunRoot/importToROOT.C"
alias hipodraw="root -l $CLAS12TOOL/RunRoot/hiporoot/LoadHipoROOT.C"
