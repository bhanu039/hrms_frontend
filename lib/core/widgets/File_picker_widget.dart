import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

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
    // Update file if it changes from the model (compare by path, not reference)
    final oldPath = oldWidget.initialFile?.path;
    final newPath = widget.initialFile?.path;
    if (oldPath != newPath && widget.initialFile != null) {
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
  Widget build(BuildContext context) {return Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: AppColors.grey.shade300),
  ),
  child: Row(
    children: [
      Icon(Icons.upload_file, color: AppColors.grey.shade700),
      const SizedBox(width: 12),
      
      // Expanded gives the text elements boundaries so text overflow works correctly
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Shrink wraps height to avoid layout crashes
          crossAxisAlignment: CrossAxisAlignment.start, // Left-aligns text elements
          children: [
            Text(
              widget.label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.grey.shade800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              file != null ? file!.path.split('/').last : "No file chosen",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13, 
                color: file != null ? AppColors.grey.shade700 : AppColors.grey.shade500,
                fontWeight: file != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 8),
      
      // Action controls packed cleanly to the right side
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (file != null)
            TextButton(
              onPressed: openFile,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: const Text("Open"),
            ),
          ElevatedButton(
            onPressed: pickFile,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.backgroundColor,
              foregroundColor: AppColors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Pick", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
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


