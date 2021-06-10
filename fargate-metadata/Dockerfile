FROM ubuntu:18.04
RUN apt-get update && apt-get install curl jq -y
COPY ./entrypoint.sh /tmp
RUN chmod u+x /tmp/entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh"]