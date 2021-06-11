# 基本原理
容器通过访问 [Fargate Metadata Endpoint](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-metadata-endpoint-v4-fargate.html) 获取 Task 相关的信息，包括 IP 等
容器镜像打包时，在 [Dockerfile](Dockerfile) 中指定 ENTRYPOINT 执行启动脚本 [entrypoint.sh](entrypoint.sh) ，在启动脚本通过 curl Metadata Endpoint 获取容器 IP 信息，并做为启动程序（如Java)的参数，以帮助应用程序获取正确的容器 IP 地址

# 与常见服务发现组件集成
## 与 Eureka 集成
启动脚本示例：
```bash
#!/bin/sh
export TASK_IP_ADDRESS=$(curl ${ECS_CONTAINER_METADATA_URI_V4} | jq ".Networks[0].IPv4Addresses[0]")
exec java ${JAVA_OPTS} -Deureka.instance.ip-address=${TASK_IP_ADDRESS} -Deureka.instance.prefer-ip-address=true -Deureka.instance.instance-id=${TASK_IP_ADDRESS}:${SERVER_PORT}  -Deureka.instance.status-page-url=http://${TASK_IP_ADDRESS}:${SERVER_PORT}/swagger-ui.html -jar /api-auth.jar
```

## 与 Nacos 集成
启动脚本示例：
```bash
#!/bin/bash
export TASK_IP_ADDRESS=$(/usr/bin/curl ${ECS_CONTAINER_METADATA_URI_V4} | /usr/bin/jq ".Networks[0].IPv4Addresses[0]" |sed $'s/\"//g')
exec java  -Dspring.cloud.nacos.discovery.ip=${TASK_IP_ADDRESS} -jar app.jar
```