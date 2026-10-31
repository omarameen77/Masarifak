import 'package:json_annotation/json_annotation.dart';

part 'data_envelope.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class DataEnvelope<T> {
  const DataEnvelope({required this.data});

  factory DataEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$DataEnvelopeFromJson(json, fromJsonT);

  final T data;
}
