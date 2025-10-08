import 'package:calculator_v2/calculateButton.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _firstDigit = '0';
  String _operator = '';
  String _secondDigit = '0';

  void _onDigit(String digit) {
    setState(() {
      if (_operator.isEmpty) {
        if (_firstDigit == '0') {
          _firstDigit = digit;
        } else {
          _firstDigit += digit;
        }
      } else {
        if (_secondDigit == '0') {
          _secondDigit = digit;
        } else {
          _secondDigit += digit;
        }
      }
      _display =
          _firstDigit + _operator + (_operator.isEmpty ? '' : _secondDigit);
    });
  }

  void _onOperator(String sign) {
    setState(() {
      _operator = sign;
      _display =
          _firstDigit + _operator + (_secondDigit == '0' ? '' : _secondDigit);
    });
  }

  void _onToggleSign() {
    setState(() {
      if (_operator.isEmpty) {
        if (_firstDigit.contains('-')) {
          _firstDigit = _firstDigit.replaceAll('-', "");
        } else {
          _firstDigit = "-$_firstDigit";
        }
        _display = _firstDigit;
      } else {
        if (_secondDigit.contains('-')) {
          _secondDigit = _secondDigit.replaceAll('-', "");
        } else {
          _secondDigit = "-$_secondDigit";
        }
        _display = _firstDigit + _operator + _secondDigit;
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (_operator.isEmpty) {
        if (_firstDigit.contains('.')) {
          return;
        } else {
          _firstDigit += '.';
          _display += '.';
        }
      } else {
        if (_secondDigit.contains('.')) {
          return;
        } else {
          _secondDigit += '.';
          _display += '.';
        }
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (_firstDigit == '0') {
        return;
      }
      if (_operator.isEmpty) {
        if (_firstDigit.length > 1) {
          _firstDigit = _firstDigit.substring(0, _firstDigit.length - 1);
          if (_firstDigit == '-' || _firstDigit == '') {
            _firstDigit = '0';
          }
        } else {
          _firstDigit = '0';
        }
      } else if (_operator.isNotEmpty && _secondDigit == '0') {
        _operator = '';
      } else {
        if (_secondDigit.length > 1) {
          _secondDigit = _secondDigit.substring(0, _secondDigit.length - 1);
          if (_secondDigit == '-' || _secondDigit == '') {
            _secondDigit = '0';
          }
        } else {
          _secondDigit = '0';
        }
      }
      _display = _display.substring(0, _display.length - 1);
    });
  }

  void _onEqual() {
    // Only default secondDigit if it's truly not entered (e.g. still null or '')
    if (_secondDigit.isEmpty && _operator.isNotEmpty) {
      _secondDigit = _firstDigit;
    }

    final firstValue = double.tryParse(_firstDigit) ?? 0;
    final secondValue = double.tryParse(_secondDigit) ?? 0;

    double result;

    switch (_operator) {
      case '+':
        result = firstValue + secondValue;
        break;
      case '-':
        result = firstValue - secondValue;
        break;
      case '*':
        result = firstValue * secondValue;
        break;
      case '/':
        if (secondValue == 0) {
          // Show error on division by zero
          setState(() {
            _display = 'Error';
            _firstDigit = '0';
            _secondDigit = '0';
            _operator = '';
          });
          return;
        }
        result = firstValue / secondValue;
        break;
      default:
        // If no operator, just re-display the number
        setState(() {
          _display = _firstDigit;
        });
        return;
    }

    // Format result to remove .0 if it's a whole number
    final resultStr = result.toString().endsWith('.0')
        ? result.toInt().toString()
        : result.toString();

    setState(() {
      _display = resultStr;
      _firstDigit = resultStr;
      _operator = '';
      _secondDigit = '0';
    });
  }

  void _onClear() {
    setState(() {
      _display = '0';
      _firstDigit = '0';
      _operator = '';
      _secondDigit = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = <List<CalcButton>>[
      [
        CalcButton(label: 'C', type: ButtonType.function, onTap: _onClear),
        CalcButton(label: 'DEL', type: ButtonType.function, onTap: _onDelete),
        CalcButton(
          label: '%',
          type: ButtonType.function,
          onTap: () => _onOperator('/'),
        ),
        CalcButton(
          label: '/',
          type: ButtonType.operator,
          onTap: () => _onOperator('/'),
        ),
      ],
      [
        CalcButton(
          label: '7',
          type: ButtonType.function,
          onTap: () => _onDigit('7'),
        ),
        CalcButton(
          label: '8',
          type: ButtonType.function,
          onTap: () => _onDigit('8'),
        ),
        CalcButton(
          label: '9',
          type: ButtonType.function,
          onTap: () => _onDigit('9'),
        ),
        CalcButton(
          label: '*',
          type: ButtonType.operator,
          onTap: () => _onOperator('*'),
        ),
      ],
      [
        CalcButton(
          label: '4',
          type: ButtonType.function,
          onTap: () => _onDigit('4'),
        ),
        CalcButton(
          label: '5',
          type: ButtonType.function,
          onTap: () => _onDigit('5'),
        ),
        CalcButton(
          label: '6',
          type: ButtonType.function,
          onTap: () => _onDigit('6'),
        ),
        CalcButton(
          label: '-',
          type: ButtonType.operator,
          onTap: () => _onOperator('-'),
        ),
      ],

      [
        CalcButton(
          label: '1',
          type: ButtonType.function,
          onTap: () => _onDigit('1'),
        ),
        CalcButton(
          label: '2',
          type: ButtonType.function,
          onTap: () => _onDigit('2'),
        ),
        CalcButton(
          label: '3',
          type: ButtonType.function,
          onTap: () => _onDigit('3'),
        ),
        CalcButton(
          label: '+',
          type: ButtonType.operator,
          onTap: () => _onOperator('+'),
        ),
      ],
      [
        CalcButton(
          label: '(-)',
          type: ButtonType.function,
          onTap: _onToggleSign,
        ),
        CalcButton(
          label: '0',
          type: ButtonType.function,
          onTap: () => _onDigit('0'),
        ),
        CalcButton(label: '.', type: ButtonType.function, onTap: _onDecimal),
        CalcButton(label: '=', type: ButtonType.operator, onTap: _onEqual),
      ],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Calculator"), centerTitle: true),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(24),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _display,
                    maxLines: 1,
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: buttons
                      .map(
                        (row) => Expanded(
                          child: Row(
                            children: row
                                .map(
                                  (btn) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: CalculateButton(
                                        label: btn.label,
                                        type: btn.type,
                                        onTap: btn.onTap,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
