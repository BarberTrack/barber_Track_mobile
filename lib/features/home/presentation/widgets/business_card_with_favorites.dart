import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../domain/entities/business.dart';
import '../../../favorites/domain/entities/favorite.dart';
import 'business_card.dart';
import '../../../../core/di/injection.dart';

class BusinessCardWithFavorites extends StatefulWidget {
  final Business business;
  final List<Favorite>? currentFavorites;

  const BusinessCardWithFavorites({
    super.key,
    required this.business,
    this.currentFavorites,
  });

  @override
  State<BusinessCardWithFavorites> createState() =>
      _BusinessCardWithFavoritesState();
}

class _BusinessCardWithFavoritesState extends State<BusinessCardWithFavorites> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  @override
  void didUpdateWidget(BusinessCardWithFavorites oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentFavorites != widget.currentFavorites) {
      _checkIfFavorite();
    }
  }

  void _checkIfFavorite() {
    if (widget.currentFavorites != null) {
      setState(() {
        _isFavorite = widget.currentFavorites!.any(
          (favorite) => favorite.businessId == widget.business.id,
        );
      });
    }
  }

  void _toggleFavorite() {
    final favoritesBloc = context.read<FavoritesBloc>();

    if (_isFavorite) {
      favoritesBloc.add(RemoveFavoriteEvent(widget.business.id));
    } else {
      favoritesBloc.add(AddFavoriteEvent(widget.business.id));
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is AddToFavoritesSuccess) {
          setState(() {
            _isFavorite = true;
          });
          _showSuccessSnackBar('Negocio agregado a favoritos exitosamente');
        } else if (state is AddToFavoritesError) {
          _showErrorSnackBar(
            state.message.contains('Espera y vuelve a intentarlo')
                ? 'Espera y vuelve a intentarlo'
                : 'Error al agregar a favoritos',
          );
        } else if (state is RemoveFromFavoritesSuccess) {
          setState(() {
            _isFavorite = false;
          });
          _showSuccessSnackBar('Negocio eliminado de favoritos exitosamente');
        } else if (state is RemoveFromFavoritesError) {
          _showErrorSnackBar(
            state.message.contains('Espera y vuelve a intentarlo')
                ? 'Espera y vuelve a intentarlo'
                : 'Error al quitar de favoritos',
          );
        }
      },
      child: BusinessCard(
        business: widget.business,
        showFavoriteButton: true,
        isFavorite: _isFavorite,
        onFavoritePressed: _toggleFavorite,
      ),
    );
  }
}
