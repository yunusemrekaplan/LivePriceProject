import 'base_dto.dart';

abstract class BaseAuditableDto extends BaseDto {
  final DateTime? createdAt;
  final int? createdById;
  final DateTime? updatedAt;
  final int? updatedById;

  BaseAuditableDto({
    required super.id,
    this.createdAt,
    this.createdById,
    this.updatedAt,
    this.updatedById,
  });
}
