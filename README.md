# Gogs-Ansible-Jenkins-CI-CD

## Introduction

This README serves as a comprehensive guide for setting up the CI/CD pipeline using Gogs, Jenkins, and Ansible. It contains instructions for installing and configuring these essential components, with Jenkins and Ansible set up in VM_1 and Gogs in VM_2. After every commit in the Gogs repo, it will trigger a webhook to Jenkins, initiating pipeline stages that install Nginx on the VM_3.
Additionally, the entire infrastructure is provisioned within AWS, utilizing specific resources and security groups to ensure the project is up and running efficiently and securely.

## Table of Contents

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Guides](#installation-guides)
    
    - [Gogs Installation Guide](#gogs-installation-guide)
    - [Jenkins Installation Guide](#jenkins-installation-guide)
3. [Jenkins Pipeline](#jenkins-pipeline)
    - [Jenkins Pipeline Stages](#jenkins-pipeline-stages)
4. [Playbooks Files](#playbooks-files)
    - [InstallNginx.yml](#installnginxyml)
    - [getUsers.yml](#getusersyml)
5. [Scripts](#scripts)
    - [CreateUsers.sh](#createuserssh)
    - [GetUsers.sh](#getuserssh)
6. [Additional Files](#additional-files)
    - [Inventory](#inventory)
    - [ansible.cfg](#ansiblecfg)
7. [Screenshots Folder](#screenshots-folder)

   
   

## Prerequisites 

Before setting up the CI/CD pipeline, I ensure the following prerequisites are met:

- **Server Environment**: 
  - All VMs running CentOS 7 to host the CI/CD pipeline components, matching the task requirements.
  - All virtual machines (VMs) have private keys configured to facilitate SSH connectivity securely.

- **Security Configuration**:
  - SSH protocol is enabled for all machines in the security groups, ensuring secure communication between components.
  
- **Essential Tools**:
  - Main tools such as curl and git are installed on the server, facilitating seamless deployment and version control processes.

By ensuring these prerequisites are met, the setup process for the CI/CD pipeline can proceed smoothly, with a secure and efficient infrastructure in place.


## Installation Guides

### Gogs Installation Guide

Refer to [Gogs-installation-guide.md](Gogs-installation-guide.md) for detailed instructions on installing and configuring Gogs, a self-hosted Git service.

### Jenkins Installation Guide

Refer to [Jenkins-installation-guide.md](Jenkins-installation-guide.md) for detailed instructions on installing and configuring Jenkins, an open-source automation CI/CD server.

## Jenkins Pipeline

The [Jenkinsfile](Jenkinsfile) in this repository outlines our CI/CD process. It details the steps for building, deploying Nginx, and notifying the DevOps Engineer with Email. This Email includes essential details like the build number, status, date, and time. Additionally, it attaches a file with users in the nginxG group on VM_3 **<u>matching</u>** task needs. 

### Jenkins Pipeline Stages

The `Jenkinsfile` in this repository defines several stages to automate the CI/CD process. Here's a breakdown of each stage:

1. **Checkout:**
   - This stage checks out the code from the Git repository hosted on my Gogs server at `http://3.88.191.128:3000/haitham/haitham-automation.git`.

2. **Install Nginx:**
   - Upon successful checkout, this stage executes an Ansible playbook `InstallNginx.yml` to install Nginx on the VM_3. 
   - It uses the `ansible-playbook` command with the `--become` option to run the playbook with escalated privileges which is need to Install Nginx.

3. **Create users file:**
   - After installing Nginx, this stage runs another Ansible playbook (`getUsers.yml`) to retrieve all users in the nginxG group which we created with `CreateUsers.sh` script and store it Locally on jenkins Server (VM_1).

4. **Email Notification**

   - The `post` section of the `Jenkinsfile` ensures that email notifications are sent after the completion of the pipeline, regardless of its result here is more explanation. 

        - **Attachments Pattern:** Specifies the pattern for attachments to be included in the email. Here, it's set to include all `.txt` files which located in Jenkins work space which was created from the previos stage with file name `users.txt`.
        - **Subject:** Defines the subject line of the email, indicating the pipeline status using the `${currentBuild.result}` variable.
        - **Body:** Constructs the body of the email in HTML format, containing details such as the build number (`${BUILD_NUMBER}`) and the date and time of pipeline execution (`${BUILD_TIMESTAMP}`).
        - **Recipient:** Specifies the email address where the notification will be sent.
        - **Sender:** Sets the sender's email address.
        - **Reply-To:** Specifies the email address to which replies should be directed.
        - **MIME Type:** Defines the MIME type of the email content, which is set to HTML in this case.

## Playbooks Files 

### InstallNginx.yml

[InstallNginx.yml](InstallNginx.yml) is an Ansible playbook used to install Nginx on a remote server.
  - **hosts**: Specifies the target hosts where the tasks will be executed. In this case, it targets hosts tagged as "nginx".
  - **become**: Indicates that the tasks will require sudo privileges. 
  - **Tasks**:
    1. **Install epel-release package**: Uses the `yum` module to ensure that the `epel-release` package is present on the system.
    
    2. **Install Nginx package**: Uses the `yum` module to install the Nginx package.
    
    3. **Start Nginx service and enable it at boot**: Uses the `systemd` module to start the Nginx service and configure it to start automatically during system boot.


### getUsers.yml

[getUsers.yml](getUsers.yml) is another Ansible playbook designed to retrieve all user information in `nginxG` Group from the Nginx server (VM_3).

- **hosts**: Specifies the target hosts where the tasks will be executed. In this case, it targets hosts tagged as "nginx".
- **gather_facts**: Indicates whether Ansible should gather facts about the target hosts. In this playbook, it's set to "no" to skip gathering facts.
- **Tasks**:
  1. **Execute command**: Uses the `shell` module to execute the `getent group nginxG` command on the target hosts. The output is registered as `result_01`.
  
  2. **Write output to localhost**: Uses the `lineinfile` module to append the output of the previous task to a file named `users.txt` located at `/var/lib/jenkins/workspace/itham-automation-pipeline_master/` on the Jenkins server (**Jenkins Pipline Workspace Directory**). The `delegate_to` parameter ensures that this task is executed on the localhost.

## Scripts

### CreateUsers.sh

This Bash script, [CreateUsers.sh](CreateUsers.sh), is responsible for creating users on the Nginx server and attaching them to the `nginxG` group in VM_3.

### GetUsers.sh 
This Bash script, [GetUsers.sh](GetUsers.sh), is responsible for retrive all user in `nginxg` in VM_3. 

## Additional Files

### Inventory

The [Inventory](Inventory) file contains the list of servers that Ansible will manage.

### ansible.cfg

[ansible.cfg](ansible.cfg) is the configuration file for Ansible, containing settings such as inventory location and default options.

## Screenshots Folder

This folder contains screenshots that serve as **proof** of completing the setup and configuration of the CI/CD pipeline using Gogs, Jenkins, and Ansible. Below is a brief description of each screenshot:


- [00-infrastructure.png](./screenshots/00-infrastructure.png): Infrastructure setup showing Three VMs created on AWS Console. 
- [01-Release-IPs.png](./screenshots/01-Release-IPs.png): Centos Release information and IP addresses for each VMs.
- [02-Gogs-Dashboard.png](./screenshots/02-Gogs-Dashboard.png): Gogs dashboard displaying the repositories and activity.
- [03-Jenkins-Dashboard.png](./screenshots/03-Jenkins-Dashboard.png): Jenkins dashboard showcasing the pipeline setup and builds.
- [04-Success-Build.png](./screenshots/04-Success-Build.png): Successful build completion indication in Jenkins.
- [05-Pipeline-Output.png](./screenshots/05-Pipeline-Output.png): Output of the CI/CD pipeline execution.
- [06-Email-Information.png](./screenshots/06-Email-Information.png): Email notification containing build information (Status, Numuber, Date&tiem and Attachment).
- [07-Attachment-Content.png](./screenshots/07-Attachment-Content.png): Content of the attachment containing users in the nginxG group.
- [08-Centos-welcome-page.png](./screenshots/08-Centos-welcome-page.png): CentOS welcome page, which serves as proof that Nginx is up and running on VM_3. Note: Many Linux distributions ship with a custom `index.html` file in the default web root directory, which is why the default Nginx page may not appear.

