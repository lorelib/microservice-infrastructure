# 项目部署步骤

## hosts配置
### windows
    修改C:\Windows\System32\drivers\etc\hosts配置，
    添加：127.0.0.1 discovery peer1 peer2 config-server gateway

## 启动microservice-discovery应用
> 单机

    java -jar microservice-discovery-1.0.jar
    访问：
        http://discovery:8761

> 高可用

    java -jar microservice-discovery-1.0.jar --spring.profiles.active=peer1
    java -jar microservice-discovery-1.0.jar --spring.profiles.active=peer2
    访问：
        http://discovery:8761   
        http://discovery:8762

## 启动microservice-provider-user服务提供者
    java -jar microservice-provider-user-1.0.jar
    访问：
        http://localhost:8000/user/1
        http://localhost:8000/instance-info
    
## 启动consumer服务消费者 
> feign-hystrix

    java -jar microservice-consumer-movie-feign-1.0.jar
    访问： http://localhost:8020/feign/1
    访问监控数据：http://localhost:8020/hystrix.stream
    
## 启动监控
> hystrix-dashboard

    java -jar microservice-hystrix-dashboard-1.0.jar
    访问：http://localhost:8030/hystrix.stream
    在地址栏输入：http://localhost:8020/hystrix.stream
    
> turbine

    需要启动hystrix-dashboard
    java -jar microservice-hystrix-turbine-1.0.jar
    访问：http://localhost:8030/hystrix.stream
    在地址栏输入：http://localhost:8031/turbine.stream
    
## 配置中心
> 获取git上的资源信息遵循如下规则：

    /{application}/{profile}[/{label}]
    /{application}-{profile}.yml
    /{label}/{application}-{profile}.yml
    /{application}-{profile}.properties
    /{label}/{application}-{profile}.properties
    
> config-server

    访问：
    http://localhost:8040/Edgware.SR3/microservice-consumer-movie-feign-dev.properties
    http://localhost:8040/microservice-consumer-movie-feign/dev/Edgware.SR3
    
> feign-hystrix

    访问：
    http://localhost:8020/hello
    修改config，然后刷新：curl  -X POST http://localhost:8020/refresh
    
## API GATEWAY

    之前通过http://localhost:8020/feign/1访问服务，
    现在通过http://localhost:8050/microservice-consumer-movie-feign/feign/1即可访问相应服务

    如果要修改访问路径为http://localhost:8050/user/feign/1
    zuul:
      routes:
        user: # 可以随便写，在zuul上面唯一即可；当这里的值 = service-id时，service-id可以不写。
          path: /user/**
          service-id: microservice-consumer-movie-feign
          
    如果需要忽略某些服务，可以通过如下配置：
    zuul:
      ignored-services: provider-user  #忽略服务