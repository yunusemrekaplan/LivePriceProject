import 'package:flutter/material.dart';
import 'package:live_price_frontend/modules/customers/models/customer_model.dart';

class CustomerForm extends StatefulWidget {
  final CustomerModel? customer;
  final Function(Map<String, dynamic>) onSubmit;

  const CustomerForm({
    super.key,
    this.customer,
    required this.onSubmit,
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'name': _nameController.text,
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
            widget.customer == null ? 'Yeni Müşteri' : 'Müşteriyi Düzenle',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Müşteri Adı',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Müşteri adı gerekli';
              }
              return null;
            },
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
                child: Text(widget.customer == null ? 'Oluştur' : 'Güncelle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
