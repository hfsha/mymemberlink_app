import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:memberlink_app/myconfig.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  late double screenWidth, screenHeight;
  File? _image;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Product",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 5,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 142, 28, 177),
                Colors.purpleAccent,
                Color.fromARGB(255, 245, 116, 174),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showSelectionDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image == null
                              ? const AssetImage("assets/images/camera.png")
                              : FileImage(_image!) as ImageProvider,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade200,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      height: screenHeight * 0.35,
                      child: _image == null
                          ? const Center(
                              child: Text(
                                "Tap to upload",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    "Product Name",
                    nameController,
                    TextInputType.text,
                    const Icon(Icons.edit),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    "Product Price",
                    priceController,
                    TextInputType.number,
                    const Icon(Icons.attach_money),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    "Product Quantity",
                    quantityController,
                    TextInputType.number,
                    const Icon(Icons.numbers),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    "Product Description",
                    descriptionController,
                    TextInputType.text,
                    const Icon(Icons.description),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    elevation: 10,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please take a photo"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      double filesize = getFileSize(_image!);
                      if (filesize > 1000) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Image size too large"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      insertProductDialog();
                    },
                    minWidth: screenWidth,
                    height: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: const Color.fromARGB(255, 209, 57, 235),
                    child: const Text(
                      "Insert",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller,
      TextInputType keyboardType, Icon icon,
      {int maxLines = 1}) {
    return TextFormField(
      validator: (value) => value!.isEmpty ? "Enter $hintText" : null,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              "Select from",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 215, 73, 194),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                icon: const Icon(Icons.photo, size: 24),
                label: const Text('Gallery'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _selectfromGallery();
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                icon: const Icon(Icons.camera_alt, size: 24),
                label: const Text('Camera'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _selectFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Please Crop Your Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInKB = (sizeInBytes / (1024 * 1024)) * 1000;
    return sizeInKB;
  }

  void insertProductDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Insert Product",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  insertProduct();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  void insertProduct() async {
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    String quantity = quantityController.text;
    String image = base64Encode(_image!.readAsBytesSync());

    try {
      final response = await http.post(
        Uri.parse(
            "${Myconfig.servername}/mymemberlink_backend/insert_product.php"),
        body: {
          "product_name": name,
          "product_desc": description,
          "product_price": price,
          "product_quantity": quantity,
          "image": image,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Insert Failed: ${data['data']}"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server Error: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unexpected Error: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
