class User{
  String name,email;
  int age;
  double height;

  User({required this.name,required this.email,required this.age,required this.height,});
  factory User.fromJson(Map<String,dynamic> json)=>User(
      name: json['name'],
      email:json['email'],
      age: json['age'],
      height:json['height']);


  Map<String,dynamic> toJson()=>{
    'name':name,
    'email':email,
    'age':age,
    'height':height
  };

}