import 'package:flutter/material.dart';
import 'package:live_price_frontend/modules/parity_groups/models/parity_group_model.dart';

class ParityGroupForm extends StatefulWidget {
  final ParityGroupModel? parityGroup;
  final Function(Map<String, dynamic>) onSubmit;

  const ParityGroupForm({
    super.key,
    this.parityGroup,
    required this.onSubmit,
  });

  @override
  State<ParityGroupForm> createState() => _ParityGroupFormState();
}

class _ParityGroupFormState extends State<ParityGroupForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _orderIndexController;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.parityGroup?.name);
    _orderIndexController =
        TextEditingController(text: widget.parityGroup?.orderIndex.toString());
    _isEnabled = widget.parityGroup?.isEnabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orderIndexController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'name': _nameController.text,
        'isEnabled': _isEnabled,
        'orderIndex': int.parse(_orderIndexController.text),
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
            widget.parityGroup == null
                ? 'Yeni Parite Grubu'
                : 'Parite Grubunu Düzenle',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Grup Adı',
              hintText: 'Örn: Döviz Kurları',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Grup adı gerekli';
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
                child:
                    Text(widget.parityGroup == null ? 'Oluştur' : 'Güncelle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
