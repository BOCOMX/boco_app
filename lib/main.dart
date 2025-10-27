// Importaciones de paquetes de Flutter y librerías necesarias
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Importaciones de pantallas de la aplicación
import 'screens/home_screen.dart';
import 'screens/adopt_screen.dart';
import 'screens/locations_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth/forgot_password_screen.dart';

// Definición de colores principales de la aplicación
const Color primaryColor = Color(0xFF1C1C1C); // Color negro oscuro principal
const Color secondaryColor = Color(0xFFFF678D); // Color rosa para elementos destacados

// Función principal de arranque de la aplicación
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Fondo blanco para la barra de estado
      statusBarIconBrightness: Brightness.dark, // Iconos oscuros
      statusBarBrightness: Brightness.light, // Para iOS
    ),
  );
  runApp(
    ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: const MyApp(),
    ),
  );
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Elimina el glow/overscroll
  }
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOCO', // Título de la aplicación

      // Configuración de localización (idiomas soportados)
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español
        const Locale('en', 'US'), // Inglés
      ],
      locale: const Locale('es', 'ES'), // Idioma por defecto

      // Configuración del tema de la aplicación
      theme: ThemeData(
        fontFamily: 'Nunito', // Fuente principal
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white, // Fondo blanco
        colorScheme: ColorScheme.fromSeed(
          seedColor: secondaryColor,
          primary: secondaryColor,
          secondary: secondaryColor,
          surface: Colors.white,      // Fondo blanco para superficies
          background: Colors.white,   // Fondo blanco general
          onSurface: Colors.black,    // Texto sobre superficies
          brightness: Brightness.light,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white, // Fondo blanco para los diálogos
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // Opcional
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white, // Fondo blanco para menús contextuales
        ),
        // Configuración del calendario y reloj
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white, // Fondo blanco
          surfaceTintColor: Colors.transparent, // Evita tintes de color
        ),

        timePickerTheme: const TimePickerThemeData(
          backgroundColor: Colors.white, // Fondo blanco
          dialBackgroundColor: Colors.white, // Fondo blanco en el selector de hora
          hourMinuteColor: Colors.white,
        ),

        // Tema de botones con color rosa
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
          ),
        ),

        // Configuración de switches y controles
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return secondaryColor;
            }
            return Colors.grey;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return secondaryColor.withOpacity(0.5);
            }
            return Colors.grey.withOpacity(0.5);
          }),
        ),

        // Tema de iconos
        iconTheme: const IconThemeData(color: primaryColor),

        // Tema de selección de texto
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: secondaryColor,
          selectionColor: Color(0xFFFFA0B5),
          selectionHandleColor: secondaryColor,
        ),
      ),

      // Pantalla inicial (se recomienda cambiar por AuthChecker)
      home: const AuthChecker(), // Verificamos si el usuario está logueado y aceptó términos (cambiar MyHomePage por AuthChecker)

      // Rutas de navegación predefinidas
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/messages': (context) => const MessagesScreen(),
      },
    );
  }
}

// Clase para verificar el estado de autenticación y términos
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoggedIn = false;
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Método para verificar el estado de inicio de sesión
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool acceptedTerms = prefs.getBool('acceptedTerms') ?? false;

    setState(() {
      _isLoggedIn = loggedIn;
      _acceptedTerms = acceptedTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lógica de navegación basada en estado de autenticación
    if (!_isLoggedIn) {
      return const LoginScreen();
    } else if (!_acceptedTerms) {
      return const WelcomeScreen();
    } else {
      return const MyHomePage();
    }
  }
}

// Clase de la página principal de la aplicación
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Índice de la pantalla seleccionada en la navegación inferior
  int _selectedIndex = 0;

  // Lista de pantallas para la navegación
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const AdoptScreen(),
    const LocationsScreen(),
    const ProfileScreen(),
  ];

  // Método para cambiar la pantalla seleccionada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior personalizada
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo de la aplicación
                  Text(
                    'BOCO',
                    style: TextStyle(
                      fontFamily: 'OrganicBrand',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  // Iconos de notificaciones y mensajes
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble),
                        onPressed: () {
                          Navigator.pushNamed(context, '/messages');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Cuerpo principal de la aplicación
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Inicio", 0),
            _buildNavItem(Icons.pets, "Adoptar", 1),
            _buildNavItem(Icons.location_on, "Lugares", 2),
            _buildNavItem(Icons.account_circle, "Perfil", 3),
          ],
        ),
      ),
    );
  }

  // Método para construir los elementos de la navegación inferior
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono con color diferente según esté seleccionado
          Icon(icon, color: isSelected ? primaryColor : Colors.grey),
          // Punto indicador de selección
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              height: 5,
              width: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}