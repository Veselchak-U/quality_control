import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';

class BlocProvider<T extends IBloc> extends StatefulWidget {
  BlocProvider({
    @required this.child,
    @required this.bloc,
    Key key,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends IBloc>(BuildContext context) {
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<IBloc>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
