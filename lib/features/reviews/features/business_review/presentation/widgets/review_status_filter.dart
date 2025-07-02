import 'package:flutter/material.dart';

class ReviewStatusFilter extends StatelessWidget {
  final String? selectedStatus;
  final Function(String?) onStatusChanged;

  const ReviewStatusFilter({
    Key? key,
    required this.selectedStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          bottom: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtrar por estado',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFilterChip(
                label: 'Todas',
                value: null,
                isSelected: selectedStatus == null,
                icon: Icons.list,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Aprobadas',
                value: 'approved',
                isSelected: selectedStatus == 'approved',
                icon: Icons.check_circle,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Pendientes',
                value: 'pending',
                isSelected: selectedStatus == 'pending',
                icon: Icons.pending,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String? value,
    required bool isSelected,
    required IconData icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onStatusChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[700]!,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[400],
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
