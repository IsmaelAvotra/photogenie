import 'package:client_photogenie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadyAvatarProfile extends StatefulWidget {
  const ReadyAvatarProfile({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  State<ReadyAvatarProfile> createState() => _ReadyAvatarProfileState();
}

class _ReadyAvatarProfileState extends State<ReadyAvatarProfile> {
  late WebViewController _controller;
  final api = 'https://api.readyplayer.me/v1/avatars';
  bool isThreeD = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) async {
              _controller = controller;
              await loadHtmlFromAssets(_controller, 'assets/viewer.html');
            },
            onPageFinished: (page) {
              debugPrint(widget.profileData.avatarUrl);
              _controller.runJavascript(
                  'window.loadViewer("${widget.profileData.avatarUrl}"),');
            },
          )
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            )),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text.rich(
              TextSpan(
                text: 'Roberty Joe ',
                children: [
                  TextSpan(
                    text: '@robertyjoe',
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'robertyjoe@artist.com',
            ),
            SizedBox(height: 10),
            Text(
              'Robery Joe is a 3D artist and '
              'designer based in New York City. '
              'He is a graduate of the Art Institute '
              'of New York City and has been working '
              'in the industry for 5 years.',
            ),
          ],
        ),
      ),
    );
  }
}
