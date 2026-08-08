class CompanyModel {
  final String id;
  final String name;
  final String ruc;
  final String address;
  final String phone;
  final String email;
  final String legalRepresentative;
  final String agreementNumber; // Número de convenio institucional
  final bool isActive;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.ruc,
    required this.address,
    required this.phone,
    required this.email,
    required this.legalRepresentative,
    required this.agreementNumber,
    this.isActive = true,
  });

  CompanyModel copyWith({
    String? id,
    String? name,
    String? ruc,
    String? address,
    String? phone,
    String? email,
    String? legalRepresentative,
    String? agreementNumber,
    bool? isActive,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ruc: ruc ?? this.ruc,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      legalRepresentative: legalRepresentative ?? this.legalRepresentative,
      agreementNumber: agreementNumber ?? this.agreementNumber,
      isActive: isActive ?? this.isActive,
    );
  }
}