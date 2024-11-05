extension StringHelper on String{
  String get removeZerosInFirst => replaceFirst(RegExp(r'^0+'), '').trim();
}