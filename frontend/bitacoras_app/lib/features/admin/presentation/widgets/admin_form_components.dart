import 'package:bitacoras_app/shared/exports.dart';

class AdminFormHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AdminFormHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.infoSoft,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        AppSizes.gapH12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.title.copyWith(fontSize: 20)),
              AppSizes.gapV4,
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminFormSheetBody extends StatelessWidget {
  final Widget child;

  const AdminFormSheetBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: child,
        ),
      ),
    );
  }
}

class AdminValidators {
  static String? requiredText(String? value, {String label = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label es obligatorio.';
    }
    return null;
  }

  static String? letters(String? value, {String label = 'El nombre'}) {
    final required = requiredText(value, label: label);
    if (required != null) return required;
    return RegExp(r'^[A-Za-z ]+$').hasMatch(value!.trim())
        ? null
      : '$label solo puede contener letras sin tildes ni símbolos.';
  }

  static String? lettersWithAccents(
    String? value, {
    String label = 'El nombre',
  }) {
    final required = requiredText(value, label: label);
    if (required != null) return required;
    return RegExp(r'^[\p{L} ]+$', unicode: true).hasMatch(value!.trim())
        ? null
        : '$label solo puede contener letras, tildes y espacios.';
  }

  static String? addressText(
    String? value, {
    String label = 'La dirección',
  }) {
    final required = requiredText(value, label: label);
    if (required != null) return required;
    return RegExp(r'^[\p{L}\d ]+$', unicode: true).hasMatch(value!.trim())
        ? null
        : '$label solo puede contener letras, números y espacios, sin símbolos especiales.';
  }

  static String? careerCode(String? value, {String label = 'El código'}) {
    final required = requiredText(value, label: label);
    if (required != null) return required;
    return RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(value!.trim())
        ? null
        : '$label solo puede contener letras, números, puntos, guiones y guiones bajos.';
  }

  static String? positiveInteger(String? value, {String label = 'El valor'}) {
    final number = int.tryParse(value?.trim() ?? '');
    return number != null && number > 0
        ? null
        : '$label debe ser un número mayor que cero.';
  }

  static String? ecuadorianId(String? value, {String label = 'La cédula'}) {
    final required = requiredText(value, label: label);
    if (required != null) return required;

    final id = value!.trim();
    if (!RegExp(r'^\d{10}$').hasMatch(id)) {
      return '$label debe tener 10 dígitos.';
    }

    final region = int.parse(id.substring(0, 2));
    if (region < 1 || region > 24) {
      return '$label no pertenece a una región válida.';
    }

    var sum = 0;
    for (var index = 0; index < 9; index++) {
      var digit = int.parse(id[index]);
      if (index.isEven) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }

    final verifier = (10 - (sum % 10)) % 10;
    return verifier == int.parse(id[9]) ? null : '$label no es válida.';
  }

  static String? email(String? value) {
    final required = requiredText(value, label: 'El correo');
    if (required != null) return required;
    final email = value!.trim().toLowerCase();
    return RegExp(
      r'^[A-Za-z]+(?:[._-][A-Za-z]+)*@est\.itstena\.edu\.ec$',
    ).hasMatch(email)
        ? null
        : 'Usa solo letras sin tildes ni símbolos y el dominio '
          '@est.itstena.edu.ec.';
  }

  static String? ecuadorianPhone(String? value, {bool required = true}) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) {
      return required ? 'Por favor ingresa un número de teléfono.' : null;
    }
    return RegExp(r'^(09\d{8}|\+5939\d{8})$').hasMatch(phone)
        ? null
        : 'Ingresa un número válido (09XXXXXXXX o +5939XXXXXXXX).';
  }

  static String? unique(
    String? value,
    Iterable<String> existing, {
    String label = 'Este valor',
  }) {
    final normalized = value?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty) return null;
    return existing.any((item) => item.trim().toLowerCase() == normalized)
        ? '$label ya existe.'
        : null;
  }
}

class AdminFormActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const AdminFormActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.save_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        label: Text(label),
      ),
    );
  }
}

class AdminFormSectionLabel extends StatelessWidget {
  final String text;

  const AdminFormSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.sm, bottom: AppSizes.xs),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
