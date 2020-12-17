class DataBase {
  static final Map<String, Map<String, List<String>>> locations = {
    'India': {
      'West Bengal': ['Kolkata', 'Midnapore', 'Haldia'],
      'Maharasta': ['Mumbai', 'Pune', 'Nagpur'],
      'Bihar': ['Patna', 'Dhanbad', 'Ranchi']
    },
  };

  static List<String> getCountries() {
    return locations.keys.toList();
  }

  static List<String> getStates(String country) {
    return locations[country].keys.toList();
  }

  static List<String> getCities(String country, String state) {
    return locations[country][state];
  }
}
