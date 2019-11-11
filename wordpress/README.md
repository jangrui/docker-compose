# Docker 部署 WordPress

![wordpress](./wordpress.png)

## 目录结构

```
wordpress
├── README.md
├── docker-compose.yml
├── nginx
│   ├── cert
│   ├── conf.d
│   │   └── wordpress.conf
│   └── logs
└── wordpress.png
```

## 部署

> 直接使用docker-compose一键启动

```
git clone https://github.com/jangrui/docker-compose
cd docker-compose/wordpress
docker-compose up -d
```
