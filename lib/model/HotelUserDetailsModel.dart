class HotelUserDetailsModel{
  String itemName;
  int id;

  HotelUserDetailsModel(this.id,this.itemName);

  HotelUserDetailsModel.fromJson(Map<String, dynamic> json)
  : itemName = json['itemName'],
      id=json['id']
  ;

  Map<String, dynamic>  toJson() => {
        'itemName': itemName,
        'id': id,
      };
}