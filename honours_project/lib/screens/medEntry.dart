import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/medicine_type.dart';

class MedEntry extends StatefulWidget {
  const MedEntry({Key? key}) : super(key: key);

  @override
  State<MedEntry> createState() => _MedEntryState();
}

class _MedEntryState extends State<MedEntry> {
  late TextEditingController nameController;
  late TextEditingController dosageController;

  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();

    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PanelTitle(
              title: 'Medicine Name',
              isRequired: true,
            ),
            TextFormField(
              maxLength: 12,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: kOtherColor),
            ),
            const PanelTitle(
              title: 'Dosage in mg',
              isRequired: true,
            ),
            TextFormField(
              maxLength: 12,
              controller: dosageController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: kOtherColor),
            ),
            SizedBox(
              height: 2.0,
            ),
            const PanelTitle(title: 'Medicine Type', isRequired: false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MedicineTypeColumn(
                        medicineType: MedicineType.bottle,
                        name: "Bottle",
                        iconValue: Icon(Icons.medication),
                        isSelected:
                            snapshot.data == MedicineType.bottle ? true : false,
                      ),
              
                      MedicineTypeColumn(
                        medicineType: MedicineType.pill,
                        name: "Pill",
                        iconValue: Icon(Icons.pie_chart),
                        isSelected:
                            snapshot.data == MedicineType.bottle ? true : false,
                      ),
              
                      MedicineTypeColumn(
                        medicineType: MedicineType.syringe,
                        name: "Syringe",
                        iconValue: Icon(Icons.medical_services),
                        isSelected:
                            snapshot.data == MedicineType.bottle ? true : false,
                      ),
              
                      MedicineTypeColumn(
                        medicineType: MedicineType.other,
                        name: "Other",
                        iconValue: Icon(Icons.question_mark),
                        isSelected:
                            snapshot.data == MedicineType.bottle ? true : false,
                      ),
                    ],
                  );
                },
                stream: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {Key? key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected})
      : super(key: key);
  final MedicineType medicineType;
  final String name;
  final Icon iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSelected ? kOtherColor : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    size: 90,
                    color: isSelected ? Colors.white : kOtherColor,
                  ),
                  child: iconValue,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: isSelected ? Colors.white : kOtherColor,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({Key? key, required this.title, required this.isRequired})
      : super(key: key);
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextSpan(
              text: isRequired ? " *" : "",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: kPrimaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
