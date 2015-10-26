# Docker Trusted Private Registry Container

[![Build Status](https://travis-ci.org/UKHomeOffice/docker-s3registry.svg?branch=master)](https://travis-ci.org/UKHomeOffice/docker-s3registry)

Docker Trusted Private Registry Container. Requires fully trusted certs 

## Getting Started

These instructions will cover usage information and for the docker container 

### Prerequisites

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Container Parameters

Starting the registry without any parameters is also the default behaviour.

```shell
docker run \
    -v ${PWD}/secrets:/etc/secrets \
    -p 5000:5000
    quay.io/ukhomeofficedigital/s3registry:v2.0.0 \
```

#### Required secrets files

The yaml file below represents the secret files required to run the registry.

All the files are required to be present and mounted at /etc/secrets 

```yaml
---
kind: "Secret"
apiVersion: "v1"
metadata:
  name: "registry-secrets"
type: "Opaque"
data:
  s3-accesskey: bG9vayBpbiBhd3MgZm9yIGNyZWRzCg==
  s3-secretkey: bG9vayBpbiBhd3MgZm9yIGNyZWRzCg==
  s3-region: bG9vayBpbiBhd3MgZm9yIGNyZWRzCg==
  s3-bucket: bG9vayBpbiBhd3MgZm9yIGNyZWRzCg==
  key: dXNlIGEgcmVhbCBrZXkK
  crt: dXNlIGEgcmVhbCBjZXJ0Cg==
  docker_user: bXJkb2NrZXJ1c2VyCg==
  docker_pass: YmFkcGFzcwo=

```

## Contributing

Feel free to submit pull requests and issues. If it's a particualy large PR, you may wish to discuss
it in an issue first.

Please note that this project is released with a [Contributor Code of Conduct](code_of_conduct.md). 
By participating in this project you agree to abide by its terms.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the 
[tags on this repository](https://github.com/UKHomeOffice/docker-s3registry/tags). 

## Authors

* **Lewis Marshall** - *Initial work* - [lewismarshall](https://github.com/lewismarshall)

See also the list of [contributors](https://github.com/UKHomeOffice/docker-s3registry/contributors) who 
participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* Large portions of this container are taken from the 
  [official registry docker container](https://hub.docker.com/_/registry/).
