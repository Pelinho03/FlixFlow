import 'package:flixflow/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  // ID do vídeo do YouTube que será carregado no player
  final String videoId;

  const YoutubePlayerWidget({super.key, required this.videoId});

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  // Controlador do YouTube Player
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador do YouTube Player com o ID do vídeo
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false, // O vídeo não começa a tocar automaticamente
        mute: false, // O vídeo começa com som
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // O YoutubePlayer exibe o player com o vídeo
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator:
          true, // Exibe o indicador de progresso do vídeo
      progressIndicatorColor: AppColors.roxo, // Cor do indicador de progresso
    );
  }

  @override
  void dispose() {
    // Desfaz o controlador quando o widget é removido da árvore
    _controller.dispose();
    super.dispose();
  }
}
