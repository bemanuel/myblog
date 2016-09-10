+++
Categories = [
	"Sysadmin", 
	"CEPH",
	"Storage",
        "Cluster"
]
description = "Alta disponibilidade e Hiperconvergência"
tags = ["ceph", "storage","hiperconvergência","ha", "cluster", "lb", "loadbalance","raid"]
date = "2016-09-12"
publishdate = "2016-09-12"
menu = "main"
title = "CEPH - O que é?"
featured = "ceph.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++


#### Série de Posts?

Este será o primeiro de uma série de posts sobre o CEPH, me ajudará mais como plano de estudo, orientando o conhecimento sobre a tecnologia.

A ideia é explicar o objetivo do mesmo e formas de implementação.

Não sou um grande especialista mas sim um estudioso da área, caso encontrem alguma falha favor comentar que isso contribuirá para todos e assim aplicarei as correções.
 
#### Hiperconvergência

Antes de qualquer coisa o que me fez chegar ao CEPH foi a Hiperconvergência. Comecei a estudar sobre isso pois o que sempre me incomodou em sistemas virtuais foi a falta de continuidade dos serviços, seja pela interdependência dos processos, seja pela falta de espaço no node A obrigando a mover a VM para um node B com mais espaço ou pelo simples fato de que o serviço caiu mas aparentemente estava tudo bem pois o servidor estava no ar.

Tenho estudado muitas coisas recentemente: Docker, CEPH, NxFilter, LXC, Cloud Computing, cultura DevOps ( coisa que já aplicava a muito tempo e não sabia que esse era o nome ), Git, Puppet e assim vai.

E veio a Hiperconvergência, para quem - assim como eu - tinha dúvidas sobre o que seria isso, entenda que a hiperconvergência veio com a ideia de atender a um mercado em constante mudança e crescimento.

Antes de entender o problema que a Hiperconvergência tende a resolver vamos analisar o cenário da maioria das instituições.

Antes na infraestrutura de TI, se fazia toda uma análise de requisitos - antes até da virtualização - de modo a se montar ou definir todo um equipamento/hardware cuja combinação de recursos ( memória, processador, placas de redes, discos ) e softwares para se montar um datacenter e atender a uma determinada necessidade. Se fossem exigidos mais recursos, uma nova máquina/configuração deveria ser definida e todo um projeto de migração/atualização do sistema deveria ser planejado. Não vamos nem falar nos procedimentos para paralização e retorno do sistema.

Isso gerava uma mistura incrível de especificações distintas de hardware para atender demandas diversas, sem falar no custo para manter toda essa heterogeneidade no parque do Datacenter.

Na Infra Convergente, com as vantagens que foram disponibilizadas pela virtualização foi criada a possibilidade de se ter todo um pacote de soluções, onde switchs, servidores, storages e roteadores eram customizados/customizáveis de modo a atender as necessidades do Datacenter sem grande impacto na construção desses Datacenter.

Mas na Infra Convergente ainda há problemas pois custos como a manutenibilidade e atualização dos equipamentos utilizados tem sua perda financeira. Para complementar essa estrutura ainda pode ser mais complicado pois é interessante adquirir novos dispositivos que trabalhem/integrem com os já existentes e se integrem com os mesmos. Tal processo pode ser complicado chegando ao ponto em que alguns casos é mais interessante tecna e financeiramente trocar todo o equipamento ao invés de mantê-lo.

Já a ideia da hipverconvergência é de que todos os pacotes são integráveis e complementares, ou seja, ao adquirir um novo servidor ou rack todo o seu datacenter é beneficiado, aumentando capacidade de processamento e armazenamento em toda a estrutura sem necessidade de migração de serviços.

Deste modo a Infra Hiperconvergente causa redução nos custos e mesmo ainda sim atingindo níveis superiores de disponibilização de serviços e armazenamento somado a alta performance.


