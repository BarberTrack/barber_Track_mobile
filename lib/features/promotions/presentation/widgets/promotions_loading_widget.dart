import 'package:flutter/material.dart';

class PromotionsLoadingWidget extends StatelessWidget {
  const PromotionsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, const Color(0xFF121212)],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildLoadingCard();
        },
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(48, 48, BorderRadius.circular(12)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(double.infinity, 20, BorderRadius.circular(4)),
                    const SizedBox(height: 8),
                    _buildShimmerBox(100, 16, BorderRadius.circular(8)),
                  ],
                ),
              ),
              _buildShimmerBox(60, 24, BorderRadius.circular(12)),
            ],
          ),
          const SizedBox(height: 16),
          _buildShimmerBox(double.infinity, 16, BorderRadius.circular(4)),
          const SizedBox(height: 8),
          _buildShimmerBox(double.infinity, 16, BorderRadius.circular(4)),
          const SizedBox(height: 16),
          _buildShimmerBox(double.infinity, 48, BorderRadius.circular(12)),
          const SizedBox(height: 16),
          _buildShimmerBox(double.infinity, 48, BorderRadius.circular(12)),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, BorderRadius borderRadius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: borderRadius,
      ),
      child: const _ShimmerEffect(),
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect();

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }
} 