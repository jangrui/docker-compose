# ELK

## SELinux

```
$ chcon -R system_u:object_r:admin_home_t:s0 elk/
```

## Usage

```console
git clone https://github.com/jangrui/docker-compose
cd docker-compose/elk
docker-compose build
docker-compose up
```

## Cleanup

Elasticsearch data is persisted inside a volume by default.

In order to entirely shutdown the stack and remove all persisted data, use the following Docker Compose command:

```
docker-compose down -v
```
