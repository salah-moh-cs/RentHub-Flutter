// ignore_for_file: public_member_api_docs, sort_constructors_first

class City {
  String name;
  String id;
  City({
    required this.name,
    required this.id,
  });
}

List<City> cities = [
  City(name: "all", id: "All"),
  City(
    name: "amman",
    id: "Amman",
  ),
  City(
    name: "irbid",
    id: "Irbid",
  ),
  City(
    name: "zarqa",
    id: "Zarqa",
  ),
  City(
    name: "aqaba",
    id: "Aqaba",
  ),
  City(
    name: "madaba",
    id: "Madaba",
  ),
  City(
    name: "ma'an",
    id: "Ma'an",
  ),
  City(
    name: "karak",
    id: "Karak",
  ),
  City(
    name: "jerash",
    id: "Jerash",
  ),
  City(
    name: "mafraq",
    id: "Mafraq",
  ),
  City(
    name: "tafilah",
    id: "Tafilah",
  ),
  City(
    name: "ajloun",
    id: "Ajloun",
  ),
  City(
    name: "salt",
    id: "Salt",
  ),
];
