FROM rootproject/root-ubuntu16:latest  # update with my centos version
USER root
WORKDIR /work
COPY . /work

# set environment variables
## root
ENV DISPLAY localhost:0.0
ENV ROOTSYS /usr/local/bin/root

# install python dependancies
RUN apt-get -y update && sudo apt-get install -y wget  # these commands will need to change
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN sudo python get-pip.py
RUN sudo pip install jupyter metakernel zmq

# extra software
RUN sudo apt-get install -y nano

####### don't need this any more #####

# Create a user that does not have root privileges 
ARG username=physicist
RUN userdel builder && useradd --create-home --home-dir /home/${username} ${username}
ENV HOME /home/${username}
WORKDIR /home/${username}

# Switch to our newly created user
#USER ${username}

# need to think about paths and how the user will find everything (copy .rootrc? somewhere? global settings?)

#####################################

# set haspect env   # update these!!
ENV HSCODE /home/${username}/HASPECT6
ENV HSEXP $HSCODE/hsexperiments/clastools
ENV CLAS12TOOL /home/${username}/Clas12Tool/

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

# Create the configuration file for jupyter and set owner
RUN echo "c.NotebookApp.ip = '0.0.0.0'" > jupyter_notebook_config.py && chown ${username} *
# have this in some kind of config file? add at the beginning? related to jupyter kernal?

# Allow incoming connections on port 8888
EXPOSE 8888

# should run root --hsexp?? then all library files are built, no need for user to have permission to compile themselves
# also faster for the user (slower for build)

# how to add a ROOT kernal to jupyter notebook?
