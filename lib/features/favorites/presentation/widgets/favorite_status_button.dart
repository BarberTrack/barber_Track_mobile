import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/storage/favorites_storage.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';

class FavoriteStatusButton extends StatefulWidget {
  final String businessId;
  final Widget Function(bool isFavorite, bool isLoading, VoidCallback onToggle)
  builder;

  const FavoriteStatusButton({
    super.key,
    required this.businessId,
    required this.builder,
  });

  @override
  State<FavoriteStatusButton> createState() => _FavoriteStatusButtonState();
}

class _FavoriteStatusButtonState extends State<FavoriteStatusButton> {
  late FavoritesStorage _favoritesStorage;
  bool _isFavorite = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _favoritesStorage = sl<FavoritesStorage>();
    _initializeFavoriteStatus();
  }

  Future<void> _initializeFavoriteStatus() async {
    final isFavorite = await _favoritesStorage.isFavorite(widget.businessId);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
        _isInitialized = true;
      });
    }
  }

  void _toggleFavorite() {
    if (!mounted) return;
    
    try {
      final favoritesBloc = context.read<FavoritesBloc>();
      if (!favoritesBloc.isClosed) {
        if (_isFavorite) {
          favoritesBloc.add(RemoveFavoriteEvent(widget.businessId));
        } else {
          favoritesBloc.add(AddFavoriteEvent(widget.businessId));
        }
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return widget.builder(false, true, () {});
    }

    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is AddToFavoritesSuccess) {
          setState(() => _isFavorite = true);
        } else if (state is RemoveFromFavoritesSuccess) {
          setState(() => _isFavorite = false);
        } else if (state is FavoriteStatusChecked &&
            state.businessId == widget.businessId) {
          setState(() => _isFavorite = state.isFavorite);
        }
      },
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final isLoading =
              state is AddingToFavorites || state is RemovingFromFavorites;

          return widget.builder(_isFavorite, isLoading, _toggleFavorite);
        },
      ),
    );
  }
}
