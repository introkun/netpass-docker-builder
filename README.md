# Containerized environment for building NetPass with docker
## Prerequisites
- Running Linux OS 
- Installed docker engine from [docker.io](https://docs.docker.com/desktop/install/linux-install/)
## Building environment
To build the environment image - run command:
```bash
docker build -t netpass_builder -f ./Dockerfile ./
```
Build environment image need to be created once and recreated with the same command every time `Dockerfile` changed.
## Compilation with Docker 
Checkout original NetPass source and inside run command: 
```bash
docker run --rm -v ./:/build/source -u $(id -u):$(id -g) -ti netpass_builder
```

By default builder will execute command `make clean codegen;make cia`, to override arguments to `make` add at the end of previous command arguments of your choose. 

Example:
```bash
docker run --rm -v ./:/build/source -u $(id -u):$(id -g) -ti netpass_builder clean
```
This will run command `make clean` overriding default arguments

# Afterword
For now it was created as Proof of Concept and can be changed in the future to being more universal. Probably will use multistage capabilities.