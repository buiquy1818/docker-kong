===========
docker-kong
===========

| |dockerhub|

.. |dockerhub| image:: http://dockeri.co/image/vikingco/kong
    :alt: Docker Hub
    :target: https://registry.hub.docker.com/u/vikingco/kong/

Prerequisites
-------------

1. docker (I'm running v1.8.2)
2. docker-compose (I'm running v1.3.3)

Quickstart
----------

1. Create docker-compose.yml and add::

    cassandra:
      image: mashape/cassandra

    kong:
      image: vikingco/kong
      links:
        - cassandra
      ports:
        - "8001:8001"
        - "8000:8000"
    
    kong-dashboard:
      image: pgbi/kong-dashboard
      links:
        - kong
      ports:
        - "80:8080"

2. $ docker-compose up

Rebuild
-------

1. $ git clone git@github.com:vikingco/docker-kong.git
2. $ cd docker-kong
3. $ docker-compose up

