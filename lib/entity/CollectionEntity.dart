class CollectionEntity {
  String title;
  String category;
  String type;
  String cover;
  int duration;
  int id;
  int itemId;
  String source;
  String resourceType;

  CollectionEntity(
      {this.source,
      this.title,
      this.itemId,
      this.cover,
      this.duration,
      this.category,
      this.type,
      this.resourceType});

  CollectionEntity.map(obj) {
    this.itemId = obj['itemId'];
    this.id = obj['id'];
    this.title = obj['title'];
    this.type = obj['type'];
    this.source = obj['source'];
    this.cover = obj['cover'];
    this.category = obj['category'];
    this.duration = obj['duration'];
    this.resourceType = obj['resourceType'];
  }

  int get itemIdO => itemId;

  int get idO => id;

  int get durationO => duration;

  String get resourceTypeO => resourceType;

  String get sourceO => source;

  String get titleO => title;

  String get typeO => type;

  String get categoryO => category;

  String get coverO => cover;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['itemId'] = itemId;
    map['title'] = title;
    map['source'] = source;
    map['cover'] = cover;
    map['category'] = category;
    map['duration'] = duration;
    map['resourceType'] = resourceType;
    map['type'] = type;
    return map;
  }
}
