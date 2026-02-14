# N.C.O. Helm Charts

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add nco https://charts.aries0d0f.me
helm repo update
```

You can then run `helm search repo nco` to see the charts.

## Charts

* [minecraft](https://github.com/N-C-O/Helm-Charts/tree/master/charts/minecraft)
* [trmnl](https://github.com/N-C-O/Helm-Charts/tree/master/charts/trmnl)
* [vault](https://github.com/N-C-O/Helm-Charts/tree/master/charts/vault)

### Minecraft

This chart is based on [itzg/minecraft-server-chart](https://github.com/itzg/minecraft-server-charts)

```bash
helm install --name your-release nco/minecraft
```

### TRMNL

A Helm chart for deploying the [TRMNL (Terminus)](https://github.com/usetrmnl/byos_hanami) self-hosted application on Kubernetes, using Bitnami PostgreSQL and Valkey as dependencies.

```bash
helm install your-release nco/trmnl
```

### Vault

This chart is based on [hashicorp/vault-helm](https://github.com/hashicorp/vault-helm)

```bash
helm install --name your-release nco/vault
```
