pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    args:
    - --dockerfile=Dockerfile
    - --context=.
    - --destination=192.168.0.165:5000/kaniko-demo:latest
    - --insecure
"""
    }
  }

  stages {
    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh "/kaniko/executor"
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh "kubectl apply -f k8s/"
      }
    }
  }
}
