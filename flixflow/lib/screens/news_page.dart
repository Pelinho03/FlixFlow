import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsService _newsService = NewsService();
  late Future<List<dynamic>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsService
        .fetchNews(); // Inicia a obtenção das notícias ao abrir a página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Notícias"),
      body: FutureBuilder<List<dynamic>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Mostra um indicador de carregamento
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'Nenhuma notícia encontrada.')); // Mensagem de erro ou dados vazios
          }

          final articles = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Título da notícia
                                      Text(
                                        article['title'] ?? 'Sem título',
                                        style: AppTextStyles.mediumBoldText
                                            .copyWith(
                                          color: AppColors.primeiroPlano,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Divider(
                                        height: 30,
                                        color: AppColors.roxo,
                                        thickness: 0.1,
                                      ),
                                      // Imagem da notícia
                                      if (article['urlToImage'] != null)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            article['urlToImage'],
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/imgs/default_actor_v2.png',
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      const Divider(
                                        height: 30,
                                        color: AppColors.roxo,
                                        thickness: 0.1,
                                      ),
                                      // Descrição da notícia
                                      Text(
                                        article['description'] ??
                                            'Sem descrição disponível',
                                        style:
                                            AppTextStyles.mediumText.copyWith(
                                          color: AppColors.primeiroPlano,
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      // Conteúdo completo (se disponível)
                                      if (article['content'] != null)
                                        Text(
                                          article['content'] ??
                                              'Conteúdo não disponível',
                                          style: AppTextStyles.regularText
                                              .copyWith(
                                            color: AppColors.primeiroPlano,
                                          ),
                                        ),
                                      const SizedBox(height: 12.0),
                                      // Link para a notícia original
                                      if (article['url'] != null)
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              launchUrl(
                                                  Uri.parse(article['url']));
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      AppColors.verde),
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Ver notícia completa',
                                              style: AppTextStyles
                                                  .mediumBoldText
                                                  .copyWith(
                                                color: AppColors
                                                    .caixas_login_registo,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: AppColors.roxo,
                                thickness: 0.1,
                              ),
                              // Botão para fechar
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.vermelho,
                                  ),
                                  child: const Text('Fechar esta notícia'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagem da notícia (se disponível)
                        if (article['urlToImage'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              article['urlToImage'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/imgs/default_actor_v2.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(width: 12.0),
                        // Texto com título e descrição
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['title'] ?? 'Sem título',
                                style: AppTextStyles.mediumText.copyWith(
                                  color: AppColors.primeiroPlano,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                article['source']['name'] ??
                                    'Fonte desconhecida',
                                style: AppTextStyles.smallText.copyWith(
                                  color: AppColors.roxo,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                article['description'] ??
                                    'Sem descrição disponível',
                                style: AppTextStyles.regularText.copyWith(
                                  color: AppColors.primeiroPlano,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2,
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(context, index);
        },
      ),
    );
  }
}
