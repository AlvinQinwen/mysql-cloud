# mysql && redis cloud
docker-compose 搭建mysql主从 与 redis 集群 

## 测试
测试产生的数据可以通过Makefile删除
命令：`make delete-mysql` `make delete-redis`

## 指定网段
本项目未使用env文件！！！ 如需使用请自行修改
`172.19.182.0/16` 如需修改 请至docker-compose.yml 最下方 

```
networks:
  mysql-network:
    ipam:
      config:
        - subnet: 172.19.182.0/16
```

## mysql

### mysql集群相关信息 名称 宿主机端口 虚拟机端口 内网ip
```text
master -> 3310 -> 3306 -> 172.19.182.0 
slave1 -> 3311 -> 3306 -> 172.19.182.1 
slave2 -> 3312 -> 3306 -> 172.19.182.2
slave3 -> 3313 -> 3306 -> 172.19.182.3
slave4 -> 3314 -> 3306 -> 172.19.182.4
slave5 -> 3315 -> 3306 -> 172.19.182.5
```

### mysql集群执行步骤

#### master
```shell
mysql -h172.19.182.0 -P3306 -uroot -p$PASSWORD$
```

获取master status
```mysql
show master status;
```

**获取File Position**

#### slave 
此处为从服务器ip地址 只展示一个 其余从从服务只需执行相同的操作**更换ip**即可
```shell
mysql -h172.19.182.1 -P3306 -uroot -p$PASSWORD$ 
```

```mysql
change master to master_host='172.19.182.0',master_port=33065,master_user='root',master_password='Admin,123',master_log_file='mysql-bin.000003',master_log_pos=156;
```
1.  ster_host master的ip 
2.  ster_port master的端口
3.  aster_user master 用户名
4.  aster_password master 密码
5.  aster_log_file master中此时的File 参数
6.  aster_log_pos master中此时的Position 参数

 salve中启动主从复制
 ```mysql
 start slave;
 ```
 
查看从机的复制状态
```mysql
SHOW SLAVE STATUS\G
```

当出现 <br>
**Slave_IO_Running: Yes** <br>
**Slave_SQL_Running: Yes** <br>
后即可正常使用

## redis
1. 进入redis master1 `docker exec -it redis-master1 bash`
2. 执行如下命令
```redis
redis-cli --cluster create 172.19.182.6:6379 \
  172.19.182.7:6379 \
  172.19.182.8:6379 \
  172.19.182.9:6379 \
  172.19.182.10:6379 \
  172.19.182.11:6379 \
  --cluster-replicas 1
```
3. 根据提示输入yes
4. 找另一台服务器链接改redis集群 `redis-cli -c -h 172.19.182.6 -p $PASSWORD$` **注意-c选项 否则会出错**
5. 查看集群状态 `cluster info`
6. 查看节点信息 `cluster nodes` 几个关键字 
  - slave  -> 该节点为备份节点
  - master -> 该节点为主节点
  - myself -> 该节点为当前连接的节点
7. 插入一个值 `set a 1` 正常出现 `Redirected to slot [15495] located at 172.19.182.8:6379` 即代表成功 
8. 这里根据切片自动切换到了该数据分片所在的节点上，所以连接的节点变为了172.19.182.8:6379

### redis 节点信息 名称 宿主机端口 虚拟机端口 内网IP
```text
  master1 -> 6380 -> 6379 -> 172.19.182.6
  master2 -> 6381 -> 6379 -> 172.19.182.7
  master3 -> 6382 -> 6379 -> 172.19.182.8
  slave1  -> 6383 -> 6379 -> 172.19.182.9
  slave2  -> 6384 -> 6379 -> 172.19.182.10
  slave3  -> 6385 -> 6379 -> 172.19.182.11
```

## 警告
mysql主从复制前master库中的表不会同步到从服务器中，需要自己手动同步，或者另寻他法
技术浅薄，止于此，欢迎大佬pr提供良好的建议
帮到你的话烦请点个star⭐
