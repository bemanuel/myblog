+++
categories = ["Development", "GoLang"]
Description = "Sobre o que é a ferramenta e como instalar"
description = "Sobre o que é a ferramenta e como instalar"
date = "2016-05-28T23:56:11-03:00"
publishdate = "2016-05-01"
menu = "main"
title = "NXFilter - O Filtro DNS"
Tags= [ "dns","filtro" ]
+++

#### Apresentação

O NXFilter é uma ferramenta que começou com a ideia de atuar como filtro DNS e agora provê também a possibilidade de filtro de conteúdo web.

Dentre as vantagens disponibilizadas se tem:

 1. É uma ferramenta leve e de fácil instalação
 2. Controle por autenticação usando: LDAP, AD, Single-sign-on ( SSO ), etc... 
 3. Pode substituir inclusive o seu proxy-cache como o Squid
 4. Usando outros componentes permite inclusive o bloqueio de ferramentas como UltraSurf e Tor

#### Funcionamento
Seu principio é atuar como servidor DNS, pode fazer:

 1. Redirect
 2. Transferência de Zona
 3. Domínio Dinâmico
 4. E inclusive como o próprio servidor DNS, permitindo registros A, AAAA, SOA e etc...



{{< highlight html >}}
<section id="main">
  <div>
    <h1 id="title">{{ .Title }}</h1>
    {{ range .Data.Pages }}
      {{ .Render "summary"}}
    {{ end }}
  </div>
</section>
{{< /highlight >}}

``` html
<section id="main">
  <div>
    <h1 id="title">{{ .Title }}</h1>
    {{ range .Data.Pages }}
      {{ .Render "summary"}}
    {{ end }}
  </div>
</section>
```

{{< highlight bash >}}
$ teste.sh
# rpm -qa

{{< /highlight >}}
