pipeline {
   agent {
       label 'linux'
   }
   stages {
       stage('Git') {
           steps{
               git branch: 'main', credentialsId: '6808eaf8-e5cd-438d-8757-73bf421b5b47', url: 'git@github.com:awertoss/vector-role.git'
           }
       }
       stage('Molecule install') {
           steps{
               sh 'pip install molecule==3.5.2'
               sh 'pip install "ansible-lint<6.0.0"'
               sh 'pip install molecule_docker'
           }
       }
       stage('Molecule test'){
           steps{
               sh 'molecule test -s centos'
               cleanWs()
           }
       }
   }
}
