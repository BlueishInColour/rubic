import 'dart:convert';

import 'package:flutter/material.dart';
import '../../main.dart';
import 'create_user_screen.dart';
import 'list_users.screen.dart';
import '../../apis/imagekit.dart';
import '../../apis/upstash.dart';

class Master extends StatefulWidget {
  const Master({super.key});

  @override
  State<Master> createState() => MasterState();
}

class MasterState extends State<Master> {
  String ext = '';
  // Uint8List bytes = List<int>[];

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          title: const Text('master command page'),
        ),
        body: commandPage(context)));
  }

  Widget commandPage(BuildContext context) {
    return (ListView(
      children: [
        //  singleCommand('create cosmos db', () => createdb()),
        //  singleCommand('getdb', () => get()),
        //  singleCommand('deletedb', () => deletedb()),
        //  singleCommand('get list', () => listdb()),
        //  ////////////
        //  singleCommand('create collection', () => createCollection()),
        //  singleCommand('get collection', () => getCollection()),
        //  singleCommand('delete collection ', () => deleteCollection()),
        //  singleCommand('get list collection', () => listCollection()),
        //  //////////
        //  //  singleCommand('create Document', () => createDocument()),
        //  singleCommand('list document', () => listDocument()),
        //  singleCommand('get document', () => getDocument('oio')),
        singleCommand('test image kit', () => uploadToImageKit()),
        singleCommand(
            'test upstashing things ',
            () => set(
                api: postApi,
                key: '@oluwapelumi',
                path: r'$',
                value: {'this': 'that'})),
        singleCommand(
            'go to create user screen',
            () => Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, _, __) => const CreateUser()))),
        singleCommand(
            'go to create get user screen',
            () => Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, _, __) => const List())))
      ],
    ));
  }

  imagebuilder() {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data.toString();
            return Center(child: Image.memory(base64Decode(data)));
          }
        }

        // Displaying LoadingSpinner to indicate waiting state
        return Center(
          child: CircularProgressIndicator(
            color: palette.lightPurple,
            // backgroundColor: palette.black,
            semanticsLabel: 'shoveling some coal in',
          ),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: null,
    );
  }

  Widget singleCommand(String text, Function() onPressed) {
    return (Row(
      children: [
        Expanded(
          child: Text(text),
        ),
        SizedBox(
            height: 30,
            width: 100,
            child: TextField(
              onChanged: (value) => setState(() {
                ext = value;
              }),
            )),
        IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.g_mobiledata, size: 20))
      ],
    ));
  }
}