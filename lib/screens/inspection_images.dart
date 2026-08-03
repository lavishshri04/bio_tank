import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

/// Displays the inspection images for a coach in a 2-column grid.
///
/// Images are placeholder tiles for now. The grid is driven entirely by
/// [imageCount], so wiring this up to a real backend later is just a
/// matter of swapping the placeholder tile for a network image and
/// passing the real list/count in from the API response.
class InspectionImagesScreen extends StatelessWidget {
  final String coachNumber;
  final String trainNumber;
  final int imageCount;

  const InspectionImagesScreen({
    super.key,
    required this.coachNumber,
    required this.trainNumber,
    required this.imageCount,
  });

  void _openViewer(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageViewerScreen(
          imageCount: imageCount,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inspection Images'),
      ),
      body: SafeArea(
        child: imageCount == 0
            ? const Center(
                child: EmptyState(
                  icon: Icons.photo_library_outlined,
                  title: 'No Images Available',
                  subtitle: 'No inspection images have been captured yet.',
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Text(
                      '$coachNumber \u00b7 Train $trainNumber',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      itemCount: imageCount,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return _ImageTile(
                          index: index,
                          onTap: () => _openViewer(context, index),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Single placeholder thumbnail in the grid.
class _ImageTile extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const _ImageTile({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: AppShadows.soft,
          ),
          clipBehavior: Clip.antiAlias,
          child: Hero(
            tag: 'inspection_image_$index',
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: AppColors.background),
                const Center(
                  child: Icon(
                    Icons.image_rounded,
                    size: 34,
                    color: AppColors.iconMuted,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                    child: Text(
                      'Image ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-screen, swipeable, pinch-to-zoom image viewer.
///
/// Uses placeholder tiles today; once wired to the backend each page
/// just needs to render the real image (e.g. via Image.network) instead
/// of the placeholder icon.
class ImageViewerScreen extends StatefulWidget {
  final int imageCount;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.imageCount,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.imageCount,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'inspection_image_$index',
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: Icon(
                        Icons.image_rounded,
                        size: 96,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.imageCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
