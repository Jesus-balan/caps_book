import 'package:bloc/bloc.dart';
import 'package:caps_book/features/data/model/login_model.dart';
import 'package:caps_book/features/data/repositories/login_repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<LoginAuthEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final success = await loginRepository.login(event.login);
        emit(LoginSuccess(success));
      } 
      catch (e) {
        emit(LoginFailure("Invalid email or password"));
      }
    });
  }
}
