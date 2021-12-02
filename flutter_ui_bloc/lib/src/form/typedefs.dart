import 'package:flutter_form_bloc/flutter_form_bloc.dart';

typedef FormBlocBuilder<TBloc extends FormBloc<TSuccess, TFailure>, TSuccess, TFailure>
    = BlocBuilder<TBloc, FormBlocState<TSuccess, TFailure>>;

typedef FieldBlocRule<TValue, TSuggestions, TExtraData> = SingleFieldBloc<TValue, TSuggestions,
    FieldBlocState<TValue, TSuggestions, TExtraData>, TExtraData>;

typedef SelectFieldBlocBuilder<TValue, TExtraData>
    = BlocBuilder<SelectFieldBloc<TValue, TExtraData>, SelectFieldBlocState<TValue, TExtraData>>;

typedef SelectFieldBlocListener<TValue, TExtraData>
    = BlocListener<SelectFieldBloc<TValue, TExtraData>, SelectFieldBlocState<TValue, TExtraData>>;

typedef ListFieldBlocBuilder<TFieldBloc extends FieldBloc, ExtraData>
    = BlocBuilder<ListFieldBloc<TFieldBloc, ExtraData>, ListFieldBlocState<TFieldBloc, ExtraData>>;
