# 安装Zookeeper Operator
```
helm upgrade --install zookeeper-operator . --namespace <YOUR-NAMESPACE>
```
# 卸载Zookeeper Operator
```
helm delete zookeeper-operator --namespace <YOUR-NAMESPACE>
```

# Zookeeper Operator chart 的配置说明

| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `image.repository` | Image repository | `pravega/zookeeper-operator` |
| `image.tag` | Image tag | `0.2.8` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `crd.create` | Create zookeeper CRD | `true` |
| `rbac.create` | Create RBAC resources | `true` |
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.name` | Name for the service account | `zookeeper-operator` |
| `watchNamespace` | Namespaces to be watched  | `""` |
| `resources` | Specifies resource requirements for the container | `{}` |
| `nodeSelector` | Map of key-value pairs to be present as labels in the node in which the pod should run | `{}` |
| `affinity` | Specifies scheduling constraints on pods | `{}` |
| `tolerations` | Specifies the pod's tolerations | `[]` |
