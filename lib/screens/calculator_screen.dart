import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _input = '';
  String _operator = '';
  double _num1 = 0;
  double _num2 = 0;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        if (_input.isEmpty || _operator.isEmpty) return;
        _num2 = double.tryParse(_input) ?? 0;
        switch (_operator) {
          case '+':
            _output = (_num1 + _num2).toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
            break;
          case '-':
            _output = (_num1 - _num2).toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
            break;
          case '*':
            _output = (_num1 * _num2).toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
            break;
          case '/':
            if (_num2 == 0) {
              _output = 'Error';
            } else {
              _output = (_num1 / _num2).toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
            }
            break;
        }
        _input = _output;
        _operator = '';
      } else if (buttonText == 'C') {
        _output = '0';
        _input = '';
        _num1 = 0;
        _num2 = 0;
        _operator = '';
      } else if (['+', '-', '*', '/'].contains(buttonText)) {
        if (_input.isNotEmpty) {
          _num1 = double.tryParse(_input) ?? 0;
          _operator = buttonText;
          _input = '';
        }
      } else {
        if (_output == 'Error') {
          _input = buttonText;
          _output = buttonText;
        } else {
          _input += buttonText;
          _output = _input;
        }
      }
    });
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(text),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: ['+', '-', '*', '/', '='].contains(text)
                ? Theme.of(context).primaryColor
                : null,
          ),
          child: Text(text, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: Text(
              _output,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 48),
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/')]),
                  Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('*')]),
                  Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-')]),
                  Row(children: [_buildButton('C'), _buildButton('0'), _buildButton('='), _buildButton('+')]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}