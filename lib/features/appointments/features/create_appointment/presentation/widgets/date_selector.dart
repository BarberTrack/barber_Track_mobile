import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.grey.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selecciona una fecha',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Elige el día que más te convenga',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade700],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.event,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Elegir fecha',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade900.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade600, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber.shade300,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Puedes elegir cualquier fecha dentro de los próximos 30 días',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber.shade200,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              surface: Colors.grey.shade800,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey.shade800,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final bloc = context.read<CreateAppointmentBloc>();
      final currentState = bloc.state;

      
      bloc.add(SelectDate(picked));

      
      if (currentState is CreateAppointmentServiceSelected ||
          currentState is CreateAppointmentDateSelected ||
          currentState is CreateAppointmentAvailabilityLoaded ||
          currentState is CreateAppointmentTimeSlotSelected ||
          currentState is CreateAppointmentWithNotes) {
        final service = _getSelectedService(currentState);

        
        if (service.barberAssignments.isNotEmpty) {
          final barberId = service.barberAssignments.first.barberId;
          final dateString = DateFormat('yyyy-MM-dd').format(picked);


          bloc.add(
            LoadAvailability(
              businessId: _getBusinessId(currentState),
              barberId: barberId,
              date: dateString,
              days: 3,
            ),
          );
        }
      }
    }
  }

  Service _getSelectedService(CreateAppointmentState state) {
    if (state is CreateAppointmentServiceSelected) return state.selectedService;
    if (state is CreateAppointmentDateSelected) return state.selectedService;
    if (state is CreateAppointmentAvailabilityLoaded)
      return state.selectedService;
    if (state is CreateAppointmentTimeSlotSelected)
      return state.selectedService;
    if (state is CreateAppointmentWithNotes) return state.selectedService;
    throw Exception('Estado no válido para obtener servicio seleccionado');
  }

  String _getBusinessId(CreateAppointmentState state) {
    if (state is CreateAppointmentServiceSelected) return state.businessId;
    if (state is CreateAppointmentDateSelected) return state.businessId;
    if (state is CreateAppointmentAvailabilityLoaded) return state.businessId;
    if (state is CreateAppointmentTimeSlotSelected) return state.businessId;
    if (state is CreateAppointmentWithNotes) return state.businessId;
    throw Exception('Estado no válido para obtener business ID');
  }
}
