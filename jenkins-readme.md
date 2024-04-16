# Jenkins installation 



## Installation steps 

1. Update System Packages

   `````bash 
   sudo yum update
   `````

2. Install java 

   ``````bash 
   sudo yum install java-11-openjdk-devel
   ``````

3. Install wget 

   `````bash
   sudo yum install -y wget
   `````

4. Adding Jenkins repositoy 

   ````bash 
   sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
   ````

5. Installion 

   `````bash 
   sudo yum instal jenkins -y 
   `````

6. Start and enable Jenkins 

   ``````bash 
   sudo systemctl start jenkins
   sudo systemctl enable jenkins
   ``````

7. Access Jenkins web Browser 

   `````text
   http://your_server_ip:8080
   `````

8. Retrive the intial Jenkins password 

   `````bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   `````

9. After the initial setup, you can configure jenkins to meet your specific needs. and create admin user and password 