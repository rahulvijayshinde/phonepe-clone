import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PinInputWidget extends StatefulWidget {
  final int pinLength;
  final Function(String) onPinChanged;
  final Function(String) onPinCompleted;
  final bool isConfirmation;
  final String? errorMessage;

  const PinInputWidget({
    super.key,
    this.pinLength = 4,
    required this.onPinChanged,
    required this.onPinCompleted,
    this.isConfirmation = false,
    this.errorMessage,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  String _pin = '';
  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pinLength; i++) {
      _focusNodes.add(FocusNode());
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && value.length == 1) {
      setState(() {
        _pin = _pin.padRight(widget.pinLength, ' ');
        List<String> pinList = _pin.split('');
        pinList[index] = value;
        _pin = pinList.join('').trim();
      });

      widget.onPinChanged(_pin);

      if (index < widget.pinLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (_pin.length == widget.pinLength) {
          widget.onPinCompleted(_pin);
        }
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onKeyPressed(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
        setState(() {
          List<String> pinList = _pin.padRight(widget.pinLength, ' ').split('');
          pinList[index - 1] = ' ';
          _pin = pinList.join('').trim();
        });
        widget.onPinChanged(_pin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.pinLength, (index) {
            return Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.errorMessage != null
                      ? AppTheme.lightTheme.colorScheme.error
                      : _focusNodes[index].hasFocus
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) => _onKeyPressed(event, index),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  obscureText: true,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  onChanged: (value) => _onDigitChanged(value, index),
                ),
              ),
            );
          }),
        ),
        if (widget.errorMessage != null) ...[
          SizedBox(height: 2.h),
          Text(
            widget.errorMessage!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
