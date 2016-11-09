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
featuredalt = ""
featuredpath = "date"
type = "post"
+++

# Relatórios no NxFilter

  O NxFilter tem relatórios gráficos e com apresentação diversificada mas, como todos os sistemas hoje existentes, os relatórios disponibilizados nem sempre atendem as mais diversas necessidades. Tendo isso sido previsto, assim como a maioria dos sistemas, o serviço NxFilter vem com a possibilidade de se usar o Syslog para exportar seus registros em tempo de execução.

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

#### INPUT ( Graylog )
  Então o INPUT é composto basicamente do tipo a ser trabalhado, que pode ser GELF ( formato proprietário ), JSON ( para entradas de APIs HTTP ), Syslog ( que já comentamos anteriormente ) e outros. Somado ao tipo de Input, ao se definir a criação do mesmo surgirá uma nova janela pedindo informações como, isso para o caso de criar um Input do tipo ''Syslog'':

1.  O nó que escutará/receberá essas informações ( pois o Graylog pode ser formado por diversos nós )
2.  O título que será dado a esse INPUT 
3.  O IP ao qual ele será vinculado
4.  A porta que escutará o serviço 

  Há outras opções para o mesmo INPUT mas só usaremos estas para esse post.

#### EXTRACTOR ( Graylog )
  O Extractor do Graylog permite que você trabalhe as mensagens recebidas de modo a classificar e especificar a que se referem os valores.
  
  Para fazer isso o Extrator oferece diversos meios seja por usando Expressão Regular, JSON, ''Split & Index'' ( Cortar/Indexar ), Copiando a mensagem ou usando o GROK.

  Quem já trabalhou com ElasticSearch ou Logstash já conhece ou deve ter ouvido falar dele. O Grok permite que se faça uma combinação de padrões afim de extrair informações e indexa-las. A sintaxe dele é bem simples %{SINTAXE:SEMÂNTICA}. Por exemplo, se você tem a mensagem

       srvl00nxf500.bemanuel.com.br NXFILTER|2016-11-01 08:45:37

 Com o GROK você usaria os seguintes padrões pra capturar e indexar a parte da mensagem:

       %{HOSTNAME:srv} %{WORD:sys}\|%{TIMESTAMP_ISO8601:date}\|

 Você obteria:

srv | sys     | date
----- | :-----: | --------:
srvl00nxf500.bemanuel.com.br | NXFILTER | 2016-11-01 08:45:37

 Foram criados os campos/fields: srv, sys e date. Me permitindo inclusive filtrar as ocorrências por eles.

 Por conta dessa facilidade usarei o Grok. No Graylog ele já vem com diversos padrões especificados, além claro dos usados aqui no exemplo ( HOSTNAME, WORD e TIMESTAMP_ISO8601 )

 Os padrões Grok, são uma prédefinição de expressõesque auxiliam no tratamento da mensagem.

IMPORTANTE: Para ativar o pacote de padrões já disponibilizado no Graylog é preciso que acesse ''System > Content Packs'' e ative o pacote ''Core Grok Patterns''.

## Graylog e NxFilter - configurando 
 
  Vamos usar os seguintes parâmetros:

Alias  |   Descrição           |   Valor
-------|-----------------------| -------------:
SRVNXF |    Servidor NxFilter  | 192.168.1.1
SRVGRA |    Servidor Graylog   | 192.168.1.2
PRTSYS |    Porta Syslog       | 5140
----   |    Placa de rede      | ens18
----   |    Procolo do Syslog  | UDP


Lembrando que estou considerando que já instalou o Graylog.

No NxFilter não há a opção de se mudar a porta 514 e no Graylog ( a não ser que você esteja fazendo errado ) não se consegue levantar portas inferiores a 1024 sem que o serviço seja levantado pelo usuário ''root''.

Para que isso funcione faremos o redirecionamento de solicitações da porta 514 para a porta 5140 - que será a utilizada neste post, conforme especificado acima.

    sudo iptables -A PREROUTING -t nat -i ens18 -p udp --dport 514 -j REDIRECT --to-port 5140 

`Esse comando deve ser executado no servidor Graylog com o usuário root`


No servidor NxFilter tudo que é necessário ser feito é ir em `Config > Setup` e definir o ip do servidor Graylog.

{{< figure src="/img/2016/11/graylog_nxfilter_syslog.png" title="Configurando o serviço Syslog no NxFilter" >}}

Após esse procedimento é necessário reiniciar o NxFilter.

