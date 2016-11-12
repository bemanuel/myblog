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

 O Cluster CEPH precisa de no mínimo 3 nós, por isso o ambiente de instalação seguirá essa premissa. O ambiente em que fiz o procedimento de instalação foi o Debian, porém o que muda para o RedHat é apenas a parte de instalação de pacotes, os comandos são iguais.


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
    apt-get install ntp openssh-server 
 ```
