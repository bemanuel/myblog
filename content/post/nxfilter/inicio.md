+++
Categories = [
	"Sysadmin", 
	"NxFilter",
	"DNS"
]
description = "Sobre o que é a ferramenta e como instalar"
tags = ["nxfilter", "dns","filtro","instalando","raspbian", "debian", "pfsense" ]
date = "2016-04-12"
publishdate = "2016-04-13"
menu = "main"
title = "NXFilter - O Filtro DNS"
featured = "nxfilter01.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

#### Apresentação

O NXFilter é uma ferramenta que começou com a ideia de atuar como filtro DNS e agora provê também a possibilidade de filtro de conteúdo web.

Dentre as vantagens disponibilizadas se tem:

 1. É uma ferramenta leve e de fácil instalação
 2. Controle por autenticação usando: LDAP, AD, Single-sign-on ( SSO ), etc... 
 3. Pode substituir inclusive o seu proxy-cache como o Squid
 4. Usando outros componentes permite inclusive o bloqueio de ferramentas como UltraSurf e Tor
 5. Reconhecimento dinâmico de sites, não depende apenas de listas, encontra o padrão e a classifica

#### Funcionamento
Seu principio é atuar como servidor DNS, pode fazer:

 1. Redirect
 2. Transferência de Zona
 3. Domínio Dinâmico
 4. E inclusive como o próprio servidor DNS, permitindo registros A, AAAA, SOA e etc...


#### Instalando
A instalação do NxFilter é bem simplificada, o site disponibiliza pacotes deb,zip e outros formatos depreciados como exe.

Como pré-requisito só é necessário ter o java instalado na máquina, funciona tanto com OpenJDK quanto com o Oracle Java.
##### Debian

##### Raspbian

##### PFSense

##### Docker
