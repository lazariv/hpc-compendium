FROM debian:buster

###############
# Linkchecker #
###############

RUN apt update && apt install -y linkchecker

WORKDIR /src/linkchecker

ENTRYPOINT ["/usr/bin/linkchecker"]

CMD ["--help"]

