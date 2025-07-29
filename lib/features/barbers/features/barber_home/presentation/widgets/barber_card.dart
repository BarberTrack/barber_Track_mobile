import 'package:flutter/material.dart';
import '../../domain/entities/barber.dart';
import 'portfolio_modal.dart';

class BarberCard extends StatelessWidget {
  final Barber barber;

  const BarberCard({super.key, required this.barber});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      barber.fullName.isNotEmpty
                          ? barber.fullName[0].toUpperCase()
                          : 'B',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barber.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${barber.ratingAverage} (${barber.totalReviews} reseñas)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: barber.isActive
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: barber.isActive
                          ? Colors.green.withOpacity(0.5)
                          : Colors.red.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    barber.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      fontSize: 12,
                      color: barber.isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            
            Text(
              barber.bio,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade300,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            
            Row(
              children: [
                Icon(
                  Icons.work_outline,
                  color: Colors.blueAccent.withOpacity(0.7),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '${barber.yearsExperience} años de experiencia',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),
              ],
            ),
            const SizedBox(height: 12),

            
            Text(
              'Especialidades:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: barber.specialties.map((specialty) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

              
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPortfolioModal(
                    context,
                    barber.portfolioImages ?? [],
                    barber.fullName,
                  );
                },
                icon: Icon(
                  barber.portfolioImages?.isNotEmpty == true
                      ? Icons.photo_library_outlined
                      : Icons.photo_library_outlined,
                  color: barber.portfolioImages?.isNotEmpty == true
                      ? Colors.white
                      : Colors.grey.shade500,
                  size: 18,
                ),
                label: Text(
                  barber.portfolioImages?.isNotEmpty == true
                      ? 'Ver Portafolio (${barber.portfolioImages!.length})'
                      : 'Sin Portafolio',
                  style: TextStyle(
                    color: barber.portfolioImages?.isNotEmpty == true
                        ? Colors.white
                        : Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: barber.portfolioImages?.isNotEmpty == true
                      ? Colors.blueAccent.withOpacity(0.8)
                      : Colors.grey.shade800.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: barber.portfolioImages?.isNotEmpty == true
                          ? Colors.blueAccent.withOpacity(0.5)
                          : Colors.grey.shade600.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPortfolioModal(
    BuildContext context,
    List<String> portfolioImages,
    String barberName,
  ) {
    if (portfolioImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Este barbero no tiene imágenes en su portafolio',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PortfolioModal(
        portfolioImages: portfolioImages,
        barberName: barberName,
      ),
    );
  }
}
