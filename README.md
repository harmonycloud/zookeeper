# ZooKeeper Coordination Service

**English** | [中文](README_zh.md)

Enterprise-grade Apache ZooKeeper distributed coordination service for Kubernetes with high availability, strong consistency, and integrated monitoring.

## Overview

Apache ZooKeeper is an open-source distributed coordination service that provides consistency guarantees for distributed applications. This package delivers a production-ready ZooKeeper ensemble on Kubernetes, featuring configuration management, naming services, distributed locking, leader election, and cluster management. ZooKeeper is widely adopted in distributed systems for service discovery, configuration management, and consensus.

## Features

### Core Capabilities
- **Configuration management**: Centralized configuration management service
- **Naming service**: Service naming and discovery for distributed systems
- **Distributed locking**: Lock mechanisms for distributed environments
- **Cluster management**: Cluster node management and monitoring
- **Data synchronization**: Data synchronization across distributed environments
- **Leader election**: Leader election support for distributed systems

### Advanced Features
- **High availability**: Multi-node ensemble deployment with automatic failover
- **Strong consistency**: ZAB protocol-based data consistency guarantees
- **Monitoring and alerting**: Integrated Prometheus metrics and alert rules
- **Log management**: Structured logging output with log rotation
- **Durable storage**: Data persistence with snapshot management
- **Auto-purge**: Automatic cleanup of expired snapshots and logs
- **ACL control**: Access control list support
- **Observer mode**: Observer nodes to reduce write pressure
- **Dynamic reconfiguration**: Cluster dynamic reconfiguration support
- **Snapshot management**: Data snapshot and recovery

### Operations Features
- **Resource management**: CPU and memory resource limits
- **Node affinity**: Pod anti-affinity and node affinity configuration
- **Tolerations**: Taint toleration settings
- **Health checks**: Built-in liveness and readiness probes
- **Metrics export**: Prometheus-format metrics
- **Graceful shutdown**: Graceful shutdown mechanism

## Supported Versions

### ZooKeeper Releases
- **3.7.2** (latest stable)

### Component Releases
- **Package version**: 1.3.1-1.0.0

## Architecture

### Deployment Modes

#### 1. Operator Standard (operator-standard)
- **Use cases**: Development, testing, and quick deployment
- **Traits**: Single replica, minimal resource usage
- **Topology**: 1 ZooKeeper instance

#### 2. Operator Highly Available (operator-highly-available)
- **Use cases**: Production environments
- **Traits**: Multi-replica with automatic failover
- **Topology**: 3 ZooKeeper instances

#### 3. Cluster (cluster)
- **Use cases**: Production environments requiring distributed coordination
- **Traits**: High availability, strong consistency, configurable replica count
- **Topology**: 3+ instances (odd number recommended)

### Technical Architecture

```
+---------------------------------------------------------+
|                   ZooKeeper Ensemble                    |
+---------------------------------------------------------+
|  +-----------+  +-----------+  +-----------+            |
|  |  Leader   |  | Follower  |  | Follower  |            |
|  |           |  |           |  |           |            |
|  | +-------+ |  | +-------+ |  | +-------+ |            |
|  | | ZNode | |  | | ZNode | |  | | ZNode | |            |
|  | | Tree  | |  | | Tree  | |  | | Tree  | |            |
|  | +-------+ |  | +-------+ |  | +-------+ |            |
|  +-----------+  +-----------+  +-----------+            |
+---------------------------------------------------------+
|                  Client Connection Layer                |
|  +-----------+  +-----------+  +-----------+            |
|  |  Client   |  |  Client   |  |  Client   |            |
|  |    1      |  |    2      |  |    3      |            |
|  +-----------+  +-----------+  +-----------+            |
+---------------------------------------------------------+
|                  ZooKeeper Operator                     |
|  +-----------+  +-----------+  +-----------+            |
|  |  Manager  |  |Controller |  |  Webhook  |            |
|  +-----------+  +-----------+  +-----------+            |
+---------------------------------------------------------+
|               Kubernetes Resources                      |
|  StatefulSet | Service | PVC | ConfigMap | Secret | Job |
+---------------------------------------------------------+
```

### Component Overview

- **ZooKeeper**: Core distributed coordination engine
- **ZooKeeper Operator**: Kubernetes operator for lifecycle management
- **Exporter**: Prometheus metrics collector

## Prerequisites

- Kubernetes 1.26+
- [OpenSaola Operator](https://github.com/harmonycloud/opensaola) deployed
- [saola-cli](https://github.com/harmonycloud/saola-cli) installed

## Quick Start

```bash
# Publish the package
saola publish zookeeper/

# Install the operator
saola operator create zk-operator --type ZooKeeper --version 3.7.2

# Create an instance
saola middleware create my-zookeeper --type ZooKeeper --version 3.7.2

# Check status
saola middleware get my-zookeeper
```

## Available Actions

| Action | Description |
|--------|-------------|
| restart | Restart the middleware instance |

## Configuration

Key parameters can be customized via the baseline configuration. See `manifests/*parameters.yaml` for the full parameter reference:

- `manifests/clusterparameters.yaml` -- Cluster mode parameters
- `manifests/sentinelparameters.yaml` -- Sentinel mode parameters

## Usage Guidance

### Environment Selection

#### Development and Test
- **Recommended topology**: Operator Standard or Standalone
- **Resources**: CPU 1 core, memory 2 Gi, storage 20 Gi
- **Suggested version**: ZooKeeper 3.7.2
- **Instances**: 1

#### Production
- **Recommended topology**: Cluster or Operator Highly Available
- **Resources**: CPU 2 cores, memory 4 Gi, storage 50 Gi
- **Suggested version**: ZooKeeper 3.7.2
- **Instances**: 3+ (odd number for quorum)

### Best Practices

#### Security
- Configure ACL permissions for ZNode access control
- Enforce strong passwords with mixed character classes
- Restrict network access to the ensemble
- Rotate credentials periodically
- Enable SASL authentication for production environments

#### Performance Tuning
- Set JVM heap size appropriately for the workload
- Configure a suitable garbage collector
- Monitor memory usage and avoid memory leaks
- Use connection pools and tune session timeouts
- Monitor network latency between nodes

#### Monitoring and Alerting
- Track node status, connection count, and request latency
- Monitor outstanding requests and pending syncs
- Define alert thresholds for critical metrics
- Watch file descriptor usage and storage utilization
- Review cluster health regularly

#### Operations
- Deploy an odd number of nodes (3 or 5) for proper quorum
- Configure Pod anti-affinity to spread nodes across hosts
- Set up automatic snapshot purging
- Establish data backup and recovery procedures
- Plan capacity based on connection count and data volume

## Related Projects

| Project | Description |
|---------|-------------|
| [OpenSaola Operator](https://github.com/harmonycloud/opensaola) | Core Kubernetes operator for middleware lifecycle management |
| [saola-cli](https://github.com/harmonycloud/saola-cli) | Command-line tool for middleware management |
| [PostgreSQL](https://github.com/harmonycloud/postgresql) | PostgreSQL database package |
| [MySQL](https://github.com/harmonycloud/mysql) | MySQL database package |
| [Kafka](https://github.com/harmonycloud/kafka) | Apache Kafka streaming platform package |
| [Redis](https://github.com/harmonycloud/redis) | Redis in-memory data store package |
| [Elasticsearch](https://github.com/harmonycloud/elasticsearch) | Elasticsearch search engine package |
| [RabbitMQ](https://github.com/harmonycloud/rabbitmq) | RabbitMQ message broker package |

## License

This project is licensed under the [Apache License 2.0](LICENSE).
