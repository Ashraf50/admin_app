class RecordModel {
  int? id;
  String? name;

  RecordModel({this.id, this.name});

  factory RecordModel.fromJson(Map<String, dynamic> json) => RecordModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
