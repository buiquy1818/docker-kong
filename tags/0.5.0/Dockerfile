###########################################################
# Kong 0.5.0 (http://getkong.org)
###########################################################
FROM mashape/kong:0.5.0
MAINTAINER Dirk Moors

# expose ports
EXPOSE 8000 8443 8001 8053

# expose run command
CMD echo "Waiting 5 seconds..." \
    && sleep 5 \
    && kong start
