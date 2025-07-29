import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../reviews/features/business_review/presentation/pages/business_review_page.dart';
import '../../../../../barbers/features/barber_home/presentation/pages/barber_home_page.dart';
import '../../../business_services/presentation/pages/business_services_page.dart';
import '../../../../../../core/router/app_router.dart';

class ActionButtonsSection extends StatelessWidget {
  final String businessId;
  final bool isFavorite;

  const ActionButtonsSection({
    super.key, 
    required this.businessId,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          
          _buildGalleryStyleButton(
            context: context,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BusinessReviewPage(businessId: businessId),
                ),
              );
            },
            icon: Icons.star_rounded,
            title: 'Ver Reseñas',
            subtitle: 'Opiniones de clientes',
            gradientColors: [
              Colors.amber.withOpacity(0.1),
              Colors.orange.withOpacity(0.1),
            ],
            borderColor: Colors.amber.withOpacity(0.3),
            iconBackgroundColor: Colors.amber.withOpacity(0.2),
            iconColor: Colors.amber.shade300,
            buttonColor: Colors.amber.shade600,
          ),

          const SizedBox(height: 16),

          
          _buildGalleryStyleButton(
            context: context,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarberHomePage(businessId: businessId),
                ),
              );
            },
            icon: Icons.person_pin_rounded,
            title: 'Ver Barberos',
            subtitle: 'Conoce a nuestro equipo',
            gradientColors: [
              Colors.blue.withOpacity(0.1),
              Colors.cyan.withOpacity(0.1),
            ],
            borderColor: Colors.blue.withOpacity(0.3),
            iconBackgroundColor: Colors.blue.withOpacity(0.2),
            iconColor: Colors.blue.shade300,
            buttonColor: Colors.blue.shade600,
          ),

          const SizedBox(height: 16),

          
          if (isFavorite) ...[
            _buildGalleryStyleButton(
              context: context,
              onPressed: () {
                context.push('${AppRouter.promotions}/$businessId');
              },
              icon: Icons.local_offer_rounded,
              title: 'Ver Promociones',
              subtitle: 'Descuentos exclusivos',
              gradientColors: [
                Colors.purple.withOpacity(0.1),
                Colors.pink.withOpacity(0.1),
              ],
              borderColor: Colors.purple.withOpacity(0.3),
              iconBackgroundColor: Colors.purple.withOpacity(0.2),
              iconColor: Colors.purple.shade300,
              buttonColor: Colors.purple.shade600,
            ),
            const SizedBox(height: 16),
          ],

            
          _buildGalleryStyleButton(
            context: context,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusinessServicesPage(businessId: businessId),
                ),
              );
            },
            icon: Icons.medical_services_rounded,
            title: 'Ver Servicios',
            subtitle: 'Servicios disponibles',
            gradientColors: [
              Colors.green.withOpacity(0.1),
              Colors.teal.withOpacity(0.1),
            ],
            borderColor: Colors.green.withOpacity(0.3),
            iconBackgroundColor: Colors.green.withOpacity(0.2),
            iconColor: Colors.green.shade300,
            buttonColor: Colors.green.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryStyleButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required Color borderColor,
    required Color iconBackgroundColor,
    required Color iconColor,
    required Color buttonColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
