FROM ademus4/root-6-14:latest
USER root
WORKDIR /work
COPY . /work

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

# HIPO
RUN git clone --recurse-submodules https://github.com/dglazier/Clas12Tool.git \
&& cd Clas12Tool \
&& git checkout mesonex
RUN cd Clas12Tool/Lz4 && make

# install HASPECT
RUN git clone https://github.com/dglazier/HASPECT6 \
&& cd HASPECT6 \
&& git checkout experiments

RUN cp $HSCODE/rootrc .rootrc

# Allow incoming connections on port 8888
EXPOSE 8888

# should run root --hsexp?? then all library files are built, no need for user to have permission to compile themselves
# also faster for the user (slower for build)

RUN root --hsexp

# general environment variables
ADD environment.sh /etc/profile.d
ADD jupyter_notebook_config.py /work/
