import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/medicine_type.dart';
import '../auth.dart';
import '../routes.dart';
import '../notifications/notificationService.dart';

class MedEntry extends StatefulWidget {
  const MedEntry({Key? key}) : super(key: key);

  @override
  State<MedEntry> createState() => _MedEntryState();
}

//Varaibles and controllers for handling screen state and user input
class _MedEntryState extends State<MedEntry> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  TimeOfDay? _reminderTime;
  DateTime? _reminderStartDate;
  MedicineType? _selectedMedicineType;
  int _selectedDuration = 0;
  int _selectedInterval = 0;

  final NotificationService _notificationService = NotificationService();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

//Initialises controllers, scaffold key, and notification services
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();

    _scaffoldKey = GlobalKey<ScaffoldState>();

    _notificationService.initialiseNotifications();
  }

//Shows a date and time picker for setting scheduled reminder
  Future<void> _selectReminderDetails() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderStartDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate == null) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _reminderStartDate = pickedDate;
        _reminderTime = picked;
      });
    }
  }

//Main scaffold structure for inputting reminder details
//Stores medication reminder in backend database
//Sets recurring notification based on date and time chosen by user
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    .titleSmall!
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
                    .titleSmall!
                    .copyWith(color: kOtherColor),
              ),
              SizedBox(
                height: 2.0,
              ),
              const PanelTitle(title: 'Medicine Type', isRequired: false),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MedicineTypeColumn(
                            medicineType: MedicineType.bottle,
                            name: "Bottle",
                            iconValue: Icon(Icons.medication),
                            isSelected:
                                _selectedMedicineType == MedicineType.bottle,
                            onTap: () {
                              setState(() {
                                _selectedMedicineType = MedicineType.bottle;
                              });
                            }),
                        MedicineTypeColumn(
                          medicineType: MedicineType.pill,
                          name: "Pill",
                          iconValue: Icon(Icons.pie_chart),
                          isSelected:
                              _selectedMedicineType == MedicineType.pill,
                          onTap: () {
                            setState(() {
                              _selectedMedicineType = MedicineType.pill;
                            });
                          },
                        ),
                        MedicineTypeColumn(
                          medicineType: MedicineType.syringe,
                          name: "Syringe",
                          iconValue: Icon(Icons.medical_services),
                          isSelected:
                              _selectedMedicineType == MedicineType.syringe,
                          onTap: () {
                            setState(() {
                              _selectedMedicineType = MedicineType.syringe;
                            });
                          },
                        ),
                        MedicineTypeColumn(
                          medicineType: MedicineType.other,
                          name: "Other",
                          iconValue: Icon(Icons.question_mark),
                          isSelected:
                              _selectedMedicineType == MedicineType.other,
                          onTap: () {
                            setState(() {
                              _selectedMedicineType = MedicineType.other;
                            });
                          },
                        ),
                      ],
                    ),
                  )),
              const PanelTitle(title: "Interval Selection", isRequired: true),
              IntervalSelection(onIntervalSelected: (interval) {
                setState(() {
                  _selectedInterval = interval;
                });
              }),
              DurationSelection(onDurationSelected: (duration) {
                setState(() {
                  _selectedDuration = duration;
                });
              }),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                    backgroundColor: kOtherColor,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _selectReminderDetails,
                  child: Text(_reminderTime == null
                      ? 'Select Reminder Time'
                      : 'Reminder: ${_reminderStartDate!.toLocal().toString().split(' ')[0]} ${_reminderTime!.format(context)}'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                    backgroundColor: kOtherColor,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    for (int i = 0; i < _selectedDuration; i++) {
                      DateTime reminderDate =
                          _reminderStartDate!.add(Duration(days: i));
                      DateTime reminderDateTime = DateTime(
                          _reminderStartDate!.year,
                          _reminderStartDate!.month,
                          _reminderStartDate!.day,
                          _reminderTime!.hour,
                          _reminderTime!.minute);

                      await _notificationService.scheduleNotification(
                        reminderDateTime,
                        'Medication Reminder',
                        'Time to take your medication!',
                      );

                      if (_selectedInterval > 0) {
                        Duration interval = Duration(hours: _selectedDuration);
                        await _notificationService
                            .scheduleRecurringNotification(
                          reminderDateTime,
                          'Medication Reminder',
                          'Time to take your medication!',
                          interval,
                        );
                      }

                      await Auth().createReminder(
                        medicineName: nameController.text,
                        medicineType: _selectedMedicineType!,
                        dosage: dosageController.text,
                        reminderTime: _reminderTime!.format(context),
                        reminderDate:
                            reminderDate.toLocal().toString().split(' ')[0],
                        interval: _selectedInterval.toString(),
                        duration: _selectedDuration.toString(),
                      );
                    }

                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                  child: const Text('Create Reminder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  final Function(int) onIntervalSelected;
  const IntervalSelection({Key? key, required this.onIntervalSelected})
      : super(key: key);

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class DurationSelection extends StatefulWidget {
  final Function(int) onDurationSelected;
  const DurationSelection({Key? key, required this.onDurationSelected})
      : super(key: key);

  @override
  State<DurationSelection> createState() => _DurationSelectionState();
}

//Provides a dropdown for user to choose duration of their medication reminders
//Is called in main body widget
class _DurationSelectionState extends State<DurationSelection> {
  final _intervals = [1, 7, 14, 30];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Medication to be taken for",
              style: Theme.of(context).textTheme.titleSmall),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: 48.0,
            hint: _selected == 0
                ? Text(
                    "Select a Duration",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: kSecondaryColor,
                        ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                },
              );
              widget.onDurationSelected(_selected);
            },
          ),
          Text(
            _selected == 1 ? " day" : "days",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

//Provides a dropdown for user to choose intervals in hours of their medication reminders
//Is called in main body widget
class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [2, 4, 6, 8];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Remind me every",
              style: Theme.of(context).textTheme.titleSmall),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: 48.0,
            hint: _selected == 0
                ? Text(
                    "Select an interval",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: kSecondaryColor,
                        ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                },
              );
            },
          ),
          Text(
            _selected == 1 ? " hour" : "hours",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

//Displays medicine types as tappable icons
//Is called in main body widget
class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {Key? key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected,
      required this.onTap})
      : super(key: key);
  final MedicineType medicineType;
  final String name;
  final Icon iconValue;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    size: 80,
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
              width: 50,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
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

//Styled title widget for form sections
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
