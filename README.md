# Mylar3 Helm Chart

Deploys [Mylar3](https://github.com/MylarComics/mylar3) from LinuxServer's image, [`lscr.io/linuxserver/mylar3`](https://github.com/linuxserver/docker-mylar3), the one Mylar3's README links to.
Mylar3 watches for new issues of the comic series it's given, sends them to a download client, and imports and renames them into the library.

It runs one replica:

- A Deployment that stops the old pod before starting the new one, since two copies of Mylar3 can't share one SQLite database.
- A volume for `/config` (`config.ini`, the SQLite database, logs and the cover cache) and one for `/data` (the library and the download folders), each an existing claim or a claim the chart creates.
- A Service on Mylar3's port, 8090, and an optional Gateway API `HTTPRoute` to it.
- A start-up, liveness and readiness probe on that port, since Mylar3 has no health endpoint that works without a login.
  Start-up gets 5 minutes, since Mylar3 checks and upgrades its database before it listens.

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
| `persistence.data.existingClaim` | none; the chart creates a claim |
| `persistence.data.storageClassName` | the cluster's default class |
| `persistence.data.size` | none; required unless `existingClaim` is set |
| `httpRoute.enabled` | `false` |
| `httpRoute.parentRefs` | none; required when enabled |
| `httpRoute.hostnames` | none |

### Settings

Mylar3 reads no settings from the environment: it writes `config.ini` itself.
Its login, ComicVine API key, folders, indexers and download clients are set in the web UI.
Set the login on first start: Mylar3 has none until one is set.

### User and group

LinuxServer's image starts as root, gives `/config` to `puid` and `pgid`, then runs Mylar3 as them.
They need to be able to write to `/data` as well.

### Storage

Mylar3 keeps its database in SQLite; it has no other backend.
Put `/config` on block storage, not a network share such as NFS, whose locking SQLite can't rely on.

`/data` holds the library and the download folders together.
An import is then a hardlink or a rename rather than a copy, which only works when both are on one filesystem.
Point Mylar3's comic folder and the download client's folder at paths under `/data`.

A claim the chart creates is `ReadWriteOnce`.
To share `/data` with a download client, give an existing claim that both mount.

## Requirements

- A storage class for the claims the chart creates, the cluster's default unless named; block storage for `/config`.
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
    existingClaim: media
```

## Development

Pull requests run:

- `helm lint --strict`, and the rendered chart checked by kubeconform against Kubernetes 1.37.
- helm-unittest's tests in `tests/`.
- An install and upgrade with chart-testing in a kind cluster.

Commits follow Conventional Commits.
Releases are versioned and tagged automatically from `main`, and published to the Helm repository on this repo's GitHub Pages.
