import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(File file) onFilePicked;
  final String label;
  final File? initialFile;

  const FileUploadWidget({
    super.key,
    required this.label,
    required this.onFilePicked,
    this.initialFile,
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  File? file;

  @override
  void initState() {
    super.initState();
    // Initialize with the file from the model (BLoC state)
    file = widget.initialFile;
  }

  @override
  void didUpdateWidget(covariant FileUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update file if it changes from the model
    if (oldWidget.initialFile != widget.initialFile &&
        widget.initialFile != null) {
      setState(() {
        file = widget.initialFile;
      });
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final pickedFile = File(result.files.single.path!);

      setState(() {
        file = pickedFile;
      });

      widget.onFilePicked(pickedFile);
    }
  }

  Future<void> openFile() async {
    if (file != null) {
      await OpenFile.open(file!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.upload_file),

          const SizedBox(width: 12),
          Text(
            widget.label,
             overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          Expanded(
            child: Text(
              file != null ? file!.path.split('/').last : "Upload File",
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (file != null) ...[
            TextButton(onPressed: openFile, child: const Text("Open")),
          ],

          TextButton(onPressed: pickFile, child: const Text("Pick")),
        ],
      ),
    );
  }
}



//use this

// /FileUploadWidget(
//       label:""
//   onFilePicked: (file) {
//     context.read<EmpFullRegBloc>().add(
//       UploadDocument(file), UploadDocument("",value)
//     );
//   },
// ),