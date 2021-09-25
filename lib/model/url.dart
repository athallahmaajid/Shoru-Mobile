import 'package:hive/hive.dart';
part 'url.g.dart';

@HiveType(typeId: 1)
class Url {
  @HiveField(0)
  String name;

  @HiveField(1)
  String actualUrl;

  @HiveField(2)
  String url;

  Url(this.name, this.actualUrl, this.url);
}
