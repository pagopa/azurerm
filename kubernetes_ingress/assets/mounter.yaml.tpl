apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${secret_provider_class}-mounter
  namespace: ${namespace}
  labels:
    app: ${secret_provider_class}-mounter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${secret_provider_class}-mounter
  template:
    metadata:
      labels:
        aadpodidbinding: ${namespace}-ingress-pod-identity
        app: ${secret_provider_class}-mounter
    spec:
      containers:
      - name: alpine
        image: alpine:latest
        command: ['tail', '-f', '/dev/null']
        volumeMounts:
          - name: secrets-store-inline-crt
            mountPath: "/mnt/secrets-store-crt"
            readOnly: true
        resources:
          requests:
            memory: 16Mi
            cpu: 50m
          limits:
            memory: 32Mi
            cpu: 100m
      volumes:
      - name: secrets-store-inline-crt
        csi:
          driver: secrets-store.csi.k8s.io
          readOnly: true
          volumeAttributes:
            secretProviderClass: ${secret_provider_class}
