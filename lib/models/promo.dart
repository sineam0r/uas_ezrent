class PromoModel {
  final String title;
  final String description;
  final String code;
  final dynamic discount;
  final DateTime validUntil;

  PromoModel({
    required this.title,
    required this.description,
    required this.code,
    required this.discount,
    required this.validUntil,
  });
}