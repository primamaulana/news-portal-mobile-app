import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  List<Datum> data;

  News({
    required this.data,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String title;
  String link;
  String contentSnippet;
  DateTime isoDate;
  Image image;

  Datum({
    required this.title,
    required this.link,
    required this.contentSnippet,
    required this.isoDate,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    title: json["title"],
    link: json["link"],
    contentSnippet: json["contentSnippet"],
    isoDate: DateTime.parse(json["isoDate"]),
    image: Image.fromJson(json["image"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "link": link,
    "contentSnippet": contentSnippet,
    "isoDate": isoDate.toIso8601String(),
    "image": image.toJson(),
  };
}

class Image {
  String small;
  String large;

  Image({
    required this.small,
    required this.large,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    small: json["small"],
    large: json["large"],
  );

  Map<String, dynamic> toJson() => {
    "small": small,
    "large": large,
  };
}
