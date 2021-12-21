# mysql-cloud
docker-compose 搭建mysql集群 

## 指定网段
本项目未使用env文件！！！ 如需使用请自行修改
`172.19.182.0/16` 如需修改 请至docker-compose.yml 最下方 
```
networks:
  mysql-network:
    ipam:
      config:
        - subnet: 172.19.182.0/16
```yml

## 集群相关
- 172.19.182.0 master
- 172.19.182.1 slave1
- 172.19.182.2 slave2
- 172.19.182.3 slave3
- 172.19.182.4 slave4
- 172.19.182.5 slave5

## 公网端口
- 3310 -> master -> 3306
- 3311 -> slave1 -> 3306
- 3312 -> slave2 -> 3306
- 3313 -> slave3 -> 3306
- 3314 -> slave4 -> 3306
- 3315 -> slave5 -> 3306

## 执行步骤

### master
```
mysql -h172.19.182.0 -P3306 -uroot -pAdmin,123
```shell

获取master status
```
show master status;
```mysql
**获取File Position**

### slave 
1. 此处为从服务器ip地址 只展示一个 其余从从服务只需执行相同的操作**更换ip**即可
```
mysql -h172.19.182.1 -P3306 -uroot -pAdmin,123 
```shell

```
change master to master_host='172.19.182.0',master_port=33065,master_user='root',master_password='Admin,123',master_log_file='mysql-bin.000003',master_log_pos=156;
```mysql

>>>
- master_host master的ip
- master_port master的端口
- master_user master 用户名
- master_password master 密码
- master_log_file master中此时的File 参数
- master_log_pos master中此时的Position 参数

 salve中启动主从复制
 ```
 start slave;
 ```mysql
 
查看从机的复制状态
```
SHOW SLAVE STATUS\G
```mysql

当出现
            ** Slave_IO_Running: Yes **
            ** Slave_SQL_Running: Yes **
后即可正常使用

## 警告
主从复制前master库中的表不会同步到从服务器中，需要自己手动同步，或者另寻他法
技术浅薄，止于此，欢迎大佬pr提供良好的建议
