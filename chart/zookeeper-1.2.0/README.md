# Zookeeper Helm Chart

## 安装 zookeeper 集群

```
helm upgrade --install zk . --namespace <YOUR-NAMESPACE>
```

## 检查 zookeeper 状态

```
kubectl get zk --namespace <YOUR-NAMESPACE>
NAME           REPLICAS   READY REPLICAS   VERSION    DESIRED VERSION   INTERNAL ENDPOINT   EXTERNAL ENDPOINT   AGE
zk-zookeeper   3          3                hc-0.2.8   hc-0.2.8          10.96.203.37:2181   N/A                 2m49s
```

```
kubectl get zk zk-zookeeper -o  yaml --namespace <YOUR-NAMESPACE>
...
status:
  conditions:
  - lastTransitionTime: "2021-03-08T05:50:55Z"
    lastUpdateTime: "2021-03-08T05:50:55Z"
    status: "True"
    type: PodsReady
  - status: "False"
    type: Upgrading
  - status: "False"
    type: Error
  currentVersion: hc-0.2.8
  externalClientEndpoint: N/A
  internalClientEndpoint: 10.96.203.37:2181
  members:
    ready:
    - zk-zookeeper-0
    - zk-zookeeper-1
    - zk-zookeeper-2
  metaRootCreated: true
  readyReplicas: 3
  replicas: 3
```

## 卸载 zookeeper 集群

```
helm delete zk --namespace <YOUR-NAMESPACE>
```

## 参数说明

| 参数                    | 描述                                                         | 参数值         |
| ----------------------- | ------------------------------------------------------------ | -------------- |
| replicas                | 节点数量                                                     | 3              |
| image                   | 镜像信息                                                     | 见 values.yaml |
| storageType             | 存储类型，EPHEMERAL(非持久化存储) 和 persistence(持久化存储) | persistence    |
| persistence             | 持久化存储配置                                               | 见 values.yaml |
| pod.resources           | pod 所需要的资源                                             | 见 values.yaml |
| kubernetesClusterDomain | 集群的域，如一般不用配置                                     | cluster.local  |
| config.initLimit        | LF 初始通信时限,初始连接 时能容忍的最多心跳数                | 10             |
| config.syncLimit        | LF 同步通信时限,请求和应答 之间能容忍的最多心跳数            | 2              |
| config.tickTime         | CS 通信心跳数,维持心跳的时间间隔                             | 2000           |

## 集群运维说明

集群 CR 的配置说明

```
apiVersion: zookeeper.pravega.io/v1beta1
kind: ZookeeperCluster
metadata:
  labels:
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: zookeeper
  name: zk-zookeeper # 集群名称
spec:
  config:
    initLimit: 10 #LF初始通信时限
    syncLimit: 2 #LF同步通信时限
    tickTime: 2000 #CS通信心跳数
  image:
    pullPolicy: IfNotPresent #拉取策略
    repository: harmonyware.harbor.cn/middleware/zookeeper #镜像地址
    tag: hc-0.2.8 #镜像tag
  kubernetesClusterDomain: cluster.local #集群域
  labels:
    app: zk-zookeeper
    release: zk-zookeeper
  persistence: #持久化存储配置
    reclaimPolicy: Retain
    spec:
      accessModes:
      - ReadWriteOnce #读写权限
      resources:
        requests:
          storage: 1Gi #存储容量
      storageClassName: middleware-lvm #存储类选择
  pod:
    affinity: #亲和性配置,和pod配置兼容
      podAntiAffinity:
        preferredDuringSchedulingIgnoredDuringExecution:
        - podAffinityTerm:
            labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - zk-zookeeper
            topologyKey: kubernetes.io/hostname
          weight: 20
    labels: # 额外的标签
      app: zk-zookeeper
      release: zk-zookeeper
    resources: {} #资源配置
    serviceAccountName: zookeeper
  ports:
  - containerPort: 2181 #客户端连接端口
    name: client
  - containerPort: 2888
    name: quorum
  - containerPort: 3888
    name: leader-election #选主端口
  - containerPort: 7000
    name: metrics
  replicas: 3 #节点数量
  storageType: persistence #存储方式
```

## 测试连接

查看 service 信息

```
kubectl get svc
NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                               AGE
zk-zookeeper-client     ClusterIP   10.98.151.103   <none>        2181/TCP                              2m6s
zk-zookeeper-headless   ClusterIP   None            <none>        2181/TCP,2888/TCP,3888/TCP,7000/TCP   2m6s
```

在集群任意节点连接

```
./bin/zkCli.sh  -server 10.98.151.103:2181
```

集群内部访问

```
kubectl exec -it zk-zookeeper-0 bash

./bin/zkCli.sh  -server zk-zookeeper-client:2181

```
