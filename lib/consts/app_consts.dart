class ConstsApi {
  static String baseUrl = 'http://192.168.0.193:8090';

  static void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
  }

  static const String basicAuth = 'Basic bGVvbmFyZG86MTIzNDU2';
  static String get authUsuario => '$baseUrl/api/auth/trivia-checkin-rm';
  static String get checkin => '$baseUrl/api/trivia-checkin-rm/checkin';
  static String get foto => '$baseUrl/api/trivia-checkin-rm/chamado/upload';
  static String get divergenciasApp =>
      '$baseUrl/api/trivia-checkin-rm/divergencias';
  static String get chamadosTipos =>
      '$baseUrl/api/trivia-checkin-rm/chamado/tipos';
  static String get checkiNotaFiscal =>
      '$baseUrl/api/trivia-checkin-rm/checkin/nfs';
  static String get checkinFinalizarConferencia =>
      '$baseUrl/api/trivia-checkin-rm/checkin/finalizar';
  static String get divergenciaRegistrar =>
      '$baseUrl/api/trivia-checkin-rm/divergencias/registrar';
  static String get chamado =>
      '$baseUrl/api/trivia-checkin-rm/chamado/registrar';
  static String get chamadoHistorico =>
      '$baseUrl/api/trivia-checkin-rm/chamados';
  //static const String baseUrl2 = 'http://acesso.triviacloud.com.br';
  static String get alterarSenha =>
      '$baseUrl/api/trivia-checkin-rm/meus-dados/alterar-senha';
  static String get esqueciSenha =>
      '$baseUrl/api/trivia-checkin-rm/esqueci-minha-senha/email';
  static String get excluirConta =>
      '$baseUrl/api/auth/trivia-checkin-rm/inativar';
  static String get excluirFoto =>
      '$baseUrl/api/trivia-checkin-rm/chamado/upload/delete';
  static String get esqueciSenhaToken =>
      '$baseUrl/api/trivia-checkin-rm/esqueci-minha-senha/token/email';
  static String get novaSenhaServiceEsqueci =>
      '$baseUrl/api/auth/trivia-checkin-rm/alterar-senha';
}
