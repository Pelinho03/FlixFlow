import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
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
    _newsFuture = _newsService.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notícias"),
        titleTextStyle: AppTextStyles.mediumAppBar.copyWith(
          color: AppColors.primeiroPlano,
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        elevation: 0.0,
        backgroundColor: AppColors.caixas,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar notícias'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma notícia encontrada.'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                elevation: 4.0,
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
                        // Substitui AlertDialog por Dialog para melhor controle de layout
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height *
                                0.8, // Limite para scroll
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                article['title'] ?? 'Sem título',
                                style: AppTextStyles.mediumText.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12.0),
                              Expanded(
                                child: SingleChildScrollView(
                                  // Permite rolagem caso o conteúdo seja grande
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                              // Se houver erro ao carregar a imagem, exibe a imagem personalizada
                                              return Image.asset(
                                                'assets/imgs/default_actor_v2.png', // Caminho para a imagem personalizada
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      // if (article['urlToImage'] == null)
                                      //   Container(
                                      //     width: 100,
                                      //     height: 100,
                                      //     decoration: BoxDecoration(
                                      //       color: AppColors.caixas,
                                      //       borderRadius:
                                      //           BorderRadius.circular(8.0),
                                      //     ),
                                      //     child: Image.asset(
                                      //       'assets/imgs/default_actor_v2.png', // Caminho para a imagem personalizada
                                      //       width: 100,
                                      //       height: 100,
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   ),
                                      const SizedBox(height: 12.0),
                                      Text(
                                        article['description'] ??
                                            'Sem descrição disponível',
                                        style: AppTextStyles.smallText,
                                      ),
                                      const SizedBox(height: 12.0),
                                      if (article['content'] != null)
                                        Text(
                                          article['content'] ??
                                              'Conteúdo não disponível',
                                          style: AppTextStyles.smallText,
                                        ),
                                      const SizedBox(height: 12.0),
                                      if (article['url'] != null)
                                        TextButton(
                                          onPressed: () {
                                            launchUrl(
                                                Uri.parse(article['url']));
                                          },
                                          child: const Text(
                                              'Ler a notícia completa'),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Fechar'),
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
                        if (article['urlToImage'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              article['urlToImage'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Se houver erro ao carregar a imagem, exibe a imagem personalizada
                                return Image.asset(
                                  'assets/imgs/default_actor_v2.png', // Caminho para a imagem personalizada
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        // if (article['urlToImage'] == null)
                        //   Container(
                        //     width: 100,
                        //     height: 100,
                        //     decoration: BoxDecoration(
                        //       color: AppColors.caixas,
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     child: Image.asset(
                        //       'assets/imgs/default_actor_v2.png', // Caminho para a imagem personalizada
                        //       width: 100,
                        //       height: 100,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['title'] ?? 'Sem título',
                                style: AppTextStyles.mediumText.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                article['source']['name'] ??
                                    'Fonte desconhecida',
                                style: AppTextStyles.smallText.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                article['description'] ??
                                    'Sem descrição disponível',
                                style: AppTextStyles.smallText,
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
