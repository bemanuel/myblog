+++
Categories = [
	"Sysadmin", 
	"NxFilter",
	"DNS",
        "Cluster"
]
description = "Alta disponibilidade e Load Balance com NxFilter"
tags = ["nxfilter", "dns","filtro","avançado","ha", "cluster", "lb", "loadbalance"]
date = "2016-09-12"
publishdate = "2016-09-12"
menu = "main"
title = "NXFilter - Alta Disponibilidade + Load Balance"
featured = "nxfilter01.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++


### Projeto - Implementar o Cluster NxFilter
 
A ideia de se implementar o Cluster é, principalmente, aumentar a disponibilidade e qualidade dos serviços de dns na rede interna/externa, afinal o NxFilter é na sua essência um servidor DNS.

Então vamos primeiro entender como funciona um servidor DNS e como ele poderia ser usado com HA e/ou Load Balance.

### Servidor DNS

Segundo a [RFC 1035](https://www.ietf.org/rfc/rfc1035.txt) ao consultar um determinado domínio a um servidor DNS usa UDP/53:
{{< highlight go >}}

  " Consultas enviadas usando UDP podem se perder, 
    por tanto uma estratégia de retransmissão é necessária. 
  ...
  A política ideal para retransmissão do pacote UDP irá variar de acordo 
  com a performance da Internet e necessidades do cliente, 
  então o seguinte deve ser implementado:
  
  - O cliente deve tentar outros servidores DNS e endereços de servidor 
  antes de repetir a consulta ao mesmo servidor.

  - O intervalo entre as retransmissões deve ser, se possível, 
  baseado em estatísticas.
  ... 
  Dependendo da conexão do cliente, o intervalo mínimo das 
  retransmissões é de 2 a 5 segundos."
{{< /highlight >}}

Então a possibilidade de cadastrar servidores DNS primário e secundário na máquina cliente atende tal requisito. De certo modo já temos a nossa alta disponibilidade, já que se o primeiro servidor NxFilter não responder o cliente irá consultar o segundo servidor NxFilter registrado.

### Motivos para se ter o Cluster

Como visto antes a implementação base de consultas DNS já atende nossa necessidade, porém não por completo. Não se pode simplesmente levantar dois servidores Nx e configurar como primário e secundário, é preciso fazer com que eles trabalhem de forma integrada.

Problemas que se teria para mais de um servidor NxFilter ativo sem o modo de cluster:

#. Se é utilizada a autenticação, como o servidor saberá que o usuário já está autenticado ?
#. Se é feita alguma configuração ( Whitelist, definição de AD, ou qualquer outra ) você teria de repetir o processo em cada um dos servidores NxFilter da sua empresa.
#. Atualização de lista de filtro teria de ser repetido em cada servidor.
#. Teria de se comprar pacotes de licenças Jahalist para cada um dos servidores.
#. etc...

Os problemas seriam muitos, o cluster do NxFilter visa atender essas necessidades.

### Criando o Cluster, usando a GUI

É muito prático e simples definir um cluster NxFilter, é possível fazê-lo por linha de comando ou GUI. 

Simularemos um ambiente onde o servidor Master terá o ip 192.168.10.50 e o Slave será 192.168.10.51.

#### Configurando o Master

Usando a GUI, entre em ''Config > Cluster''
{{< figure src="/img/2016/09/cluster_01.png" title="Config > Cluster" >}}

O parâmetro ''Mode'', vem por padrão com o valor ''None'' marque a opção para ''Master'', isso irá fazer com o que o campo ''Slave IP'' fique habilitado. 
{{< figure src="/img/2016/09/cluster_master_definindo.png" title="Config > Cluster > Master" >}}

Clique em Submit, e pare o servidor NxFilter.

#### Configurando o Slave

Acesse a mesma interface no servidor Slave
{{< figure src="/img/2016/09/cluster_01.png" title="Config > Cluster" >}}

Mais uma vez o parâmetro ''Mode'' vem por padrão com o valor ''None'' marque a opção para ''Slave'', isso irá fazer com o que o campo ''Master IP'' fique habilitado. E dessa vez vamos preencher com o IP do Master - 192.168.10.50.

{{< figure src="/img/2016/09/cluster_slave_definindo.png" title="Config > Cluster > Slave" >}}

Clique em Submit, e pare o servidor NxFilter.

### Criando o Cluster, via console

1. Pare os servidores NxFilter.
2. Entre na pasta /nxfilter/conf
3. Edit o arquivo cfg.properties de cada um dos servidores conforme as instruções a seguir


#### Configurando o Master

No arquivo /nxfilter/conf/cfg.properties, deixe as propriedades conforme explicado:

```jproperties
cluster_mode = 1
master_ip =
slave_ip = 192.168.10.51
```


#### Configurando o Slave 
 
No arquivo /nxfilter/conf/cfg.properties, deixe as propriedades conforme explicado:

```jproperties
cluster_mode = 2
master_ip = 192.168.10.50
slave_ip =
```

### Ativando os serviços

Agora ative o servidor Master, no arquivo de log deverá ver algo como:

```bash
 INFO [09-12 03:10:15] - Starting NxOEM v3.4.2
 INFO [09-12 03:10:15] - It's running as a master node.
```

Após o inicio do Master, inicie o serviço NxFilter Slave. O Log deverá ter os seguintes registros:
```bash
 INFO [09-12 03:13:39] - Starting NxOEM v3.4.2
 INFO [09-12 03:13:39] - It's running as a slave node.
 INFO [09-12 03:13:40] - MasterCheck started.
```

### Verificando o Master

Ao levantar o serviço Master e Slave algumas coisas mudam no Slave, o ambiente GUI não abrirá mais a parte gráfica, apenas a informação onde indica o Master.

Não importará a opção selecionada, ele sempre abrirá a tela de configuração de Cluster.


{{< figure src="/img/2016/09/cluster_slave_tela.png" title="Config > Cluster ( Slave )" >}}

### Término do processo

Nesse ponto está preparado o cluster NxFilter, agora é configurar as estações cliente ( ou o servidor DHCP ) para apontar os servidores DNS primário e secundário do NxFilter.
