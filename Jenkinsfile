@Library("myshared") _

def arrayStr = []
def testFunc(String name) {
    println "Hello, " + name
}
def baseCommit
def lastCommit

pipeline {
  agent { label 'linux-agent' }
  parameters {
    booleanParam(name: 'PARAM_ALL_FP', defaultValue: false, description: 'Parameter to decide how much FPs to build')
  }
  stages {
//    stage('get previous successful commit') {
//      steps {
//        script {
//baseCommit = sh(script: "git rev-parse origin/" + env.BRANCH_NAME, returnStdout: true).trim()
//        }
//      }
//    }
    stage('get list of FPs') {
      steps {
        dir ('main-repo') {
          git branch: 'main', url: 'https://github.com/Workingtechman/jenkins-pipeline.git'
          script {
            baseCommit = sh(script: "cat last_successful_build.txt", returnStdout: true).trim()
            env.baseCommit = "${baseCommit}"
          }
        }
        git branch: 'inside_root_fp1_few_fp', url: 'https://github.com/Workingtechman/jenkins.git'
        script {
          lastCommit = sh(script: "git rev-parse origin/" + env.BRANCH_NAME, returnStdout: true).trim()
          env.lastCommit = "${lastCommit}"
          if ( PARAM_ALL_FP == true ) {
            def map = ["cpvb": runParallelFunc("cpvb"), "detection": runParallelFunc("detection"), "intersect": runParallelFunc("intersect"), "main": runParallelFunc("main"), "stvb": runParallelFunc("stvb"), "profile": runParallelFunc("profile")]
          }
          else {
            def folders = sh(script: 'bash ./main-repo/script.bash', returnStdout: true).trim()
            echo "folders is ${folders}"
            arrayStr = folders.split("\\r?\\n")
            for (i=0; i < arrayStr.size(); i++) {
              if ( arrayStr[i] == "cpvb" || arrayStr[i] == "detection" || arrayStr[i] == "intersect" || arrayStr[i] == "main" || arrayStr[i] == "stvb" ) {
                echo "i is " + arrayStr[i]
                echo "Ours FP"
              }
              else {
                echo "i is " + arrayStr[i]
                echo "NOT ours FP"
                return 0
              }
            }
            echo "arrayStr"
            println arrayStr
            echo "runArrayFunc"
            runArrayFunc(arrayStr)
            echo "create map from arrastr.collectEntries"
            map = arrayStr.collectEntries { [it, runParallelFunc(it) ] }

//            map.each{entry -> println "$entry.key: $entry.value"}
//            echo "println map"
//            println map
//            echo "println of * is module"
//            println "stvb is module - " + map["stvb"]
//            println "main is module - " + map.main
//            echo "runMapFunc"
//            runMapFunc(map)

            echo "testFunc in this pipeline"
            testFunc("Evgen")
          }
        }
      }
    }
    stage('paralleling') {
      steps {
        script {
          echo "run parallel"
          parallel(map)
        }
      }
    }
  }
}

