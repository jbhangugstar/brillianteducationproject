import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final Color? bgColor;
  final Color? textColor;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;

  const SearchBar({
    super.key,
    this.hintText = "Cari...",
    required this.onChanged,
    this.onSubmitted,
    this.bgColor,
    this.textColor,
    this.prefixIcon = Icons.search,
    this.suffixIcon,
    this.onSuffixPressed,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {
            _isActive = value.isNotEmpty;
          });
          widget.onChanged(value);
        },
        onSubmitted: widget.onSubmitted,
        style: TextStyle(
          color: widget.textColor ?? Colors.black87,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.6),
            fontSize: 14,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.prefixIcon,
            color: _isActive
                ? const Color(0xFF6C4FD8)
                : Colors.grey.withOpacity(0.5),
            size: 20,
          ),
          suffixIcon: _isActive && widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    widget.suffixIcon,
                    color: const Color(0xFF6C4FD8),
                    size: 20,
                  ),
                  onPressed:
                      widget.onSuffixPressed ??
                      () {
                        _controller.clear();
                        widget.onChanged('');
                        setState(() {
                          _isActive = false;
                        });
                      },
                )
              : null,
        ),
      ),
    );
  }
}
