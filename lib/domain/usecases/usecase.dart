import '../../core/utils/typedef.dart';

abstract class UseCase<Type, Params> {
  const UseCase();
  ResultFuture<Type> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();
  ResultFuture<Type> call();
}

class NoParams {
  const NoParams();
}
