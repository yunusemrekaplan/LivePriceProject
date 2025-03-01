import 'package:flutter/material.dart';
import 'package:live_price_frontend/modules/parities/models/parity_model.dart';

class ParityForm extends StatefulWidget {
  final ParityModel? parity;
  final Function(Map<String, dynamic>) onSubmit;

  const ParityForm({
    super.key,
    this.parity,
    required this.onSubmit,
  });

  @override
  State<ParityForm> createState() => _ParityFormState();
}

class _ParityFormState extends State<ParityForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _symbolController;
  late final TextEditingController _orderIndexController;
  late bool _isEnabled;
  late int _parityGroupId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.parity?.name);
    _symbolController = TextEditingController(text: widget.parity?.symbol);
    _orderIndexController =
        TextEditingController(text: widget.parity?.orderIndex.toString());
    _isEnabled = widget.parity?.isEnabled ?? true;
    _parityGroupId = widget.parity?.parityGroupId ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _orderIndexController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'name': _nameController.text,
        'symbol': _symbolController.text,
        'isEnabled': _isEnabled,
        'orderIndex': int.parse(_orderIndexController.text),
        'parityGroupId': _parityGroupId,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.parity == null ? 'Yeni Parite' : 'Pariteyi Düzenle',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Parite Adı',
              hintText: 'Örn: Gram Altın',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Parite adı gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _symbolController,
            decoration: const InputDecoration(
              labelText: 'Sembol',
              hintText: 'Örn: XAU/TRY',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Sembol gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _orderIndexController,
            decoration: const InputDecoration(
              labelText: 'Sıra',
              hintText: 'Örn: 1',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Sıra gerekli';
              }
              if (int.tryParse(value) == null) {
                return 'Geçerli bir sayı girin';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Aktif'),
            value: _isEnabled,
            onChanged: (value) => setState(() => _isEnabled = value),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(widget.parity == null ? 'Oluştur' : 'Güncelle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
