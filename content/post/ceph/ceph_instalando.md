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
    apt-get update && apt-get -y install ntp openssh-server sudo 
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

3. Criando usuário CEPH e gerando chave SSH sem senha

    Será criado um usuário para fazer o deploy do CEPH. Aqui definirei a senha do mesmo como 'ceph1234'

  ```bash
    adduser uceph
    echo "uceph ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/uceph
  ```
4. Gerando chave RSA para uso no SSH e permitir a comunicação entre os servidores sem senha
 
    Considerando que está no servidor cph_01, ao executar o procedimento não defina nenhuma senha.

  ```bash
    sudo su - uceph
    ssh-keygen
    ssh-copyid uceph@cph_01
    ssh-copyid uceph@cph_02
    ssh-copyid uceph@cph_03
  ``` 

   Vamos fazer o processo em apenas 3 nós, ao menos nesse instante.

## Instalando o CEPH 


1. Instalando o CEPH-DEPLOY

   Ferramenta para auxilio na criação do cluster Ceph, facilita todo o processo.

  ```bash
    sudo su -
    apt-get install ceph-deploy
    mkdir /etc/ceph && cd /etc/ceph
    ceph-deploy --username uceph new cph_01
  ```

    Em cada nó instale o ceph-deploy, apenas para garantir os pacotes pré-instalados

  ```bash
    sudo su -
    apt-get install ceph-deploy
  ```  
   
    Esse processo irá criar os arquivos de configuração e as chaves. Listando o contéudo 'ls /etc/ceph', verá que existens arquivos na pasta.


2. Instalando o CEPH e configurando todos os nós com apenas 1 comando

   Tendo o ceph-deploy instalado e sua configuração inicial só é necessário 1 comando para levantar o cluster, esse é um processo que levará tempo pois fará o download de pacotes.

   ```bash
    sudo su - uceph
    ceph-deploy install --release hammer cph_01 cph_02 cph_03
   ```
   
   Esse processo fará com que o servidor se conecte a cada nó ( e para isso que configuramos o `/etc/hosts` ) e execute o processo de instalação.

