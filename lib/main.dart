import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BiodataApp());
}

class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 2,
            ),
          ),
        ),
      ),
      home: const PersonalInfoPage(),
    );
  }
}

// ============================================================
// COMMON WIDGETS
// ============================================================

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            size: 40,
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const NextButton({
    super.key,
    required this.onPressed,
    this.text = 'NEXT',
    this.icon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

// ============================================================
// PAGE 1 - PERSONAL INFORMATION
// ============================================================

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final nameController = TextEditingController();
  final sectionController = TextEditingController();
  final courseController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    sectionController.dispose();
    courseController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (nameController.text.trim().isEmpty ||
        sectionController.text.trim().isEmpty ||
        courseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubjectPage(
          name: nameController.text.trim(),
          section: sectionController.text.trim(),
          course: courseController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 35, 24, 30),
          child: Column(
            children: [
              const PageHeader(
                title: 'Biodata Form',
                subtitle: 'Enter your personal information',
                icon: Icons.person_rounded,
              ),

              const SizedBox(height: 30),

              SectionCard(
                title: 'Personal Information',
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: sectionController,
                      decoration: const InputDecoration(
                        labelText: 'Section',
                        hintText: 'Example: BSIT 2A',
                        prefixIcon: Icon(Icons.groups_outlined),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: courseController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Course',
                        hintText: 'Example: Bachelor of Science in IT',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              NextButton(
                onPressed: nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PAGE 2 - TWO SUBJECTS + TWO TIMES
// ============================================================

class SubjectPage extends StatefulWidget {
  final String name;
  final String section;
  final String course;

  const SubjectPage({
    super.key,
    required this.name,
    required this.section,
    required this.course,
  });

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final subjectOneController = TextEditingController();
  final timeOneController = TextEditingController();
  final subjectTwoController = TextEditingController();
  final timeTwoController = TextEditingController();

  @override
  void dispose() {
    subjectOneController.dispose();
    timeOneController.dispose();
    subjectTwoController.dispose();
    timeTwoController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (subjectOneController.text.trim().isEmpty ||
        timeOneController.text.trim().isEmpty ||
        subjectTwoController.text.trim().isEmpty ||
        timeTwoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all subject and time fields.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPage(
          name: widget.name,
          section: widget.section,
          course: widget.course,
          subjectOne: subjectOneController.text.trim(),
          timeOne: timeOneController.text.trim(),
          subjectTwo: subjectTwoController.text.trim(),
          timeTwo: timeTwoController.text.trim(),
        ),
      ),
    );
  }

  Widget subjectInput({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Class Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
          child: Column(
            children: [
              const PageHeader(
                title: 'Your Subjects',
                subtitle: 'Add your two subjects and schedules',
                icon: Icons.menu_book_rounded,
              ),

              const SizedBox(height: 25),

              SectionCard(
                title: 'Subject 1',
                child: Column(
                  children: [
                    subjectInput(
                      label: 'Subject',
                      hint: 'Example: Programming',
                      icon: Icons.book_outlined,
                      controller: subjectOneController,
                    ),
                    const SizedBox(height: 16),
                    subjectInput(
                      label: 'Time',
                      hint: 'Example: 8:00 AM - 10:00 AM',
                      icon: Icons.schedule_outlined,
                      controller: timeOneController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SectionCard(
                title: 'Subject 2',
                child: Column(
                  children: [
                    subjectInput(
                      label: 'Subject',
                      hint: 'Example: Database',
                      icon: Icons.book_outlined,
                      controller: subjectTwoController,
                    ),
                    const SizedBox(height: 16),
                    subjectInput(
                      label: 'Time',
                      hint: 'Example: 1:00 PM - 3:00 PM',
                      icon: Icons.schedule_outlined,
                      controller: timeTwoController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              NextButton(
                onPressed: nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PAGE 3 - REVIEW
// ============================================================

class ReviewPage extends StatefulWidget {
  final String name;
  final String section;
  final String course;
  final String subjectOne;
  final String timeOne;
  final String subjectTwo;
  final String timeTwo;

  const ReviewPage({
    super.key,
    required this.name,
    required this.section,
    required this.course,
    required this.subjectOne,
    required this.timeOne,
    required this.subjectTwo,
    required this.timeTwo,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool saving = false;

  Future<void> saveData() async {
    setState(() {
      saving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('biodata').add({
        'name': widget.name,
        'section': widget.section,
        'course': widget.course,
        'subject1': widget.subjectOne,
        'time1': widget.timeOne,
        'subject2': widget.subjectTwo,
        'time2': widget.timeTwo,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biodata saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (!mounted) return;

      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  Widget reviewItem(
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
          child: Column(
            children: [
              const PageHeader(
                title: 'Almost Done!',
                subtitle: 'Check your information before saving',
                icon: Icons.fact_check_rounded,
              ),

              const SizedBox(height: 25),

              SectionCard(
                title: 'Personal Information',
                child: Column(
                  children: [
                    reviewItem(
                      'Name',
                      widget.name,
                      Icons.person_outline,
                    ),
                    reviewItem(
                      'Section',
                      widget.section,
                      Icons.groups_outlined,
                    ),
                    reviewItem(
                      'Course',
                      widget.course,
                      Icons.school_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SectionCard(
                title: 'Class Schedule',
                child: Column(
                  children: [
                    reviewItem(
                      'Subject 1',
                      widget.subjectOne,
                      Icons.book_outlined,
                    ),
                    reviewItem(
                      'Time 1',
                      widget.timeOne,
                      Icons.schedule_outlined,
                    ),
                    reviewItem(
                      'Subject 2',
                      widget.subjectTwo,
                      Icons.book_outlined,
                    ),
                    reviewItem(
                      'Time 2',
                      widget.timeTwo,
                      Icons.schedule_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: saving ? null : saveData,
                  icon: saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.cloud_upload_rounded),
                  label: Text(
                    saving ? 'SAVING...' : 'SAVE TO FIREBASE',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}