+++
Categories = [
	"Sysadmin", 
	"NxFilter",
	"DNS"
]
description = "Usando o recursos free time"
tags = ["nxfilter", "dns","filtro","avançado","free-time", "policy"]
date = "2016-08-28"
publishdate = "2016-08-28"
menu = "main"
title = "NXFilter - Usando a Politica Free-Time"
featured = "clock_freetime_nxf.png"
featuredalt = ""
featuredpath = "date"
type = "post"
+++

#### A funcionalidade
O NxFilter é um filtro DNS que já foi citado em outro post - http://blog.bemanuel.com.br/post/nxfilter/inicio/ - , ele tem diversas funcionalidades e uma das mais controversas tem sido a Free-Time, o que motivou esse post.

A ideia padrão de Free Time (horário livre) é poder definir em que horários não há bloqueios. Porém o conceito não é aplicado exatamente dessa forma no NxFilter.

Vamos imaginar a situação onde você realmente libere os acessos no horário do almoço, de modo que os usuários da rede tenham acesso a redes sociais e webmail. Mas se for definida apenas a liberação pode haver a situação onde alguns tipos de site ainda deveriam ser bloqueados como sites pornô. Pensando nisso no NxFilter o Free-Time não serve somente para dizer o horário em que devem ser aplicadas as regras e sim para definir que políticas devem ser usadas no horário definido como horário livre.

Ficou um pouco confuso? Vamos para a parte visual da funcionalidade.

#### Implementando

Existem vários pontos onde se ajusta o Free Time, há local para definição geral e definição pontual.

1. Geral: Você define em ``Policy > Free Time``. Será aplicada a todos os Grupos. Você pode definir intervalos e dias da semana.
2. Pontual: Você pode definir diretamente no Grupo o intervalo aplicado como tal. Desvantagem: Você não pode definir que dias da semana isso se aplica.

### Configuração Geral
Para definir os horários e dias em que são aplicados os 'Free Time' você deve acessar, como dito antes, o menu ``Policy > Free Time``.

{{< figure src="/img/2016/08/29/definindo_free_time.png" title="Policy > Free Time" >}}

Neste exemplo já tem alguns modelos pré-configurados, vou alterar para deixar apenas um modelo de Free Time.

{{< figure src="/img/2016/08/29/definindo_free_time_modelo.png" title="Policy > Free Time - modelo definido" >}}

Agora o ponto principal, é necessário criar uma política que será usada para o Free Time, caso contrário - por padrão - será aplicada a mesma regra definida nos Grupos, no parâmetro 'Work-Time Policy'.

{{< figure src="/img/2016/08/29/politica_corujao.png" title="Policy & Rule > Policy" >}}

Após a criação da política temos de aplicá-la ao grupo, pois aí sim serão aplicados bloqueios diferentes.

Original:
{{< figure src="/img/2016/08/29/GrupoOriginal.png" title="User & Group > Group - Original" >}}

Agora alterado...
{{< figure src="/img/2016/08/29/GrupoFreeTime.png" title="User & Group > Group" >}}

Após essa aplicação o usuário que estiver nesse mesmo grupo terá as políticas aplicadas.

Para validar a informação basta acessar no horário definido no Free Time, a área ''User & Group > User'', escolha um usuário que esteja no grupo e clique em 'Test' ( como na imagem abaixo )
{{< figure src="/img/2016/08/29/User_TestButton.png" title="User & Group > User - Testando" >}}


Se tudo foi aplicado corretamente aparecerá a seguinte imagem:
{{< figure src="/img/2016/08/29/UserTest_FreeTime.png" title="User & Group > User - Teste exibido" >}}

`Vale ressaltar que estou fazendo o teste no período estabelecido no Free Time`
