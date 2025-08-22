import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'storage_service.dart';

class GetImageUrl extends StatefulWidget {
  final String imageOwnerId;

  const GetImageUrl({super.key, required this.imageOwnerId});

  @override
  GetImageUrlState createState() => GetImageUrlState();

  static Widget buildMiniPic(BuildContext context, String imageId) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        final imageUrl = storageService.imageUrls[imageId];
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          clipBehavior: Clip.antiAlias, // Ensures circular clip
          child:
              imageUrl != null
                  ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(Icons.error),
                  )
                  : const Icon(Icons.person),
        );
      },
    );
  }
}

class GetImageUrlState extends State<GetImageUrl> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchImages();
    });
  }

  void fetchImages() {
    Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        final imageUrl = storageService.imageUrls[widget.imageOwnerId];
        return Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias, // Ensures circular clip
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) {
                            return SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              ),
                            );
                          } else {
                            return child;
                          }
                        },
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.error),
                      )
                      : const Icon(Icons.person, size: 40),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center, // Center buttons
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.orange.shade300,
                      ),
                    ),
                    onPressed:
                        imageUrl != null
                            ? () => Provider.of<StorageService>(
                              context,
                              listen: false,
                            ).deleteImage(widget.imageOwnerId, imageUrl)
                            : null, // Disable button if no image
                    child: const Text("Delete Pic"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.orange.shade500,
                      ),
                    ),
                    onPressed:
                        () => Provider.of<StorageService>(
                          context,
                          listen: false,
                        ).uploadImage(context),
                    child: const Text("Edit Pic"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
