# Example: Kubernetes with PersistentVolume

This example shows how to deploy chrony in Kubernetes with persistent storage for the drift file.

## Create PersistentVolume and PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: chrony-data
  namespace: kube-system
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi
  storageClassName: standard
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chrony
  namespace: kube-system
  labels:
    app: chrony
spec:
  replicas: 1
  selector:
    matchLabels:
      app: chrony
  template:
    metadata:
      labels:
        app: chrony
    spec:
      containers:
      - name: chrony
        image: ghcr.io/chris-short/chrony:latest
        imagePullPolicy: IfNotPresent
        securityContext:
          capabilities:
            drop:
            - ALL
            add:
            - SYS_TIME
          readOnlyRootFilesystem: true
          allowPrivilegeEscalation: false
          runAsNonRoot: true
          runAsUser: 100
        resources:
          requests:
            cpu: 10m
            memory: 16Mi
          limits:
            cpu: 100m
            memory: 32Mi
        volumeMounts:
        - name: chrony-data
          mountPath: /var/lib/chrony
        - name: chrony-run
          mountPath: /run/chrony
        - name: chrony-log
          mountPath: /var/log/chrony
        livenessProbe:
          exec:
            command:
            - /bin/sh
            - -c
            - chronyc tracking | grep -q "Leap status"
          initialDelaySeconds: 30
          periodSeconds: 30
          timeoutSeconds: 5
          failureThreshold: 3
      volumes:
      - name: chrony-data
        persistentVolumeClaim:
          claimName: chrony-data
      - name: chrony-run
        emptyDir:
          medium: Memory
      - name: chrony-log
        emptyDir: {}
```

## Deploy

```bash
kubectl apply -f persistent-deployment.yaml
```

## Verify

```bash
# Check pod status
kubectl get pods -n kube-system -l app=chrony

# Check logs
kubectl logs -n kube-system -l app=chrony

# Execute commands
kubectl exec -n kube-system -l app=chrony -- chronyc sources
```
