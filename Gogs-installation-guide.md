# Gogs Installation Guide

Gogs will use MariaDB as its backend database.


### Install MariaDB

1. Update the distribution:

    ```bash
    sudo yum update
    ```

2. Install Git:

    ```bash
    sudo yum install git
    ```
4. Install the MariaDB server:

    ```bash
    sudo yum install mariadb-server
    ```

5. Secure the installation and set passwords for mariadb :

    ```bash
    sudo mysql_secure_installation
    ```

6. Connect to the server and create the database:
    
    ```bash 
    mysql -u root -p
    ```
   This will open mariadb console, then create database which gogs server will use.  
    ```text
    
    CREATE SCHEMA `gogs` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
    GRANT ALL PRIVILEGES ON gogs.* TO 'gogs'@'localhost' IDENTIFIED BY 'PASS';
    FLUSH PRIVILEGES;
    quit;
    ```

### Install Gogs

1. Create a new user for Gogs:

    ```bash
    sudo adduser --home /opt/gogs --shell /bin/bash --comment 'Gogs application' gogs
    ```

2. Download the Gogs code:

    ```bash
    wget https://github.com/gogs/gogs/releases/download/v0.11.86/linux_amd64.tar.gz
    ```

3. Extract the archive to `/opt/gogs`:

    ```bash
    tar xvf linux_amd64.tar.gz --strip-components=1 -C /opt/gogs
    ```

4. Change the ownership of the extracted directory:

    ```bash
    sudo chown -R gogs:gogs /opt/gogs/
    ```

5. Copy the systemd file to the system:

    ```bash
    sudo cp /opt/gogs/scripts/systemd/gogs.service /etc/systemd/system/
    ```

6. Edit the unit file:

    ```bash
    sudo vim /etc/systemd/system/gogs.service
    ```

    My configurations are as follows:

    ```plaintext
    [Service]
    Type=simple
    User=gogs
    Group=gogs
    WorkingDirectory=/opt/gogs
    ExecStart=/opt/gogs web
    Restart=always
    Environment=USER=gogs HOME=/opt/gogs
    ProtectSystem=full
    PrivateDevices=yes
    PrivateTmp=yes
    NoNewPrivileges=true

    [Install]
    WantedBy=multi-user.target
    ```

7. Reload the daemon:

    ```bash
    sudo systemctl daemon-reload
    ```

8. Start and enable Gogs, and check its status to ensure it's working correctly:

    ```bash
    sudo systemctl start gogs
    sudo systemctl enable gogs
    sudo systemctl status gogs
    ```

### Configure Gogs

* Default URL for Gogs: `http://machineIP:3000/install`

* Database settings:

  Make sure your configuration resembles the following:

  * Database type: MySQL
  * Host: `127.0.0.1:3306`
  * User: gogs
  * Password: The password you set in the database configuration

* Gogs settings:

  * Application Name: Gogs
  * Repository Root Path: `/opt/gogs/gogs-repositories`
  * Run User: gogs
  * Domain: SERVER_IP
  * SSH Port: 22
  * HTTP Port: 3000
  * Application URL: `http://SERVER_IP:3000/`
  * Log Path: `/opt/gogs/log`
