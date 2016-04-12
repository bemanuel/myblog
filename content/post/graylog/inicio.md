+++
Categories = [
	"Sysadmin", 
	"Graylog"
]
description = "Instalando Graylog - Centralizador de logs"
tags = ["graylog2", "graylog","centralizador","logs","instalando"]
date = "2016-04-03"
publishDate = "2016-04-12"
menu = "main"
title = "graylog - centralizador de logs"
featured = "graylog01.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

## Centralizador de Logs, para quê?

Imagine manter uma estrutra onde há serviços NGinx, Tomcat, DCHP, DNS, AD, PostgreSQL, MySQL, contêineres Docker e diversos outros serviços na sua rede.

De repente você recebe uma ocorrência de que seu site principal sofreu a 3 dias atrás uma tentativa de invasão e tudo o que você tem é uma url que foi criada no seu servidor de páginas web.

Como identificar e traçar todo o caminho utilizado por esse invasor?

Os passos iniciais seriam recuperar os logs do seu serviço de páginas, depois os logs do servidor onde ele está contido (que envolve no minimo logs gerais e logs de autenticação). Para desse modo encontrar o inicio da ocorrência e os ips envolvidos nesse processo, pedindo inclusive que esses logs não tenham sido removidos na invasão. Isso tudo filtrando mais de 15 dias, afinal a invasão foi a 3 dias mas a quanto tempo esse processo não ocorre?

- E se de lá ele entrou em outros servidores? 
- E se ele fez alguma alteração no seu servidor DNS ou implantou algum trojan?

 Mais e mais logs terão de ser analisados em servidores distintos.

 Agora em um ambiente com logs centralizados toda a sua consulta é feita num local só, você procura pela url e obtendo o ip em segundos descobre por onde mais esse invasor pode ter andado na sua rede, descobrindo inclusive que usuários ele pode ter tentado usar ( afinal seu log de autenticação também está centralizado ).
 Esse é um dos poucos exemplos da vantagem de se ter uma ferramenta dessas na sua rede.


## Pesquisando
Na busca de um centralizador de logs encontrei o *GrayLog2* e o que mais achei interessante na ferramenta foi o fato de ser um pacote completo e todo acessível via browser. Exceto claro no que seria necessário para criar cluster e balanceamento de carga.

Então seguindo a ideia de manter todos os logs em só lugar, ele permite centralizar e agregar todos os logs. Gerar gráficos e consultas baseadas nos dados coletados.

## Graylog - instalando
No site do próprio Graylog ele disponibiliza várias formas:
- Appliance com VM
- Usando o script graylog-ctl
- Pacotes para SOs/Distros
- Usando Chef, Puppet, Ansible ou Vagrant
- Docker
- Openstack
- AWS
- Configuração manual

Tem pra todos os gostos, mas aqui irei citar apenas os que executei


O graylog é dividido em 2 módulos principais:
- Graylog-Server
  Que tem a parte de recebimento dos logs, as bases de dados, todo o core principal
- Gralog-Web
  Como o próprio nome diz, tem a interface Web para administração dos Nós

Desse modo fica possível separar ou dividir a carga entre os servidores, pode não parecer mas o processo de tratar e arquivar os logs consome bastante recurso.

Pré-requisito ter o Java 8 instalado. 
	http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
	https://www.vivaolinux.com.br/dica/Atualizando-o-Java-Runtime-Environment-JRE-da-Oracle-no-Ubuntu/

** Atualmente a versão que está disponivel é a 1.3 porém a 2.0 já está em versão Alpha. 

** Na versão 2.0 não terá mais essa divisão, onde ficará tudo com um módulo só


