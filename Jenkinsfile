pipeline {
  agent { label 'Cafe-system' }   // 👈 use your node label

  environment {
    APP_NAME = 'leafcafe'
    IMAGE = "${APP_NAME}:${env.BUILD_NUMBER}"
    CONTAINER_NAME = "${APP_NAME}"
    HOST_PORT = '80'
    CONTAINER_PORT = '80'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE .'
      }
    }

    stage('Stop Old Container') {
      steps {
        sh 'docker rm -f $CONTAINER_NAME || true'
      }
    }

    stage('Run New Container') {
      steps {
        sh '''
          docker run -d --name $CONTAINER_NAME \
            -p $HOST_PORT:$CONTAINER_PORT \
            --restart unless-stopped \
            $IMAGE
        '''
      }
    }

    stage('Health Check') {
      steps {
        sh 'sleep 5 && curl -fsS http://localhost/ || (echo "App not healthy" && exit 1)'
      }
    }
  }

  post {
    success {
      echo "✅ Successfully deployed $APP_NAME on agent $NODE_NAME"
    }
    failure {
      sh 'docker logs $CONTAINER_NAME || true'
    }
  }
}
