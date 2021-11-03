FROM python:3.8-bullseye

########
# Base #
########

RUN pip install mkdocs>=1.1.2 mkdocs-material>=7.1.0

##########
# Linter #
##########

RUN apt update && apt install -y nodejs npm aspell git

RUN npm install -g markdownlint-cli markdown-link-check

WORKDIR /docs

CMD ["mkdocs", "build", "--verbose", "--strict"]
