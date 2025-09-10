import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';

class FondosScreen extends StatefulWidget {
  const FondosScreen({super.key});

  @override
  State<FondosScreen> createState() => _FondosScreenState();
}

class _FondosScreenState extends State<FondosScreen> {
  List<Uint8List> fondos = [];
  late Box box;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    box = await Hive.openBox('fondos');
    setState(() {
      fondos = List<Uint8List>.from(box.get('imagenes', defaultValue: []));
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        fondos.add(bytes);
      });
      await box.put('imagenes', fondos);
    }
  }

  void _setAsHomeBackground(Uint8List image) async {
    await box.put('fondoHome', image);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fondo de pantalla guardado para Home!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fondos de Pantalla'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: fondos.isEmpty
          ? const Center(child: Text('No hay fondos guardados.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: fondos.length,
              itemBuilder: (context, index) {
                final image = fondos[index];
                return GestureDetector(
                  onTap: () => _setAsHomeBackground(image),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(image, fit: BoxFit.cover),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          color: Colors.black54,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              'Usar como fondo',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
