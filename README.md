# Mylar3 Helm Chart

![Downloads](https://img.shields.io/github/downloads/tonylea/helm-chart-mylar3/total)

Deploys [Mylar3](https://github.com/MylarComics/mylar3) from LinuxServer's image, [`lscr.io/linuxserver/mylar3`](https://github.com/linuxserver/docker-mylar3), the one Mylar3's README links to.

It runs one replica, and stops the old pod before starting the new one, since two copies of Mylar3 can't share one SQLite database.

## Values

| Value | Default |
| --- | --- |
| `image.tag` | the chart's `appVersion` |
| `puid` | `1000` |
| `pgid` | `1000` |
| `timezone` | `UTC` |
| `resources` | none |
| `persistence.config.existingClaim` | none; the chart creates a claim |
| `persistence.config.storageClassName` | the cluster's default class |
| `persistence.config.size` | `5Gi` |
| `persistence.data` | none; at least one mount required |
| `persistence.data[].name` | required; mounted at `/data/<name>` |
| `persistence.data[].existingClaim` | none; the chart creates a claim |
| `persistence.data[].storageClassName` | the cluster's default class |
| `persistence.data[].size` | none; required unless `existingClaim` is set |
| `httpRoute.enabled` | `false` |
| `httpRoute.parentRefs` | none; required when enabled |
| `httpRoute.hostnames` | none |

## Requirements

- A storage class for the claims the chart creates, the cluster's default unless named.
  `/config` holds Mylar3's SQLite database, so it needs block storage, not a network share such as NFS, whose locking SQLite can't rely on.
  A claim the chart creates is `ReadWriteOnce`, so sharing a data mount with a download client needs an existing claim.
  Mylar3's own documentation is in [its repo](https://github.com/MylarComics/mylar3).
- The Gateway API's `HTTPRoute` CRD, when `httpRoute.enabled` is set.

## Usage

```sh
helm repo add mylar3 https://tonylea.github.io/helm-chart-mylar3
helm install mylar3 mylar3/mylar3 --values my-values.yaml
```

```yaml
timezone: Europe/London
persistence:
  data:
    - name: downloads
      existingClaim: downloads
    - name: comics
      existingClaim: comics
```

## Development

Pull requests run:

- `helm lint --strict`, and the rendered chart checked by kubeconform against Kubernetes 1.37.
- helm-unittest's tests in `tests/`.
- An install with chart-testing in a kind cluster.

Commits follow Conventional Commits.
Releases are versioned and tagged automatically from `main`, and published to the Helm repository on this repo's GitHub Pages.
