import 'package:flutter/material.dart';

class CompanyCard extends StatelessWidget {
  final Map company;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CompanyCard({
    super.key,
    required this.company,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),

              SizedBox(width: 12),

              _buildDetails(),

              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔵 LEFT ICON
  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.business, color: Colors.blue),
    );
  }

  // 📄 DETAILS
  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company['name'] ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          _infoRow(Icons.email, company['email']),

          SizedBox(height: 4),

          _infoRow(Icons.language, company['domain']),
        ],
      ),
    );
  }

  // ⚙️ ACTION BUTTONS
  Widget _buildActions() {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    );
  }

  // 📌 SMALL ROW WIDGET
  Widget _infoRow(IconData icon, dynamic text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}