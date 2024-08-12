import 'package:flutter/material.dart';
import 'package:agoy_weather/screens/favorites_screen.dart';
import 'package:agoy_weather/screens/settings_screen.dart';
import 'package:agoy_weather/services/weather_service.dart';
import 'package:agoy_weather/search_delegate.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  Map<String, dynamic>? forecastData;
  List<String> favoriteCities = [];
  String city = 'Jakarta';
  int _selectedIndex = 0;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
    fetchForecastData();
  }

  void fetchWeatherData() async {
    try {
      var data = await weatherService.fetchWeather(city);
      if (data['cod'] == "404") {
        _showCityNotFoundDialog();
      } else {
        setState(() {
          weatherData = data;
        });
      }
    } catch (e) {
      setState(() {
        weatherData = {'error': 'Failed to load weather data'};
      });
    }
  }

  void fetchForecastData() async {
    try {
      var data = await weatherService.fetchForecast(city);
      if (data['cod'] == "404") {
        _showCityNotFoundDialog();
      } else {
        setState(() {
          forecastData = data;
        });
      }
    } catch (e) {
      setState(() {
        forecastData = {'error': 'Failed to load forecast data'};
      });
    }
  }

  void _searchCity(String cityName) {
    setState(() {
      city = cityName;
      weatherData = null;
      forecastData = null;
    });
    fetchWeatherData();
    fetchForecastData();
  }

  void _showCityNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('City Not Found'),
          content: Text('The city you entered could not be found. Please try searching for another city.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                showSearch(context: context, delegate: CitySearchDelegate(_searchCity));
              },
            ),
          ],
        );
      },
    );
  }

  String _getBackgroundImage() {
    if (weatherData == null || weatherData!.containsKey('error')) {
      return 'assets/images/clear.jpg'; // Default
    }

    String weatherMain = weatherData!['weather'][0]['main'].toLowerCase();

    switch (weatherMain) {
      case 'clear':
        return 'assets/images/clear.jpg';
      case 'rain':
        return 'assets/images/rain.jpg';
      case 'clouds':
        return 'assets/images/clouds.jpg';
      case 'snow':
        return 'assets/images/snow.jpg';
      case 'thunderstorm':
        return 'assets/images/thunderstorm.jpg';
      default:
        return 'assets/images/clear.jpg';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritesScreen(
            favoriteCities: favoriteCities,
            onCitySelected: _searchCity,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(
            isDarkMode: isDarkMode,
            onDarkModeChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
        ),
      );
    }
  }

  void _toggleFavorite() {
    setState(() {
      if (favoriteCities.contains(city)) {
        favoriteCities.remove(city);
      } else {
        favoriteCities.add(city);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Agoy Weather',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CitySearchDelegate(_searchCity),
                );
              },
            ),
            IconButton(
              icon: Icon(
                favoriteCities.contains(city) ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _getBackgroundImage(),
              fit: BoxFit.cover,
            ),
            weatherData == null
                ? Center(child: CircularProgressIndicator())
                : weatherData!.containsKey('error')
                    ? Center(child: Text('Error: ${weatherData!['error']}'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: kToolbarHeight + 20),
                            _buildWeatherHeader(context),
                            SizedBox(height: 20),
                            _buildWeatherDetailsHorizontal(),
                            SizedBox(height: 20),
                            _buildHourlyForecast(),
                            SizedBox(height: 20),
                            _build5DayForecast(),  // Ditambahkan 5-day forecast
                          ],
                        ),
                      ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildWeatherHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: CitySearchDelegate(_searchCity));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.redAccent, size: 30),
                  SizedBox(width: 10),
                  Text(
                    weatherData!['name'],
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              Icon(Icons.edit_location, color: Colors.white, size: 30),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          '${weatherData!['main']['temp']}°',
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        Text(
          weatherData!['weather'][0]['description'],
          style: TextStyle(
            fontSize: 22,
            color: Colors.white70,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailsHorizontal() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildWeatherInfoTile('Humidity', '${weatherData!['main']['humidity']}%', Icons.water_drop),
          _buildWeatherInfoTile('Wind Speed', '${weatherData!['wind']['speed']} m/s', Icons.air),
          _buildWeatherInfoTile('Pressure', '${weatherData!['main']['pressure']} hPa', Icons.speed),
          _buildWeatherInfoTile('Visibility', '${weatherData!['visibility'] / 1000} km', Icons.visibility),
          _buildWeatherInfoTile('UV Index', 'N/A', Icons.wb_sunny), // UV index tidak tersedia dari API ini
          _buildWeatherInfoTile('Cloudiness', '${weatherData!['clouds']['all']}%', Icons.cloud),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildHourlyForecastTile('Now', '${weatherData!['main']['temp']}°', weatherData!['weather'][0]['icon']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecastTile(String time, String temperature, String icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 5),
          Image.network(
            'https://openweathermap.org/img/w/$icon.png',
            width: 50,
            height: 50,
          ),
          SizedBox(height: 5),
          Text(
            temperature,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _build5DayForecast() {
    if (forecastData == null) {
      return Container();
    }

    List<dynamic> forecastList = forecastData!['list'];
    Map<String, List<dynamic>> dailyForecasts = {};

    for (var forecast in forecastList) {
      String date = DateFormat('EEEE').format(DateTime.parse(forecast['dt_txt']));
      if (!dailyForecasts.containsKey(date)) {
        dailyForecasts[date] = [];
      }
      dailyForecasts[date]!.add(forecast);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dailyForecasts.keys.map((date) {
        var dailyTemps = dailyForecasts[date]!
            .map((item) => item['main']['temp'])
            .cast<double>()
            .toList();
        var avgTemp = dailyTemps.reduce((a, b) => a + b) / dailyTemps.length;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Image.network(
              'https://openweathermap.org/img/w/${dailyForecasts[date]![0]['weather'][0]['icon']}.png',
              width: 50,
              height: 50,
            ),
            title: Text(date),
            subtitle: Text('Average Temp: ${avgTemp.toStringAsFixed(1)}°C'),
          ),
        );
      }).toList(),
    );
  }
}
