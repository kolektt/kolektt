import 'package:flutter/cupertino.dart';

class CupertinoChip extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final IconData? leadingIcon;

  const CupertinoChip({
    Key? key,
    required this.label,
    this.onTap,
    this.selected = false,
    this.selectedColor,
    this.backgroundColor,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.leadingIcon,
  }) : super(key: key);

  @override
  State<CupertinoChip> createState() => _CupertinoChipState();
}

class _CupertinoChipState extends State<CupertinoChip> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = widget.selectedColor ?? CupertinoColors.activeBlue;
    final Color backgroundColor = widget.backgroundColor ?? CupertinoColors.systemGrey6;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.selected ? selectedColor : backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: widget.selected
                ? [
              BoxShadow(
                color: selectedColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ]
                : null,
            border: Border.all(
              color: widget.selected
                  ? selectedColor
                  : CupertinoColors.systemGrey3,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(
                  widget.leadingIcon,
                  size: widget.fontSize ?? 14,
                  color: widget.selected ? CupertinoColors.white : CupertinoColors.black,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.selected ? CupertinoColors.white : CupertinoColors.black,
                  fontSize: widget.fontSize ?? 14,
                  fontWeight: widget.fontWeight ?? FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              if (widget.selected) ...[
                const SizedBox(width: 6),
                AnimatedOpacity(
                  opacity: widget.selected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    CupertinoIcons.checkmark_circle_fill,
                    size: 14,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 사용 예제
class ChipExample extends StatefulWidget {
  const ChipExample({Key? key}) : super(key: key);

  @override
  State<ChipExample> createState() => _ChipExampleState();
}

class _ChipExampleState extends State<ChipExample> {
  final List<String> _categories = [
    '음악', '영화', '스포츠', '여행', '요리', '게임'
  ];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('카테고리 선택'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _categories.map((category) {
              return CupertinoChip(
                label: category,
                selected: _selectedCategory == category,
                leadingIcon: _getIconForCategory(category),
                selectedColor: _getColorForCategory(category),
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  IconData? _getIconForCategory(String category) {
    switch (category) {
      case '음악': return CupertinoIcons.music_note;
      case '영화': return CupertinoIcons.film;
      case '스포츠': return CupertinoIcons.sportscourt;
      case '여행': return CupertinoIcons.airplane;
      case '요리': return CupertinoIcons.flame;
      case '게임': return CupertinoIcons.game_controller;
      default: return null;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case '음악': return CupertinoColors.systemPink;
      case '영화': return CupertinoColors.systemIndigo;
      case '스포츠': return CupertinoColors.systemGreen;
      case '여행': return CupertinoColors.systemBlue;
      case '요리': return CupertinoColors.systemOrange;
      case '게임': return CupertinoColors.systemPurple;
      default: return CupertinoColors.activeBlue;
    }
  }
}
