+++
Categories = [
	"Sysadmin", 
	"Graylog"
]
description = "Instalando Graylog v2.0 GA - Centralizador de logs"
tags = ["graylog2", "graylog","centralizador","logs","instalando","ubuntu", "v2.0 GA"]
date = "2016-04-28"
publishDate = "2016-04-28"
menu = "main"
title = "graylog 2.0 GA - centralizador de logs"
featured = "graylog01.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

### Nova versão do Graylog - v2.0 GA

Em 27/04/2016 foi lançada a versão estável do Graylog a v 2.0 GA. Dentre todas as mudanças três me chamaram bastante a atenção:

1. Compatibilidade com ElasticSearch 2.0, que dizem estar bem mais rápido
2. Widget de GeoMap - Possibilidade de uso de mapas no Dashboard e plugin de identificação dos ips
3. A interface Web não é mais um processo a parte, é tudo um conjunto só - a meu ver ficou melhor, assim tem menos configuração


## Instalando

 Pré-requisito ter o Java 8 instalado. 
	http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
	https://www.vivaolinux.com.br/dica/Atualizando-o-Java-Runtime-Environment-JRE-da-Oracle-no-Ubuntu/

### Ubuntu 14.04/16.04
```
#Java
$ echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
$ echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
$ apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
$ apt-get update
$ apt-get install oracle-java8-installer

#ElasticSearch    
$ sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
$ sudo echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" \
 | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
    
#MongoDB
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
$ sudo echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" \
 | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

#Graylog
$ wget https://packages.graylog2.org/repo/packages/graylog-2.0-repository_latest.deb
$ sudo dpkg -i graylog-2.0-repository_latest.deb

#Procedendo com a instalação    
$ sudo apt-get update
$ sudo apt-get install apt-transport-https graylog-server pwgen elasticsearch mongodb-org

```

### Configurar o ElasticSearch
O arquivo de configuração ficará com os parâmetros abaixo:

```
$ sudo vi /etc/elasticsearch/elasticsearch.yml
#Alterar os parametros, deixando do seguinte modo
cluster.name: graylog2
network.host: 127.0.0.1
#Esse último tem de ser incluso
# script.disable_dynamic: true - O suporte a esse parâmetro foi removido na versão 2
script.inline: on
script.indexed: on
```

### Configurando o Graylog Server

Em /etc/graylog/server/server.conf, será necessário setar as senhas, para isso execute:

```
#Resultado para parâmetro 'password_secret'
$ pwgen -N 1 -s 96

#Resultado para parâmetro 'root_password_sha2' senha sha, essa senha 
#  será utilizada para o login na interface web, será a senha do usuário admin
$ echo -n <sua_senha> | shasum -a 256
$ sudo vi /etc/graylog/server/server.conf
```

Os parâmetros ficarão com os seguintes valores:

```
password_secret = <valor do resultado de pwgen, executado acima >
root_password_sha2 = < valor do resultado de shasum, executado também logo acima >
root_timezone = America/Fortaleza #Minha região
rest_listen_uri = http://0.0.0.0:12900/
rest_transport_uri = http://<ip_host>:12900/
elasticsearch_shards = 1 #Pois só levantamos uma instância
elasticsearch_cluster_name = graylog2 #Mesmo nome setado em cluster.name
elasticsearch_http_enabled = false #Desativar o servidor HTTP
# Para usar unicast ao invés de multicast
elasticsearch_discovery_zen_ping_multicast_enabled = false
elasticsearch_discovery_zen_ping_unicast_hosts= 127.0.0.1:9300
```

### Configurando para inicializar

Para iniciar automaticamente execute os passos:

```
#ElasticSearch - Ubuntu 14.04
$ sudo update-rc.d elasticsearch defaults 95 10
$ sudo /etc/init.d/elasticsearch start

#ElasticSearch - Ubuntu com SystemD
$ sudo /bin/systemctl daemon-reload
$ sudo /bin/systemctl enable elasticsearch.service
$ sudo /bin/systemctl start elasticsearch


#Graylog
$ sudo rm -f /etc/init/graylog-server.override
$ sudo start graylog-server
```

### Bônus ativando o GeoMap

```
#Baixar base de dados da MaxMind
$ cd /tmp
$ wget -t0 -c http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
$ gunzip GeoLite2-City.mmdb.gz
$ chown graylog. GeoLite2-City.mmdb
``` 

Na interface do Graylog vá em  System > Config

Na área Plugins, clique em Update e marque a opção (Enable Geo-Location processor)
  
Mais acima, clique em "Message Processors Configuration" altere a ordem de GeoIP Resolver para ser o último 'message processor'. Clique em 'Save'

Pronto, a configuração estando correta os inputs em que houver a ocorrência de ips terão um campo adicional com o nome incluindo _geolocation, por exemplo: o input com o campo "dst_ip" terá mais um campo o  "dst_ip_geolocation". 

Para visualizar o mapa, vá na área de pesquisa 'Search', clique no campo com terminação '_geolocation' e clique no link 'World Map'.
{{< figure src="/img/2016/04/geomap01.png" title="GeoMap IP" >}}
