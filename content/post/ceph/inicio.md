+++
Categories = [
	"Sysadmin", 
	"CEPH",
	"Storage",
        "Cluster"
]
description = "Alta disponibilidade e Hiperconvergência"
tags = ["ceph", "storage","hiperconvergência","ha", "cluster", "lb", "loadbalance","raid"]
date = "2016-09-10"
publishdate = "2016-09-14"
menu = "main"
title = "CEPH - O que é?"
featured = "ceph.svg"
featuredalt = ""
featuredpath = "date"
type = "post"
+++


## Série de Posts?

 Este será o primeiro de uma série de posts sobre o CEPH, me ajudará mais como plano de estudo, orientando o conhecimento sobre a tecnologia.

 A ideia é explicar o objetivo do mesmo e formas de implementação.

 Em tempo, existem outras propostas além do CEPH para a parte de distribuição de arquivos, porém a ideia ainda não é fazer comparativos até para não perdermos o foco. A proposta dessa série é elucidar como ele funciona e seus complementos, afinal não adianta tentarmos fazer comparações antes de conhecer como realmente ele funciona. 

 Não sou um grande especialista mas sim um estudioso da área, caso encontrem alguma falha favor comentar que isso contribuirá para todos e assim aplicarei as correções.
 
### O que é Hiperconvergência ?

Antes de qualquer coisa o que me fez chegar ao CEPH foi a Hiperconvergência. Comecei a estudar sobre isso pois o que sempre me incomodou em sistemas virtuais foi a falta de continuidade dos serviços, seja pela interdependência dos processos, seja pela falta de espaço no node A que te obriga a mover a VM para um node B com mais espaço ( ou isso é feito de modo automático ) ou pelo simples fato de que o serviço caiu mas aparentemente estava tudo bem pois o servidor estava no ar.

Tenho estudado muitas coisas recentemente: Docker, CEPH, NxFilter, LXC, Cloud Computing, cultura DevOps ( coisa que já aplicava a muito tempo e não sabia que esse era o nome ), Git, Puppet e assim vai.

E veio a Hiperconvergência, para quem - assim como eu - tinha dúvidas sobre o que seria isso, entenda que a hiperconvergência veio com a ideia de atender a um mercado em constante mudança e crescimento.

Antes de entender o problema que a Hiperconvergência tende a resolver vamos analisar o cenário da maioria das instituições.

Antes na infraestrutura de TI, se fazia toda uma análise de requisitos - antes até da virtualização - de modo a se montar ou definir todo um equipamento/hardware cuja combinação de recursos ( memória, processador, placas de redes, discos ) e softwares para se montar um datacenter e atender a uma determinada necessidade. Se fossem exigidos mais recursos, uma nova máquina/configuração deveria ser definida e todo um projeto de migração/atualização do sistema deveria ser planejado. Não vamos nem falar nos procedimentos para paralização e retorno do sistema.

Isso gerava uma mistura incrível de especificações distintas de hardware para atender demandas diversas, sem falar no custo para manter toda essa heterogeneidade no parque do Datacenter.

Na Infra Convergente, com as vantagens que foram disponibilizadas pela virtualização foi criada a possibilidade de se ter todo um pacote de soluções, onde switchs, servidores, storages e roteadores eram customizados/customizáveis de modo a atender as necessidades do Datacenter sem grande impacto na construção desses Datacenter.

Mas na Infra Convergente ainda há problemas pois custos como a manutenibilidade e atualização dos equipamentos utilizados tem sua perda financeira. Para complementar essa estrutura ainda pode ser mais complicado pois é interessante adquirir novos dispositivos que trabalhem/integrem com os já existentes. Tal processo pode ser complicado chegando ao ponto em que alguns casos é mais interessante tecnológica e financeiramente trocar todo o equipamento ao invés de mantê-lo.

