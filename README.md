# Big Brother CCTV — Helm Charts (Kubernetes)

Colección de charts oficiales de **Helm** para el despliegue distribuido de la plataforma **Big Brother CCTV** en clusters de **Kubernetes** (k3s, MicroK8s, EKS, GKE, Bare Metal).

---

## 📦 Mapa de Charts

| Chart | Directorio | Descripción |
|---|---|---|
| **big-brother** *(Recomendado)* | [`charts/big-brother`](file:///home/rdvl/repositories/big-brother-cctv/helm/charts/big-brother) | **Umbrella Chart**: Despliega y orquesta la suite completa con un solo comando. |
| **api** | [`charts/api`](file:///home/rdvl/repositories/big-brother-cctv/helm/charts/api) | Backend en Go (REST API, SSE en tiempo real, gestión de snapshots y base de datos). |
| **telescreen** | [`charts/telescreen`](file:///home/rdvl/repositories/big-brother-cctv/helm/charts/telescreen) | Dashboard táctico web (React 19, HLS.js, visor forense, sonido de alarma). |
| **mediamtx** | [`charts/mediamtx`](file:///home/rdvl/repositories/big-brother-cctv/helm/charts/mediamtx) | Servidor de streaming de alto rendimiento (RTSP, RTMP, HLS, WebRTC). |
| **motion-detector** | [`charts/motion-detector`](file:///home/rdvl/repositories/big-brother-cctv/helm/charts/motion-detector) | Daemon unificado multi-cámara con captura forense y purga inmediata de disco. |
| **postgres** | [`charts/postgres`](file:///home/rdvl/repositories/big-brother-cctv/helm/charts/postgres) | Base de datos PostgreSQL con soporte para volumen persistente (PVC). |
| **camera** | [`charts/camera`](file:///home/rdvl/repositories/big-brother-cctv/helm/charts/camera) | Agente edge para dispositivos USB físicos (desactivado por defecto en la nube). |

---

## 🚀 Despliegue Rápido (Stack Completo)

Para desplegar todo el sistema en un namespace dedicado:

```bash
# 1. Crear namespace
kubectl create namespace big-brother-cctv

# 2. Desplegar mediante el Umbrella Chart
helm upgrade --install big-brother ./charts/big-brother -n big-brother-cctv
```

### Personalización mediante valores
Puedes anular parámetros directamente en la línea de comandos o creando tu propio archivo `my-values.yaml`:

```bash
helm upgrade --install big-brother ./charts/big-brother \
  --namespace big-brother-cctv \
  --set postgres.persistence.size=20Gi \
  --set api.config.jwtSecret="tu-secreto-super-seguro" \
  --set telescreen.ingress.hosts[0].host="cctv.midominio.com"
```

---

## 🔧 Parámetros Clave de Configuración

### 1. API Core (`charts/api`)
```yaml
api:
  config:
    port: "8080"
    dbHost: "postgres"
    dbPort: "5432"
    dbUser: "admin"
    dbPassword: "admin"
    dbName: "bigbrother"
    internalToken: "internal-token-pro"
    mediamtxApiUrl: "http://mediamtx:9997"
    mediamtxRtspHost: "mediamtx"
  persistence:
    enabled: true
    size: 10Gi
    mountPath: /app/data
```

### 2. Motion Detector Unificado (`charts/motion-detector`)
```yaml
motion-detector:
  config:
    apiUrl: "http://api:8080/api/alerts"
    internalToken: "internal-token-pro"
    cooldownSeconds: "15"
    discordWebhook: "" # Opcional: webhook para alertas en Discord
```

### 3. Base de Datos PostgreSQL (`charts/postgres`)
```yaml
postgres:
  image:
    tag: "16-alpine"
  persistence:
    enabled: true
    size: 10Gi
  configMap:
    data:
      POSTGRES_USER: "admin"
      POSTGRES_PASSWORD: "admin"
      POSTGRES_DB: "bigbrother"
      PGDATA: "/var/lib/postgresql/data/pgdata"
```

---

## 🌐 Ingress y Exposición Externa

El sistema admite controladores Ingress como **Traefik** (estándar en k3s) o **Cloudflare Tunnels**:

```yaml
telescreen:
  ingress:
    enabled: true
    className: "traefik"
    hosts:
      - host: cctv.local
        paths:
          - path: /
            pathType: Prefix
```

---

## 🛠️ Mantenimiento y Empaquetado del Repositorio Helm

Para generar los paquetes `.tgz` e indexar el catálogo público en `docs/index.yaml`:

```bash
cd helm
bash ./build-helm-repo.sh
```
