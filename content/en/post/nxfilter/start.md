+++
Categories = [
	"Sysadmin", 
	"NxFilter",
	"DNS"
]
description = "About the tool and how to install"
tags = ["nxfilter", "dns","filtro","installing","raspbian", "debian", "pfsense" ]
date = "2016-04-12"
publishdate = "2016-04-15"
menu = "main"
title = "NXFilter - DNS Webfilter"
featured = "nxfilter01.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

#### Presentation 

[NXFilter](http://www.nxfilter.org/) it's a tool that works like DNS Webfilter and more, proving tools to filter web content.

The advantages of NxFilter:

 1. lightweight and easy to install
 2. Authentication based on : LDAP, AD, Single-sign-on ( SSO ), etc... 
 3. Replace proxy-cache like Squid
 4. Can block tools like UltraSurf and/or Tor
 5. Dynamic site identification, not use onliest lists, can find patterns and classificate the sites

#### Funcionamento

Seu principio é atuar como servidor DNS, pode fazer:

 1. Redirect
 2. Transferência de Zona
 3. Domínio Dinâmico
 4. E inclusive como o próprio servidor DNS, permitindo registros A, AAAA, SOA e etc...


#### Instalando

A instalação do NxFilter é bem simplificada, o site disponibiliza pacotes deb,zip e outros formatos depreciados como exe.

Como pré-requisito só é necessário ter o java instalado na máquina, funciona tanto com OpenJDK quanto com o Oracle Java.

##### Debian Jessie / Raspbian
```bash
$ sudo su - 
$ apt-get update
$ apt-get install openjdk-8-jre-headless upstart
$ wget -t0 -c http://nxfilter.org/download/nxfilter-3.1.8.deb
$ dpkg -i nxfilter-3.1.8.deb
```

##### PFSense 2.2.6 - Dica do Grupo NxFilter - DNS WebFilter no Telegram
```bash
$ pkg update
$ pkg install openjdk8-jre
$ rehash
$ mkdir -p /opt/nxfilter
$ cd /opt/nxfilter
$ fetch http://nxfilter.org/download/nxfilter-3.4.2.zip
$ unzip nxfilter-3.1.8.zip
$ cd bin
$ chmod +x *.sh
$ ./startup.sh -d
```
