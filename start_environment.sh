#!/bin/bash

kind create cluster

kubectl create namespace infra
kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace pre
kubectl create namespace prod


# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# Install Concourse
helm repo add concourse https://concourse-charts.storage.googleapis.com/
helm install concourse concourse/concourse \
    --namespace infra

# Install Chart Museum
helm install chartmuseum stable/chartmuseum \
    --namespace infra \
    --set env.open.DISABLE_API=false

