abstract class Places {
  String name;

  Places(this.name);
}

class Country extends Places {
  Country(String name) : super(name);
}

class State extends Places {
  State(String name) : super(name);
}

class City extends Places {
  City(String name) : super(name);
}
