FROM ademus4/root-6-14:latest
USER root
WORKDIR /work
ENV HOME /work
ENV ROOTSYS /usr/local/bin/root
ENV HSCODE /work/HASPECT6
ENV HSEXP $HSCODE/hsexperiments/clas12tool
ENV CLAS12ROOT /work/clas12root/
ENV USE_HIPO4 1
ENV HSFINAL 1
ENV PATH="$PATH:$CLAS12ROOT/bin"
ENV DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes


# make cmake3 the default
RUN ln -s cmake3 /usr/bin/cmake

# install python dependancies and extra software
RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install jupyter metakernel zmq ipython

# install requirements for novnc server
RUN yum install -y fluxbox \
    novnc \
    x11vnc \
    xterm \
    xvfb \
    socat \
    supervisor \
net-tools

# setting up the root kernal with jupyter
RUN cp -r /usr/local/etc/root/notebook/kernels/root /usr/share/jupyter/kernels/

# get CLAS12ROOT
RUN git clone --recurse-submodules https://github.com/dglazier/clas12root.git \
&& cd clas12root \
&& git checkout master \
&& ./installC12Root

# install HASPECT
RUN git clone https://github.com/dglazier/HASPECT6 \
&& cd HASPECT6 \
&& git checkout sector-hits 

# important paths for HASPECT and ROOT
RUN cp HASPECT6/rootrc .rootrc

# compile common haspect code ready for user
RUN root --hsexp

# Allow incoming connections on port 8888 for notebook
EXPOSE 8888
# open vnc port
EXPOSE 8080

# general environment variables
ADD environment.sh .bashrc
RUN mkdir /work/.jupyter/
ADD jupyter_notebook_config.py /work/.jupyter/

# make sure the work directory can be modified by any user
RUN chmod -R 777 /work

# run novnc server
COPY . /app
CMD ["/app/entrypoint.sh"]