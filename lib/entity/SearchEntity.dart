class SearchEntity{
  String _name;
  int _id;

  SearchEntity(this._name);
  SearchEntity.map(obj) {
    this._id = obj['id'];
    this._name = obj['name'];
  }

  int get id => _id;

  String get name => _name;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}