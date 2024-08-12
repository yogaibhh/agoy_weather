import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteCities;
  final Function(String) onCitySelected;

  FavoritesScreen({required this.favoriteCities, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Cities'),
      ),
      body: favoriteCities.isEmpty
          ? Center(
              child: Text(
                'No favorite cities yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text(favoriteCities[index]),
                    onTap: () {
                      onCitySelected(favoriteCities[index]);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
    );
  }
}
