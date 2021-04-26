FROM webpage:base

##########
# Linter #
##########

RUN apt update && apt install -y nodejs npm

RUN npm install -g markdownlint-cli

WORKDIR /src/linter

ENTRYPOINT ["/usr/local/bin/markdownlint"]

CMD ["--help"]

