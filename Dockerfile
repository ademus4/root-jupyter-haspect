FROM rootproject/root-ubuntu16:latest
USER root
WORKDIR /work
COPY . /work

# set environment variables
## haspect
ENV HSCODE /work/HASPECT6
ENV HSANA /work/HASPECT6/HaSpect
ENV HSEXP $HSCODE/hsexperiments/clas12
ENV RHIPO /work/HASPECT6/ExtraPackages/rhipo3
ENV CHIPO /work/software/hipo/libcpp
ENV LD_LIBRARY_PATH /work/software/lz4/lib
ENV LZ4_h /work/software/lz4/lib
## root
ENV DISPLAY localhost:0.0
ENV ROOTSYS /usr/local/bin/root

# install python dependancies
RUN apt-get -y update && sudo apt-get install -y wget
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN sudo python get-pip.py
RUN sudo pip install jupyter metakernel zmq

# lz4
RUN mkdir software && cd software \
&& git clone https://github.com/lz4/lz4.git \
&& cd lz4 \
&& make && sudo make install

# HIPO
RUN cd software \
&& wget http://nuclear.gla.ac.uk/~adamt/software/hipo.zip \
&& unzip hipo.zip

# install HASPECT
RUN git clone https://github.com/dglazier/HASPECT6 \
&& cd HASPECT6 \
&& git checkout experiments
RUN cp $HSCODE/rootrc /root/.rootrc

# Create a user that does not have root privileges 
ARG username=physicist
RUN userdel builder && useradd --create-home --home-dir /home/${username} ${username}
ENV HOME /home/${username}

WORKDIR /home/${username}

# Create the configuration file for jupyter and set owner
RUN echo "c.NotebookApp.ip = '0.0.0.0'" > jupyter_notebook_config.py && chown ${username} *

# Switch to our newly created user
USER ${username}

# Allow incoming connections on port 8888
EXPOSE 8888

# Start root
CMD ["root", "--notebook"]

