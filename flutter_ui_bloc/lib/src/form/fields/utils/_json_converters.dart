import 'package:json_annotation/json_annotation.dart';
import 'package:pure_extensions/pure_extensions.dart';

class NullRationalJsonConverter extends JsonConverter<Rational?, String?> {
  const NullRationalJsonConverter();

  @override
  Rational? fromJson(String? json) => json == null ? null : Rational.parse(json);

  @override
  String? toJson(Rational? object) => object == null ? null : object.toString();
}

class RationalJsonConverter extends JsonConverter<Rational, String> {
  const RationalJsonConverter();

  @override
  Rational fromJson(String json) => Rational.parse(json);

  @override
  String toJson(Rational object) => object.toString();
}
