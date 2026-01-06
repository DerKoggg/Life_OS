import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/shift.dart';
import '../../application/shift_controller.dart';

class AddShiftCard extends ConsumerStatefulWidget {
  const AddShiftCard({super.key});

  @override
  ConsumerState<AddShiftCard> createState() => _AddShiftCardState();
}

class _AddShiftCardState extends ConsumerState<AddShiftCard> {
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool get _canSubmit =>
      _amountController.text.isNotEmpty &&
      double.tryParse(_amountController.text) != null;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _amountField(),
          const SizedBox(height: 12),
          _datePicker(context),
          const SizedBox(height: 16),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _amountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 24, color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Сумма за смену',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _datePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: Text(
        'Дата: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: _canSubmit ? _submit : null,
      child: const Text('Добавить смену'),
    );
  }

  void _submit() {
    final amount = double.parse(_amountController.text);

    ref
        .read(shiftProvider.notifier)
        .addShift(Shift(date: _selectedDate, amount: amount));

    _amountController.clear();
    setState(() => _selectedDate = DateTime.now());
  }
}
