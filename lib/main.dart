import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PDF View'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "https://firebasestorage.googleapis.com/v0/b/auth-9ca42.appspot.com/o/uploads%2Fpdf%2Ffil.pdf?alt=media&token=5acb599d-25be-468e-8e08-7490866ec039";

  void  _refresh(){
    setState((){
      url="https://firebasestorage.googleapis.com/v0/b/auth-9ca42.appspot.com/o/uploads%2Fpdf%2Fpdf-test%20(1).pdf?alt=media&token=cb753546-51f3-4f83-8a33-36fc623f067d";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: FutureBuilder<Uint8List?>(
        future: _fetchPdfContent(url),
        builder: (context, snapshot) {
          if(snapshot.hasData){
              return PdfPreview(
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              initialPageFormat: PdfPageFormat(100 * PdfPageFormat.mm, 120 * PdfPageFormat.mm),
              build: (format) => snapshot.data!,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
  Future<Uint8List?> _fetchPdfContent(final String url) async {
    try {
      final Response<List<int>> response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } catch (e) {
      print(e);
      return null;
    }
  }
}

