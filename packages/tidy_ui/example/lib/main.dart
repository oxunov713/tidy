import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

void main() => runApp(const GalleryApp());

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tidy_ui gallery',
      debugShowCheckedModeBanner: false,
      theme: TidyTheme.light(),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int _bedrooms = 2;
  int _tab = 0;
  final _selected = <String>{'Inside oven'};
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('tidy_ui')),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          TidyNavItem(label: 'Home', icon: Icons.home_outlined),
          TidyNavItem(label: 'Bookings', icon: Icons.event_outlined),
          TidyNavItem(label: 'Profile', icon: Icons.person_outline),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(TidySpacing.lg),
        children: [
          const SectionHeader(title: 'Buttons', actionLabel: 'See all'),
          TidyButton(
            label: 'Book a clean',
            isLoading: _loading,
            onPressed: () async {
              setState(() => _loading = true);
              await Future<void>.delayed(const Duration(seconds: 2));
              if (mounted) setState(() => _loading = false);
            },
          ),
          const SizedBox(height: TidySpacing.sm),
          TidyButton(
            label: 'Secondary',
            variant: TidyButtonVariant.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: TidySpacing.sm),
          TidyButton(
            label: 'Ghost',
            variant: TidyButtonVariant.ghost,
            onPressed: () {},
          ),
          const SectionHeader(title: 'Chips'),
          Wrap(
            spacing: TidySpacing.sm,
            runSpacing: TidySpacing.sm,
            children: [
              for (final label in ['Inside oven', 'Fridge', 'Windows'])
                TidyChip(
                  label: label,
                  selected: _selected.contains(label),
                  onSelected: (on) => setState(
                    () => on ? _selected.add(label) : _selected.remove(label),
                  ),
                ),
            ],
          ),
          const SectionHeader(title: 'Card with stepper'),
          TidyCard(
            child: Row(
              children: [
                const Expanded(child: Text('Bedrooms')),
                TidyStepper(
                  value: _bedrooms,
                  min: 1,
                  max: 6,
                  onChanged: (v) => setState(() => _bedrooms = v),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Status'),
          Wrap(
            spacing: TidySpacing.sm,
            runSpacing: TidySpacing.sm,
            children: [
              for (final s in TidyStatus.values) StatusBadge(status: s),
            ],
          ),
          const SectionHeader(title: 'Avatar and price'),
          Row(
            children: [
              const Avatar(name: 'Sarah Jones'),
              const SizedBox(width: TidySpacing.md),
              const Expanded(child: Text('Sarah Jones')),
              PriceText(
                6800,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: TidySpacing.lg),
          const SizedBox(
            height: 260,
            child: EmptyState(
              title: 'No bookings yet',
              message: 'When you book a clean it will show up here.',
              actionLabel: 'Book now',
            ),
          ),
        ],
      ),
    );
  }
}
