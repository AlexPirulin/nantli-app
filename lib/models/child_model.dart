class ChildModel {
  final String id;
  final String name;
  final int age;
  final String specialNotes;

  ChildModel({
    required this.id,
    required this.name,
    required this.age,
    this.specialNotes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'specialNotes': specialNotes,
    };
  }

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      specialNotes: json['specialNotes'] ?? '',
    );
  }
}
