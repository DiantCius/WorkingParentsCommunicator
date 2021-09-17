class Child {
  final int? childId;
  final String? name;
  final String? birthDate;
  final int? parentId;

  Child(
      {this.childId,
      this.name,
      this.birthDate,
      this.parentId});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      childId: json['childId'],
      name: json['name'],
      birthDate: json['birthDate'],
      parentId: json['parentId'],
    );
  }
      
}
