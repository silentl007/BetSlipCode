// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Future<void> main() async {
//   const apiKey = '7d296sn45r65';
//   const userToken =
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2lsZW50bDAwNyJ9.-ENmPtambuJxV00D6HrFmjRLqnZ5xW4QdE76sIYQoa4';
//   final client = StreamChatClient(apiKey, logLevel: Level.INFO);
//   await client.connectUser(User(id: 'silentl007'), userToken);
//   final channel = client.channel('messaging',
//       id: 'TestRoom', extraData: {'name': 'Test Room Flutter'});
//   channel.watch();
//   runApp(MyApp(client, channel));
// }

// class MyApp extends StatelessWidget {
//   final StreamChatClient client;
//   final Channel channel;
//   MyApp(this.client, this.channel);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       builder: (context, widget) {
//         return StreamChat(
//           child: widget,
//           client: client,
//         );
//       },
//       home: StreamChannel(
//         channel: channel,
//         child: ChatUI(),
//       ),
//     );
//   }
// }

// class ChatUI extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ChannelHeader(),
//       body: Column(
//         children: [
//           Expanded(
//             child: MessageListView(),
//           ),
//           MessageInput()
//         ],
//       ),
//     );
//   }
// }
