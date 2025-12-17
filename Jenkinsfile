pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
      - /busybox/sh
      - -c
      - sleep 999999
    tty: true
    volumeMounts:
      - name: workspace-volume
        mountPath: /workspace

  - name: kubectl
    image: 192.168.0.165:5000/custom-kubectl-client:v1
    command:
      - /bin/sh
      - -c
      - sleep 999999
    tty: true
    volumeMounts:
      - name: workspace-volume
        mountPath: /workspace

  volumes:
    - name: workspace-volume
      emptyDir: {}
"""
    }
  }

  environment {
    REGISTRY   = "192.168.0.165:5000"
    IMAGE_NAME = "kaniko-demo"
    IMAGE_TAG  = "latest"
  }

  stages {

    stage('Checkout Source') {
      steps {
        container('kaniko') {
          checkout scm
        }
      }
    }

    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh '''
            echo "Building image with Kaniko..."
            /kaniko/executor \
              --context=dir://$WORKSPACE \
              --dockerfile=$WORKSPACE/Dockerfile \
              --destination=$REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
              --insecure \
              --skip-tls-verify
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        container('kubectl') {
          sh '''
            echo "Deploying manifests..."
            kubectl apply -f k8s/
          '''
        }
      }
    }
  }
}
