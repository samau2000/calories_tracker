class RecipeModel {
  late String id = "";
  late String name;
  late String desc;

  RecipeModel(
    id,
    name,
    desc,
  );

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'status': desc,
    };
  }

  RecipeModel fromMap(Map value) {
    if (value == null) {
      return RecipeModel("", "", "");
    }

    return RecipeModel(
      value['id'],
      value['name'],
      value['desc'],
    );
  }

  @override
  String toString() {
    return ('{id: $id, name: $name, status: $desc}');
  }
}
