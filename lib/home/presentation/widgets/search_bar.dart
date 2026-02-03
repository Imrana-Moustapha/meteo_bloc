import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Charger l'historique
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _history = prefs.getStringList('search_history') ?? []);
  }

  // Sauvegarder
  Future<void> _saveToHistory(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _history.remove(query);
    _history.insert(0, query);
    if (_history.length > 5) _history.removeLast();
    await prefs.setStringList('search_history', _history);
    _loadHistory();
  }

  // Supprimer un élément spécifique
  Future<void> _removeFromHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history.remove(city);
    });
    await prefs.setStringList('search_history', _history);
    
    // Si l'historique devient vide, on ferme l'infobulle
    if (_history.isEmpty) {
      _hideOverlay();
    } else {
      // Sinon on force le rafraîchissement de l'infobulle
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _showOverlay() {
    if (_history.isEmpty || _overlayEntry != null) return;
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
        // L'infobulle prend la largeur exacte du widget parent (SearchBar)
        width: size.width, 
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
            child: Container(
              // S'adapte au contenu mais max 250px
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _history.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final city = _history[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.history, size: 20, color: Colors.grey),
                      title: Text(
                        city,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: Colors.redAccent),
                        onPressed: () => _removeFromHistory(city),
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
            ),
          ),
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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  style: const TextStyle(color: Colors.black), // Texte tapé en noir
                  decoration: InputDecoration(
                    hintText: t.searchHint,
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.blue),
                  ),
                  onTap: _showOverlay,
                  onChanged: (val) {
                    // Cache l'infobulle si l'utilisateur commence à taper un nouveau texte
                    if (_overlayEntry != null) _hideOverlay();
                  },
                  onSubmitted: (value) {
                    _saveToHistory(value);
                    _hideOverlay();
                    widget.onSearch(value);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.my_location, color: Colors.blue),
                onPressed: () {
                  _hideOverlay();
                  widget.onReturnToDefault();
                },
                tooltip: '${t.returnDefaultTooltip} (${widget.currentCity})',
              ),
            ],
          ),
        ),
      ),
    );
  }
}