resource "kubectl_manifest" "node_pool_x86" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: x86
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
      provider:
        instanceTypes: ["m5.large", "c5.large"]
        subnetSelector:
          Name: "${var.cluster_name}-private-*"
        securityGroupSelector:
          Name: "${var.cluster_name}-node"
      ttlSecondsAfterEmpty: 60
  YAML
}

resource "kubectl_manifest" "node_pool_arm64" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: arm64
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["arm64"]
      provider:
        instanceTypes: ["m6g.large", "c6g.large"]
        subnetSelector:
          Name: "${var.cluster_name}-private-*"
        securityGroupSelector:
          Name: "${var.cluster_name}-node"
      ttlSecondsAfterEmpty: 60
  YAML
}