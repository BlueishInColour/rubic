import 'package:upstash_redis/upstash_redis.dart';

connect() async {
  final redis = Redis(
      url: "https://feasible-drum-45096.upstash.io",
      token:
          "AbAoASQgZmVlNDA0MzgtNDJmNi00YmIxLTkzMzUtMjcxNThkMWNmZWEyYjJhNDIzYzQzOGYxNDE0NDk5OTU4NGFhMjIyY2I4ZTk=");
  return redis;
}

final redis = connect();

final postApi = Redis(
    url: "https://normal-raccoon-46075.upstash.io",
    token:
        "AbP7ACQgM2JmYTkyMGUtZjhmZi00ZGVhLWJmMTEtOGJkN2Y5NmIyNzc2ZGQxNmQ4ZjgwYjczNDZkMGE2YmE4NDVmZjhmNDcxZDc=");

final userApi = Redis(
  url: 'https://oriented-heron-46081.upstash.io',
  token:
      'AbQBACQgZGFiYWIyMTMtYmViNS00Y2VlLTg4Y2YtZDFlOTQ0NDY1NmRjZTUyYzJkYjZhYTZlNGJhMDhhYmU4ZjY4YWY5NGU3MGM=',
);

final associateApi = Redis(
    url: 'https://causal-bear-46070.upstash.io',
    token:
        'AbP2ACQgYWYwYTA5ZDctYTU0My00MzYzLTkyY2UtNWRlMjdlYTY4MDRkNDliNTlmNmI5OWI5NDA2YWI4Yjg4ZThmNWE2MzM2MDI=');
//// print(await redis.json.set('json', $, {'counter': 1, 'hello': '', 'name': 're'}));
//  print(await redis.json.numincrby('json', r'$.counter', 1));
//  print(await redis.json.set('json', r'$.hello', '"world"'));
//  print(await redis.json.strappend('json', r'$.name', '"baz"'));
//  print(await redis.json.strlen('json', r'$.name'));
//  print(await redis.json.get('json', [r'$.name']));
//