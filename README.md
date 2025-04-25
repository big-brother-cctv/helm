# Big Brother Helm Charts

This repository contains Helm charts for deploying the Big Brother CCTV system and its microservices on Kubernetes.

## Charts

- **api**: Backend API for the CCTV system.
- **camera**: Microservice for camera management and streaming.
- **mediamtx**: Media server for handling video streams.
- **motion-detector**: Microservice for detecting motion events.
- **postgres**: PostgreSQL database for persistent storage.
- **telescreen**: Frontend web application for monitoring and control.

## Usage

1. **Add the Helm repository:**
   ```sh
   helm repo add big-brother-cctv https://big-brother-cctv.github.io/helm
   helm repo update
   ```

2. **Install a chart:**
   ```sh
   helm install my-release big-brother-cctv/<chart-name>
   ```

   Replace `<chart-name>` with one of: `api`, `camera`, `mediamtx`, `motion-detector`, `postgres`, `telescreen`.

3. **Customize values:**
   Each chart supports customization via its `values.yaml`. You can override values using `-f my-values.yaml` or `--set key=value`.

## Development

To package and update the Helm repository index, run:

```sh
./build-helm-repo.sh
```

This will package all charts in the `charts/` directory and update the `docs/index.yaml` file.
