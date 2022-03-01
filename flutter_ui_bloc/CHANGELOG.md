## [0.7.3]
- General improve on `UploadFileFieldBlocBuilder`

## [0.7.2]
- First implementation of error translations

## [0.7.1]
- Fixed FileValidation when user insert a different upper/lower case
- Fixed not show heic type

## [0.7.0]
- Removed `ChipGroupFieldBlocBuilder` and `SliderFieldBlocBuilder` because they are now present in `flutter_form_bloc` package

## [0.6.2]
- Align `RequiredValidation` to `ValidationParser`
- Add `Validation.none` and `Validation.composite`

## [0.6.1]
- Add `Validation` class and more validations, now you can validate our fields.
  - `RequiredValidation`: It allows you to convert a field from null to non-null
  - `ValidationParser`: It allows you to convert a field from an `x` type to a` y` type, (stringToInt, stringToDouble, stringToRational)
  - `EqualityValidation`: It allows you to compare two values
  - `TextValidation`: It allows to validate a text field such as the length or if it is match with a regexp
  - `NumberValidation`: It allows you to validate a field of type `num`, `int`, `double`
  - `OptionsValidation`: It allows you to validate a list of options
  - `FileValidation`: It allows you to validate a file by checking its extension

## [0.6.0]
- Jump to flutter_form_bloc: `0.29.0`
- Simplify the buttons to submit

## [0.5.3]
- Fix not change tab on `TabBarControllerFieldBlocProvider`

## [0.5.2]
- Added `SubmitButtonFormBlocBuilder.willSubmit` 

## [0.5.1]
- upgrade pure_extension: ^4.0.0

## [0.5.0]
- Update provider version to `^6.0.0`
- Align code to flutter lints

## [0.4.5]
- Improve on `SubmitButtonFormBlocBuilder` step validation
- Added colors on `SliderFieldBlocBuilder`

## [0.4.4]
- Now you can pass to the `SubmitButtonFormBlocBuilder` the step that must be validated in order to submit
- `SubmitFloatingButtonFormBlocBuilder` and `SubmitIconButtonFormBlocBuilder` names aligned

## [0.4.3]
You can use one of these widgets to build your ui based on the `TabBar` widget and the `SelectFieldBloc`:
- TabBarControllerFieldBlocProvider
- TabBarFieldBlocBuilder
- TabBarViewFieldBlocBuilder

## [0.4.2]
- First implementation of [UploadFileFieldBlocBuilder]

## [0.4.1]
- Add error on slider

## [0.4.0]
- Improved documentation and code style 

## [0.3.0]
- Improved fields with `readOnly` attribute
- Removed `file_picker` and `image_picker` dependencies and moved it to `cross_file_picker`

## [0.2.0]
- Migrated to null-safety

## [0.1.2]
- Release `SubmitButtonFormBlocBuilder`

## [0.1.1]
- Update dependencies

## [0.1.0]
- Replaced **ReadableField** with **XFile** of [cross_file](https://pub.dev/packages/cross_file) package

## [0.0.3]
- Fix `AddChekSuffixInputFieldBlocBuilder` and improved it.

## [0.0.2]
- Fix field pickers.

## [0.0.1]
- Initial release.
