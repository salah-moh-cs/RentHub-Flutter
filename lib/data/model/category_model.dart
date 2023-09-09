// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  String name;
  String id;
  Category({
    required this.name,
    required this.id,
  });

  static List<Category> get categories {
    return [
      Category(
        name: 'immovables',
        id: 'immovables',
      ),
      Category(
        name: 'electronic',
        id: 'electronic',
      ),
      Category(
        name: 'clothes',
        id: 'clothes',
      ),
      Category(
        name: 'animals',
        id: 'animals',
      ),
      Category(
        name: 'industrialEquipment',
        id: 'industrial equipment',
      ),
      Category(
        name: 'vehciles',
        id: 'vehciles',
      ),
      Category(
        name: 'others',
        id: 'others',
      ),
    ];
  }

  static List<String> getSubCategorie(String id) {
    return subCategoryMap[id] ?? [];
  }
}

Map<String, List<String>> subCategoryMap = {
  'immovables': ["all", "apartments", "farms", "villas"],
  'electronic': ["all", "houseware", "entertainment"],
  'clothes': ["all", "men", "women"],
  'animals': ["all", "cats", "dogs", "birds"],
  'industrial equipment': ["all", "equipment", "machinery"],
  'vehciles': ["all", "cars", "motorcycles", "trucks", "bus"],
  'others': ["all", "books", "toys", "furniture"],
};
