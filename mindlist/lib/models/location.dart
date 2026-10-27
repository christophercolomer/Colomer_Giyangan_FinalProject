class Location {
  final String name;
  final double latitude;
  final double longitude;

  const Location(this.name, this.latitude, this.longitude);

  // Two locations are the same if they have the same name.
  @override
  bool operator ==(Object other) => other is Location && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

const List<Location> philippineCities = [
  Location('Cebu City', 10.3157, 123.8854),
  Location('Manila', 14.5995, 120.9842),
  Location('Quezon City', 14.6760, 121.0437),
  Location('Iloilo City', 10.7202, 122.5621),
  Location('Bacolod', 10.6765, 122.9509),
  Location('Davao City', 7.1907, 125.4553),
  Location('Cagayan de Oro', 8.4542, 124.6319),
  Location('Zamboanga City', 6.9214, 122.0790),
  Location('Baguio', 16.4023, 120.5960),
];