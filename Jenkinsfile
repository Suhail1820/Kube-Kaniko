pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - /busybox/sh
    args:
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

    stage('Debug Workspace') {
      steps {
        container('kaniko') {
          sh '''
            echo "PWD:"
            pwd
            echo "FILES:"
            ls -l
          '''
        }
      }
    }

    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh '''
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
        container('kaniko') {
          sh '''
            kubectl apply -f k8s/
          '''
        }
      }
    }
  }
}
