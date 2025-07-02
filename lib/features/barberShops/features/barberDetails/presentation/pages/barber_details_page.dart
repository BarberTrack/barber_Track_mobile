import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/barberdetails_bloc.dart';
import '../../../../../appointments/features/create_appointment/presentation/pages/create_appointment_page.dart';
import '../widgets/hero_section_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/info_grid_widget.dart';
import '../widgets/schedule_timeline_widget.dart';
import '../widgets/action_buttons_section.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class BarberDetailsPage extends StatelessWidget {
  final String businessId;

  const BarberDetailsPage({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BarberdetailsBloc>()..add(LoadBusinessDetails(businessId)),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
          builder: (context, state) {
            if (state is BarberdetailsLoading) {
              return const LoadingWidget();
            } else if (state is BarberdetailsLoaded) {
              return _buildBusinessDetails(context, state.business);
            } else if (state is BarberdetailsError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: () {
                  context.read<BarberdetailsBloc>().add(
                    LoadBusinessDetails(businessId),
                  );
                },
              );
            }
            return _buildInitialState();
          },
        ),
        floatingActionButton: _buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildBusinessDetails(BuildContext context, dynamic business) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, const Color(0xFF121212)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            title: Text(
              "Detalles de Barbería",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Hero Section - Información principal destacada
                HeroSectionWidget(business: business),

                const SizedBox(height: 24),

                // Quick Actions - Acciones rápidas
                //QuickActionsWidget(businessId: businessId),

                //const SizedBox(height: 32),

                // Info Grid - Información de contacto compacta
                InfoGridWidget(business: business),

                const SizedBox(height: 32),

                // Schedule Timeline - Horarios en formato timeline
                ScheduleTimelineWidget(businessHours: business.businessHours),

                const SizedBox(height: 32),

                // Action Buttons - Botón de reseñas
                ActionButtonsSection(businessId: businessId),

                const SizedBox(height: 120), // Espacio para FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
      builder: (context, state) {
        if (state is BarberdetailsLoaded) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateAppointmentPage(businessId: businessId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today_rounded, size: 24),
              ),
              label: Text(
                'Agendar Cita Ahora',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade900, Colors.grey.shade800],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.store_rounded, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 16),
            Text(
              'Preparando información...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
