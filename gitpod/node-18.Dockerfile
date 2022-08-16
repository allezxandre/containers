# See: https://hub.docker.com/r/gitpod/workspace-full/tags
ARG GITPOD_BASE_IMAGE=gitpod/workspace-full:latest
FROM $GITPOD_BASE_IMAGE

# Set up Node 18 and enyable Node Corepack
RUN bash -c 'VERSION="18" \
    && source $HOME/.nvm/nvm.sh && nvm install $VERSION \
    && nvm use $VERSION && nvm alias default $VERSION \
    && corepack enable'

# Make NVM use the default version in Bash RC
RUN echo "nvm use default &>/dev/null" >> ~/.bashrc.d/51-nvm-fix-use-default

# Set up Vite HMR to work with Gitpod
RUN echo 'export GITPOD_HMR_HOST=`gp url 5173`' >> ~/.bashrc.d/52-vite-hmr
