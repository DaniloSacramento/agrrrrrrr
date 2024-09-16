class ValidarEmail {
  static String? validarEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Por favor, insira um e-mail.';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return 'Digite um e-mail correto ';
    }
    return null;
  }
}
