// Importación de paquetes necesarios de Flutter
import 'package:flutter/material.dart';
// Importación de las pantallas de la calculadora
import 'calculator_screen.dart';
import 'scientific_calculator_screen.dart';

/**
 * FUNCIÓN PRINCIPAL DE LA APLICACIÓN
 * 
 * Esta es la función que Flutter ejecuta al iniciar la aplicación.
 * runApp() inicia la aplicación con el widget MyApp como raíz.
 */
void main() {
  runApp(const MyApp());
}

/**
 * CLASE PRINCIPAL DE LA APLICACIÓN - MyApp
 * 
 * Esta clase representa toda la aplicación Flutter.
 * Es un Widget sin estado (StatelessWidget) que configura aspectos generales.
 */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /**
   * MÉTODO build - Construye la interfaz de la aplicación
   * 
   * Este método define cómo se ve la aplicación:
   * - MaterialApp: Es el contenedor principal que provee el diseño Material Design
   * - title: Nombre de la aplicación
   * - theme: Configura los colores y estilo visual
   * - home: Define la pantalla inicial (HomeScreen)
   * - debugShowCheckedModeBanner: Oculta la etiqueta de "DEBUG" en esquina superior derecha
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Avanzada',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Usa la versión 3 de Material Design
      ),
      home: const HomeScreen(), // Pantalla de inicio con los botones de selección
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
    );
  }
}

/**
 * PANTALLA DE INICIO - HomeScreen
 * 
 * Esta es la primera pantalla que ve el usuario al abrir la aplicación.
 * Permite elegir entre Calculadora Básica y Calculadora Científica.
 */
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /**
   * MÉTODO build - Construye la pantalla de inicio
   * 
   * Contiene:
   * - AppBar: Barra superior con el título
   * - Body: Cuerpo central con botones de navegación
   * - Dos botones grandes para seleccionar el tipo de calculadora
   * - Texto informativo para el usuario
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BARRA SUPERIOR DE LA APLICACIÓN
      appBar: AppBar(
        title: const Text('Calculadora Avanzada'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      // CUERPO PRINCIPAL DE LA PANTALLA
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
          children: [
            // =============================================
            // BOTÓN 1: CALCULADORA BÁSICA
            // =============================================
            ElevatedButton(
              // ACCIÓN AL PRESIONAR EL BOTÓN
              onPressed: () {
                // Navegación a la pantalla de Calculadora Básica
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalculatorScreen()),
                );
              },
              // ESTILO DEL BOTÓN
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Color de fondo morado
                foregroundColor: Colors.white,      // Color del texto blanco
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Espaciado interno
                textStyle: const TextStyle(fontSize: 18), // Tamaño de texto
              ),
              child: const Text('Calculadora Básica'),
            ),
            
            // ESPACIO ENTRE BOTONES (separador de 30 pixels)
            const SizedBox(height: 30),
            
            // =============================================
            // BOTÓN 2: CALCULADORA CIENTÍFICA
            // =============================================
            ElevatedButton(
              // ACCIÓN AL PRESIONAR EL BOTÓN
              onPressed: () {
                // Navegación a la pantalla de Calculadora Científica
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScientificCalculatorScreen()),
                );
              },
              // ESTILO DEL BOTÓN (naranja para diferenciarlo)
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,     // Color de fondo naranja
                foregroundColor: Colors.white,      // Color del texto blanco
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Calculadora Científica'),
            ),
            
            // ESPACIO ADICIONAL
            const SizedBox(height: 20),
            
            // =============================================
            // TEXTO INFORMATIVO PARA EL USUARIO
            // =============================================
            const Padding(
              padding: EdgeInsets.all(20.0), // Margen alrededor del texto
              child: Text(
                'Selecciona el tipo de calculadora que deseas usar',
                textAlign: TextAlign.center,   // Texto centrado
                style: TextStyle(
                  fontSize: 16,                // Tamaño de letra mediano
                  color: Colors.grey,          // Color gris para texto secundario
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * RESUMEN DE FUNCIONAMIENTO:
 * 
 * 1. La aplicación inicia con main() que ejecuta MyApp
 * 2. MyApp configura el tema y establece HomeScreen como pantalla inicial
 * 3. HomeScreen muestra dos botones grandes y un texto informativo
 * 4. Al presionar un botón, Navigator.push lleva al usuario a la calculadora seleccionada
 * 5. Cada calculadora (básica/científica) está en archivos separados que se importan
 * 
 * CONCEPTOS CLAVE PARA ENTENDER:
 * - Widget: Elemento básico de interfaz en Flutter (como un componente)
 * - StatelessWidget: Widget que no cambia su estado (es estático)
 * - BuildContext: Contexto de construcción que contiene información de ubicación en el árbol de widgets
 * - Navigator: Sistema de navegación entre pantallas
 * - MaterialPageRoute: Define una transición de pantalla con animación Material Design
 */
