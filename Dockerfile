FROM ademus4/root-6-14:latest
USER root
WORKDIR /work
ENV HOME /work
ENV DISPLAY localhost:0.0
ENV ROOTSYS /usr/local/bin/root
ENV HSCODE /work/HASPECT6
ENV HSEXP $HSCODE/hsexperiments/clas12tool
ENV CLAS12ROOT /work/clas12root/
ENV USE_HIPO4 1
ENV HSFINAL 1
ENV PATH="$PATH:$CLAS12ROOT/bin"

#COPY environment.sh .

# set environment variables
#RUN /bin/bash -c "source environment.sh"

# get CLAS12ROOT
RUN git clone --recurse-submodules https://github.com/dglazier/clas12root.git \
&& cd clas12root \
&& git checkout mesonextrigger \
&& ./installC12Root

# install dependancies
#RUN cd /work/clas12root/lz4 && make
#RUN cd /work/clas12root/hipo4 && make 

# install HASPECT
RUN git clone https://github.com/dglazier/HASPECT6 \
&& cd HASPECT6 \
&& git checkout hsfarm 

# important paths for HASPECT and ROOT
RUN cp HASPECT6/rootrc .rootrc

# compile common haspect code ready for user
RUN root --hsexp

# make sure the work directory can be modified by any user
RUN chmod -R 777 /work
