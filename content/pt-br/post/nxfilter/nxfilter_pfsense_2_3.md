+++
Categories = [
	"Sysadmin", 
	"NxFilter",
	"DNS",
	"pfSense"
]
description = "Instalando o NxFilter no pfSense 2.3"
tags = ["nxfilter", "dns","filtro","instalando","freebsd", "pfsense" ]
date = "2016-04-13"
publishdate = "2016-04-13"
menu = "main"
title = "NXFilter no pfSense"
featured = "pfsense_nxfilter01.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++


### Apresentação
**Atenção essa instalação não foi homologada em produção e não teve testes de segurança, se feito não tenho responsabilidades pelos problemas causados**

Com o lançamento do pfSense 2.3 a instalação do NxFilter no mesmo servidor teve algumas mudanças, seguem os procedimentos para fazê-lo.

##### Instalando o Java
O Java é o pré-requisito e foi a maior mudança que houve no processo de instalação.
Acesse o servidor via SSH:

```bash
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/openjdk8-jre-8.66.17_3.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/giflib-5.1.2_2.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXt-1.1.5,1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/xproto-7.0.28.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libSM-1.2.2_3,1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libICE-1.0.9_1,1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libX11-1.6.3,1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/kbproto-1.0.7.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXdmcp-1.1.2.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libxcb-1.11.1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libpthread-stubs-0.3_6.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXtst-1.2.2_3.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXext-1.3.3_1,1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/xextproto-7.3.0.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/inputproto-2.3.1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXi-1.7.6,1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXfixes-5.0.1_3.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/fixesproto-5.0.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/recordproto-1.14.2.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/java-zoneinfo-2015.f.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXrender-0.9.9.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/renderproto-0.11.1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/freetype2-2.6.2.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/alsa-lib-1.1.0.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/fontconfig-2.11.1_1,1.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/dejavu-2.35.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/mkfontdir-1.0.7.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/mkfontscale-1.1.2.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libXau-1.0.8_3.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/java-zoneinfo-2015.f.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/javavmwrapper-2.5.txz
fetch http://pkg.freebsd.org/freebsd:10:x86:64/release_3/All/libfontenc-1.1.3.txz

#Instalando o openjdk8
pkg add openjdk8-jre-8.66.17_3.txz

#Pontos de montagem necessários
mount -t fdescfs fdesc /dev/fd
mount -t procfs proc /proc
```
Testando o funcionamento do pacote java
```
rehash
java -version
```
Deve retornar algo como 
```sh
openjdk version "1.8.0_66"
OpenJDK Runtime Environment (build 1.8.0_66-b17)
OpenJDK 64-Bit Server VM (build 25.66-b17, mixed mode)
```

#### Preparando o ambiente do pfSense - removendo conflitos
A ferramenta de administração do pfSense usa as portas 80/tcp e 443/tcp, o serviço **DNS Resolver** utiliza a porta 53/udp. Que entram em conflito com os requisitos do NxFilter. Para evitar problemas é necessário mudar essa configuração.

###### Mudando portas e desativando redirect da porta 80
1. Se é usada a porta 80 para acesso ao ambiente de administração as mudanças necessárias estão abaixo, caso use a 443 siga para o item 2.
  - Entre em System > Advanced e na aba **Admin Access** altere o campo **TCP Port** para 8080, ou outra porta disponível desde que seja diferente de **80**
  - Clique no botão **Save**
{{< figure src="/img/2016/04/pfsense_nxfilter_mudando_porta_80.png" title="System > Advanced" >}}

2. Mudando a porta 443
  - Entre em System > Advanced e na aba **Admin Access** altere o campo **TCP Port** para 8443, ou outra porta disponível desde que seja diferente de **443**
  - Marque a opção "Disable webConfigurator redirect rule", ela é responsável por redirecionar solictações na porta 80 para a 443 ou a nova https definida, se ela não for marcada não aparecerão as telas do NxFilter.
{{< figure src="/img/2016/04/pfsense_nxfilter_mudando_porta_443.png" title="System > Advanced" >}}

3. Desativando o DNS Resolver
  * O Serviço usa porta 53/udp e essa é essencial para o NxFilter, como o mesmo fará cache também e tem funcionalidades que permitem redirect e forward ele atenderá as funcionalidades básicas do mesmo.
  * Vá em **Services > DNS Resolver**, desmarque a opção **Enable DNS resolver** e clique em **Save**
{{< figure src="/img/2016/04/pfsense_nxfilter_desativar_dns_resolver.png" title="Services > DNS Resolver" >}}

#### Preparando o ambiente do pfSense - alterando regras para acesso a porta 53/udp
Para garantir o acesso crie uma regra no pfSense para que se possível a consulta DNS e impeça a consulta em servidores externos.

Em *Firewall > Rules**, na aba LAN ( ou a aba que tenhas a VLAN onde será aplicado ) e crie a regra com permissão de consulta na porta 53, usando o protocolo UDP. Pode ficar como na imagem abaixo.

```Nesse caso permiti a TCP só por conta da possibilidade de transferência de Zona```
{{< figure src="/img/2016/04/pfsense_nxfilter_regra.png" title="Firewall > Rules - LAN" >}}

Não esqueça de aplicar a regra.


#### Instalando o NxFilter - Fonte Grupo Telegram - [NxFilter - DNS Webfilter](https://telegram.me/joinchat/BpMjGQb6zc4kQv9c_R0Fvg)
Nesse ponto o procedimento de instalação é iqual a versão anterior
```
mkdir -p /opt/nxfilter
cd /opt/nxfilter/
fetch http://nxfilter.org/download/nxfilter-3.1.6.zip
unzip nxfilter*
rm nxfilter*.zip
cd bin
chmod +x *.sh
``` 
Altere o arquivo startup.sh para ter o timezone da sua região, colocando o parâmetro:

``` -Duser.timezone=America/Fortaleza ``` 

Ficando mais ou menos assim.

```
# vi /opt/nxfilter/bin/startup.sh
nohup java -Duser.timezone=America/Fortaleza -Djava.net.preferIPv4Stack=true \ 
 -Xmx512m -Djava.security.egd=file:/dev/./urandom -cp $NX_HOME/nxd.jar:$NX_HOME//lib/*: \ 
 nxd.Main > /dev/null 2>&1 &
```

Agora é iniciar o serviço e usá-lo.
```
/opt/nxfilter/bin/startup.sh -d
```

Para deixar iniciando automaticamente você pode usar o pacote do pfsense **shellcmd**, instale-o e adicione a linha. 

``` /opt/nxfilter/bin/startup.sh -d ```

É indicado se colocar no cron um script para verificar se o sistema está rodando, caso não ele ainda o ativa.
Esse script também foi originado no grupo do Telegram mas teve uma pequena variação.
```
#!/bin/sh
b_grep=`which grep`
nxfilter_path="/opt/nxfilter"

result=$($nxfilter_path/bin/ping.sh)

if  [ "$result" = "ERR" ] ; then
   echo "Iniciando NxFilter"
   $nxfilter_path/bin/startup.sh -d
fi
```
Grave o mesmo com o nome checknx.sh e coloque no /root, aí é chamar pra executar pelo cron.

