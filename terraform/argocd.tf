resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"

  create_namespace = false

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.argocd
  ]
}
