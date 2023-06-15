#!/bin/bash
MYDIR=$(dirname $0)
k3d cluster delete awx-hackathon
k3d cluster create awx-hackathon
k3d kubeconfig get awx-hackathon  > /tmp/awx-hackathon.config
export KUBECONFIG=/tmp/awx-hackathon.config
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
helm install --repo https://argoproj.github.io/argo-helm --create-namespace --namespace argocd argocd argo-cd --version 5.21.0  --set "configs.cm.application\.resourceTrackingMethod=annotation" --set "server.extraArgs[0]=--disable-auth" --set "server.extraArgs[1]=--insecure" --wait
kubectl -n argocd apply -f $MYDIR/../argocd-applications


## How to access vCluster
# kubectl port-forward svc/customer1-76xvt-vcluster -n customer1-76xvt  8443:443
# vcluster connect customer1-76xvt-vcluster --server=https://localhost:8443
