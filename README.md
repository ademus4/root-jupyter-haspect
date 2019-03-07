# root-jupyter-haspect
Docker container with ROOT, Jupyter and HASPECT

## Instructions on using the CLAS12Tool Docker container
These are instructions on how to run and perform basic analysis of CLAS12 data using the CLAS12Tool software hosted within a dedicated Docker container.

Firstly the docker images needs to be pulled from Dockerhub:

```
docker pull ademus4/root-jupyter-haspect:hsfit
```

This will take some time to download the image (minutes). Once that is finished, you will see the newly downloaded image in the local list:

```
docker images
```

Running a docker image is as simple as the following:

```
docker run ademus4/root-jupyter-haspect:hsfit
```

However there are a few options that are needed/useful in doing practical work from within the container, as well as settings required for the various features to work. For a full list see the documentation on “docker run”:

https://docs.docker.com/engine/reference/commandline/run/

Aan example of starting up the container on a linux machine (ubuntu) may look like the following:

#!/usr/bin/env bash
docker run -it --rm \
    -v /home/adam/uni/:/local_work/ \
    -w /work/Clas12Tool/RunRoot/ \
    -p 8888:8888 \
    --user $(id -u):$(id -g) \
    ademus4/root-jupyter-haspect:hsfit \
    bash

Change the paths for the volume parameter to match somewhere useful. The parameters for the user are to match the current users ID and group ID. The last command points to the name of the docker container to be used, if it doesn’t exist on the host machine it will be downloaded at this point. 

If the command above was successful, you should have an open terminal like so:

```
bash-4.2$
```

You should be able to run a jupyter notebook at this point:

```
jupyter notebook
```

And this will be accessible from a browser at http://0.0.0.0:8888 (you may need to copy the token ID from the terminal to the browser).

Runnings some examples
In order to run the examples, some data is required! This can be found either on the Jlab work disk:

```
/work/clas12/jnp/clas_004152.recon.hipo
```

This should be put somewhere accessible by the container using the volume parameter. Once the container is running (script above) start a jupyter notebook instance:

```
jupyter notebook
```

Within the subfolder “jupy” are a number of notebooks to run to plot events from the data above. The path will need to be adjusted to wherever the files are stored locally. Remember all changes within the container will not be saved, only changes made on the mounted volumes will persist. 

