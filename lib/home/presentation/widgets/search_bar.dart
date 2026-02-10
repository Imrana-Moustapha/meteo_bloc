import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/home/presentation/cubit/search_cubit_cubit.dart';
import 'package:meteo/home/presentation/cubit/search_cubit_state.dart';
import 'package:meteo/l10n/app_localizations.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final String currentCity;
  final Function(String) onSearch;
  final VoidCallback onReturnToDefault;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.currentCity,
    required this.onSearch,
    required this.onReturnToDefault,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

// ... imports (bloc, search_cubit, search_state)

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Plus de initState ici pour charger l'historique, c'est géré par le Cubit

  void _showOverlay() {
    // On accède à l'historique via le Cubit
    final history = context.read<SearchCubit>().state.history;
    if (history.isEmpty || _overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 8),
          // On utilise BlocBuilder ici pour que l'overlay se mette à jour 
          // quand on supprime un élément de l'historique
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state.history.isEmpty) {
                // Si on supprime tout, on cache l'overlay proprement
                WidgetsBinding.instance.addPostFrameCallback((_) => _hideOverlay());
                return const SizedBox.shrink();
              }
              return _buildOverlayContent(state.history);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(List<String> history) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: history.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final city = history[index];
            return ListTile(
              title: Text(city, style: const TextStyle(color: Colors.black)),
              trailing: IconButton(
                icon: const Icon(Icons.clear, color: Colors.redAccent),
                onPressed: () => context.read<SearchCubit>().removeFromHistory(city),
              ),
              onTap: () {
                widget.controller.text = city;
                widget.onSearch(city);
                _hideOverlay();
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return CompositedTransformTarget(
      link: _layerLink,
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                onTap: _showOverlay,
                onSubmitted: (value) {
                  context.read<SearchCubit>().addToHistory(value);
                  _hideOverlay();
                  widget.onSearch(value);
                },
                // ... reste de ta déco
              ),
            ),
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                _hideOverlay();
                widget.onReturnToDefault();
              },
            ),
          ],
        ),
      ),
    );
  }
}