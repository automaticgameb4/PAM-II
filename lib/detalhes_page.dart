import 'package:flutter/material.dart';
import 'models/produto.dart';

class DetalhesPage extends StatelessWidget {
  final Produto produto;

  const DetalhesPage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            produto.imagemUrl,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 250,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text('Descrição:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(produto.descricao, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar ao Catálogo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}