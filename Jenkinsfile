@Library("myshared") _

def arrayStr = []

pipeline {
  agent { label 'linux-agent' }
  stages {
    stage('example') {
      steps {
        git branch: 'inside_root_fp1_few_fp', url: 'https://github.com/Workingtechman/jenkins.git'
        script {
          def folders = sh(script: 'bash ./script.bash', returnStdout: true).trim()
          echo "folders is ${folders}"
          arrayStr = folders.split("\\r?\\n")
          for (i=0; i < arrayStr.size(); i++) {
            if ( arrayStr[i] == "cpvb" || arrayStr[i] == "detection" || arrayStr[i] == "intersect" || arrayStr[i] == "main" || arrayStr[i] == "stvb" ) {
              echo "i is" + arrayStr[i]
              echo "Ours FP"
            }
            else {
              echo "i is " + arrayStr[i]
              echo "NOT ours FP"
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

