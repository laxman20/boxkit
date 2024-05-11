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

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

