class ValidarSenha {
  bool validarSenha(String senha) {
    if (senha.length < 6) {
      return false;
    }
    if (!senha.contains(RegExp(r'\d'))) {
      return false;
    }
    if (!senha.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!senha.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (!senha.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return false;
    }
    if (senha.contains(RegExp(r'\s'))) {
      return false;
    }
    return true;
  }
}
