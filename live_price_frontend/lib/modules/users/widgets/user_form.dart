import 'package:flutter/material.dart';
import 'package:live_price_frontend/modules/users/models/user_model.dart';

class UserForm extends StatefulWidget {
  final UserModel? user;
  final Function(Map<String, dynamic>) onSubmit;

  const UserForm({
    super.key,
    this.user,
    required this.onSubmit,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late UserRole _role;
  late int? _customerId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name);
    _surnameController = TextEditingController(text: widget.user?.surname);
    _usernameController = TextEditingController(text: widget.user?.username);
    _emailController = TextEditingController(text: widget.user?.email);
    _passwordController = TextEditingController();
    _role = widget.user?.role ?? UserRole.customer;
    _customerId = widget.user?.customerId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameController.text,
        'surname': _surnameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'role': _role.name,
        'customerId': _customerId,
      };

      if (_passwordController.text.isNotEmpty) {
        data['password'] = _passwordController.text;
      }

      widget.onSubmit(data);
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
            widget.user == null ? 'Yeni Kullanıcı' : 'Kullanıcıyı Düzenle',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Ad',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ad gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _surnameController,
            decoration: const InputDecoration(
              labelText: 'Soyad',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Soyad gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Kullanıcı Adı',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kullanıcı adı gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'E-posta',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'E-posta gerekli';
              }
              if (!value.contains('@')) {
                return 'Geçerli bir e-posta adresi girin';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: widget.user == null ? 'Şifre' : 'Yeni Şifre',
              helperText: widget.user != null
                  ? 'Boş bırakırsanız şifre değişmez'
                  : null,
            ),
            obscureText: true,
            validator: (value) {
              if (widget.user == null && (value == null || value.isEmpty)) {
                return 'Şifre gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<UserRole>(
            value: _role,
            decoration: const InputDecoration(
              labelText: 'Rol',
            ),
            items: UserRole.values
                .map(
                  (role) => DropdownMenuItem(
                    value: role,
                    child: Text(role.displayName),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _role = value);
              }
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
                child: Text(widget.user == null ? 'Oluştur' : 'Güncelle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
