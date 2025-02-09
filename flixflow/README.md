---

# FlixFlow

## 📌 Sobre o Projeto

FlixFlow é uma aplicação Flutter que permite aos utilizadores gerir e visualizar filmes. A app oferece funcionalidades como marcar filmes como favoritos, comentar e avaliar filmes.

## 🛠️ Configuração do Ambiente

Para executar o projeto, precisas de ter o Flutter instalado. Caso ainda não tenhas, segue as instruções oficiais:

- [Instalar Flutter](https://docs.flutter.dev/get-started/install)

Além disso, certifica-te de que tens o **Java JDK** e o **Android SDK** configurados corretamente.

## 📥 Instalação

1️⃣ **Clonar o Repositório**

```bash
git clone https://github.com/Pelinho03/FlixFlow.git
cd FlixFlow
```

2️⃣ **Criar o Projeto**

Caso ainda não tenhas as páginas e ficheiros gerados, executa o comando abaixo:

```bash
flutter create .
```

3️⃣ **Instalar as Dependências**

```bash
flutter pub get
```

4️⃣ **Gerar Ícones e Splash Screen**

Se precisares de atualizar o ícone ou a splash screen, executa:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## ⚠️ Atualização do `minSdkVersion`

Este projeto usa Firebase, que requer um **minSdkVersion de 23**. Se encontrares algum erro ao compilar, atualiza o ficheiro `android/app/build.gradle`:

1. Abre `android/app/build.gradle`.
2. Altera o valor de `minSdk` para 23:

    ```gradle
    minSdk = 23
    ```

3. Depois, executa:

    ```bash
    flutter clean
    flutter pub get
    ```

## 🚀 Como Gerar o APK

Para gerar o APK, usa o comando abaixo:

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

Se quiseres testar em um dispositivo específico:

```bash
flutter run -d <ID_do_dispositivo>
```

Para listar os dispositivos disponíveis:

```bash
flutter devices
```

---

## 🎨 Mockups

Caso seja necessário confirmar os mockups da app, podes aceder ao design completo no Figma:

[Mockups do Figma - FlixFlow](https://www.figma.com/design/N2neSEkPEFsgqUJbpohqfh/FlixFlow?node-id=20-184&t=rvAMveOhzVEQEP6s-1)

---

Caso tenhas algum erro ou problema, podes sempre consultar o meu repositório para obter os ficheiros necessários: [FlixFlow no GitHub](https://github.com/Pelinho03/FlixFlow.git)

---
