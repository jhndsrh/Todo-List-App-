import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  final int code;
  final bool success;
  final int timestamp;
  final String message;
  final List<Item> items;
  final Meta meta;

  Welcome({
    required this.code,
    required this.success,
    required this.timestamp,
    required this.message,
    required this.items,
    required this.meta,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        code: json["code"],
        success: json["success"],
        timestamp: json["timestamp"],
        message: json["message"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "timestamp": timestamp,
        "message": message,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Item {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"] ?? '',
        title: json["title"] ?? 'Untitled',
        description: json["description"] ?? 'No description',
        isCompleted: json["is_completed"] ?? false,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "is_completed": isCompleted,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Meta {
  final int totalItems;
  final int totalPages;
  final int perPageItem;
  final int currentPage;
  final int pageSize;
  final bool hasMorePage;

  Meta({
    required this.totalItems,
    required this.totalPages,
    required this.perPageItem,
    required this.currentPage,
    required this.pageSize,
    required this.hasMorePage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalItems: json["total_items"],
        totalPages: json["total_pages"],
        perPageItem: json["per_page_item"],
        currentPage: json["current_page"],
        pageSize: json["page_size"],
        hasMorePage: json["has_more_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_items": totalItems,
        "total_pages": totalPages,
        "per_page_item": perPageItem,
        "current_page": currentPage,
        "page_size": pageSize,
        "has_more_page": hasMorePage,
      };
}
