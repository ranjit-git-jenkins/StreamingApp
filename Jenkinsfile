pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds() }
  parameters {
    string(name: 'AWS_REGION', defaultValue: 'ap-south-1')
    string(name: 'AWS_ACCOUNT_ID', defaultValue: '', description: '12-digit AWS account ID')
    string(name: 'IMAGE_TAG', defaultValue: '', description: 'Optional image tag; defaults to short Git SHA')
    booleanParam(name: 'PUSH_TO_ECR', defaultValue: false, description: 'Requires AWS credentials and ECR repositories')
  }
  environment { REGISTRY = "${params.AWS_ACCOUNT_ID}.dkr.ecr.${params.AWS_REGION}.amazonaws.com" }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Validate') { steps { sh 'docker version && test -f docker-compose.yml' } }
    stage('Build Images') {
      steps {
        script {
          env.TAG = params.IMAGE_TAG?.trim() ? params.IMAGE_TAG.trim() : sh(script:'git rev-parse --short HEAD',returnStdout:true).trim()
          def services = ['authService':'backend/authService','streamingService':'backend/streamingService','adminService':'backend/adminService','chatService':'backend/chatService','frontend':'frontend']
          services.each { name, dir ->
            if (!fileExists("${dir}/Dockerfile")) { error("Missing Dockerfile: ${dir}") }
            sh "docker build -t streamingapp-${name.toLowerCase()}:${TAG} ${dir}"
          }
        }
      }
    }
    stage('Push ECR') {
      when { expression { return params.PUSH_TO_ECR } }
      steps {
        script {
          if (!(params.AWS_ACCOUNT_ID ==~ /[0-9]{12}/)) { error('Set valid AWS_ACCOUNT_ID') }
          withCredentials([[$class:'AmazonWebServicesCredentialsBinding', credentialsId:'aws-jenkins']]) {
            sh 'aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REGISTRY"'
            ['authservice','streamingservice','adminservice','chatservice','frontend'].each { name ->
              sh "docker tag streamingapp-${name}:${TAG} ${REGISTRY}/streamingapp-${name}:${TAG}"
              sh "docker push ${REGISTRY}/streamingapp-${name}:${TAG}"
            }
          }
        }
      }
    }
  }
  post { always { echo 'Pipeline finished. Deployment to EKS is a separate, controlled step.' } }
}
