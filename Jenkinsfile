@Library("myshared") _

def arrayStr = []

pipeline {
  agent { label 'linux-agent' }
  stages {
    stage('example') {
      steps {
        git branch: 'master', url: 'https://github.com/Workingtechman/jenkins.git'
        script {
          def folders = sh(script: 'git diff --name-only HEAD~1..HEAD | cut -f2 -d \'/\'', returnStdout: true).trim()
          echo "folders is ${folders}"
          arrayStr = folders.split("\\r?\\n")
          if (arrayStr !== "cpvb" || arrayStr !== "detection" || arrayStr !== "intersect" || arrayStr !== "main" || arrayStr !== "stvb") {
            echo "not ours FP"
            return 0
          }
          println arrayStr
          runParallelFunc(arrayStr)
        }
      }
    }
  }
}

