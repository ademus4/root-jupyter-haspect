FROM ademus4/root-6-14:latest
USER root
WORKDIR /work
ENV HOME /work

# set environment variables
## root
ENV DISPLAY localhost:0.0
ENV ROOTSYS /usr/local/bin/root

# install python dependancies and extra software
RUN yum install -y python-setuptools nano
RUN easy_install pip
RUN pip install jupyter metakernel zmq ipython

# setting up the root kernal with jupyter
RUN cp -r /usr/local/etc/root/notebook/kernels/root /usr/share/jupyter/kernels/

# set haspect env   # update these!!
ENV HSCODE /work/HASPECT6
ENV HSEXP $HSCODE/hsexperiments/clastools
ENV CLAS12TOOL /work/Clas12Tool/

# clas12tools
RUN git clone --recurse-submodules https://github.com/dglazier/Clas12Tool.git \
&& cd Clas12Tool \
&& git checkout proof
RUN cd Clas12Tool/Lz4 && make

# install HASPECT
RUN git clone https://github.com/dglazier/HASPECT6 \
&& cd HASPECT6 \
&& git checkout hsfit

# important paths for HASPECT and ROOT
RUN cp $HSCODE/rootrc .rootrc

# Allow incoming connections on port 8888
EXPOSE 8888

# compile common haspect code ready for user
RUN root --hsexp
RUN root -l $CLAS12TOOL/RunRoot/importToROOT.C
RUN root -l $CLAS12TOOL/RunRoot/hiporoot/LoadHipoROOT.C

# general environment variables
ADD environment.sh .bashrc
RUN mkdir /work/.jupyter/
ADD jupyter_notebook_config.py /work/.jupyter/

# make sure the work directory can be modified by any user
RUN chmod -R 777 /work
