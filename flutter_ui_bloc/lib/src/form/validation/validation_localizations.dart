import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation_translations.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation_translator.dart';

class ValidationLocalizations extends LocalizationsDelegate<ValidationTranslations> {
  final ValidationTranslator translator;

  const ValidationLocalizations({
    this.translator = const ValidationTranslator(),
  });

  @override
  bool isSupported(Locale locale) {
    return translator.isSupported(locale.languageCode);
  }

  @override
  Future<ValidationTranslations> load(Locale locale) {
    return SynchronousFuture(translator.resolve(locale.languageCode));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<ValidationTranslations> old) {
    return false;
  }

  static ValidationTranslations? maybeOf(BuildContext context) {
    return Localizations.of<ValidationTranslations>(context, ValidationTranslations);
  }

  static ValidationTranslations of(BuildContext context) {
    return Localizations.of<ValidationTranslations>(context, ValidationTranslations)!;
  }

  static String translate(BuildContext context, ValidationError error) {
    final t = ValidationLocalizations.maybeOf(context) ?? const ValidationEnTranslations();

    return t.translate(error);
  }
}
