import '../apis/upstash.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import '../services/auth_services.dart';
///
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///
import '../widgets/dummy_data.dart';
import '../main.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
//import 'dart:async';
import 'dart:io';
import '../widgets/explore_screen_widgets/pod_icon_buttons.dart';
import './post_upload_screen.dart';
import '../widgets/explore_screen_widgets/full_screen_image.dart';

//final palette = Palette();

class ExploreScreenWidget extends StatefulWidget {
  final Auth0? auth0;
  const ExploreScreenWidget({this.auth0, final Key? key}) : super(key: key);

  @override
  State<ExploreScreenWidget> createState() => ExploreScreenWidgetState();
}

class ExploreScreenWidgetState extends State<ExploreScreenWidget> {
  ExploreScreenWidgetState();
  bool imagegetterclicked = false;
  bool hasImage = false;
  File image = File('');

  bool manyFloatingwidget = false;

  bool extraDetails = false;

  //Oauthpart of explore screen

  UserProfile? _user;

  late Auth0 auth0;
  late Auth0Web auth0Web;
  String auth_domain = 'dev-gb1zfslh4ohvjdyr.us.auth0.com';
  String auth_client = 'gtTMyeSeBBnY0hw03BlpDKsXFrG8OeVO';
  String auth_custom_scheme = 'com.auth0.sample';

  @override
  void initState() {
    super.initState();
    auth0 = widget.auth0 ??
        Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
    auth0Web =
        Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

    if (kIsWeb) {
      auth0Web.onLoad().then((final credentials) => setState(() {
            _user = credentials?.user;
          }));
    }
  }

  //

  var storage = const FlutterSecureStorage();

  Future<void> login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:3000');
      }

      var credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login();
      //
      storage.write(key: 'name', value: credentials.user.givenName);
      storage.write(key: 'email', value: credentials.user.email);
      storage.write(key: 'phone_number', value: credentials.user.phoneNumber);
      storage.write(
          key: 'picture_url', value: credentials.user.pictureUrl.toString());
      storage.write(key: 'username', value: credentials.user.preferredUsername);
      setState(() {
        _user = credentials.user;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'http://localhost:3000');
      } else {
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            .logout();

        storage.delete(key: 'name');
        storage.delete(key: 'email');
        storage.delete(key: 'phone_number');
        storage.delete(key: 'picture_url');
        storage.delete(key: 'username');

        setState(() {
          _user = null;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //ending Oauth

  //login service state
  bool isProgressing = false;
  bool isLoggedIn = false;
  String errorMessage = '';
  String? name;

  @override
  Widget build(BuildContext context) {
    //appbar

    PreferredSizeWidget appbar(context) {
      return AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: palette.appName,
                    style: TextStyle(
                        color: palette.black,
                        fontSize: 35,
                        fontFamily: 'Geologica_Cursive-Bold')),
                TextSpan(
                    text: '',
                    style: TextStyle(
                        color: palette.black,
                        fontSize: 47,
                        fontWeight: FontWeight.w500)),
                //  WidgetSpan(
                //      child: Icon(
                //    Icons.local_fire_department_outlined,
                //    color: palette.red,
                //    size: 35,
                //  )),
              ])),
            ),
            isProgressing
                ? const CircleAvatar(child: CircularProgressIndicator())
                : !isLoggedIn
                    ? ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(palette.black),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        onPressed: () => login(),
                        child: Text('login | signup',
                            style: TextStyle(color: palette.white)))
                    : const Text('welcome')
          ],
        ),
      );
    }
    //full screen image page route

