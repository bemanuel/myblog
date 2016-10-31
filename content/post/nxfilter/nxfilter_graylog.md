+++
Categories = [
	"Sysadmin", 
	"NxFilter",
	"DNS",
	"Graylog",
        "Syslog",
        "UDP"
]
description = "Integrando o NxFilter com o Graylog através do Syslog"
tags = ["nxfilter", "dns","filtro","instalando","docker", "graylog","syslog" ]
date = "2016-10-30"
publishdate = "2016-10-31"
menu = "main"
title = "NxFilter + Graylog = Relatórios"
featured = "pfsense_nxfilter01.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

# Relatórios no NxFilter

  O NxFilter tem relatórios gráficos e com apresentação diversificada mas como todos os sistemas hoje existentes nem todos os relatórios apresentados podem atender as mais diversas necessidades. Porém, assim como a maioria dos sistemas, o serviço NxFilter vem com a possibilidade de se usar o Syslog para exportar seus registros em tempo de execução.

## O que é Syslog ?
  
  O Syslog é um protocolo criado pelo IETF para permitir que os sistemas transmitam mensagens de log usando a rede IP. Esse protocolo permite que um determinado sistema envie a um determinado servidor os registros de operações aplicados a um determinado sistema. Ele pode enviar usando UDP ou TCP.
 
  Por exemplo, imagine que há um servidor na internet que provê serviço HTTP ( Apache/NGinx ) e há o interesse de que os registros de utilização desses sistemas ( LOGs ) sejam armazenados não só no servidor local - como ocorre por padrão - mas que pra caso haja uma auditoria ele fique quardado em outro servidor.
  
  Para isso se instalar um servidor syslogd que atende o padrão Syslog e que irá receber os dados enviados pelo servidor HTTP já citado. Desse modo todos os dados de acesso ficarão arquivados nesse servidor remoto.

## Como funciona o Syslog no NxFilter

  O servidor NxFilter, conforme documentação do mesmo [Syslog no NxFilter](http://docs.nxf.kernel.inf.br/pt_BR/latest/pages/misc/syslog.html), é composto por dados separados por '|' e segue o seguinte padrão e ordem para envio dos dados aos servidores Syslog:

 1. Prefixo - Identificação 
 2. Data - Data/Hora da Operação
 3. Bloqueado - Se foi bloqueado ou não
 4. Domínio - Domínio requisitado - vale ressaltar que como o NxFilter é um servidor DNS não se obterá a URL
 5. Usuario - Usuário requisitante
 6. IP - IP do Cliente requisitante
 7. Política - Política aplicada ao usuário/ip requisitante
 8. Categoria - Em que categoria o domínio se enquadrou
 9. Motivo - Razão, caso tenha sido bloqueado, por que foi bloqueado.
 10. Tipo de Consulta - Código da Consulta DNS

 Por exemplo, o Syslog enviará para o servidor SyslogD o seguinte texto:

       NXFILTER|2013-01-28 10:53:23|Y|www.bbc.co.uk|pwuser|192.168.0.101|admin|news|Blocked by admin|33

 Que significará:
 
 * Prefixo : NXFILTER
 * Data : ‘2013-01-28 10:53:23’
 * Bloqueado (Sim=y/Não=n) : Y
 * Domínio : www.bbc.co.uk
 * Usuário : pwuser
 * IP Cliente : 192.168.0.101
 * Política : admin
 * Categoria : news
 * Motivo do bloqueio : ‘Blocked by admin’
 * Tipo de consulta DNS : 33

## Graylog

  O serviço Graylog funciona como Centralizador de Logs. Permitindo receber logs de diversas maneiras inclusive através do modo Syslog.

  São criados Inputs e esses recebem as mensagens, permitindo gerar Extratores ( para quebrar e manipular as mensagens ) e Streams para gerar Dashboards e alertas.

  Não vou desperdiçar o tempo explicando os motivos de se utilizar um centralizador pois já foi comentado em [Graylog - Centralizador de Logs](http://blog.bemanuel.com.br/post/graylog/inicio/) e a instalação da versão mais nova do Graylog é explicada em outro post neste mesmo blog com o título [GRAYLOG 2.0 GA - CENTRALIZADOR DE LOGS](http://blog.bemanuel.com.br/post/graylog/graylog_v2/).

  Para esse post eu utilizei a imagem do Graylog para Docker [Graylog/AllInOne](https://hub.docker.com/r/graylog2/allinone/), afim de tornar mais rápida e fácil a criação deste post.

### Graylog - Input e Extractor 

  O Graylog permite que sejam criados vários canais de Input ( Entrada ) de dados, isso facilita para separarmos ou organizarmos de onde vem as informações e como estas deverão ser trabalhadas. Não digo que o modo como farei seja o mais perfeito mas é o modo como tem me atendido e essa é a beleza da ferramenta, a flexibilidade.

  Então o INPUT é composto basicamente do tipo a ser trabalhado, que pode ser GELF ( formato proprietário ), JSON ( para entradas de APIs HTTP ), Syslog ( que já comentamos anteriormente ) e outros. Somado ao tipo de Input, ao se definir a criação do mesmo surgirá uma nova janela pedindo informações como, isso para o caso de criar um Input do tipo ''Syslog'':

  1.  O nó que escutará/receberá essas informações ( pois o Graylog pode ser formado por diversos nós )
  2.  O título que será dado a esse INPUT 
  3.  O IP ao qual ele será vinculado
  4.  A porta que escutará o serviço 

  Há outras opções para o mesmo INPUT mas só usaremos estas para esse post.

  O Extractor


## Graylog e NxFilter - configurando 
 
  Vamos usar os seguintes parâmetros:

  | ----------------- | ------------ |
  | Servidor NxFilter | 192.168.1.1 |
  | Servidor Gralog | 192.168.1.2 |
  | Porta Syslog | 5140 |
  | Procolo do Syslog | UDP |
   
