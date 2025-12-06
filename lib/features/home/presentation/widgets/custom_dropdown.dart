import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomDropdown extends StatefulWidget {
  final String? selectedValue;
  final List<String> items;
  final String hintText;
  final String label;
  final Function(String?) onChanged;
  final bool searchable;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    this.selectedValue,
    required this.items,
    required this.hintText,
    required this.label,
    required this.onChanged,
    this.searchable = false,
    this.validator,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isOpen = false;
  String? _searchQuery;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredItems {
    if (_searchQuery == null || _searchQuery!.isEmpty) {
      return widget.items;
    }
    return widget.items.where((item) => item.toLowerCase().contains(_searchQuery!.toLowerCase())).toList();
  }

  void _showDropdown(BuildContext context) {
    setState(() {
      _isOpen = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DropdownModal(
        items: _filteredItems,
        selectedValue: widget.selectedValue,
        searchable: widget.searchable,
        searchController: _searchController,
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        onSelected: (value) {
          widget.onChanged(value);
          setState(() {
            _isOpen = false;
          });
          Navigator.pop(context);
        },
      ),
    ).then((_) {
      setState(() {
        _isOpen = false;
        _searchQuery = null;
        _searchController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showDropdown(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _isOpen ? AppColors.primary : Colors.grey.shade300, width: _isOpen ? 2 : 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedValue ?? widget.hintText,
                    style: TextStyle(fontSize: 14, color: widget.selectedValue == null ? Colors.grey.shade400 : Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(_isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.black87, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownModal extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final bool searchable;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function(String?) onSelected;

  const _DropdownModal({
    required this.items,
    this.selectedValue,
    required this.searchable,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSelected,
  });

  @override
  State<_DropdownModal> createState() => _DropdownModalState();
}

class _DropdownModalState extends State<_DropdownModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header with search
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (widget.searchable)
                  Expanded(
                    child: TextField(
                      controller: widget.searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: widget.onSearchChanged,
                    ),
                  ),
                if (widget.searchable) const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.home), onPressed: () => Navigator.pop(context), iconSize: 24),
              ],
            ),
          ),
          // List of items
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = item == widget.selectedValue;
                return InkWell(
                  onTap: () => widget.onSelected(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white),
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
