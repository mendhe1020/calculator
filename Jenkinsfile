pipeline {
  agent {
    docker {
      image 'php:8.2-cli'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket for host Docker access
    }
  }
  stages {
    stage('Checkout') {
      steps {
        // Checkout the PHP application code
        git branch: 'main', url: 'https://github.com/mendhe1020/calculator.git'
      }
    }
    stage('Code Linting') {
      steps {
        // Run PHP linting
        sh 'php -l index.php'
      }
    }
    stage('Build Docker Image') {
      environment {
        DOCKER_IMAGE = "anurag1020/php-app:${BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
          // Build and tag the Docker image
          sh 'docker build -t ${DOCKER_IMAGE} .'
          
          // Push the Docker image to Docker Hub
          def dockerImage = docker.image("${DOCKER_IMAGE}")
          docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
              dockerImage.push()
          }
        }
      }
    }
    stage('Deploy Application') {
      environment {
        GIT_REPO_NAME = "calculator"
        GIT_USER_NAME = "mendhe1020"
      }
      steps {
        withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
          dir("${WORKSPACE}") {
            // Ensure we're in the correct directory before running git commands
            sh '''
              git config user.email "anurag.mendhe14@gmail.com"
              git config user.name "${GIT_USER_NAME}"
              sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" k8s/deployment.yaml
              git add k8s/deployment.yaml
              git commit -m "Update deployment image to version ${BUILD_NUMBER}"
              git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
            '''
          }
        }
      }
    }
  }
}
