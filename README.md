# Big Brother Helm Charts

This repository contains Helm charts for deploying the Big Brother CCTV system and its microservices on Kubernetes.

## Charts

- **big-brother** *(Recommended)*: Complete umbrella chart orchestrating all microservices together with a single command.
- **api**: Backend API for the CCTV system, alerts ingestion, real-time SSE dispatch, and snapshot storage with PVC support.
- **telescreen**: Frontend web dashboard (React 19 + HLS.js) with real-time motion alerts drawer and acoustic radar chime.
- **mediamtx**: High-performance streaming server handling video streams (RTSP, RTMP, HLS, WebRTC).
- **motion-detector**: 100% in-house motion detector microservice uploading snapshots directly to the local API.
- **postgres**: PostgreSQL database for persistent storage (users, cameras, alerts).
- **camera**: Edge microservice for local webcam/device capture and streaming.

---

## Quick Start (Deploy the Entire System)

Deploy everything with a single Helm command using the **umbrella chart**:

```sh
# Clone or navigate to the helm folder
cd helm

# Deploy all services into Kubernetes
helm install big-brother ./charts/big-brother
```

To customize or enable/disable specific microservices:
```sh
helm install big-brother ./charts/big-brother \
  --set api.persistence.enabled=true \
  --set api.persistence.size=10Gi \
  --set motion-detector.config.cameraName="salon-cctv"
```

---

## Usage via Helm Repository

1. **Add the Helm repository:**
   ```sh
   helm repo add big-brother-cctv https://big-brother-cctv.github.io/helm
   helm repo update
   ```

2. **Install the full stack:**
   ```sh
   helm install big-brother big-brother-cctv/big-brother
   ```

3. **Or install individual charts:**
   ```sh
   helm install my-api big-brother-cctv/api
   helm install my-telescreen big-brother-cctv/telescreen
   helm install my-motion-detector big-brother-cctv/motion-detector
   ```

---

## Configuration & Key Parameters

### API Chart (`charts/api`)
| Parameter | Default | Description |
|---|---|---|
| `persistence.enabled` | `false` | Enable PVC persistent volume for motion alert snapshots (`/app/data`) |
| `persistence.size` | `5Gi` | Storage size for snapshots |
| `config.internalToken` | `"internal-token-pro"` | Shared secret for edge motion detectors |
| `config.jwtSecret` | `...` | Secret key for JWT authentication |

### Motion Detector Chart (`charts/motion-detector`)
| Parameter | Default | Description |
|---|---|---|
| `config.apiUrl` | `"http://api:8080/api/alerts"` | In-house API target endpoint for snapshots |
| `config.internalToken` | `"internal-token-pro"` | Token matching the API `INTERNAL_TOKEN` |
| `config.cameraName` | `"camera"` | Name of the camera associated with motion events |
| `config.cooldownSeconds` | `"15"` | Smart cooldown seconds between alert notifications |
| `config.rtspUrl` | `"rtsp://mediamtx:8554/stream"` | RTSP stream source to analyze |

---

## Development & Repository Maintenance

To package all charts and update the `docs/index.yaml` repository index:

```sh
bash ./build-helm-repo.sh
```
