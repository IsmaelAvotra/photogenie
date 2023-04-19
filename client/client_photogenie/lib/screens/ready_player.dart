import 'package:client_photogenie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadyPlayerMe extends StatefulWidget {
  const ReadyPlayerMe({
    Key? key,
  }) : super(key: key);

  //  final SharedPreferences prefs;

  @override
  State<ReadyPlayerMe> createState() => _ReadyPlayerMeState();
}

class _ReadyPlayerMeState extends State<ReadyPlayerMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          await loadHtmlFromAssets(controller, 'assets/iframe.html');
        },
        javascriptChannels: {
          JavascriptChannel(
              name: 'AvatarCreated',
              onMessageReceived: (JavascriptMessage message) async {
                //  await widget.prefs.setString('avatar', message.message);
                //  final user = userFromPrefs(widget.prefs);
                //  if(!mounted) return;
                //  if(user){
                //   Get.offAll(const BottomBar());
                //  }
              })
        },
      ),
    ));
  }
}
