## ManageIQ Kubernetes Container Provider

### Deploying Kubernetes locally with [hack/local-up-cluster.sh](https://github.com/kubernetes/kubernetes/blob/master/hack/local-up-cluster.sh)
Clone the core kubernetes repo:

```bash
mkdir -p ${GOPATH}/src/k8s.io/
cd ${GOPATH}/src/k8s.io/
git clone https://github.com/kubernetes/kubernetes/
```

Build binaries & launch a single node cluster running on localhost, **with privileged containers enabled (required for running SSA scans)**:
```bash
cd kubernetes
sudo env ALLOW_PRIVILEGED=true hack/local-up-cluster.sh
```

Note, to skip re-building binaries in the future, run like so:
```bash
sudo env ALLOW_PRIVILEGED=true hack/local-up-cluster.sh -o _output/bin/
```

### Deploying Kubernetes Manually
When deploying Kubernetes manually, there are a few extra steps necessary to get it working with ManageIQ.

Based on instructions for deploying Kubernetes manually from here: https://kubernetes.io/docs/getting-started-guides/fedora/flannel_multi_node_cluster/

Ensure the following conditions are met:

0. In `/etc/kubernetes/kubelet`, ensure `KUBELET_ARGS` contains `--allow-privileged`
0. On the master node, generate a default serviceaccount key with `openssl genrsa -out /tmp/serviceaccount.key 2048`
0. In `/etc/kubernetes/apiserver`, ensure `KUBE_API_ARGS` contains `--service_account_key_file=/tmp/serviceaccount.key` (or the correct path to your default serviceaccount key).
0. In `/etc/kubernetes/apiserver`, ensure `KUBE_API_ARGS` contains `--allow-privileged`


### Prepare cluster for use with ManageIQ:
0. Create `management-infra` namespace:
    ```bash
    kubectl create ns management-infra
    ```
0. Create required serviceaccounts:
    ```bash
    kubectl create sa -n management-infra management-admin   
    kubectl create sa -n management-infra inspector-admin   
    ```
0. Grant cluster-reader cluster role to `management-admin` SA:
    ```bash
    kubectl create clusterrolebinding management-infra-cluster-reader --clusterrole=cluster-reader --user=system:serviceaccount:management-infra:management-admin
    ```
0. Retrieve the serviceaccount token for `management-admin` (this will be the auth token ManageIQ uses):
    ```bash
    kubectl describe secret -n management-infra $(kubectl get secrets -n management-infra | grep management-admin | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t'
    ```

The local kubernetes cluster should now be ready for use with ManageIQ (simply use localhost as the hostname and the `management-admin` token to authenticate).
