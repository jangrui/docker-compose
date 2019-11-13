# Docker Compose for MySQL 8 InnoDB Cluster

**This is for testing only - don't use it in production.**  

Once the cluster is up, use `./mysql.sh` to execute the MySQL client on the first server:  
```
> ./mysql.sh --execute="SHOW DATABASES" | head
mysql: [Warning] Using a password on the command line interface can be insecure.
+-------------------------------+
| Database                      |
+-------------------------------+
| information_schema            |
| mysql                         |
| mysql_innodb_cluster_metadata |
| performance_schema            |
| sys                           |
+-------------------------------+
```

Similarly, use `./mysqlsh.sh` to execute a MySQL shell:  
```
> ./mysqlsh.sh --interactive --execute="dba.getCluster().status()" | head
mysqlsh: [Warning] Using a password on the command line interface can be insecure.
Creating a session to 'root@localhost'
Fetching schema names for autocompletion... Press ^C to stop.
Your MySQL connection id is 350 (X protocol)
Server version: 8.0.12 MySQL Community Server - GPL
No default schema selected; type \use <schema> to set one.
{
    "clusterName": "test", 
    "defaultReplicaSet": {
        "name": "default", 
```
