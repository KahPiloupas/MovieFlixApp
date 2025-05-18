# MovieFlix App

Um aplicativo iOS para buscar, visualizar detalhes e favoritar filmes usando a API TMDB.

## Funcionalidades

- Busca de filmes por nome
- Listagem de resultados com poster, título e avaliação
- Visualização detalhada com: título, título original, sinopse, avaliação, orçamento, receita, data de lançamento
- Sistema de favoritos com armazenamento local
- Visualização e gerenciamento de favoritos

## Tecnologias utilizadas

- Swift 5
- UIKit
- Arquitetura VIPER
- UserDefaults para persistência local
- Grand Central Dispatch (GCD) para concorrência
- API TMDB (The Movie Database)

## Instalação

1. Clone o repositório
2. Abra o arquivo `MovieFlixApp.xcodeproj` no Xcode
3. Selecione um simulador ou dispositivo físico
4. Execute o projeto (⌘+R)

## Arquitetura

O projeto segue a arquitetura VIPER, onde:

- View: Responsável pela exibição da interface
- Interactor: Encapsula a lógica de negócios
- Presenter: Coordena a comunicação entre View e Interactor
- Entity: Modelos de dados
- Router: Gerencia a navegação entre telas

## Nota

A API Key do TMDB está incluída no projeto para fins de teste. Em um ambiente de produção, esta chave deveria ser armazenada de forma segura.
