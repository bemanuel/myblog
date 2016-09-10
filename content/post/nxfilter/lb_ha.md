+++
Categories = [
	"Sysadmin", 
	"NxFilter",
	"DNS",
        "Cluster"
]
description = "Alta disponibilidade e Load Balance com NxFilter"
tags = ["nxfilter", "dns","filtro","avançado","ha", "cluster", "lb", "loadbalance"]
date = "2016-09-11"
publishdate = "2016-09-11"
menu = "main"
title = "NXFilter - Alta Disponibilidade + Load Balance"
featured = "lb_plus_ha_nxf.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++


#### Projeto - Implementar o Cluster NxFilter
 
A ideia de se implementar o Cluster é, principalmente, aumentar a disponibilidade e qualidade dos serviços de dns na rede interna/externa, afinal o NxFilter é na sua essência um servidor DNS.

Então vamos primeiro entender como funciona um servidor DNS e como ele poderia ser usado com HA e/ou Load Balance.

#### Servidor DNS
