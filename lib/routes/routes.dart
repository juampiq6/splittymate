enum AppRoute {
  splash('/splash'),
  join('/join'),
  login('/login'),
  otpInput('/login/otp_input/:email'),
  finishSignUp('/login/finish_sign_up'),
  home('/'),
  profileSettings('/profile_settings'),
  newSplitGroup('/new_split_group'),
  splitGroupSettings('/split_group_settings/:groupSettingsId'),
  splitGroupHome('/split_group/:groupId'),
  splitGroupBalances('/split_group/:groupId/balances'),
  newExpenseForm('/split_group/:groupId/new_expense'),
  newPaymentForm('/split_group/:groupId/new_payment'),
  transactionDetail('/split_group/:groupId/tx_detail/:txId');

  final String _path;
  const AppRoute(this._path);

  /// Only use this method when assigning the path to a route in the router
  /// This is used to get the path for the nested routes
  String get getNestedPath {
    switch (this) {
      case AppRoute.splash:
      case AppRoute.join:
      case AppRoute.login:
      case AppRoute.home:
        return _path;
      case AppRoute.otpInput:
      case AppRoute.finishSignUp:
        return _path.replaceFirst('/login/', '');
      case AppRoute.profileSettings:
      case AppRoute.newSplitGroup:
      case AppRoute.splitGroupHome:
      case AppRoute.splitGroupSettings:
        return _path.replaceFirst('/', '');
      case AppRoute.splitGroupBalances:
      case AppRoute.newExpenseForm:
      case AppRoute.newPaymentForm:
      case AppRoute.transactionDetail:
        return _path.replaceFirst('/split_group/:groupId/', '');
    }
    // if (_path == '/') return _path;
    // final parts = _path.split('/').reversed;
    // for (var i = 1; i < parts.length; i++) {
    //   final part = parts.elementAt(i - 1);
    //   if (part.startsWith(':')) {
    //     continue;
    //   } else if (part.isNotEmpty) {
    //     return parts.take(i).toList().reversed.join('/');
    //   }
    // }
    // throw Exception('No non-parameter part found in path: $_path');
  }

  /// Method to get the path with parameters replaced
  String path({Map<String, String>? parameters}) {
    if (parameters == null) return _path;
    var resolvedPath = _path;
    parameters.forEach((key, value) {
      resolvedPath = resolvedPath.replaceAll(':$key', value);
    });
    return resolvedPath;
  }
}
