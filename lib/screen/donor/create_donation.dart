import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/resources/db_methods.dart';
import 'package:foodsarv01/resources/storage_methods.dart';
import 'package:foodsarv01/utils/utils.dart';
import 'package:foodsarv01/widgets/google_map_picker_widget.dart';
import 'package:foodsarv01/widgets/textfiled.dart';
import 'package:image_picker/image_picker.dart';

List<String> list = <String>['Kg', 'Liter', 'Packet', 'Plate', 'Bottle'];

class CreateDonationScreen extends StatefulWidget {
  final void Function(int page) navigatonTapped;
  const CreateDonationScreen({Key? key, required this.navigatonTapped})
      : super(key: key);

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController foodName = TextEditingController();
  TextEditingController foodQuantity = TextEditingController();
  TextEditingController foodDescription = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController foodExpiryTime = TextEditingController();
  TextEditingController foodPickupTime = TextEditingController();
  TextEditingController pickupLocationName = TextEditingController(text: "Goa");
  TextEditingController pickupLocationCoordinates =
      TextEditingController(text: "15.496777,73.827827");

  DateTime selectedExpiryDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedPickupDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String dropdownValue = list.first;

  Uint8List? _file;
  bool _filepicked = false;
  String url = '';

  Future<void> uploadImage() async {
    if (kDebugMode) {
      print('uploading image');
    }
    StorageMethods storageMethods = StorageMethods();
    url = await storageMethods.uploadImagetoStorage(_file!);
    if (kDebugMode) {
      print('upload image success');
    }
    if (kDebugMode) {
      print(url);
    }
  }

  void _selectImage() async {
    Uint8List image = await PickImage(ImageSource.gallery);
    _filepicked = true;
    setState(() {
      _file = image;
      if (kDebugMode) {
        print('image selected');
      }
    });
  }

  void _clickImage() async {
    Uint8List image = await PickImage(ImageSource.camera);
    _filepicked = true;
    setState(() {
      _file = image;
      if (kDebugMode) {
        print('image selected');
      }
    });
  }

  Future<String> uploadDonation() async {
    DBMethods dbMethods = DBMethods();
    if (name.text.isNotEmpty &&
        foodName.text.isNotEmpty &&
        foodQuantity.text.isNotEmpty &&
        foodDescription.text.isNotEmpty &&
        mobile.text.isNotEmpty &&
        pickupLocationName.text.isNotEmpty) {
      String res = await dbMethods.addDonationToDB(
          name: name.text,
          foodName: foodName.text,
          uid: FirebaseAuth.instance.currentUser!.uid,
          imgurl: url,
          requests: [],
          location: pickupLocationName.text,
          coordinates: pickupLocationCoordinates.text,
          status: 'pending',
          quantity: int.parse(foodQuantity.text),
          unit: dropdownValue,
          expiry_time: selectedExpiryDate,
          pickup_time: selectedPickupDate,
          mobile: mobile.text,
          url: url);
      return res;
    }
    return "Please fill all the fields";
  }

  @override
  void dispose() {
    name.dispose();
    foodName.dispose();
    foodQuantity.dispose();
    foodDescription.dispose();
    mobile.dispose();
    foodExpiryTime.dispose();
    foodPickupTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());

    Future<TimeOfDay?> pickTime() =>
        showTimePicker(context: context, initialTime: TimeOfDay.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Donation",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // ignore: unnecessary_null_comparison
            !(_filepicked)
                ? const CircleAvatar(
                    backgroundColor: Color.fromARGB(0, 0, 0, 0),
                    backgroundImage: AssetImage('assets/images/pick.png'),
                    radius: 50,
                    // child: Container(
                    //   child: Text("Pick an Image"),
                    //   padding: EdgeInsets.only(left: 20),
                    // ),
                  )
                : CircleAvatar(
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    backgroundImage: MemoryImage(_file!),
                    radius: 50,
                    // child: Container(
                    //   child: Text("Pick an Image"),
                    //   padding: EdgeInsets.only(left: 20),
                    // ),
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple)),
                  onPressed: () {
                    if (kDebugMode) {
                      print('tapped');
                    }
                    _selectImage();
                  },
                  child: const Text(
                    'Upload Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text('OR'),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple)),
                  onPressed: () {
                    if (kDebugMode) {
                      print('tapped');
                    }
                    _clickImage();
                  },
                  child: const Text(
                    'Pick an Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            TextInput(hint: 'Enter your name', controller: name),
            TextInput(hint: 'Food Name', controller: foodName),
            Row(
              children: [
                Expanded(
                  child: TextInput(
                      hint: 'Food Quantity',
                      keybordType: TextInputType.number,
                      controller: foodQuantity),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DropdownMenu<String>(
                    initialSelection: dropdownValue,
                    onSelected: (String? value) => {
                      setState(() {
                        dropdownValue = value!;
                      })
                    },
                    dropdownMenuEntries:
                        list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            TextInput(
                hint: "Food Description",
                maxlines: 3,
                controller: foodDescription),

            TextInput(
                hint: 'Mobile Number',
                keybordType: TextInputType.number,
                controller: mobile),

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expiry Time',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                      text:
                          "${selectedExpiryDate.year}/${selectedExpiryDate.month}/${selectedExpiryDate.day}  ${selectedExpiryDate.hour}:${selectedExpiryDate.minute}"),
                  onTap: () async {
                    final date = await pickDate();
                    final time = await pickTime();
                    if (date == null) return;
                    if (time == null) return;

                    setState(() {
                      selectedExpiryDate = date;
                      selectedExpiryDate = DateTime(
                          selectedExpiryDate.year,
                          selectedExpiryDate.month,
                          selectedExpiryDate.day,
                          time.hour,
                          time.minute);
                    });
                  },
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pickup Time',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                      text:
                          "${selectedPickupDate.year}/${selectedPickupDate.month}/${selectedPickupDate.day}  ${selectedPickupDate.hour}:${selectedPickupDate.minute}"),
                  onTap: () async {
                    final date = await pickDate();
                    final time = await pickTime();
                    if (date == null) return;
                    if (time == null) return;
                    setState(() {
                      selectedPickupDate = date;
                      selectedPickupDate = DateTime(
                          selectedPickupDate.year,
                          selectedPickupDate.month,
                          selectedPickupDate.day,
                          time.hour,
                          time.minute);
                    });
                  },
                )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onTap: () async {
                  Map<String, String?> locationInfo =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GoogleMapView(),
                    ),
                  );

                  setState(() {
                    pickupLocationName.text = locationInfo['destinationName']!;
                    pickupLocationCoordinates.text =
                        locationInfo['coordinates']!;
                  });
                },
                readOnly: true,
                controller: pickupLocationName,
                decoration: const InputDecoration(
                  labelText: 'Pickup Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please pick location';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              width: double.infinity, // Make the button full width
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await uploadImage();
                    String res = await uploadDonation();

                    if (kDebugMode) {
                      print("tap");
                    }
                    if (res == 'success') {
                      if (context.mounted) {
                        name.text = '';
                        foodQuantity.text = '';
                        foodDescription.text = '';
                        foodName.text = '';
                        selectedExpiryDate = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);
                        selectedPickupDate = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);
                        pickupLocationName.text = '';
                        pickupLocationCoordinates.text = '';
                        dropdownValue = list.first;
                        mobile.text = '';
                        _filepicked = false;

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Donation created')));
                        widget.navigatonTapped(0);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(res.toString())));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  child: const Text("Create Donation"),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
