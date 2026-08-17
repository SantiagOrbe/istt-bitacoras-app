// --- CONFIG & THEME ---
export 'package:bitacoras_app/config/constants/app_colors.dart';
export 'package:bitacoras_app/config/constants/app_sizes.dart';
export 'package:bitacoras_app/config/constants/app_strings.dart';
export 'package:bitacoras_app/config/theme/app_text_styles.dart';
export 'package:bitacoras_app/config/theme/app_theme.dart';
export 'package:bitacoras_app/app/routes/app_routes.dart';


// --- CORE WIDGETS ---
export 'package:bitacoras_app/core/widgets/app_logo.dart';
export 'package:bitacoras_app/core/widgets/buttons/custom_button.dart';
export 'package:bitacoras_app/core/widgets/inputs/custom_text_field.dart';
export 'package:bitacoras_app/core/widgets/inputs/password_text_field.dart';

// --- MODELS GLOBALES / COMUNES ---
export 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
export 'package:bitacoras_app/features/inicio/domain/models/rol_usuario_model.dart';
export 'package:bitacoras_app/features/inicio/domain/models/accion_rapida_model.dart';

// --- FLUTTER & MATERIAL ---
export 'package:flutter/material.dart';

// --- Fake user Repositorio (datos falsos) ---

export 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';

// --- Widgets compartidos por todos los módulos ---
export 'package:bitacoras_app/features/inicio/presentation/widgets/inicio_app_bar.dart';