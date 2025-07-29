import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/favorite.dart';
import '../../../home/presentation/widgets/business_card.dart';
import '../../../../core/router/app_router.dart';

class FavoriteCard extends StatelessWidget {
  final Favorite favorite;

  const FavoriteCard({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        GestureDetector(
          onTap: () {
            context.push('${AppRouter.barberDetails}/${favorite.business.id}');
          },
          child: BusinessCard(business: favorite.business),
        ),

        
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'Favorito',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
