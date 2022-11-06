# See: https://hub.docker.com/r/gitpod/workspace-full-vnc/tags
FROM gitpod/workspace-full-vnc:2022-11-04-17-43-13

# Set up Node 18 and enyable Node Corepack
RUN bash -c 'VERSION="18" \
    && source $HOME/.nvm/nvm.sh && nvm install $VERSION \
    && nvm use $VERSION && nvm alias default $VERSION \
    && corepack enable'

# From: https://www.mikenikles.com/blog/develop-cypress-end-to-end-tests-on-gitpod-io-virtual-desktop-included
# Install Cypress dependencies.
RUN sudo install-packages \
    libgtk2.0-0 \
    libgtk-3-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb

# Make NVM use the default version in Bash RC
RUN echo "nvm use default &>/dev/null" >> ~/.bashrc.d/51-nvm-fix-use-default

# Set up Vite HMR to work with Gitpod
RUN echo 'export GITPOD_HMR_HOST=`gp url 5173`' >> ~/.bashrc.d/52-vite-hmr