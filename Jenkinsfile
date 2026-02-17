pipeline {
    agent any

    environment {
        DEVELOPER_DIR = "/Applications/Xcode.app/Contents/Developer"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh '''
                set -o pipefail

                xcodebuild test \
                  -project GithubAPIWrapper.xcodeproj \
                  -scheme GithubAPIWrapper \
                  -destination "platform=iOS Simulator,name=iPhone 17,OS=latest"
                '''
            }
        }
    }
}

