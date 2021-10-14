FROM python:3.8-bullseye

########
# Base #
########

COPY ./ /src/

RUN pip install -r /src/doc.zih.tu-dresden.de/requirements.txt

##########
# Linter #
##########

RUN apt update && apt install -y aspell 

RUN curl -sfL https://install.goreleaser.com/github.com/ValeLint/vale.sh | sh -s v2.11.1
ENV PATH="./bin:$PATH"
RUN vale -v
#RUN apt update && apt install -y nodejs npm aspell
#RUN npm install -g markdownlint-cli markdown-link-check

WORKDIR /src/doc.zih.tu-dresden.de

CMD ["mkdocs", "build", "--verbose", "--strict"]
