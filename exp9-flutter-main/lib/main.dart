import 'package:flutter/material.dart';

void main() {
  runApp(const UpdateStudentApp());
}

class UpdateStudentApp extends StatelessWidget {
  const UpdateStudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Student Information',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const UpdateStudentPage(),
    );
  }
}

class UpdateStudentPage extends StatefulWidget {
  const UpdateStudentPage({super.key});

  @override
  State<UpdateStudentPage> createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  final registrationController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final marksController = TextEditingController();

  bool isLoading = true;
  bool recordFound = false;

  // Dummy student records
  final List<Map<String, dynamic>> students = [
    {
      'registrationNumber': '25CSE001',
      'name': 'Aishmitha',
      'department': 'CSE',
      'marks': 95,
    },
    {
      'registrationNumber': '25CSE002',
      'name': 'Priya',
      'department': 'CSE',
      'marks': 88,
    },
    {
      'registrationNumber': '25AIML003',
      'name': 'Manasa',
      'department': 'AIML',
      'marks': 92,
    },
    {
      'registrationNumber': '25ECE004',
      'name': 'Dhanya',
      'department': 'ECE',
      'marks': 85,
    },
    {
      'registrationNumber': '25IT005',
      'name': 'Harini',
      'department': 'IT',
      'marks': 90,
    },
    {
      'registrationNumber': '25AIML006',
      'name': 'Kavya',
      'department': 'AIML',
      'marks': 78,
    },
    {
      'registrationNumber': '25AIML007',
      'name': 'Risha',
      'department': 'AIML',
      'marks': 99,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadDummyRecords();
  }

  // Simulate loading student records
  Future<void> loadDummyRecords() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  // Search and load student record
  Future<void> loadStudent() async {
    final regNo = registrationController.text.trim();

    if (regNo.isEmpty) {
      showMessage('Please enter a registration number.');
      return;
    }

    setState(() {
      isLoading = true;
      recordFound = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final index = students.indexWhere(
      (student) =>
          student['registrationNumber'].toString().toLowerCase() ==
          regNo.toLowerCase(),
    );

    if (index == -1) {
      nameController.clear();
      departmentController.clear();
      marksController.clear();

      setState(() {
        recordFound = false;
        isLoading = false;
      });

      showMessage('Student record not found.');
      return;
    }

    final student = students[index];

    nameController.text = student['name'].toString();
    departmentController.text = student['department'].toString();
    marksController.text = student['marks'].toString();

    setState(() {
      recordFound = true;
      isLoading = false;
    });

    showMessage('Student record loaded successfully.');
  }

  // Update student information
  Future<void> updateStudent() async {
    final regNo = registrationController.text.trim();
    final name = nameController.text.trim();
    final department = departmentController.text.trim();
    final marksText = marksController.text.trim();
    final marks = int.tryParse(marksText);

    if (!recordFound) {
      showMessage('Search for an existing student first.');
      return;
    }

    if (name.isEmpty ||
        department.isEmpty ||
        marks == null ||
        marks < 0 ||
        marks > 100) {
      showMessage('Enter valid details. Marks must be between 0 and 100.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final index = students.indexWhere(
      (student) =>
          student['registrationNumber'].toString().toLowerCase() ==
          regNo.toLowerCase(),
    );

    if (index != -1) {
      setState(() {
        students[index]['name'] = name;
        students[index]['department'] = department;
        students[index]['marks'] = marks;
        isLoading = false;
      });

      showMessage('Student information updated successfully.');
    } else {
      setState(() {
        isLoading = false;
        recordFound = false;
      });

      showMessage('Update failed. Student record not found.');
    }
  }

  // Display messages
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // Clear all fields
  void clearFields() {
    registrationController.clear();
    nameController.clear();
    departmentController.clear();
    marksController.clear();

    setState(() {
      recordFound = false;
    });
  }

  @override
  void dispose() {
    registrationController.dispose();
    nameController.dispose();
    departmentController.dispose();
    marksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),

      appBar: AppBar(
        title: const Text(
          'Update Student Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.edit_note, size: 70, color: Colors.teal),

                const SizedBox(height: 10),

                const Text(
                  'Update Student Record',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Search and modify existing student information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 25),

                // Registration number
                TextField(
                  controller: registrationController,
                  enabled: !isLoading,

                  decoration: InputDecoration(
                    labelText: 'Registration Number',
                    hintText: 'Enter registration number',
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // Load student button
                OutlinedButton.icon(
                  onPressed: isLoading ? null : loadStudent,
                  icon: const Icon(Icons.search),
                  label: const Text('Load Student Record'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    padding: const EdgeInsets.all(15),
                  ),
                ),

                const SizedBox(height: 20),

                // Student name
                TextField(
                  controller: nameController,
                  enabled: recordFound && !isLoading,

                  decoration: InputDecoration(
                    labelText: 'Student Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // Department
                TextField(
                  controller: departmentController,
                  enabled: recordFound && !isLoading,

                  decoration: InputDecoration(
                    labelText: 'Department',
                    prefixIcon: const Icon(Icons.school),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // Marks
                TextField(
                  controller: marksController,
                  enabled: recordFound && !isLoading,
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    labelText: 'Marks (0–100)',
                    prefixIcon: const Icon(Icons.grade),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // Update button
                ElevatedButton.icon(
                  onPressed: isLoading || !recordFound ? null : updateStudent,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Update Student Information',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Clear button
                OutlinedButton.icon(
                  onPressed: isLoading ? null : clearFields,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Clear Fields'),
                ),

                if (isLoading) ...[
                  const SizedBox(height: 25),
                  const Center(
                    child: CircularProgressIndicator(color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Processing student information...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.teal),
                  ),
                ],

                if (recordFound && !isLoading) ...[
                  const SizedBox(height: 20),

                  Card(
                    color: Colors.teal.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Student record is available for editing.',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Available records information
                Card(
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, color: Colors.teal),
                        const SizedBox(width: 10),
                        Text(
                          'Available student records: ${students.length}',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
