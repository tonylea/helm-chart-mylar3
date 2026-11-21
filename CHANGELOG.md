# Changelog

All notable changes to this project will be documented in this file. See [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version) for commit guidelines.

## [2.0.0](https://github.com/tonylea/helm-chart-mylar3/compare/v1.0.1...v2.0.0) (2026-11-21)

### ⚠ BREAKING CHANGES

* persistence.data is now a list of named mounts, each at
  /data/<name>, with at least one required.

### Features

* mount each data volume at /data/<name> ([d447d27](https://github.com/tonylea/helm-chart-mylar3/commit/d447d2713462d9543899dc1175194c8209496714))

### Documentation

* show the chart's download count ([67ee30d](https://github.com/tonylea/helm-chart-mylar3/commit/67ee30dab93b2cdc28a86591bb629912f222c3ba))

## [1.0.1](https://github.com/tonylea/helm-chart-mylar3/compare/v1.0.0...v1.0.1) (2026-11-21)

### Bug Fixes

* leave resource requests to whoever deploys the chart ([d1963b0](https://github.com/tonylea/helm-chart-mylar3/commit/d1963b07e91cf28509f4c50d27c4f6da652da146))

### Documentation

* keep only the comments that record a decision ([588d92c](https://github.com/tonylea/helm-chart-mylar3/commit/588d92c1fbeb5cd6da8beec6048eae6d692cf687))
* keep the README to what the chart needs ([f60d39f](https://github.com/tonylea/helm-chart-mylar3/commit/f60d39fc2a7112c04bd76ae63e0112c7cf45c058))

## 1.0.0 (2026-11-21)

### Features

* deploy Mylar3 with claims for /config and /data ([d5981c7](https://github.com/tonylea/helm-chart-mylar3/commit/d5981c7cc8abc7e81b2ceabc1c90fff3f8d1707a))

### Documentation

* describe the chart, its values and how to contribute ([6dc15ca](https://github.com/tonylea/helm-chart-mylar3/commit/6dc15ca37acf4dd1089c963e0de9fd13b2e6f9ed))
