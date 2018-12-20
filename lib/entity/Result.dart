class Result<T> {
  bool ret;
  T data;

  Result({this.ret, this.data});


  @override
  String toString() {
    return 'Result{ret: $ret, data: $data}';
  }
}
