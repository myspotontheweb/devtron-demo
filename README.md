# devtron-demo

Evaluation repository for Devtron

https://docs.devtron.ai/

## Getting Started

Create a Kubernetes cluster

```
AZURE_NAME=my-cluster AZURE_SUBSCRIPTION=my-subscription bin/bootstrap-aks.sh
```

Install Devtron

```
helm repo add devtron https://helm.devtron.ai

helm install devtron devtron/devtron-operator \
--create-namespace --namespace devtroncd \
--set installer.modules={cicd} \
--set argo-cd.enabled=true
```

Check the state of the install

```
kubectl -n devtroncd get installers installer-devtron -o jsonpath='{.status.sync.status}';echo
```

Get the Load Balancer end-point

```
kubectl -n devtroncd get service devtron-service
```

Credentials

```
kubectl -n devtroncd get secret devtron-secret -o go-template='{{printf "Username: admin\nPassword: %s\n" (.data.ADMIN_PASSWORD|base64decode)}}'
```

# Clean up

```
AZURE_NAME=my-cluster AZURE_SUBSCRIPTION=my-subscription bin/purge-aks.sh
```
