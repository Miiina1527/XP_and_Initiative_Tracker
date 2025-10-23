import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';

class FondosScreen extends StatefulWidget {
  // When campaignSlot is provided, fondos are read/written from 'fondos_slot_{slot}'
  final int? campaignSlot;

  const FondosScreen({super.key, this.campaignSlot});

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
    final boxName = widget.campaignSlot != null ? 'fondos_slot_${widget.campaignSlot}' : 'fondos';
    box = await Hive.openBox(boxName);
    fondos = List<Uint8List>.from(box.get('imagenes', defaultValue: []));
    // Cargar imagen predeterminada de assets si no está en la lista
    // ignore: use_build_context_synchronously
    final defaultAsset = await DefaultAssetBundle.of(context).load('assets/images/fondo.jpeg');
    final defaultBytes = defaultAsset.buffer.asUint8List();
    // Añadir al inicio si no existe ya
    if (!fondos.any((img) => img.length == defaultBytes.length && img.every((b) => defaultBytes.contains(b)))) {
      fondos.insert(0, defaultBytes);
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    // Solicitar permiso antes de abrir la galería
    var status = await Permission.storage.request();
    var mediaStatus = await Permission.photos.request(); // Para iOS y Android 13+
    if (status.isGranted || mediaStatus.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          fondos.add(bytes);
        });
        await box.put('imagenes', fondos);
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permiso denegado para acceder a la galería")),
      );
    }
  }

  void _setAsHomeBackground(Uint8List image) async {
    await box.put('fondoHome', image);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("background_saved".tr())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("backgrounds_title".tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: fondos.isEmpty
          ? Center(child: Text("no_backgrounds_saved".tr()))
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              "use_as_background".tr(),
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
