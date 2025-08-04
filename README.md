# Bastion Host

Sometimes you just need the right tools to troubleshoot the network, containers, and other deployments.
This is to be a bastion host image, to be used for SysAdmin testing from a Kubernetes cluster.

Tools installed in this image:

* Shell
  * Bash
  * ZSH
  * screen
  * tmux
* Networking
  * dig
  * host
  * ipgrab
  * netcat
  * nmap
  * ping
  * rsync
  * tcpdump
  * tcpreplay
  * tcpslice
  * tcptrace
  * tcptraceroute
  * tracepath
  * traceroute
  * traceroute
  * whois
* Clients
  * kubectl
  * MySQL Client
  * PostgreSQL Client

## Using this image

### Docker

You may start this image running the following command:

```shell
docker run --rm -it --name bastion fboaventura/dckr-bastion /bin/bash 
```

You can add a volume to the instance to persist logs, share scripts, or any other usage you may think of.

```shell
docker run --rm -it --name bastion -v "${PWD}/bastion:/sysadm" fboaventura/dckr-bastion /bin/bash 
```

### Kubernetes

To deploy the instance into a Kubernetes cluster, you may start a single pod using `kubectl`:
kubectl 

```shell
kubectl run bastion --image=fboaventura/dckr-bastion --restart=Never
```

Or, to a structured and secure pod deployment, copy the following snippet into a YAML file (`bastion.yaml`):

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: devops-bastion-sa

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: devops-bastion-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: devops-bastion-role-binding
subjects:
- kind: ServiceAccount
  name: devops-bastion-sa
roleRef:
  kind: Role
  name: devops-bastion-role
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: v1
kind: Pod
metadata:
  name: devops-bastion
  labels:
    role: devops-bastion-role
spec:
  serviceAccountName: devops-bastion-sa
  containers:
    - name: devops-bastion
      image: fboaventura/dckr-bastion:1.4.0
      imagePullPolicy: Always
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        readOnlyRootFilesystem: true
        allowPrivilegeEscalation: false
      resources:
        requests:
          cpu: 1000m
          memory: 512Mi
          ephemeral-storage: 500Mi
        limits:
          cpu: 2000m
          memory: 2Gi
          ephemeral-storage: 2Gi
      volumeMounts:
        - name: ephemeral
          mountPath: "/tmp"
  restartPolicy: Always

```

and run the command:

```shell
kubectl apply -f bastion.yaml --namespace default
```
