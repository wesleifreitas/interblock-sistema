[![MIT License][license-image]][license-url]

[![AngularJS][angularJs-image]][angularJs-url]

# Phoenix Project AngularJS 1 (px-project-a1)

Template de software modular, possui como objetivo permitir o desenvolvimento ágil de aplicações web modernas com qualidade, confiabilidade e segurança.

* Web site: http://pxproject.com.br
* Contribution guidelines: [CONTRIBUTING.md](CONTRIBUTING.md)
* Demo page: http://demo-a1.pxproject.com.br/

Usuário | Senha
------------ | -------------
admin | admin

[license-image]: https://img.shields.io/github/license/mashape/apistatus.svg?style=flat
[license-url]: LICENSE

[angularJs-image]: https://img.shields.io/badge/angularJs-v1.*-blue.svg?style=flat
[angularJs-url]: https://angularjs.org/

## Building

* Instale as dependências do projeto

```bash
npm install && bower install
```

* Na pasta backend/nojde execute

```bash
node server.js
```

* Em outro terminal execute a tarefa serve

```bash
gulp serve
```

Acesse [http://localhost:9000](http://localhost:9000) no navegador (**usuario:** *admin* | **senha:** *admin*)
