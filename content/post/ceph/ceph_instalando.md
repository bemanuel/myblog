+++
Categories = [
	"Sysadmin", 
	"CEPH",
	"Storage",
        "Cluster"
]
description = "Alta disponibilidade e Hiperconvergência"
tags = ["ceph", "storage","hiperconvergência","ha", "cluster", "lb", "loadbalance","raid"]
date = "2016-11-12"
publishdate = "2016-11-12"
menu = "ceph"
title = "CEPH - Instalando"
featured = "ceph.svg"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

## Cluster CEPH - Quick start

 O CEPH já foi comentado no post [CEPH - O que é ?](http://blog.bemanuel.com.br/post/ceph/inicio/)

 O Cluster CEPH precisa de no mínimo 3 nós, por isso o ambiente de instalação seguirá essa premissa. O ambiente em que fiz o procedimento de instalação foi o Debian/Ubuntu, porém o que muda para o RedHat é apenas a parte de instalação de pacotes, os comandos são iguais.

 O Ambiente que instalaremos terá a especificação:

Nó | IP | IP Rede CEPH
----- | :--------: | :-------:
cph_01 | 172.16.0.2 | 192.168.50.2
cph_02 | 172.16.0.3 | 192.168.50.3
cph_03 | 172.16.0.4 | 192.168.50.4
cph_04 | 172.16.0.5 | 192.168.50.5
cph_05 | 172.16.0.6 | 192.168.50.6

 O Hardware mínimo para cada máquina

. Memória = 1GB
. 2 HDs. 1 com 8GB ( para o SO ) + 4 HDs com 16GB ( para o CEPH )
. 2 Placas de Rede 1 GB - Para Rede 172.16.0.0/24

## Pré-requisito

 Antes de criar o Cluster CEPH é preciso preparar o ambiente onde ele será publicado. Como pré-requisito deve se ter:

Recurso | Descrição 
:--------- | ---------- 
 NTP | Protocolo para sincronia de horário
 SSH | Secure Shell - Protocolo para comunicação de rede de forma segura
 Conexao SSH sem Senha | É preciso permitir a conexão entre os servidores sem senha
 Rede dedicada | Rede dedicada para o cluster CEPH, Rede 1G atende mas 10G é desejável
 Firewall liberado | Porta 6789 protocolo tcp liberados para comunicação

1. Instalando NTP e SSH
  
 O Serviço NTP é responsável por manter o horário dos servidores sincronizados. Como estamos falando de um cluster que mantém dados replicados e sincronizados isso é muito importante. 

 Para instalar o serviço NTP, execute:

 ```bash
    apt-get update && apt-get -y install ntp openssh-server 
    dpkg-reconfigure tzdata
 ```
   Na configuração do Timezone defina o seu local

2. Definindo configurações de rede

 Em `/etc/network/interfaces` são definidos os ips de cada máquina de acordo com a tabela especificada. Por exemplo, no servidor 01 ( cph_node01 ) ficará assim:

 ```bash /etc/network/interfaces
    auto enp0s3 
    iface enp0s3 inet static
        address 172.16.0.2
        netmask 255.255.255.0

    auto enp0s8 
    iface enp0s8 inet static
        address 192.168.50.2
        netmask 255.255.255.0
 ``` 
  
  Em /etc/hosts de cada servidor relacione os nomes e ips de cada servidor, deixe cadastrado assim:

 ```bash /etc/hosts
    192.168.50.2 cph_01
    192.168.50.3 cph_02
    192.168.50.4 cph_03
    192.168.50.5 cph_04
    192.168.50.6 cph_05
 ```
