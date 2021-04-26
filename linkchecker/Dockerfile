FROM webpage:base

###############
# Linkchecker #
###############

RUN apt update && apt install -y nodejs npm

RUN npm install -g markdown-link-check

WORKDIR /src/linkchecker

