// lib/search_delegate.dart

import 'package:flutter/material.dart';

const List<String> cityList = [
  // Provinsi Banten
  'Serang',
  'Cilegon',
  'Tangerang',
  'Tangerang Selatan',
  'Pandeglang',
  'Lebak',

  // Provinsi DKI Jakarta
  'Jakarta',

  // Provinsi Jawa Barat
  'Bandung',
  'Bekasi',
  'Bogor',
  'Depok',
  'Sukabumi',
  'Cirebon',
  'Tasikmalaya',
  'Cimahi',
  'Banjar',
  'Karawang',
  'Subang',
  'Purwakarta',
  'Sumedang',
  'Majalengka',
  'Indramayu',
  'Kuningan',
  'Ciamis',
  'Pangandaran',
  'Garut',

  // Provinsi Jawa Tengah
  'Semarang',
  'Surakarta (Solo)',
  'Salatiga',
  'Magelang',
  'Pekalongan',
  'Tegal',
  'Kebumen',
  'Purwokerto',
  'Cilacap',
  'Banyumas',
  'Brebes',
  'Pemalang',
  'Batang',
  'Wonosobo',
  'Temanggung',
  'Kendal',
  'Demak',
  'Grobogan',
  'Pati',
  'Rembang',
  'Blora',
  'Jepara',
  'Kudus',
  'Purwodadi',
  'Klaten',
  'Sragen',
  'Boyolali',
  'Wonogiri',
  'Karanganyar',
  'Sukoharjo',
  'Magelang',

  // Provinsi DI Yogyakarta
  'Yogyakarta',
  'Sleman',
  'Bantul',
  'Gunungkidul',
  'Kulon Progo',

  // Provinsi Jawa Timur
  'Surabaya',
  'Malang',
  'Batu',
  'Kediri',
  'Blitar',
  'Madiun',
  'Mojokerto',
  'Probolinggo',
  'Pasuruan',
  'Jember',
  'Banyuwangi',
  'Situbondo',
  'Bondowoso',
  'Lumajang',
  'Tulungagung',
  'Trenggalek',
  'Nganjuk',
  'Ngawi',
  'Bojonegoro',
  'Tuban',
  'Lamongan',
  'Gresik',
  'Sidoarjo',
  'Jombang',
  'Mojokerto',
  'Pacitan',
  'Ponorogo',
  'Magetan',
  'Madiun',
  'Bangkalan',
  'Sampang',
  'Pamekasan',
  'Sumenep'
];

class CitySearchDelegate extends SearchDelegate {
  final Function(String) onCitySelected;

  CitySearchDelegate(this.onCitySelected);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onCitySelected(query);
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = cityList.where((city) {
      return city.toLowerCase().startsWith(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.location_city),
          title: Text(suggestions[index]),
          onTap: () {
            onCitySelected(suggestions[index]);
            close(context, null);
          },
        );
      },
    );
  }
}
