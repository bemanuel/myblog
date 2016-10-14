+++
Categories = [
	"Sysadmin", 
	"CEPH",
	"Storage",
        "Cluster"
]
description = "Alta disponibilidade e Hiperconvergência"
tags = ["ceph", "storage","hiperconvergência","ha", "cluster", "lb", "loadbalance","raid"]
date = "2016-10-10"
publishdate = "2016-10-16"
menu = "ceph"
title = "CEPH - Componentes"
featured = "ceph.svg"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

### Ibagens eu quero ibagens

  Mas como é realmente o funcionamento do CEPH ? Como ele faz isso ?
 
  Então para facilitar o entendimento temos de conhecer os componentes básicos do CEPH:

Ferramenta | Função
----------- | ----------------------------------------------------------------------------------------------------
Ceph OSD   | Daemon responsável por armazenar os dados, replicá-los, fazer o balanceamento e se comunicar com os monitors deixando-os atualizados quanto ao mapeamento dos dados.
Monitors   | Verifica o funcionamento do Cluster CEPH, o mapeamento dos monitores e dos OSD, os mapas dos PG e o CRUSH. Guarda ainda as alterações ocorridas nos Monitors,OSDs e PGs.
MDS | Metadata Server, armazena os metadados para dar apoio ao Ceph Filesystem ( o Ceph Block Devices e Ceph Object Storage não usam MDS ). Ele serve apenas para auxiliar o CEPH FS, tornando possível que usuários de sistemas executem comandos triviais como ls, find, etc...
CRUSH | É o algoritmo responsável por determinar como armazenar e coletar os dados. Ele permite que os clientes CEPH se comuniquem diretamente com os OSD invés de precisar de um servidor ou controlador para intermediar a comunicação.
PG | Placement Group - agrega os objetos dentro de um pool, já que rastrear objetos e seus metadados em um sistema de armazenamento de objetos pode gerar um custo computacional considerável. 
RADOS |
Librados |
Rados GW |
