class StateModel<T>{
  StateModel._();
  factory StateModel.success(T value) = SuccessState<T>;
  factory StateModel.error(T msg) = ErrorState<T>;
}

class ErrorState<T> extends StateModel<T> {
  ErrorState(this.msg) : super._();
  final T msg;
}

class SuccessState<T> extends StateModel<T> {
  SuccessState(this.value) : super._();
  final T value;
}