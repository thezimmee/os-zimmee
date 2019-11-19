# The Perfect Media Server

## Tutorials

-   [Docker Home Media Server](https://www.smarthomebeginner.com/docker-home-media-server-2018-basic/)
-   [CloudBox](https://github.com/Cloudbox/Cloudbox/wiki/Basics%3A-Introduction)

## Requirements and Features

-   [ ] Requirements and Features:
    -   [ ] File server:
        -   [ ] Serve files throughout home network.
        -   [ ] Access and share files online.
    -   [ ] HTPC:
        -   [ ] Watch and manage movies, shows, and music.
            -   [ ] Watch at home.
            -   [ ] Watch online.
        -   [ ] Automatically download movies, shows, and music.
        -   [ ] Automatically erase/skip commercials from shows.
        -   [ ] Watch live TV.
        -   [ ] Record live TV to media library.
        -   [ ] Track popular new shows, upcoming shows, shows we might be interested in.
        -   [ ] Parental controls.
            -   [ ] Restrict content on a per-user basis.
            -   [ ] Restrict by time watched on per-user basis.
    -   [ ] Single mount point with multiple storage drives.

## Step by Step Install

_Note: Step by step instructions are available for many of these earlier steps [here](https://forums.serverbuilds.net/t/setting-up-media-server-using-ubuntu-and-snapraid/239/2)._

-   [ ] Install Ubuntu server.
    -   [ ] Create bootable USB drive.
    -   [ ] Go to bios screen and change boot order to USB drive first (remove later).
    -   [ ] Reboot and install.
-   [ ] Update package manager:
    -   Run: `sudo apt update`
    -   Then: `sudo apt upgrade`
-   [ ] Set up [SSH server](https://www.smarthomebeginner.com/install-ssh-server-on-ubuntu-1204/).
-   [ ] If needed, [format drives](https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux).
-   [ ] Mount drives and [set up mergerFS](https://blog.linuxserver.io/2017/06/24/the-perfect-media-server-2017/).
-   [ ] Set up file sharing:
    -   [ ] Create directory structure:
        -   /Memories
        -   /Movies
        -   /Music
        -   /Projects
        -   /Reference or /Accounting or /Library
        -   /Sheet Music
        -   /Shows
    -   [ ] Set up [NFS server](https://linuxize.com/post/how-to-install-and-configure-an-nfs-server-on-ubuntu-18-04/).
    -   [ ] Set up [Samba server](https://tutorials.ubuntu.com/tutorial/install-and-configure-samba#1) ([see also](https://help.ubuntu.com/lts/serverguide/samba-fileserver.html)).
-   [ ] Set up [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/).
    -   [ ] Set up [Watchtower](https://containrrr.github.io/watchtower/): Manage Docker container updates.
-   [ ] Set up Plex media server:
    -   [ ] Set up Plex.
    -   [ ] Set up [Tautulli for Plex](https://tautulli.com): monitor Plex activity and record various statistics.
    -   [ ] Set up [Ombi](https://ombi.io) or [Plex Requests](https://plexrequests.8bits.ca): Allow users to request new media content.
    -   [ ] Set up [Organizr](https://organizr.app): manage plex invites, users, UI, etc.
    -   [ ] Set up ability to [remove commercials in Plex](https://support.plex.tv/articles/115003944134-removing-commercials/): part of Plex media server.
-   [ ] Set up movie/shows/music manager:
    -   [ ] Set up [Radarr](https://radarr.video) or [CouchPotato](https://couchpota.to) or [Sickrage](https://git.sickrage.ca/SiCKRAGE/sickrage): Manage movies.
    -   [ ] Set up [Sonarr](https://sonarr.tv): Manage TV shows.
    -   [ ] Set up [Lidarr](https://lidarr.audio) or [LibreSonic](https://github.com/Libresonic/libresonic) ?? or [AirSonic](https://airsonic.github.io) ??: Web-based media streamer for music. Share music with friends, listen at work, etc.
-   [ ] Set up file downloaders:
    -   [ ] Set up [NZBGet](https://nzbget.net) or [sabnzbd](https://sabnzbd.org): Most efficient usenet downloader.
    -   [ ] Set up [Deluge](https://www.deluge-torrent.org) or [Transmission](https://transmissionbt.com) or [QBitTorrent](https://www.qbittorrent.org): BitTorrent client.
    -   [ ] Automate downloads.
-   [ ] Set up [NextCloud](https://nextcloud.com): UI to serve and share files.
-   [ ] Set up online ftp/ssh access to network.
    -   To get these working outside the home network:
        1. Open ports on local firewall.
        2. Set up [port forwarding](https://www.online-tech-tips.com/computer-tips/ott-explains-what-is-port-forwarding-and-what-is-it-used-for/) to forward certain ports from your router to the server.
        3. Set up [dynamic DNS](https://www.online-tech-tips.com/computer-tips/ddns-dynamic-dns-service/), so that it can be access via a URL rather than an IP address.
-   [ ] Set up online file sharing with NextCloud.
-   [ ] Consider setting up the following:
    -   [nzbhydra](https://github.com/theotherp/nzbhydra): meta search for NZB indexers.
    -   [Jackett](https://github.com/Jackett/Jackett): API support for favorite torrent trackers.
    -   [Traefik](https://traefik.io): Watch media anywhere.
    -   [Portainer](https://www.portainer.io): Docker container management.
-   [ ] Figure out how to watch live OTA TV.
-   [ ] Figure out how to record live OTA TV.
