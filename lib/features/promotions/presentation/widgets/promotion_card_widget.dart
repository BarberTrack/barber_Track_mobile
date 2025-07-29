import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/promotion.dart';

class PromotionCardWidget extends StatelessWidget {
  final Promotion promotion;

  const PromotionCardWidget({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.red.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildDescription(),
            const SizedBox(height: 16),
            _buildDetails(),
            const SizedBox(height: 16),
            _buildValidityPeriod(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.local_offer_rounded,
            color: Colors.orange.shade300,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                promotion.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              _buildDiscountBadge(),
            ],
          ),
        ),
        if (promotion.isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Text(
              'ACTIVA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade300,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    final discountText = promotion.discountType == 'percentage'
        ? '${promotion.discountValue.toInt()}% OFF'
        : '\$${promotion.discountValue.toStringAsFixed(2)} OFF';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(
        discountText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade300,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      promotion.description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade300,
        height: 1.4,
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.attach_money_rounded,
            color: Colors.blue.shade300,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Compra mínima: \$${promotion.conditions.minAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade300,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidityPeriod() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final validFromText = dateFormat.format(promotion.validFrom);
    final validToText = dateFormat.format(promotion.validTo);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: Colors.purple.shade300,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Válida desde: $validFromText',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple.shade300,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Válida hasta: $validToText',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple.shade300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 