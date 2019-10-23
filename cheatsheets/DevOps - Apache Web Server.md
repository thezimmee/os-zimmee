# Apache Web Server

## Common commands

### Install

```bash
sudo apt install apache2
```

### Check status

```bash
sudo systemctl status apache2
```

### Stop/Start/Restart

```bash
sudo systemctl stop apache2
sudo systemctl start apache2
sudo systemctl restart apache2
```

## Host multiple websites with Apache on Ubuntu Server 18

1.  Create your website files:

    1.  Create the directory: `sudo mkdir -p /home/zimmees/test.com`
    2.  If needed, ensure proper ownership: `sudo chown -R $USER:$USER /home/zimmees/test.com`
    3.  If needed, modify file permissions: `sudo chmod -R 755 /home/zimmees/test.com`
    4.  Create website files: `sudo nano /home/zimmees/test.com/index.html`

2.  Create and configure virtual host:

    ```bash
    sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/test.com.conf
    sudo nano /etc/apache2/sites-available/test.com.conf
    ```

    Overwrite values as follows:

    ```txt
    <VirtualHost *:80>
        ServerAdmin admin@test.com
        ServerName test.local
        ServerAlias www.test.local
        DocumentRoot /home/zimmees/test.com
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory />
            Options FollowSymLinks
            AllowOverride None
        </Directory>
        <Directory /mnt/volume-nyc1-01/html/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride None
            Require all granted
        </Directory>
    </VirtualHost>
    ```

    If needed, edit the SSL config as well:

    ```bash
    sudo nano /etc/apache2/sites-available/ssl-default.conf
    ```

    And ensure it looks similar to this:

    ```txt
    ...
    <IfModule mod_ssl.c>
        <VirtualHost _default_:443>
            ServerAdmin webmaster@localhost
            DocumentRoot /mnt/volume-nyc1-01

        <Directory />
            Options FollowSymLinks
            AllowOverride None
        </Directory>
        <Directory /mnt/volume-nyc1-01/html/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride None
            Require all granted
        </Directory>
    ...
    ```

3.  Enable new virtual host: `sudo a2ensite test.com.conf`

4.  Restart Apache: `sudo systemctl restart apache2`

5.  Configure hosts file on the local/client machine:

    ```bash
    sudo nano /etc/hosts
    ```

    Configure as follows (use the actual IP of the host machine, and choose your desired host name):

    ```txt
    192.168.10.100  test.local
    ```

6.  Navigate to `test.local` in the browser of the local/client machine.

## Remove a site from Apache

1. Remove virtual host file from `/etc/apache2/sites-available/test.com.conf`
2. Disable site: `sudo a2dissite test.com.conf`
3. Remove from hosts file (`/etc/hosts`) on local/client machine(s).

_References:_

-   [Ubuntu docs](https://help.ubuntu.com/lts/serverguide/httpd.html.en)
-   [HostAdvice.com](https://hostadvice.com/how-to/how-to-host-multiple-website-on-an-ubuntu-18-04-vps/)
-   [Digital Ocean tutorials](https://www.digitalocean.com/community/tutorials/how-to-move-an-apache-web-root-to-a-new-location-on-debian-8)
