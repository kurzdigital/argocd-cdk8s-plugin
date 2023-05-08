# argocd-cdk8s-plugin

This is a Docker image which can be used as a sidecar for ArgoCD to enable [`cdk8s`](https://cdk8s.io/) support.

WARNING: This is an early alpha version, currently only supporting TypeScript.

## Requirements

This plugin currently requires a `cdk8s.yaml` file to be anywhere in the repository to be activated.

## Usage

Step 1: add an extra container to ArgoCD Helm release:

```jsonnet
{
  "extraContainers": [
    {
      "name": "cdk8s-cmp",
      "image": "kurzdigital/argocd-cdk8s-plugin",
      "securityContext": {
        "runAsUser": 999
      },
      "volumeMounts": [
        {
          "mountPath": "/var/run/argocd",
          "name": "var-files"
        },
        {
          "mountPath": "/home/argocd/cmp-server/plugins",
          "name": "plugins"
        },
        {
          "mountPath": "/tmp",
          "name": "cmp-tmp"
        }
      ]
    }
  ]
}
```

Step 2 (optional): add plugin configuration to your ArgoCD application:

```yaml
spec:
  source:
    plugin: {}
```
