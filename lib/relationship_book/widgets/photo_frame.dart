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
      angle: -0.02,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: Container(
          width: double.infinity,
          height: 200,
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              10,
              10,
              32,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffdddddd),
                border: Border.all(
                  color: const Color(0xffcfcfcf),
                ),
              ),
              child: image != null
                  ? ClipRect(
                      child: Image(
                        image: image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.photo_outlined,
                          size: 62,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Klepněte pro vložení\nspolečné fotografie",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
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