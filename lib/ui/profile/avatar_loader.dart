import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:splittymate/services/avatar_picture_service.dart';

class AvatarLoader extends StatelessWidget {
  final String email;
  final String? nickname;
  final double size;

  const AvatarLoader({
    super.key,
    required this.email,
    required this.nickname,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      AvatarPictureService.getAvatarUrl('$email${nickname}dd'),
      semanticsLabel: 'avatar',
      width: size,
      height: size,
      placeholderBuilder: (context) => CircleAvatar(
        radius: size / 2,
        child: const CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      errorBuilder: (context, error, stackTrace) => CircleAvatar(
        radius: size / 2,
        child: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
    );
  }
}
