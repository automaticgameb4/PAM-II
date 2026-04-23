import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'detalhes_page.dart';
import 'services/usuario_service.dart';
import 'services/carrinho_service.dart';
import 'login_page.dart';
import 'carrinho_page.dart';
import 'favoritos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Produto> produtos = [
    Produto(id: 1, nome: 'Notebook Gamer', preco: 4599.99, descricao: 'Processador i7, 16GB RAM, SSD 512GB, placa de vídeo dedicada.', imagemUrl: 'https://picsum.photos/seed/notebook/400/300'),
    Produto(id: 2, nome: 'Smartphone Pro', preco: 2999.90, descricao: 'Tela AMOLED 6.7", câmera 108MP, bateria 5000mAh.', imagemUrl: 'https://picsum.photos/seed/phone/400/300'),
    Produto(id: 3, nome: 'Fone Bluetooth', preco: 349.00, descricao: 'Cancelamento de ruído ativo, 30h de bateria, dobrável.', imagemUrl: 'https://picsum.photos/seed/headphone/400/300'),
    Produto(id: 4, nome: 'Teclado Mecânico', preco: 599.00, descricao: 'Switch red, RGB por tecla, anti-ghosting completo.', imagemUrl: 'https://picsum.photos/seed/keyboard/400/300'),
    Produto(id: 5, nome: 'Monitor 27"', preco: 1899.00, descricao: 'Resolução 4K, 144Hz, IPS, HDR400.', imagemUrl: 'https://picsum.photos/seed/monitor/400/300'),
    Produto(id: 6, nome: 'Mouse Sem Fio', preco: 189.90, descricao: '2.4GHz, 1600 DPI, autonomia de 12 meses.', imagemUrl: 'https://picsum.photos/seed/mouse/400/300'),
    Produto(id: 7, nome: 'Webcam Full HD', preco: 279.00, descricao: '1080p 30fps, microfone embutido, plug and play.', imagemUrl: 'https://picsum.photos/seed/webcam/400/300'),
    Produto(id: 8, nome: 'SSD Externo 1TB', preco: 459.00, descricao: 'USB 3.2 Gen2, leitura 1050MB/s, compacto e robusto.', imagemUrl: 'https://picsum.photos/seed/ssd/400/300'),
    Produto(id: 9, nome: 'Cadeira Gamer', preco: 1199.00, descricao: 'Apoio lombar, reclinável 180°, suporta até 120kg.', imagemUrl: 'https://picsum.photos/seed/chair/400/300'),
    Produto(id: 10, nome: 'Hub USB-C 7 em 1', preco: 149.90, descricao: 'HDMI 4K, 3x USB-A, SD card, PD 100W.', imagemUrl: 'https://picsum.photos/seed/hub/400/300'),
  ];

  final _carrinho = CarrinhoService();
  final _favoritos = FavoritosService();

  void _mostrarPerfil() {
    final usuario = UsuarioService().usuarioLogado;
    if (usuario == null) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFF4F46E5),
              child: Text(usuario.nome[0].toUpperCase(), style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Text(usuario.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(usuario.email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  UsuarioService().logout();
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sair da conta', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirCarrinho() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const CarrinhoPage()));
    setState(() {}); // atualiza badge
  }

  void _abrirFavoritos() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritosPage()));
    setState(() {}); // atualiza badge
  }

  void _abrirDetalhes(Produto p) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhesPage(produto: p)));
    setState(() {}); // atualiza badges ao voltar
  }

  @override
  Widget build(BuildContext context) {
    final usuario = UsuarioService().usuarioLogado;
    final primeiroNome = usuario?.nome.split(' ').first ?? 'Usuário';
    final totalCarrinho = _carrinho.totalItens;
    final totalFav = _favoritos.favoritos.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá, $primeiroNome 👋', style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const Text('Catálogo de Produtos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          // Favoritos
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _abrirFavoritos,
                icon: const Icon(Icons.favorite_outline, color: Colors.white),
              ),
              if (totalFav > 0)
                Positioned(
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text('$totalFav', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
          // Carrinho
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _abrirCarrinho,
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              ),
              if (totalCarrinho > 0)
                Positioned(
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text('$totalCarrinho', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
          // Avatar perfil
          GestureDetector(
            onTap: _mostrarPerfil,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 4),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white24,
                child: Text(primeiroNome[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final p = produtos[index];
          final fav = _favoritos.isFavorito(p.id);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _abrirDetalhes(p),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(p.imagemUrl, width: 72, height: 72, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                              GestureDetector(
                                onTap: () { setState(() => _favoritos.toggleFavorito(p)); },
                                child: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? const Color(0xFFEF4444) : Colors.grey, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(p.descricao, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('R\$ ${p.preco.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 15)),
                              GestureDetector(
                                onTap: () {
                                  _carrinho.adicionar(p);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${p.nome} adicionado ao carrinho!'),
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFF4F46E5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      action: SnackBarAction(label: 'Ver', textColor: Colors.white, onPressed: _abrirCarrinho),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(20)),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add_shopping_cart, color: Colors.white, size: 13),
                                      SizedBox(width: 4),
                                      Text('Carrinho', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
