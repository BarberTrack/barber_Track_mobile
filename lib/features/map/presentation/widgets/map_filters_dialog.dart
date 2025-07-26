import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/map_business_filters.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';

class MapFiltersDialog extends StatefulWidget {
  final MapBusinessFilters initialFilters;
  final MapBloc mapBloc;

  const MapFiltersDialog({
    super.key,
    required this.initialFilters,
    required this.mapBloc,
  });

  @override
  State<MapFiltersDialog> createState() => _MapFiltersDialogState();
}

class _MapFiltersDialogState extends State<MapFiltersDialog> {
  late TextEditingController _searchController;
  late MapBusinessFilters _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters;
    _searchController = TextEditingController(
      text: _currentFilters.search ?? '',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono y título
            Row(
              children: [
                const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.blueAccent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Filtros del Mapa',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Campo de búsqueda con validación y botón de limpiar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar barberías',
                hintText: 'Ingresa el nombre de la barbería...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _currentFilters = _currentFilters.copyWith(
                              clearSearch: true,
                            );
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _currentFilters = _currentFilters.copyWith(
                      clearSearch: true,
                    );
                  } else {
                    _currentFilters = _currentFilters.copyWith(search: value);
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            // Selector de rating con chips
            Text(
              'Rating mínimo',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildRatingChip(null, 'Todos'),
                for (int i = 1; i <= 5; i++) _buildRatingChip(i, '$i⭐'),
              ],
            ),
            const SizedBox(height: 20),
            // Selector de fecha con validación
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _currentFilters.date ?? 'Seleccionar fecha',
                            style: TextStyle(
                              color: _currentFilters.date != null
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_currentFilters.date != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      setState(() {
                        _currentFilters = _currentFilters.copyWith(
                          clearDate: true,
                        );
                      });
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            // Selector de hora con validación
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _currentFilters.time ?? 'Seleccionar hora',
                            style: TextStyle(
                              color: _currentFilters.time != null
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_currentFilters.time != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      setState(() {
                        _currentFilters = _currentFilters.copyWith(
                          clearTime: true,
                        );
                      });
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text('Cancelar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.mapBloc.add(
                        LoadMapBusinessesWithFilters(_currentFilters),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Aplicar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir chips de rating
  Widget _buildRatingChip(int? rating, String label) {
    final isSelected = _currentFilters.rating == rating;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (rating == null) {
            _currentFilters = _currentFilters.copyWith(clearRating: true);
          } else {
            _currentFilters = _currentFilters.copyWith(
              rating: selected ? rating : null,
              clearRating: !selected,
            );
          }
        });
      },
      selectedColor: Colors.blueAccent.withOpacity(0.2),
      checkmarkColor: Colors.blueAccent,
    );
  }

  // Método para seleccionar fecha
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentFilters.date != null
          ? DateTime.parse(_currentFilters.date!)
          : now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        _currentFilters = _currentFilters.copyWith(
          date: selectedDate.toIso8601String().split('T')[0],
        );
      });
    }
  }

  // Método para seleccionar hora
  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _currentFilters.time != null
          ? TimeOfDay(
              hour: int.parse(_currentFilters.time!.split(':')[0]),
              minute: int.parse(_currentFilters.time!.split(':')[1]),
            )
          : TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _currentFilters = _currentFilters.copyWith(
          time:
              '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
        );
      });
    }
  }
}
