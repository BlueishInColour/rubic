import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:upstash_redis/upstash_redis.dart';

import 'create_freak.dart';
import '../Models/post_model.dart';

///(PostModel)
///post_id = id
///posted_pix = []
///extra_text_informtion = varcharr
///date_of_pushing = datetime
///no_of_shares = int
///no_of_freaks = int
///
///no_of-pull_request = int
///no_of_push_requests = int
///user(full_name,user_name,user_profile_pix)
///creator(brand_name, profilepix,design_name)
///
///
///
//id: int //unique id of object
//objecttype: string //usermodel,postmodel,
//data: byte
//
///
createPostSchema() {
  print('connecting');
  var redis = Redis.fromEnv();
  print('connected');

  print(redis.json.set('post', $, {}));
}

createPost(Post post) async {
  print('connecting');
  var redis = Redis.fromEnv();
  print('connected');
//  var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
//  List<int> bytes = await image!.readAsBytes();
//  print(bytes);
  //Codec Imagetobase64 = utf8.fuse(base64);
  //String encoded = Imagetobase64.encode(bytes.toString());

  print(redis.json.set('post', r'$.blueish', post.toJson()));
  print('post created');
}

Future<List<Post>> getPosts() async {
  print('connecting');
  var redis = Redis.fromEnv();
  print('connected');
  print(await redis.json.get('post', [r'$.BlueshInColour.data.postedby']));
  print('done that');

  List bytes = await redis.json.get('post', [r'$.blueish']);
  var mapping = bytes.map((e) => Post.fromJson(e)).toList();
  print(mapping[0].data.postedby);
  print('this is mapping $mapping ');

  print('gotten the posts ');
  return mapping;
}

Future<File> writeImageTemp(String base64Image, String imageName) async {
  final dir = await getTemporaryDirectory();
  await dir.create(recursive: true);
  final tempFile = File(path.join(dir.path, imageName));
  await tempFile.writeAsBytes(base64.decode(base64Image));
  return tempFile;
}
