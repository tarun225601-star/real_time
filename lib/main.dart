import 'package:flutter/material.dart';

void main() {
  runApp(const NextLevelCalculatorApp());
}

class NextLevelCalculatorApp extends StatelessWidget {
  const NextLevelCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIP Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'sans-serif',
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _input = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isFinished = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _output = '0';
        _input = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isFinished = false;
      } else if (value == '⌫') {
        if (_output.isNotEmpty && _output != '0') {
          _output = _output.substring(0, _output.length - 1);
          if (_output.isEmpty || _output == '-') {
            _output = '0';
          }
        }
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _num1 = double.tryParse(_output) ?? 0;
        _operand = value;
        _input = _output + ' ' + _operand;
        _output = '0';
      } else if (value == '=') {
        _num2 = double.tryParse(_output) ?? 0;
        if (_operand == '+') {
          _output = (_num1 + _num2).toString();
        } else if (_operand == '-') {
          _output = (_num1 - _num2).toString();
        } else if (_operand == '×') {
          _output = (_num1 * _num2).toString();
        } else if (_operand == '÷') {
          _output = _num2 != 0 ? (_num1 / _num2).toString() : 'Error';
        }
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
        _input = '';
        _operand = '';
        _isFinished = true;
      } else {
        if (_output == '0' || _isFinished) {
          _output = value;
          _isFinished = false;
        } else {
          _output += value;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? textColor, Color? bgColor}) {
    bool isOperator = text == '+' || text == '-' || text == '×' || text == '÷' || text == '=';
    bool isTopAction = text == 'AC' || text == '⌫' || text == '%';

    Color defaultBg = isOperator
        ? const Color(0xFF6366F1)
        : isTopAction
            ? const Color(0xFF334155)
            : const Color(0xFF1E293B);

    Color defaultTextCol = isOperator
        ? Colors.white
        : isTopAction
            ? const Color(0xFF38BDF8)
            : Colors.white;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onButtonPressed(text),
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white24,
            child: Ink(
              decoration: BoxDecoration(
                color: bgColor ?? defaultBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                gradient: isOperator
                    ? const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? defaultTextCol,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar Branding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'VIP STUDIO',
                    style: TextStyle(
                      color: Color(0xFF38BDF8),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.fingerprint, color: Color(0xFF38BDF8)),
                ],
              ),
            ),
            
            // Display Screen Section
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _input,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _output,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Keypad Section
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF111827),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(child: Row(children: [_buildButton('AC'), _buildButton('⌫'), _buildButton('%'), _buildButton('÷')])),
                    Expanded(child: Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('×')])),
                    Expanded(child: Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('-')])),
                    Expanded(child: Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('+')])),
                    Expanded(child: Row(children: [_buildButton('00'), _buildButton('0'), _buildButton('.'), _buildButton('=')])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