A partir daqui todo o processo é feito no Graylog.

No Graylog temos de fazer os seguintes passos:

1. Criar o INPUT
2. Aplicar um Extractor na mensagem recebida
3. Criar os Gráficos
4. Gerar um Stream para criar alertas

### Criando o INPUT

O INPUT é a parte base do sistema de gerenciamento de logs, através dele que são coletadas as informações. Será criado um INPUT para a entrada de registros enviados pelo NxFilter e conforme definido anteriormente a porta usada será a 5140.

Acesse o menu em ''System > Inputs'', lá você terá acesso a todos os Inputs registrados.

{{< figure src="/img/2016/11/graylog_nxfilter_system_inputs.png" title="System >  Inputs" >}}

Retornando a listagem de inputs existentes e suas estatísticas. Para criar o seu input acesse o combo com a listagem de tipos de input, escolho o modelo ''Syslog UDP'' e clique em ''Launch new input''. 

{{< figure src="/img/2016/11/graylog_nxfilter_criando_input_00.png" title="Combo Input" >}}

{{< figure src="/img/2016/11/graylog_nxfilter_criando_input.png" title="Criando INPUT" >}}

Em seguida aparecerá uma janela solicitando a definição de parâmetros para esse INPUT. Defina o título/nome do input como ''NxFilter'' e em `Node` você deve escolher que servidor do Graylog receberá os registros do syslog para isso basta clicar na seta do combo e aparecerá a listagem dos `nodes` registrados, deixe `Bind address` com o valor padrão '0.0.0.0' e em port - que é a porta que o serviço deverá abrir para reveber os registros - sete o valor 5140.

Há ainda outros parâmetros mas para o momento somente esses interessam.

Deverá aparecer um item como o abaixo...


{{< figure src="/img/2016/11/graylog_nxfilter_criando_input_01.png" title="Definindo parâmetros do INPUT" >}}

Após a criação do Input deverá aparecer o item contendo:
1. título e protocolo definidos
2. a porta
3. Botões para: Exibir as mensagens, Gerenciar Extratores, Parar o Input e outros...

{{< figure src="/img/2016/11/graylog_nxfilter_input_criado.png" title="Resultado da criação do Input" >}}

Neste ponto se estiver tudo correto o item Input recém criado deverá exibir mensagens como a abaixo ao se clicar em ''Show received messages''.

{{< figure src="/img/2016/11/graylog_nxfilter_msgs.png" title="Mensagens capturadas" >}}

Agora é o momento de tratá-las usando o ''Extractor'' que nos auxiliará trabalhando a mensagem. 

### Criando o Extractor

A função do 'Extractor' é tratar/manipular o texto recebido e quebrá-lo em 'fields'/campos, de um modo flexível permitindo ser especificado de acordo com o interesse do usuário do sistema.

Uma das formas de criá-lo é na área do Input, clicando no botão 'Show messages', como a imagem mostrada acima. Essa operação fará com que se abra uma tela contendo diversas mensagens recebidas pelo input 'NxFilter'.

Clique na mensagem e aparecerá o campo ''message'' no canto direito há uma espécie de lupa. Ao clicar nela aparecerão diversas opções, dentre elas ''Create extractor field message'', selecionado essa opção aparecerá um submenu.

No submenu escolha ''Grok pattern', que será o padrão que usaremos para extrair as informações e atribuir aos campos desejados.

IMPORTANTE: Para ativar o pacote de padrões já disponibilizado no Graylog é preciso que acesse ''System > Content Packs'' e ative o pacote ''Core Grok Patterns''.

Deixe marcado o campo 'Named captures only', desse modo só os resultados recebidos na análise do padrão serão exibidos.

Em 'Grok Pattern' insira - exatamente - a seguinte expressão:

     %{HOSTNAME:srv} %{WORD:sys}\|%{TIMESTAMP_ISO8601:date}\|%{WORD:block}\|%{HOSTNAME:domain}\|%{GREEDYDATA:user}\|%{IP:src_ip}\|%{GREEDYDATA:policy}\|%{GREEDYDATA:category}\|%{GREEDYDATA:reason}\|%{INT:dns_type}

Clique no botão 'Try', se estiver tudo certo aparecerá um item ''Extractor preview'' mostrando a previsão do resultado da análise da mensagem, parecido como abaixo:


{{< figure src="/img/2016/11/graylog_nxfilter_extractor_pattern.png" title="Saída do Extractor" >}}


