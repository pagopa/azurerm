apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: ${secret_name}
  namespace: ${namespace}
spec:
  provider: azure
  secretObjects:
    - secretName: ${secret_name}
      type: kubernetes.io/tls
      data:
        - key: tls.key
          objectName: ${secret_name}
        - key: tls.crt
          objectName: ${secret_name}
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: ${keyvault_name}
    tenantId: ${tenant_id}
    cloudName: ""
    objects: |
      array:
        - |
          objectName: ${secret_name}
          objectType: secret
          objectVersion: ""
