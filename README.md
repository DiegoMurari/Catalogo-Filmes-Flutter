# 🎬 Catálogo de Filmes Flutter

Aplicativo desenvolvido com **Flutter**, que consome dados da API do TMDb, exibe trailers do YouTube e permite curtir e comentar os filmes. Integração com **Firebase Firestore** para armazenamento dos comentários.

## 📱 Funcionalidades

- Listagem infinita de filmes populares usando API do TMDb
- Busca por filmes
- Página de detalhes do filme com:
  - Trailer (YouTube)
  - Informações como nota, sinopse, data de lançamento e duração
  - Comentários (com Firebase Firestore)
  - Curtidas em comentários
- Suporte a tema escuro
- Responsivo (suporte mobile e web)

## 🚀 Tecnologias Utilizadas

- Flutter
- Dart
- Firebase (Cloud Firestore)
- TMDb API (https://www.themoviedb.org/documentation/api)
- Youtube Player Flutter

## 🧪 Prints da Aplicação

| Home Page | Página de Filme |
|-----------|------------------|
| ![Home](assets/images/Home.png) | ![MovieHome](assets/images/MovieHome.png) |
| Trailer + Comentários | |
| ![Trailer e Comentários](assets/images/Captura%20de%20tela%202025-04-14%20124252.png) | |

## 🔥 Firebase

- Firestore utilizado para armazenar os comentários por ID do filme.
- Comentários persistem ao reiniciar o app.

## 🌐 Versão Web

Acesse a versão web do projeto [clicando aqui](https://<SEU_DEPLOY_WEB>.web.app) *(substitua pelo seu link após o deploy)*.

## 📦 Instalação

```bash
git clone https://github.com/DiegoMurari/Catalogo-Filmes-Flutter.git
cd Catalogo-Filmes-Flutter
flutter pub get
🛠️ Execução
bash
Sempre exibir os detalhes

Copiar
flutter run -d chrome      # Executa versão Web
flutter run -d android     # Executa em dispositivo Android
flutter build apk          # Gera APK para distribuição
flutter build web          # Gera versão Web em build/web
📁 Estrutura
css
Sempre exibir os detalhes

Copiar
lib/
├── models/
│   └── movie_model.dart
├── pages/
│   ├── home_page.dart
│   └── detail_page.dart
├── services/
│   └── api_service.dart
└── main.dart
👨‍💻 Autor
Diego de Oliveira Murari Guimarães

Projeto desenvolvido para a disciplina Desenvolvimento Mobile (ESO/5) – 1º Bimestre

