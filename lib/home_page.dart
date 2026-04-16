import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'detalhes_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(produto.imagemUrl),
                ),
                title: Text(
                  produto.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Abrindo ${produto.nome}...'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesPage(produto: produto),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}