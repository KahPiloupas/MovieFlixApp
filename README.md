# MovieFlixApp

Um aplicativo iOS para explorar e gerenciar seus filmes favoritos usando a API do The Movie Database (TMDb).

## 📱 Funcionalidades

- Busca de filmes por nome
- Visualização de detalhes dos filmes
- Sistema de favoritos
- Interface em grid para listagem de filmes
- Cache de imagens
- Suporte offline para filmes favoritos
- Feedback visual para ações do usuário

## 📄 Requisitos

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+
- Conta no The Movie Database (TMDb) para API Key

## 📦 Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/MovieFlixApp.git
```

2. Navegue até o diretório do projeto:
```bash
cd MovieFlixApp
```

3. Abra o arquivo do projeto no Xcode:
```bash
open MovieFlixApp.xcodeproj
```

4. Configure sua API Key do TMDb:
   - Acesse [The Movie Database](https://www.themoviedb.org/)
   - Crie uma conta ou faça login
   - Vá para as configurações da sua conta
   - Na seção "API", gere uma nova API Key
   - No projeto, localize o arquivo `MovieAPIService.swift`
   - Substitua `YOUR_API_KEY` pela sua API Key

## 🚀 Execução

1. No Xcode, selecione um simulador iOS ou dispositivo físico

2. Pressione `⌘R` ou clique no botão de "Play" para executar o aplicativo

3. Aguarde o aplicativo compilar e iniciar

## 🧪 Testes

Para executar os testes unitários:

1. No Xcode, pressione `⌘U` ou
2. Vá em `Product > Test` no menu superior

## 📁 Estrutura do Projeto

O projeto segue a arquitetura VIPER:

## Arquitetura

O projeto segue a arquitetura VIPER, onde:

- View: Responsável pela exibição da interface
- Interactor: Encapsula a lógica de negócios
- Presenter: Coordena a comunicação entre View e Interactor
- Entity: Modelos de dados
- Router: Gerencia a navegação entre telas

## Nota

A API Key do TMDB está incluída no projeto para fins de teste. Em um ambiente de produção, esta chave deveria ser armazenada de forma segura.