Já a ideia da hiperconvergência é de que todos os pacotes são integrados e complementares, ou seja, ao adquirir um novo servidor ou rack mesmo que com especificações diferentes todo o seu datacenter é beneficiado, aumentando capacidade de processamento e armazenamento em toda a estrutura sem necessidade de migração de serviços.

Deste modo a Infra Hiperconvergente proporciona redução nos custos e mesmo ainda sim atingindo níveis superiores de disponibilização de serviços e armazenamento somado a alta performance.

## CEPH

Neste primeiro post tentarei não entrar tanto em partes técnicas.

O CEPH permite criar um ambiente com espaço de armazenamento escalável, com replicação e tolerância a falhas.

### Senta que lá vem história - referência [Learning CEPH]( http://www.livrariacultura.com.br/p/learning-ceph-86944824 )

 O CEPH foi um projeto que teve seu desenvolvimento feito por Sage Weil como parte do seu PhD, o projeto inicial foi o sistema de arquivos CEPH, o qual se tornou Open Source em 2006 sob a licença LGPL. Entre 2003 e 2007, foi o período de pesquisas para o CEPH e também de crescimento dos seus componentes contanto com a contribuição da comunidade.

 Em 2007 o projeto já tinha uma certa maturidade e estava pronto para ser incubado. A DreamHost foi a incubadora do projeto entre 2007 e 2011. Neste período o CEPH foi tomando forma, seus componentes se tornaram mais estáveis e seguros, novas funcionalidades foram contempladas e novos objetivos foram traçados. A partir deste momento o CEPH já tinha opções para empresas. Nesse interim muitos desenvolvedores começaram a contribuir para o projeto, dentre eles Gregory Farnum, Josh Durgin, Samuel Just, Wido den Hollander, Yehuda Sade e Loïc Dachary. 

 Em 2012 a empresa Inktank foi fundada pela DreamHost, visando de difundir os serviços e suporte para o Ceph.Seu principal objetivo era prover conhecimento, ferramentas e suporte para clientes empresariais, facilitando assim a adoção e gestão de sistemas usando o Ceph storage. Sage foi o fundador e CTO da Inktank. Em 2013, a empresa recebeu um investimos de US$ 13,5 milhões. Em 2014 a Red Hat adquiriu a Inktank por US$ 175 milhões. 

 Alguns dos clientes da Inktank são: Cisco, CERN e a empresa de telecomunicações alemã Deutsch Telekom. Entre seus parceiros estão: Dell e Alcatel-Lucent. Que com a aquisição pela Red Hat, se tornaram clientes da mesma.

 Ceph foi lançado na versão 0.2 e após isso os estágios de desenvolvimento evoluíram rapidamente, de modo que o tempo entre as novas versões se tornaram mais curtos. Em Julho de 2012 foi anunciada versão estável com o codinome Argonault ( v.0.48 [ LTS ]  ). Para saber sobre novas versões e notas sobre essas acesse http://ceph.com/category/releases/ .

### Importância no mercado

  Nos últimos anos o mercado empresarial tem exigido cada vez mais performance, escalabilidade e estabilidade da área de Storages. E segundo dados a necessidade de área para armazenamento vem crescendo numa progressão geométrica, segundo a IBM - ( [matéria] (https://www.ibm.com/blogs/research/2016/02/exabytes-elephants-objects-and-spark/) ) - já não se fala mais em Terabytes como a pouco tempo atrás, agora se fala em Petabytes e Exabytes.E que tudo deverá convergir para a nuvem.

  Isso faz com que haja uma demanda para áreas de armazenamento e publição de sistemas que seja unificada, distribuída, confiável e com alta performance. Ainda - não menos importante - com fácil escalabilidade. Afinal a produção de informação não vai parar para esperar o aumento da área.

  O Ceph visa preencher exatamente essa lacuna, atende todos os requisitos. Atende as necessidades atuais/futuras e já está incorporado ao Kernel Linux.


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
