import 'package:flutter/material.dart';
import 'package:meteo/presentation/screens/favorie_screen.dart';
import 'package:meteo/presentation/screens/setting_screen.dart';

// Créez un écran séparé pour le contenu de la page d'accueil
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sunny, size: 100, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Bienvenue dans votre application météo !',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Sélectionnez une ville pour voir la météo',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectIndex = 0;

  // Liste des pages - NE PAS inclure HomeScreen() pour éviter la récursion
  List<Widget> pages = [
    HomeContentScreen(), // Utilisez HomeContentScreen au lieu de HomeScreen
    const FavoriteScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil - Météo'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {},
            tooltip: 'Changer de langue',
          ),
        ],
      ),
      body: pages[selectIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Exemple: Rafraîchir la météo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Météo rafraîchie !'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectIndex,
        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
