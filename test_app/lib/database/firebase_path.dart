class FirestorePath {
  static String recipe(String uid, String recipeId) =>
      'users/$uid/recipes/$recipeId';
  static String recipes(String uid) => 'users/$uid/recipes';
}
