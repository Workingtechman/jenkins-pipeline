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
          for (i=0; i < arrayStr.size(); i++) {
            if ( arrayStr[i] !== "cpvb" || arrayStr[i] !== "detection" || arrayStr[i] !== "intersect" || arrayStr[i] !== "main" || arrayStr[i] !== "stvb" ) {
              echo "i is ${i}"
              echo "not ours FP"
              return 0
            }
          }
          println arrayStr
          runParallelFunc(arrayStr)
        }
      }
    }
  }
}

