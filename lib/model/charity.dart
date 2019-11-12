class Charity  {
  String name;
  String imageUrl;
  int credits;
  String id;

  Charity({
    this.name,
    this.imageUrl,
    this.credits,
    this.id,
  });

  Charity.fromData(Map<String, dynamic> data)
      : name = data['name'],
        imageUrl = data['imageUrl'],
        credits = data['credits'],
        id = data['id'];
}