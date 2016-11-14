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
publishdate = "2016-11-15"
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
cph-01 | 172.16.0.2 | 192.168.50.2
cph-02 | 172.16.0.3 | 192.168.50.3
cph-03 | 172.16.0.4 | 192.168.50.4
cph-04 | 172.16.0.5 | 192.168.50.5
cph-05 | 172.16.0.6 | 192.168.50.6

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

 Para instalar o serviço NTP,SSH e algun requisitos, execute:

 ```bash
    apt-get update && apt-get -y install ntp openssh-server sudo python-setuptools vim apt-transport-https libgoogle-perftools4
    dpkg-reconfigure tzdata
 ```
   Na configuração do Timezone defina o seu local

- Caso não consiga instalar o pacote 'apt-transport-https' adicione o CD-ROM do Debian ao apt pois nele contém.

- Se o pacote `libgoogle-perftools4` não for encontrado adicione o repositório ao sources.list do Debian: `deb http://ftp.br.debian.org/debian jessie main`

2. Definindo configurações de rede

 Em `/etc/network/interfaces` são definidos os ips de cada máquina de acordo com a tabela especificada. Por exemplo, no servidor 01 ( node01 ) ficará assim:

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
    192.168.50.2 node01
    192.168.50.3 node02
    192.168.50.4 node03
    192.168.50.5 node04
    192.168.50.6 node05
 ```

3. Criando usuário CEPH e gerando chave SSH sem senha

    Será criado um usuário para fazer o deploy do CEPH. Neste mesmo momento é definida a senha do mesmo como 'ceph1234'

    Deve ser feito em todos os nós.

  ```bash
    adduser uceph
    echo "uceph ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/uceph
  ```
4. Gerando chave RSA para uso no SSH e permitir a comunicação entre os servidores sem senha
 
    Considerando que está no servidor node01, ao executar o procedimento não defina nenhuma senha.

  ```bash
    sudo su - uceph
    ssh-keygen -t rsa
    ssh-copy-id node01
    ssh-copy-id node02
    ssh-copy-id node03
  ``` 

   Vamos fazer o processo para apenas 3 nós, ao menos nesse instante.

## Instalando o CEPH 


1. Instalando o CEPH-DEPLOY

   Ferramenta para auxilio na criação do cluster Ceph, facilita todo o processo.

  ```bash
    sudo su -
    wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add -
    echo deb http://download.ceph.com/debian-jewel/ $(lsb_release -sc) main | tee /etc/apt/sources.list.d/ceph.list
    apt-get update
    apt-get install ceph-deploy
    mkdir /etc/ceph && cd /etc/ceph && chown -R uceph. /etc/ceph 
    su - uceph
    cd /etc/ceph
    ceph-deploy new --cluster-network 192.168.50.0/24 node01 node02 node03
  ```
    Esse processo irá criar os arquivos de configuração e as chaves. Listando o contéudo 'ls /etc/ceph', verá que existem arquivos na pasta.


2. Instalando o CEPH e configurando todos os nós com apenas 1 comando

   Tendo o ceph-deploy instalado e sua configuração inicial só é necessário 1 comando para levantar o cluster, esse é um processo que levará tempo pois fará o download de pacotes.

   ```bash
    sudo su - uceph
    ceph-deploy --username uceph install --release jewel node01 node02 node03
   ```
   Esse processo fará com que o servidor se conecte a cada nó ( e para isso que configuramos o `/etc/hosts` ) e execute o processo de instalação.

   Ao concluir o processo com sucesso aparecerá uma tela com a abaixo.

## Criando o monitor

   Para confirmar que o serviço foi instalado com sucesso execute 'ceph -v'. Deverá retornar a versão do CEPH.

   Agora vamos criar o `monitor`. A função do monitor é ....

   ```bash
   ceph-deploy --username=uceph mon create-initial
   ```
   
   Todo o processo do monitor tendo sido feito com sucesso ao executar o comando `ceph status` deverá ter algo como a imagem abaixo, apesar do erro aparente tem de se levar em conta que ainda não foram criados  os ''OSD''!???? 

   -- figura

   Agora para listar os discos existentes no nó, usamos o comando `ceph-deploy disk list node01`.

   Reparando na figura acima vemos que temos os discos `sdb`, `sdc`, `sdd`, `sde` disponíveis.

   Agora para confirmar vamos listar os discos existentes na máquina, ele listará tanto partições quanto discos disponíveis para criação do OSD.


## Anexando Discos ao Cluster CEPH - OSD

   OSD é ....

   O comando 'ceph-deploy disk' serve para gerenciar os discos. O atributo 'zap' destroy possíveis partiçoes e conteúdo do disco selecionado. Para evitar perda de dados tenha certeza de estar indicando o disco certo.

   Iremos executar o comando para preparar os discos `sdb`, `sdc`, `sdd` e `sde`, que visualizamos com o comando ``ceph-deploy disk list``, então deverá executar o comando de criação do OSD, por padrão ele gera partições XFS. 

  ```bash
   ceph-deploy --username uceph disk zap node01:sdb node01:sdc node01:sdd node01:sde
   ceph-deploy --username uceph osd create node01:sdb node01:sdc node01:sdd node01:sde
  ```

  No comando `ceph-deploy --username uceph osd create` não foi especificada a área de journal, então ele criará duas partições em cada disco, uma para os dados e outra para o journal.
   
  Executando novamente o comando `ceph status` o CEPH ainda não estará 'saudável' porém já devem aparecer os 4 OSDs.
 
## Adicionando novos monitores ao cluster

  Essa parte é muito importante pois o cluster CEPH exige um mínimo de 3 monitores para levantar o cluster, levando em conta que todas as partes de firewall ( como liberação da porta 6789 ) já foram feitas, vamos aos passos.

  Esse processo pode ser feito a partir do `node01`, já que foi feita toda a parte de intregração com os outros nós ( ssh, keygen, etc... ). Mas antes vamos garantir que realmente está ok.

  ```bash
  sudo su - uceph
  ssh uceph@node02 -C true
  ssh uceph@node03 -C true
  ```
  
  Deverá receber retornos como na imagem abaixo.

  --figura



  ```bash
  su - uceph
  ceph-deploy --username mon create node02
  ceph-deploy --username mon create node03

  ```
