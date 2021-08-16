# Copied from gitpod/workspace-base's Dockerfile from https://github.com/gitpod-io/workspace-images/commit/cc84194ce4bef23db1d380e73a253b5d3da83ff4,
# which licensed under the MIT License.

# To use GitLab Dependency Proxy or another Docker Hub container registry pull-through proxy,
# add an build arg pointing to this one. When unused, it'll pull directly from Docker Hub
# which subject to their ratelimiting policies.
ARG BASE_IMAGE_CUSTOM=buildpack-deps:focal
FROM ${BASE_IMAGE_CUSTOM}

# Copy the install-packages script first
COPY bin/install-packages /usr/local/bin

### base ###
ARG DEBIAN_FRONTEND=noninteractive

RUN yes | unminimize \
    && install-packages \
        zip \
        unzip \
        bash-completion \
        build-essential \
        ninja-build \
        htop \
        jq \
        less \
        locales \
        man-db \
        nano \
        ripgrep \
        software-properties-common \
        sudo \
        time \
        vim \
        multitail \
        lsof \
        ssl-cert \
        fish \
        zsh \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8

### Git ###
RUN add-apt-repository -y ppa:git-core/ppa \
    && install-packages git git-lfs

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

# Init /workspace directory for those who use this image directly (probably to use code-server)
# instead of using it as part of your Gitpod workspace configuration.
# Note that this will be lost when using this image in Gitpod, through it's recommended to run
# the init-gitpodify-dir script ahead of time.
RUN mkdir -p /workspace/.gitpodify/logs \
    # Temporary files
    && mkdir /workspace/.gitpodify/tmp \
    # GNUPGHOME
    && mkdir /workspace/.gitpodify/gnupghome \
    && chown gitpod:gitpod -R /workspace \
    # JUst fix some chaos
    && chmod -Rv 700 /workspace/.gitpodify/gnupghome

ENV HOME=/home/gitpod \
    # Point Gitpodify homedir to the presistent /workspace directory btw
    GITPODIFY_DIR_PREFIX=/workspace/.gitpodify \
    GNUPGHOME=/workspace/.gitpodify/gnupghome \
    # This variable are just an way for others to know that we're inside an Gitpd workspace
    GITPOD=true

WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 \" (%s)\") $ '" ; } >> .bashrc

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    # create .bashrc.d folder and source it in the bashrc
    mkdir /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc

COPY bin/setup-dotfiles-dir /home/gitpod/.local/bin/setup-dotfiles
COPY bin/init-gitpodify-dir /home/gitpod/.local/bin

# configure git-lfs
RUN sudo git lfs install --system

# Then place our Workspace Dotfiles last on $HOME/.bashrc.d directory
COPY ./bashrcdir/workspace-dotfiles.bashrc /home/gitpod/.bashrc.d/99-workspace-dotfiles

### Docker ###
# WARNING: IDK if we can use Dazzle on GitHub Actions/GitLab CI, but good luck.
LABEL dazzle/layer=docker-tools
LABEL dazzle/test=tests/docker-tools.yaml
ENV TRIGGER_REBUILD=2
# https://docs.docker.com/engine/install/ubuntu/
RUN curl -o /var/lib/apt/dazzle-marks/docker.gpg -fsSL https://download.docker.com/linux/ubuntu/gpg \
    && sudo apt-key add /var/lib/apt/dazzle-marks/docker.gpg \
    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && sudo install-packages docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03.15~3-0~ubuntu-focal containerd.io \
    # Docker Compose
    && curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/1.28.5/docker-compose-Linux-x86_64 \
    && chmod +x /usr/local/bin/docker-compose
RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.9/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns
# https://github.com/wagoodman/dive
RUN curl -o /tmp/dive.deb -fsSL https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb \
    && apt install /tmp/dive.deb \
    && rm /tmp/dive.deb

### Prologue (built across all layers) ###
LABEL dazzle/layer=dazzle-prologue
LABEL dazzle/test=tests/ownership-checks-homedir.yml
RUN sudo curl -o /usr/bin/dazzle-util -fsSL https://github.com/csweichel/dazzle/releases/download/v0.0.3/dazzle-util_0.0.3_Linux_x86_64 \
    && sudo chmod +x /usr/bin/dazzle-util \
    && wget -qO- https://github.com/gitpod-io/dazzle/releases/download/v0.1.2/dazzle_0.1.2_Linux_x86_64.tar.gz | tar -xJv -C /tmp \
    && sudo cp /tmp/dazzle/dazzle /usr/bin/ \
    && rm -rfv /tmp/*
# merge dpkg status files
RUN cp /var/lib/dpkg/status /tmp/dpkg-status \
    && for i in $(ls /var/lib/apt/dazzle-marks/*.status); do /usr/bin/dazzle-util debian dpkg-status-merge /tmp/dpkg-status $i > /tmp/dpkg-status; done \
    && cp -f /var/lib/dpkg/status /var/lib/dpkg/status-old \
    && cp -f /tmp/dpkg-status /var/lib/dpkg/status
# correct the path as per https://github.com/gitpod-io/gitpod/issues/4508
ENV PATH=$PATH:/usr/games
# merge GPG keys for trusted APT repositories
RUN for i in $(ls /var/lib/apt/dazzle-marks/*.gpg); do apt-key add "$i"; done
# copy tests to enable the self-test of this image
# Repeat this for the main image btw
COPY tests /var/lib/dazzle/tests
