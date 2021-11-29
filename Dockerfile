FROM python:3.8-bullseye

SHELL ["/bin/bash", "-c"]

########
# Base #
########

RUN pip install mkdocs>=1.1.2 mkdocs-material>=7.1.0

##########
# Linter #
##########

RUN apt update && apt install -y nodejs npm aspell git

RUN npm install -g markdownlint-cli markdown-link-check

###########################################
# prepare git for automatic merging in CI #
###########################################
RUN git config --global user.name 'Gitlab Bot'
RUN git config --global user.email 'hpcsupport@zih.tu-dresden.de'

RUN mkdir -p ~/.ssh

#see output of `ssh-keyscan gitlab.hrz.tu-chemnitz.de`
RUN echo $'# gitlab.hrz.tu-chemnitz.de:22 SSH-2.0-OpenSSH_7.4\n\
gitlab.hrz.tu-chemnitz.de ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNixJ1syD506jOtiLPxGhAXsNnVfweFfzseh9/WrNxbTgIhi09fLb5aZI2CfOOWIi4fQz07S+qGugChBs4lJenLYAu4b0IAnEv/n/Xnf7wITf/Wlba2VSKiXdDqbSmNbOQtbdBLNu1NSt+inFgrreaUxnIqvWX4pBDEEGBAgG9e2cteXjT/dHp4+vPExKEjM6Nsxw516Cqv5H1ZU7XUTHFUYQr0DoulykDoXU1i3odJqZFZQzcJQv/RrEzya/2bwaatzKfbgoZLlb18T2LjkP74b71DeFIQWV2e6e3vsNwl1NsvlInEcsSZB1TZP+mKke7JWiI6HW2IrlSaGqM8n4h\n\
gitlab.hrz.tu-chemnitz.de ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/cSNsKRPrfXCMjl+HsKrnrI3HgbCyKWiRa715S99BR\n' > ~/.ssh/known_hosts

WORKDIR /docs

CMD ["mkdocs", "build", "--verbose", "--strict"]
