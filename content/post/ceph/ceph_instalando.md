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
node1 | 172.16.0.2 | 192.168.0.2
node2 | 172.16.0.3 | 192.168.0.3
node3 | 172.16.0.4 | 192.168.0.4
node4 | 172.16.0.5 | 192.168.0.5
node5 | 172.16.0.6 | 192.168.0.6

 O Hardware de cada máquinas

#. Memória = 1GB
#. 1o. HD com 8GB ( para o SO )
#. 2o. HD com 32GB ( para o CEPH )

## Pré-requisito

 Antes de criar o Cluster CEPH é preciso preparar o ambiente onde ele será publicado. Como pré-requisito deve se ter:

Recurso | Descrição 
:--------- | ---------- 
 NTP | Protocolo para sincronia de horário
 SSH | Secure Shell - Protocolo para comunicação de rede de forma segura
 Conexao SSH sem Senha | É preciso permitir a conexão entre os servidores sem senha
 Rede dedicada | Rede dedicada para o cluster CEPH, Rede 1G atende mas 10G é desejável
 Firewall liberado | Porta 6789 protocolo tcp liberados para comunicação

### Instalando pré-requisitos

1. NTP e SSH
  
 O Serviço NTP é responsável por manter o horário dos servidores sincronizados. Como estamos falando de um cluster que mantém dados replicados e sincronizados isso é muito importante. 

 Para instalar o serviço NTP, execute:

 ```bash
    apt-get update && apt-get -y install ntp openssh-server 
    dpkg-reconfigure tzdata
 ```
