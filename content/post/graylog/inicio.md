+++
Categories = [
	"Sysadmin", 
	"Graylog"
]
description = "Usando Graylog como centralizador de logs"
tags = ["graylog2", "graylog","centralizador","logs"]
date = "2016-04-03"
publishDate = "2016-04-05"
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

** Atualmente a versão que está disponivel é a 1.3 porém a 2.0 já está em versão Alpha. 

** Na versão 2.0 não terá mais essa divisão, onde ficará tudo com um módulo só

### Ubuntu 14.04
```
$ wget https://packages.graylog2.org/repo/packages/graylog-1.3-repository-ubuntu14.04_latest.deb
$ sudo dpkg -i graylog-1.3-repository-ubuntu14.04_latest.deb
$ sudo apt-get update
$ sudo apt-get install apt-transport-https graylog-server graylog-web
```

### Debian 7
```
$ wget https://packages.graylog2.org/repo/packages/graylog-1.3-repository-debian7_latest.deb
$ sudo dpkg -i graylog-1.3-repository-debian7_latest.deb
$ sudo apt-get update
$ sudo apt-get install apt-transport-https graylog-server graylog-web
```

### Docker
```
$ docker pull graylog2/allinone
$ docker run -t -p 9000:9000 -p 12201:12201 -p 12201:12201/udp -p 514:514 -p 514:514/udp \ 
 -e GRAYLOG_TIMEZONE=America/Fortaleza graylog2/allinone
```


```
## this is a comment
$ echo this is a command
this is a command

## edit the file
$ vi foo.md
+++
date = "2014-09-28"
title = "creating a new theme"
+++

bah and humbug
:wq
```
