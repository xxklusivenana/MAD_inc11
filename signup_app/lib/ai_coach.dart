import 'package:flutter/material.dart';
import 'tip_service.dart';

class AiCoach extends StatefulWidget {
  const AiCoach({super.key});

  @override
  State<AiCoach> createState() => _AiCoachState();
}

class _AiCoachState extends State<AiCoach> {
  final SignupTipService _service = SignupTipService();

  Offset? _position;

  static const double _buttonWidth = 194.0;
  static const double _buttonHeight = 48.0;

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  void _openSignupTip() {
    showDialog<void>(
      context: context,
      builder: (context) => SignupTipDialog(service: _service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLeft = (constraints.maxWidth - _buttonWidth)
            .clamp(0.0, double.infinity)
            .toDouble();

        final maxTop = (constraints.maxHeight - _buttonHeight)
            .clamp(0.0, double.infinity)
            .toDouble();

        final defaultPosition = Offset(
          (constraints.maxWidth - _buttonWidth - 16)
              .clamp(0.0, maxLeft)
              .toDouble(),
          (constraints.maxHeight - _buttonHeight - 16)
              .clamp(0.0, maxTop)
              .toDouble(),
        );

        final currentPosition = _position ?? defaultPosition;

        final position = Offset(
          currentPosition.dx.clamp(0.0, maxLeft).toDouble(),
          currentPosition.dy.clamp(0.0, maxTop).toDouble(),
        );

        final colors = Theme.of(context).colorScheme;

        return Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _position = Offset(
                      (position.dx + details.delta.dx)
                          .clamp(0.0, maxLeft)
                          .toDouble(),
                      (position.dy + details.delta.dy)
                          .clamp(0.0, maxTop)
                          .toDouble(),
                    );
                  });
                },
                child: Material(
                  color: colors.primary,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    onTap: _openSignupTip,
                    borderRadius: BorderRadius.circular(28),
                    child: SizedBox(
                      width: _buttonWidth,
                      height: _buttonHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: colors.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Get A Signup Tip',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SignupTipDialog extends StatefulWidget {
  final SignupTipService service;

  const SignupTipDialog({
    super.key,
    required this.service,
  });

  @override
  State<SignupTipDialog> createState() => _SignupTipDialogState();
}

class _SignupTipDialogState extends State<SignupTipDialog> {
  bool _isLoading = true;
  bool _isMock = false;

  String? _tip;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTip();
  }

  Future<void> _loadTip() async {
    setState(() {
      _isLoading = true;
      _tip = null;
      _error = null;
    });

    try {
      final result = await widget.service.getSignupTip();

      if (!mounted) return;

      setState(() {
        _tip = result.tip;
        _isMock = result.isMock;
        _isLoading = false;
      });
    } on SignupTipException catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text('Getting your signup tip...'),
          ),
        ],
      );
    }

    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_error!),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _loadTip,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isMock
              ? 'Mock signup advice — no live model called'
              : 'AI-generated advice',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(_tip ?? ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your Signup Tip'),
      content: SizedBox(
        width: 320,
        child: _buildContent(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}