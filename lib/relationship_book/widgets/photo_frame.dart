import 'package:flutter/material.dart';

class PhotoFrame extends StatelessWidget {
  final VoidCallback? onTap;
  final ImageProvider? image;

  const PhotoFrame({
    super.key,
    this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.035,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          height: 260,
          margin: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .22),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              14,
              14,
              42,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE2E2E2),
                border: Border.all(
                  color: const Color(0xFFD0D0D0),
                ),
              ),
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image(
                        image: image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 82,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 18),
                        Text(
                          "Klepněte pro vložení\nspolečné fotografie",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}