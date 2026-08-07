// lib/config/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Colores Institucionales IST Tena
  static const primary = Color(0xFF0F4C81);   // Azul Petróleo Principal
  static const secondary = Color(0xFF0F4C81); // Cian / Verde Agua

  // Backgrounds y Superficies
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;

  // Textos
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const textHint = Color(0xFF9E9E9E);

  // Estados Institucionales (Colores del Isotipo)
  static const success = Color(0xFF8CBF3F);   // Verde Hoja IST Tena
  static const warning = Color(0xFFFFD100);   // Amarillo Hoja IST Tena
  static const error = Color(0xFFD32F2F);

  // Bordes
  static const outline = Color(0xFFE0E0E0);
  static const divider = Color(0xFFEEEEEE);


  // Colores de Apoyo y Modales
  static const overlay = Color(0x80000000);        // Transparencia para fondos de diálogos y modales
  static const shadow = Color(0x0A000000);         // Sombras suaves de cards e inputs
  static const disabled = Color(0xFFCBD5E1);       // Botones u opciones inactivas
  static const textDisabled = Color(0xFF94A3B8);   // Texto sobre elementos deshabilitados

  // Fondos para Badges y Estados (Tonos Soft)
  static const successSoft = Color(0xFFF0FDF4);   // Fondo para badges o contenedores de éxito
  static const warningSoft = Color(0xFFFEFCE8);   // Fondo para badges de registros "En curso"
  static const errorSoft = Color(0xFFFEF2F2);     // Fondo para alertas o contenedores de error
  static const infoSoft = Color(0xFFEFF6FF);      // Fondo para mensajes informativos
  static const info = Color(0xFF3B82F6);           // Color de acento para notificaciones o alertas informativas
}