///////*********User details pod  ******/////

    Widget pad([Color color = const Color.fromARGB(255, 72, 72, 73)]) {
      return (VerticalDivider(color: color));
    }

    Widget actionButtons() {
      return (Row(children: [
        Semantics(
          label: 'like',
          hint: 'like',
          enabled: true,
          child: Iconish(
              re: () => debugPrint('clicked'),
              icony: Icons.local_fire_department_outlined),
        ),
        Iconish(
          re: () => null,
          size: 23,
          icony: Icons.chat_bubble_outline_rounded,
        ),
      ]));
    }

    Widget userDetailsPod(BuildContext context, int index) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          // color: palette.lightPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: (Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //profilepix
            GestureDetector(
              onDoubleTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return (FullScreenPage(
                            dark: true,
                            child: Image.network(
                                "https://source.unsplash.com/random/?art&width=500&height=1000"),
                          ));
                        }));
              },
              child: CircleAvatar(
                  backgroundColor: palette.grey,
                  backgroundImage: const NetworkImage(
                    "https://source.unsplash.com/random/?art&width=500&height=1000",
                  )),
            ),

            pad(),
            //name and user name container
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //name
                Text(posts[index].name, style: const TextStyle(fontSize: 15)),
                Text(posts[index].username,
                    style: const TextStyle(color: Colors.blue))
              ],
            ),

            pad()
          ],
        )),
      );
    }

    Widget creatorPod(context) {
      return (Container(
        height: 40,
        decoration: BoxDecoration(
          color: palette.lightPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            CircleAvatar(
              backgroundColor: palette.grey,
              // backgroundImage: const NetworkImage(
              //   "https://source.unsplash.com/random/?art&width=500&height=1000",
              // ),
            ),
            pad(),
            const Text('@LouisVuitton',
                style: TextStyle(
                  color: Colors.blue,
                )),
            pad(),
            Expanded(child: actionButtons())
          ],
        ),
      ));
    }

///// ****ImagePod Widget ********//////

    Widget imagePod(BuildContext context, int index) {
      return (Center(
          child: Column(children: [
        userDetailsPod(context, index),
        const SizedBox(
          height: 5,
        ),
        Stack(children: [
          Container(
            decoration: BoxDecoration(
                color: palette.lightPurple,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child:
                //   height: 400,
                // width: 250,
                // fit: BoxFit.fill,
                //posts[index].postedpix,
                GestureDetector(
                    onTap: () => setState(() {
                          extraDetails = !extraDetails;
                        }),
                    onDoubleTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return (FullScreenPage(
                                  dark: true,
                                  child: Image.network(
                                      posts[index].userprofilepix),
                                ));
                              }));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: posts[index].postedpix,
                          placeholder: (context, url) => Container(
                            height: 300,
                            color: palette.grey,
                            child: const Center(child: Text('fetching images')),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 300,
                            color: palette.grey,
                            child: Center(
                                child: Text(
                              'connect to the internet',
                              style: TextStyle(color: palette.red),
                            )),
                          ),
                        ))),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: Iconish(re: () => null, icony: Icons.share_rounded)),
        ]),
        const SizedBox(height: 5),
        SizedBox(
          child: extraDetails
              ? const Text(
                  'creates a text widget., If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].,The [data] parameter must not be null, The [overflow] property behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option.',
                )
              : null,
        ),
        const SizedBox(height: 5),
        creatorPod(context),
        const SizedBox(height: 30),
        const Divider()
      ])));
    }

    void refreshToGetMoreDataFromDb() async {
      debugPrint('refresing');
    }

    return (Scaffold(
        appBar: appbar(context),
        floatingActionButton: CircleAvatar(
          radius: 30,
          backgroundColor: palette.black,
          child: IconButton(
              color: palette.white,
              padding: const EdgeInsets.all(0),
              onPressed: () => showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    useSafeArea: true,
                    backgroundColor: Colors.white70,
                    // anchorPoint: Offset(500, 500),
                    isScrollControlled: true,
                    enableDrag: true,
                    isDismissible: true,
                    // barrierColor: Colors.white,
                    shape: const ContinuousRectangleBorder(
                        // side: BorderSide(width: 5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70))),
                    //  isDismissible: bool.fromEnvironment('off'),
                    constraints: const BoxConstraints(maxHeight: 600),
                    builder: (BuildContext context) {
                      return const PostUpload();
                    },
                  ),
              icon: Icon(Icons.file_upload_outlined,
                  size: 40, color: palette.grey)),
        ),
        body: WillPopScope(
            onWillPop: () async => false,
            child: RefreshIndicator(
                child: ListView.builder(
                  itemBuilder: imagePod,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: posts.length,
                ),
                onRefresh: () async => refreshToGetMoreDataFromDb()))));
  }
}
