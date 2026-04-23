class Usuario {
  final String nome;
  final String email;
  final String senha;

  Usuario({required this.nome, required this.email, required this.senha});
}

class UsuarioService {
  // Singleton
  static final UsuarioService _instance = UsuarioService._internal();
  factory UsuarioService() => _instance;
  UsuarioService._internal();

  // Lista de usuários salvos (começa com o usuário padrão)
  final List<Usuario> _usuarios = [
    Usuario(nome: 'João', email: 'joao@gmail.com', senha: '1234567'),
  ];

  // Usuário logado atualmente
  Usuario? _usuarioLogado;

  Usuario? get usuarioLogado => _usuarioLogado;

  bool login(String email, String senha) {
    try {
      final usuario = _usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.senha == senha,
      );
      _usuarioLogado = usuario;
      return true;
    } catch (_) {
      return false;
    }
  }

  bool cadastrar(String nome, String email, String senha) {
    // Verifica se e-mail já existe
    final existe = _usuarios.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (existe) return false;

    _usuarios.add(Usuario(nome: nome, email: email, senha: senha));
    return true;
  }

  void logout() {
    _usuarioLogado = null;
  }
}
