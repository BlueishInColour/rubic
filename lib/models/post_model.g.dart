// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      postedBy: json['postedBy'] as String,
      id: json['id'] as String,
      text: json['text'] as String,
      postType: json['postType'] as String? ?? '',
      photosUrl:
          (json['photosUrl'] as List<dynamic>).map((e) => e as String).toList(),
      tags: json['tags'] as String,
      specialTag: json['specialTag'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'postedBy': instance.postedBy,
      'id': instance.id,
      'postType': instance.postType,
      'text': instance.text,
      'tags': instance.tags,
      'specialTag': instance.specialTag,
      'photosUrl': instance.photosUrl,
    };
