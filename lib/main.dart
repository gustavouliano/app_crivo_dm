import 'package:flutter/material.dart';

void main() => runApp(const ExemploInicial());

class ExemploInicial extends StatelessWidget {
  const ExemploInicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 0, 150, 136),
              secondary: Color.fromARGB(255, 255, 193, 7)),
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder()),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 193, 7),
                  foregroundColor: Colors.white))),
      home: const BottomNavController(),
    );
  }
}

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _currentPage = 0;

  final List<Widget> _pages = const [
    DescricaoApp(),
    VerificarPrimo(),
    GerarPrimos(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Descrição"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: "Verificar Primo"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate), label: "Calcular Primos"),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}

class DescricaoApp extends StatelessWidget {
  const DescricaoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/eratostenes.png', height: 120),
            const Text(
              "Aplicativo dos Números Primos!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Seguintes ações possíveis: Verificar se um número é primo (1ª Tela) e Calcular todos os números primos até um valor limite (Algoritmo Crivo de Eratóstenes).",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class VerificarPrimo extends StatefulWidget {
  const VerificarPrimo({Key? key}) : super(key: key);

  @override
  State<VerificarPrimo> createState() => _VerificarPrimoState();
}

class _VerificarPrimoState extends State<VerificarPrimo> {
  final TextEditingController _controller = TextEditingController();
  String _resultado = '';

  bool _isPrimo(int valor) {
    if (valor < 2) return false;
    for (int i = 2; i * i <= valor; i++) {
      if (valor % i == 0) return false;
    }
    return true;
  }

  _verificar() {
    setState(() {
      int? numero = int.tryParse(_controller.text);
      if (numero == null) {
        _resultado = "Digite um valor válido.";
      } else {
        _resultado = _isPrimo(numero)
            ? "$numero é um número primo."
            : "$numero não é um número primo.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Digite o valor",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _verificar,
            child: const Text("Verificar Primo"),
          ),
          const SizedBox(height: 20),
          Text(
            _resultado,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GerarPrimos extends StatefulWidget {
  const GerarPrimos({Key? key}) : super(key: key);

  @override
  State<GerarPrimos> createState() => _GerarPrimosState();
}

class _GerarPrimosState extends State<GerarPrimos> {
  final TextEditingController _controller = TextEditingController();
  List<int> _primos = [];

  List<int> _crivoDeEratostenes(int n) {
    if (n < 2) return [];
    List<bool> primoList = List.filled(n + 1, true);
    primoList[0] = primoList[1] = false;
    for (int i = 2; i * i <= n; i++) {
      if (primoList[i]) {
        for (int j = i * i; j <= n; j += i) {
          primoList[j] = false;
        }
      }
    }

    List<int> primos = [];
    for (int i = 2; i <= n; i++) {
      if (primoList[i]) {
        primos.add(i);
      }
    }
    return primos;
  }

  void _gerar() {
    setState(() {
      int? limite = int.tryParse(_controller.text);
      if (limite == null || limite < 2) {
        _primos = [];
      } else {
        _primos = _crivoDeEratostenes(limite);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Digite o limite",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _gerar,
            child: const Text("Gerar Primos"),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Text(
              _primos.isEmpty
                  ? "Nenhum número primo gerado."
                  : "Primos: ${_primos.join(', ')}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
