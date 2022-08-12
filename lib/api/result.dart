import 'dart:convert';

class Result {
  Result({
    this.status,
    this.text,
    this.messages,
    this.path,
    this.isError = false,
  });

  bool? status;
  bool isError;
  String? text;
  String? path;
  String? messages;

  /// TO PARSE INTO MODEL USE .fromMap()
  Map<String, dynamic>? body;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        status: json["status"] == null
            ? null
            : json["status"] == 200 || json["status"] == 201,
        text: json["text"],
        path: json["path"],
        messages: json["messages"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "text": text,
        "messages": messages,
        "path": path,
      };
}

class ResultBody<T> {
  int? status;
  String? title;
  T? data;
  Meta? meta;
  Links? links;
  dynamic errors;

  bool isError() {
    return (status ?? 0) < 200 || (status ?? 0) > 299;
  }

  ResultBody({this.status, this.title, this.data});

  ResultBody.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    title = json['title'];
    errors = json["errors"];
    meta = Meta.fromJson(json["meta"]??{});
    links = Links.fromJson(json["links"]??{});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['title'] = this.title;
    if (this.data != null) {
      data['data'] = jsonEncode(this.data);
    }
    if (this.meta != null) data["meta"] = meta!.toJson();
    if (this.links != null) data["links"] = links!.toJson();
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination(
      {this.total,
      this.count,
      this.perPage,
      this.currentPage,
      this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['count'] = this.count;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    return data;
  }
}

class Links {
  String? self;
  String? first;
  String? last;

  Links({this.self, this.first, this.last});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['self'] = this.self;
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }
}
