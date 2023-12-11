kind create cluster --config kind/config.yaml --name minio
kubectl apply -f kind/ingress-controller.yaml
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=140s

helm repo add jetstack https://charts.jetstack.io
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.13.2 \
  --set installCRDs=true


# helm install -n cert-manager namecheap-webhook cert-manager-webhook-namecheap/deploy/cert-manager-webhook-namecheap/

# helm install --set email=cprasonghtam@snaplogic.com -n cert-manager letsencrypt-namecheap-issuer cert-manager-webhook-namecheap/deploy/letsencrypt-namecheap-issuer/

kubectl create secret generic namecheap-credentials \
  --namespace=cert-manager \
  --from-literal=apiKey=test \
  --from-literal=apiUser=test


kubectl create ns minio
# kubectl apply -f cert-manager-webhook-namecheap/certificate.yaml

kubectl create secret generic minio-root-credential \
  --namespace=minio \
  --from-literal=root-user=admin \
  --from-literal=root-password=test

kubectl apply -f minio/pesistence.yaml -n minio

helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install minio bitnami/minio -f minio/values/minio-values.yaml -n minio

