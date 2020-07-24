
# Continuous Delivery with ArgoCD and Concourse


1. Clone Git repositories:
```
git clone git@github.com:danielinclouds/cd-with-argo-prereq.git
git clone git@github.com:danielinclouds/cd-with-argo-app.git
git clone git@github.com:danielinclouds/cd-with-argo-env-dev.git
git clone git@github.com:danielinclouds/cd-with-argo-env-pre.git
git clone git@github.com:danielinclouds/cd-with-argo-env-prod.git
```

2. Start environment 
```
cd cd-with-argo-prereq
./start_environment.sh
```

3. Build required docker containers
```sh
cd cd-with-argo-prereq/helm_container
docker build --no-cache --build-arg VERSION=3.2.4 -t danielinclouds/helm:3.2.4 .
docker push danielinclouds/helm:3.2.4
```

4. Populate `credentials.yaml` file and move it to `cd-with-argo-app/ci`

5. Login to Concourse
```sh
kubectl port-forward svc/concourse-web -n infra 8080:8080
fly login -c http://127.0.0.1:8080 --target=local
open http://127.0.0.1:8080
# login: test
# pass: test
```

6. Login to ArgoCD
```sh
kubectl port-forward svc/argocd-server -n argocd 9090:443
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
open https://127.0.0.1:9090
# login: admin 
# pass: pod_name
```

7. Go to ArgoCD and configure new application:  
```
Application Name: argo-env  
Repo URL: https://github.com/danielinclouds/cd-with-argo-prereq.git  
Path: argo_env  
```

8. Go to Concourse and set pipeline
```sh
cd cd-with-argo-app/ci

fly -t local set-pipeline \
    --pipeline app-pipeline \
    --config pipeline.yaml \
    --load-vars-from credentials.yaml
```