import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AuftragPDFPage extends StatefulWidget {
  const AuftragPDFPage({super.key});

  @override
  State<AuftragPDFPage> createState() => _AuftragPDFPageState();
}

class _AuftragPDFPageState extends State<AuftragPDFPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _schadenartDropdownOptions = [
    'Feuer',
    'Einbruchdiebstahl',
    'Leitungswasser',
    'Sturm/Hagel',
    'Glas',
    'Elementar',
    'Sonstiges'
  ];
  final List<String> _anredeDropdownOptions = ['Herr', 'Frau', 'Firma'];
  String? _selectedSchadenartValue;
  String? _selectedAnredeValue;
  final TextEditingController _schadensnummerController =
      TextEditingController();
  final TextEditingController _versicherungszweigController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titelController = TextEditingController();
  final TextEditingController _vornameController = TextEditingController();
  final TextEditingController _nachnameController = TextEditingController();
  final TextEditingController _kontaktStrasseController =
      TextEditingController();
  final TextEditingController _kontaktPLZController = TextEditingController();
  final TextEditingController _kontaktOrtController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _schadensnummerController.dispose();
    _versicherungszweigController.dispose();
    _titelController.dispose();
    _vornameController.dispose();
    _nachnameController.dispose();
    _kontaktStrasseController.dispose();
    _kontaktPLZController.dispose();
    _kontaktOrtController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  Widget _buildTextFormField(
      {required String label,
      void Function()? onTap,
      String? Function(String?)? validator,
      TextEditingController? controller,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: suffixIcon),
        validator: validator,
        onTap: onTap,
        readOnly: onTap != null,
      ),
    );
  }

  Future<void> _generateAndDisplayPdf() async {
    if (_formKey.currentState!.validate()) {
      final pdf = pw.Document();
      final headerFont = pw.Font.helveticaBold();
      final textFont = pw.Font.helvetica();

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Blanko-Auftrag',
                      style: pw.TextStyle(font: headerFont, fontSize: 24)),
                  pw.SizedBox(height: 20),
                  pw.Text('Schadensnummer: ${_schadensnummerController.text}',
                      style: pw.TextStyle(font: textFont, fontSize: 18)),
                  pw.Text('Schadenart: $_selectedSchadenartValue',
                      style: pw.TextStyle(font: textFont, fontSize: 18)),
                  pw.Text(
                      'Versicherungszweig: ${_versicherungszweigController.text}',
                      style: pw.TextStyle(font: textFont, fontSize: 18)),
                  pw.Text('Schadendatum: ${_dateController.text}',
                      style: pw.TextStyle(font: textFont, fontSize: 18)),
                  pw.Divider(),
                  pw.Text('Kontaktdaten',
                      style: pw.TextStyle(font: headerFont, fontSize: 20)),
                  pw.SizedBox(height: 20),
                  pw.Text(
                      '$_selectedAnredeValue ${_titelController.text} ${_vornameController.text} ${_nachnameController.text}',
                      style: pw.TextStyle(font: textFont, fontSize: 18)),
                  pw.Text(_kontaktStrasseController.text,
                      style: pw.TextStyle(font: textFont, fontSize: 18)),
                  pw.Text(
                      '${_kontaktPLZController.text} ${_kontaktOrtController.text}',
                      style: pw.TextStyle(font: textFont, fontSize: 18)),
                ]);
          }));

      // Zeige das PDF im Viewer an
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Bitte füllen Sie alle erforderlichen Felder aus"),
            duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Blanko-Auftrag',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generateAndDisplayPdf,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTextFormField(
                controller: _schadensnummerController,
                label: 'Schadensnummer',
                validator: (value) => value == null || value.isEmpty
                    ? 'Bitte Schadensnummer eingeben'
                    : null),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedSchadenartValue,
                decoration: const InputDecoration(
                    labelText: 'Schadenart', border: OutlineInputBorder()),
                items: _schadenartDropdownOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSchadenartValue = newValue;
                  });
                },
                validator: (String? value) => value == null || value.isEmpty
                    ? 'Bitte eine Schadenart auswählen'
                    : null,
              ),
            ),
            _buildTextFormField(
                controller: _versicherungszweigController,
                label: 'Versicherungszweig',
                validator: (value) => value == null || value.isEmpty
                    ? 'Bitte Versicherungszweig eingeben'
                    : null),
            _buildTextFormField(
                label: 'Schadendatum',
                controller: _dateController,
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
                validator: (value) => value == null || value.isEmpty
                    ? 'Bitte wählen Sie ein Datum'
                    : null),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text('Kontaktdaten',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedAnredeValue,
                decoration: const InputDecoration(
                    labelText: 'Anrede', border: OutlineInputBorder()),
                items: _anredeDropdownOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAnredeValue = newValue;
                  });
                },
                validator: (String? value) => value == null || value.isEmpty
                    ? 'Bitte eine Anrede auswählen'
                    : null,
              ),
            ),
            _buildTextFormField(controller: _titelController, label: 'Titel'),
            _buildTextFormField(
                controller: _vornameController, label: 'Vorname'),
            _buildTextFormField(
                controller: _nachnameController, label: 'Nachname'),
            _buildTextFormField(
                controller: _kontaktStrasseController,
                label: 'Straße/Hausnummer'),
            _buildTextFormField(
                controller: _kontaktPLZController, label: 'PLZ'),
            _buildTextFormField(
                controller: _kontaktOrtController, label: 'Ort'),
          ],
        ),
      ),
    );
  }
}
