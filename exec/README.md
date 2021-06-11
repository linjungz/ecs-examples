## 1. 创建具有访问SSM权限的 IAM Policy
```json
{
   "Version": "2012-10-17",
   "Statement": [
       {
       "Effect": "Allow",
       "Action": [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
       ],
      "Resource": "*"
      }
   ]
}
```

## 2. 创建 ECS Task Role 并绑定上述 IAM Policy

在 Task Definition 中配置 Task Role , 以确保 Task 具有访问 SSM 的权限


## 3. 启动 Task / Service 并激活 exec 功能

启动 Task:
```bash
aws ecs run-task --cluster test --network-configuration "awsvpcConfiguration={subnets=subnet-1bbd897c,assignPublicIp=ENABLED}" --task-definition nginx-exec --launch-type FARGATE --enable-execute-command
```

查看 Task 是否已激活 exec 功能
```bash
aws ecs describe-tasks --cluster test --tasks 2ba90f21bdfb4ccfbf5e2e0743e55375
```
## 4. 发起远程连接至容器

```bash
aws ecs execute-command --cluster test --task 2ba90f21bdfb4ccfbf5e2e0743e55375 --interactive --command "/bin/bash"
```

如果 AWS CLI 报错，则需要升级至最新版本，以确保 CLI 支持 exec 功能