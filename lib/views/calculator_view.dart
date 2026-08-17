import 'package:real_time/controllers/calculator_controller.dart';
import 'package:real_time/models/calculator_model.dart';
import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final CalculatorController _calculatorController = CalculatorController();
  final CalculatorModel _calculatorModel = CalculatorModelImpl(CalculatorController());
  String _expression = '';
  String _result = '';

  void _onButtonTap(String value) {
    setState(() {
      if (value == '=') {
        _result = _calculatorModel.calculate(_expression);
        _expression = '';
      } else if (value == 'C') {
        _expression = '';
        _result = '';
      } else {
        _expression += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 48),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.2,
                children: [
                  _buildButton('7', _onButtonTap),
                  _buildButton('8', _onButtonTap),
                  _buildButton('9', _onButtonTap),
                  _buildButton('/', _onButtonTap),
                  _buildButton('4', _onButtonTap),
                  _buildButton('5', _onButtonTap),
                  _buildButton('6', _onButtonTap),
                  _buildButton('*', _onButtonTap),
                  _buildButton('1', _onButtonTap),
                  _buildButton('2', _onButtonTap),
                  _buildButton('3', _onButtonTap),
                  _buildButton('-', _onButtonTap),
                  _buildButton('0', _onButtonTap),
                  _buildButton('.', _onButtonTap),
                  _buildButton('=', _onButtonTap),
                  _buildButton('+', _onButtonTap),
                  _buildButton('C', _onButtonTap),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value, Function(String) onPressed) {
    return GestureDetector(
      onTap: () => onPressed(value),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}