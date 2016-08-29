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

