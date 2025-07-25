import 'package:flutter/material.dart';
import '../../domain/entities/business_filters.dart';

class BusinessFiltersWidget extends StatefulWidget {
  final BusinessFilters initialFilters;
  final Function(BusinessFilters) onFiltersChanged;

  const BusinessFiltersWidget({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
  });

  @override
  State<BusinessFiltersWidget> createState() => _BusinessFiltersWidgetState();
}

class _BusinessFiltersWidgetState extends State<BusinessFiltersWidget> {
  late TextEditingController _searchController;
  late BusinessFilters _currentFilters;

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

  void _updateFilters() {
    widget.onFiltersChanged(_currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Filtros de búsqueda',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Campo de búsqueda
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
                        _updateFilters();
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
                  _currentFilters = _currentFilters.copyWith(clearSearch: true);
                } else {
                  _currentFilters = _currentFilters.copyWith(search: value);
                }
              });
            },
            onSubmitted: (value) {
              _updateFilters();
            },
          ),
          const SizedBox(height: 16),

          // Selector de rating
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
          const SizedBox(height: 16),

          // Selección de fecha
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
                        Icon(
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
                    _updateFilters();
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Selección de hora
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
                        Icon(
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
                    _updateFilters();
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _updateFilters,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Aplicar filtros'),
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
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Limpiar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(int? rating, String label) {
    final isSelected = _currentFilters.rating == rating;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (rating == null) {
            // Botón "Todos" - limpiar el rating
            _currentFilters = _currentFilters.copyWith(clearRating: true);
          } else {
            // Botón de rating específico
            _currentFilters = _currentFilters.copyWith(
              rating: selected ? rating : null,
              clearRating: !selected,
            );
          }
        });
        _updateFilters();
      },
      selectedColor: Colors.blueAccent.withOpacity(0.2),
      checkmarkColor: Colors.blueAccent,
    );
  }

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
      _updateFilters();
    }
  }

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
      _updateFilters();
    }
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _currentFilters = _currentFilters.copyWith(
        page: 1,
        clearSearch: true,
        clearRating: true,
        clearDate: true,
        clearTime: true,
      );
    });
    _updateFilters();
  }
}