### Ubuntu 14.04
```

# Prepara para instalar o elasticsearch
$ sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
$ echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" \ 
 | sudo tee -a /etc/apt/sources.list.d/elasticsearch.list

# Ajusta para instalacao do MongoDB
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
$ echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" \
 | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

$ wget https://packages.graylog2.org/repo/packages/graylog-1.3-repository-ubuntu14.04_latest.deb
$ sudo dpkg -i graylog-1.3-repository-ubuntu14.04_latest.deb

$ sudo apt-get update
$ sudo apt-get install apt-transport-https graylog-server \ 
 graylog-web pwgen elasticsearch mongodb-org

```

### Debian 7
```

# Prepara para instalar o elasticsearch
$ sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
$ echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" \ 
 | sudo tee -a /etc/apt/sources.list.d/elasticsearch.list

# Ajusta para instalacao do MongoDB
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
$ echo "deb http://repo.mongodb.org/apt/debian "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" \ 
 | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

$ wget https://packages.graylog2.org/repo/packages/graylog-1.3-repository-debian7_latest.deb
$ sudo dpkg -i graylog-1.3-repository-debian7_latest.deb
$ sudo apt-get update
$ sudo apt-get install apt-transport-https graylog-server \ 
 graylog-web pwgen elasticsearch mongodb-org

```

### Docker
```
$ docker pull graylog2/allinone
$ docker run -t -p 9000:9000 -p 12201:12201 -p 12201:12201/udp -p 514:514 -p 514:514/udp \ 
 -e GRAYLOG_TIMEZONE=America/Fortaleza graylog2/allinone
```

Exceto pelo docker que já vem com uma imagem pré-configurada, no Ubuntu/Debian ainda é necessário setar alguns parâmetros:

# Configurando o ElasticSearch
```
$ sudo vi /etc/elasticsearch/elasticsearch.yml
#Alterar os parametros, deixando do seguinte modo
cluster.name: graylog2
network.bind_host: 127.0.0.1
#Esse último tem de ser incluso
script.disable_dynamic: true
```

# Configurando o GrayLog Server

Em /etc/graylog/server/server.conf, será necessário setar as senhas, para isso execute:
```
#Resultado para parâmetro 'password_secret'
$ pwgen -N 1 -s 96

#Resultado para parâmetro 'root_password_sha2' senha sha, essa senha 
#  será utilizada para o login na interface web, será a senha do usuário admin
$ echo -n <sua_senha> | shasum -a 256

$ sudo vi /etc/graylog/server/server.conf
```
Os parâmetros ficarão:
```
password_secret = <valor do resultado de pwgen, executado acima >
root_password_sha2 = < valor do resultado de shasum, executado também logo acima >
root_timezone = America/Fortaleza #Minha região
rest_listen_uri = http://127.0.0.1:12900/
rest_transport_uri = http://127.0.0.1:12900/
elasticsearch_shards = 1 #Pois só levantamos uma instância
elasticsearch_cluster_name = graylog2 #Mesmo nome setado em cluster.name
elasticsearch_http_enabled = false #Desativar o servidor HTTP
# Para usar unicast ao invés de multicast
elasticsearch_discovery_zen_ping_multicast_enabled = false
elasticsearch_discovery_zen_ping_unicast_hosts= 127.0.0.1:9300

# Configurando o GrayLog Web
```
$ sudo vi /etc/graylog/web/web.conf
# Parâmetros
```
graylog2-server.uris="http://127.0.0.1:12900/"
application.secret="< mesmo valor de password_secret setado em server.conf >"
timezone="America/Fortaleza"
```
Salvar o arquivo

# Iniciando os serviços
## ElasticSearch

```
$ sudo service elasticsearch start
```
Para testar execute o comando após 1 minuto para ter certeza que a instância subiu 
```
$ curl -XGET 'http://localhost:9200/_cluster/health?pretty=true'
#Retornará algo como, repare no status:green confirmando funcionamento
{
  "cluster_name" : "graylog2",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0
}
```

## GrayLog Server e Web
```
$ sudo service graylog-server start
$ sudo service graylog-web start
```
Acesse o endereço http://ip-do-servidor:9000/
{{< figure src="/img/2016/04/capt01.png" title="System > Overview" >}}

