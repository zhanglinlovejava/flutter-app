class TabInfo {
  int _id;
  String _name;
  String _apiUrl;
  String _bgPicture;

  TabInfo(this._id, this._name);

//  TabInfo(this._id, this._name, this._apiUrl, this._bgPicture);

  TabInfo.map(obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._apiUrl = obj['apiUrl'];
    this._bgPicture = obj['bgPicture'];
  }

  int get id => _id;

  String get name => _name;

  String get apiUrl => _apiUrl;

  String get bgPicture => _bgPicture;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    map['apiUrl'] = _apiUrl;
    map['bgPicture'] = _bgPicture;
    return map;
  }
}
