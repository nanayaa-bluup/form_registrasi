
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nomorteleponController = TextEditingController();
  final _birthDateController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  DateTime? _selectedDate;
  String? _selectedJenisKelamin;

  bool _isSetujuSyarat = false;

double _passwordStrength = 0.0;
String _passwordStrengthText = '';
Color _passwordStrengthColor = Colors.grey;


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nomorteleponController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

 

void _checkPasswordStrength(String password) {
  setState(() {
    if (password.isEmpty) {
      _passwordStrength = 0.0;
      _passwordStrengthText = '';
      _passwordStrengthColor = Colors.grey;
    } else if (password.length < 8) {
      _passwordStrength = 0.33;
      _passwordStrengthText = 'Lemah password harus mengandung huruf kapital, angka, dan simbol minnimal 8 karakter';
      _passwordStrengthColor = Colors.red;
    } else if (RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])')
        .hasMatch(password) &&
        !RegExp(r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])')
            .hasMatch(password)) {
      _passwordStrength = 0.66;
      _passwordStrengthText = 'Sedang password harus mengandung huruf kapital, angka, dan simbol minnimal 8 karakter';
      _passwordStrengthColor = Colors.orange;
    } else if (RegExp(
      r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])',
    ).hasMatch(password)) {
      _passwordStrength = 1.0;
      _passwordStrengthText = 'Kuat';
      _passwordStrengthColor = Colors.green;
    } else {
      _passwordStrength = 0.33;
      _passwordStrengthText = 'Lemah';
      _passwordStrengthColor = Colors.red;
    }
  });
}

  // Validasi nama
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // Validasi konfirmasi password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Validasi nomor telepon
  String? _validatenomortelepon(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor telepon harus angka';
    }
    if (value.length < 10) {
      return 'Nomor telepon minimal 10 digit';
    }
    if (value.length > 13) {
      return 'Nomor telepon maksimal 13 digit';
    }
    return null;
  }

  // Memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime(today.year - 18, today.month, today.day),
      firstDate: DateTime(1950),
      lastDate: today,
      helpText: 'Pilih Tanggal Lahir',
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  // Handler submit form
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isSetujuSyarat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Anda harus menyetujui Syarat & Ketentuan!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi proses registrasi
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registrasi Berhasil'),
          content: Text(
            'Selamat, ${_nameController.text}!\n'
            'Email: ${_emailController.text}\n'
            'Nomor Telepon: ${_nomorteleponController.text}\n'
            'Tanggal Lahir: ${_birthDateController.text}\n'
            'Jenis Kelamin: $_selectedJenisKelamin\n'
            'Setuju Syarat & Ketentuan: '
            '${_isSetujuSyarat ? "Ya" : "Tidak"}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  // Reset form
  void _resetForm() {
    _formKey.currentState?.reset();

    setState(() {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nomorteleponController.clear();
      _birthDateController.clear();

      _selectedDate = null;
      _selectedJenisKelamin = null;

      _isSetujuSyarat = false;

      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),

                const SizedBox(height: 12),

                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 12),

                // Field Nomor Telepon
                CustomTextField(
                  controller: _nomorteleponController,
                  label: 'Nomor Telepon',
                  hint: 'Masukkan nomor telepon Anda',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validatenomortelepon,
                ),

                const SizedBox(height: 12),

                // Field Tanggal Lahir
                TextFormField(
                  controller: _birthDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: 'Pilih tanggal lahir',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (_selectedDate == null) {
                      return 'Tanggal lahir harus dipilih';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Dropdown Jenis Kelamin
                DropdownButtonFormField<String>(
                  value: _selectedJenisKelamin,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin',
                    prefixIcon: Icon(Icons.people),
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Pilih jenis kelamin'),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _selectedJenisKelamin = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis kelamin harus dipilih';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),


// field password

TextFormField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: const Icon(Icons.lock),
    border: const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    ),
  ),
  validator: _validatePassword,

  
  onChanged: _checkPasswordStrength,
),


const SizedBox(height: 8),
if (_passwordStrengthText.isNotEmpty) ...[
  LinearProgressIndicator(
    value: _passwordStrength,
    backgroundColor: Colors.grey.shade300,
    color: _passwordStrengthColor,
    minHeight: 6,
  ),
  const SizedBox(height: 6),
  Text(
    'Kekuatan Password: $_passwordStrengthText',
    style: TextStyle(
      color: _passwordStrengthColor,
      fontWeight: FontWeight.bold,
    ),
  ),
],
const SizedBox(height: 16),

                // Field Konfirmasi Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                  ),
                ),

                const SizedBox(height: 24),

CheckboxListTile(
                  value: _isSetujuSyarat,
                  onChanged: (value) {
                    setState(() {
                      _isSetujuSyarat = value ?? false;
                    });
                  },
                  title: const Text(
                    'Saya setuju dengan Syarat & Ketentuan',
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),

                const SizedBox(height: 12),

                // Tombol Daftar
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Daftar',
                          style: TextStyle(fontSize: 16),
                        ),
                ),

                const SizedBox(height: 12),

                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
