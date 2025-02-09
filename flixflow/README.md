# FlixFlow

## 📌 Sobre o Projeto

FlixFlow é uma aplicação Flutter para gestão e visualização de filmes, permitindo aos utilizadores marcar favoritos, comentar e avaliar os filmes.

## 🛠️ Configuração do Ambiente

Para executar o projeto, é necessário ter o Flutter instalado. Se ainda não o tens, segue as instruções oficiais:

-   [Instalar Flutter](https://docs.flutter.dev/get-started/install)

Além disso, deves garantir que tens o **Java JDK** e o **Android SDK** configurados corretamente.

## 📥 Instalação

1️⃣ **Clonar o repositório**

```bash
git clone https://github.com/teu-repositorio/flixflow.git
cd flixflow
```

2️⃣ **Instalar as dependências**

```bash
flutter pub get
```

3️⃣ **Gerar as plataformas (caso necessário)**

```bash
flutter create .
```

## ⚠️ Atualização do `minSdkVersion`

Este projeto utiliza Firebase, que requer um **minSdkVersion de 23**. Caso ocorra um erro ao compilar para Android, deves atualizar o ficheiro:

### \*\*Editar \*\***`android/app/build.gradle`**

1. Abrir `android/app/build.gradle`
2. Alterar esta linha dentro de `defaultConfig`:
    ```gradle
    minSdk = 23
    ```
3. Guardar e fechar o ficheiro.
4. Limpar e atualizar o projeto:
    ```bash
    flutter clean
    flutter pub get
    ```

## 🎨 Gerar Ícones da App

Caso alteres o ícone da aplicação, deves gerar os ícones com o seguinte comando:

```bash
dart run flutter_launcher_icons
```

O ficheiro de configuração encontra-se em `flutter_launcher_icons.yaml`.

## 🚀 Configurar Splash Screen

Se for necessário configurar ou atualizar a splash screen da aplicação, executa:

```bash
dart run flutter_native_splash:create
```

O ficheiro de configuração está em `pubspec.yaml`.

## 🔧 Como Gerar o APK

Após instalar as dependências e corrigir possíveis erros, podes gerar o APK com:

```bash
flutter build apk --release
```

O APK gerado estará em:

```
build/app/outputs/flutter-apk/app-release.apk
```

## 🏃 Como Executar a App

Para testar a app em modo debug, usa:

```bash
flutter run
```

Se quiseres executar em um emulador específico, usa:

```bash
flutter run -d <ID_do_dispositivo>
```

Para listar os dispositivos disponíveis:

```bash
flutter devices
```

---

Qualquer dúvida, verifica a documentação oficial do Flutter ou entra em contacto! 🚀
