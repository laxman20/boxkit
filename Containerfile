FROM quay.io/fedora/fedora-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="laxman"

ARG user=laxmansooriyathas

RUN useradd --system --create-home $user && \
  echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user

USER root


COPY extra-packages /

RUN dnf -y upgrade && \
    dnf -y install $(<extra-packages)

RUN rm /extra-packages

RUN curl --create-dirs -o /usr/share/terminfo/x/xterm-kitty -fSL https://github.com/kovidgoyal/kitty/raw/master/terminfo/x/xterm-kitty

WORKDIR /atuin

RUN curl https://api.github.com/repos/atuinsh/atuin/releases/latest  \
        | jq '.assets[] | select(.name | test("aarch64.*linux")).browser_download_url' \
        | xargs curl -LJ -o atuin.tar.gz && \
    tar -xvf atuin.tar.gz && \
    mv atuin-*/atuin /usr/bin && \
    rm -rf /artuin.tar.gz && \
    rm -rf /atuin

WORKDIR /

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y -b /usr/bin

