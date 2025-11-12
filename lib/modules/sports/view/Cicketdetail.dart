// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class CricketDetailsPage extends StatefulWidget {
//   final String matchUrl;
//   final String title;

//   const CricketDetailsPage({
//     Key? key,
//     required this.matchUrl,
//     required this.title,
//   }) : super(key: key);

//   @override
//   State<CricketDetailsPage> createState() => _CricketDetailsPageState();
// }

// class _CricketDetailsPageState extends State<CricketDetailsPage> {
//   bool _isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     final url = widget.matchUrl.startsWith('https://')
//         ? widget.matchUrl
//         : 'https://www.google.com/search?q=${Uri.encodeComponent(widget.title)}';

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red[800],
//         title: Text(
//           widget.title,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebView(
//             initialUrl: url,
//             javascriptMode: JavascriptMode.unrestricted,
//             onPageFinished: (_) {
//               setState(() => _isLoading = false);
//             },
//           ),
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }
// }
