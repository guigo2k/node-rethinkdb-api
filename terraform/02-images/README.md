# Packer

The [Packer](https://www.packer.io/) templates are design to use the VPC Network, so make sure to deploy the VPC first. It creates the necessary `.env` to use with Packer.

### RethinkDB GCE Cloud Image
```
source ../.env
packer build rethinkdb-server.json
```

### RethinkDB Proxy Docker Image
`Obs.` Make sure you are logged in in Docker Hub!
```
docker login
source ../.env
packer build rethinkdb-proxy.json
```
