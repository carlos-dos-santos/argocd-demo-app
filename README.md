## ArgoCD demo app
- kubectl apply -n argocd -f application.yaml

### Adding repo to argocd
argocd repo add https://github.com/argoproj/argocd-example-apps --username <username> --password <password/token>
