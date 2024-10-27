import 'dart:ui';

import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  Map<String, bool> selectedFilters = {
    'Sustainable': false,
    'Plastic-free': false,
    'Local': false,
    'Biodegradable': false,
    'Zero Waste': false,
    'Fair Trade': false,
  };

  // Enhanced color scheme
  static const primaryColor = Color(0xFF2E7D32);
  static const secondaryColor = Color(0xFFE8F5E9);
  static const backgroundColor = Color(0xFFF5F9F5);
  static const textColor = Color(0xFF1B5E20);

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.filter_list, color: primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'Filter Products',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: selectedFilters.keys.map((filter) {
                    return FilterChip(
                      label: Text(filter),
                      selected: selectedFilters[filter]!,
                      onSelected: (bool value) {
                        setState(() {
                          selectedFilters[filter] = value;
                        });
                      },
                      backgroundColor: secondaryColor,
                      selectedColor: primaryColor.withOpacity(0.2),
                      checkmarkColor: primaryColor,
                      labelStyle: TextStyle(
                        color: selectedFilters[filter]! ? primaryColor : Colors.grey.shade700,
                        fontWeight: selectedFilters[filter]! ? FontWeight.bold : FontWeight.normal,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear All'),
                  onPressed: () {
                    setState(() {
                      selectedFilters.updateAll((key, value) => false);
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Apply'),
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredItems(List<Map<String, dynamic>> items) {
    return items.where((item) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final name = item['name'].toString().toLowerCase();
        final description = item['description'].toString().toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        if (!name.contains(searchLower) && !description.contains(searchLower)) {
          return false;
        }
      }

      // Apply tag filters
      if (selectedFilters.containsValue(true)) {
        final itemTags = item['tags'] as List<String>;
        return selectedFilters.entries
            .where((entry) => entry.value)
            .any((entry) => itemTags.contains(entry.key));
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'name': 'Bamboo Cutlery Set',
        'description': 'Sustainable bamboo cutlery set with carrying case. Perfect for on-the-go dining without single-use plastics. Includes fork, spoon, knife, and chopsticks.',
        'price': '\$15',
        'image': '🥢',
        'tags': ['Zero Waste', 'Sustainable']
      },
      {
        'name': 'Beeswax Wraps',
        'description': 'Natural alternative to plastic wrap. Made with organic cotton, beeswax, jojoba oil, and tree resin. Reusable for up to one year with proper care.',
        'price': '\$20',
        'image': '🐝',
        'tags': ['Plastic-free', 'Biodegradable']
      },
      {
        'name': 'Cotton Produce Bags',
        'description': 'Set of 6 organic cotton mesh bags perfect for grocery shopping. Different sizes for all your produce needs. Washable and durable.',
        'price': '\$12',
        'image': '🧺',
        'tags': ['Zero Waste', 'Sustainable']
      },
      {
        'name': 'Steel Water Bottle',
        'description': 'Double-walled stainless steel water bottle that keeps drinks cold for 24 hours and hot for 12 hours. BPA-free and built to last.',
        'price': '\$25',
        'image': '🍶',
        'tags': ['Plastic-free', 'Sustainable']
      },
      {
        'name': 'Compost Bin',
        'description': 'Sleek countertop compost bin with charcoal filter to eliminate odors. Perfect for collecting kitchen scraps for composting.',
        'price': '\$35',
        'image': '🌱',
        'tags': ['Zero Waste', 'Local']
      },
      {
        'name': 'Hemp Backpack',
        'description': 'Durable hemp backpack with organic cotton lining. Multiple pockets and laptop sleeve. Water-resistant and ethically made.',
        'price': '\$45',
        'image': '🎒',
        'tags': ['Sustainable', 'Fair Trade']
      },
      {
        'name': 'Bamboo Toothbrush',
        'description': 'Biodegradable bamboo toothbrush with charcoal-infused bristles. Comes in a pack of 4 for the whole family.',
        'price': '\$10',
        'image': '🪥',
        'tags': ['Biodegradable', 'Zero Waste']
      },
      {
        'name': 'Solar Power Bank',
        'description': 'Portable solar-powered charger with dual USB ports. Perfect for outdoor adventures and emergency backup power.',
        'price': '\$40',
        'image': '🔋',
        'tags': ['Sustainable', 'Local']
      },
      {
        'name': 'Reusable Coffee Cup',
        'description': 'Insulated bamboo coffee cup with silicone lid and sleeve. Perfect for your daily coffee run without the waste.',
        'price': '\$18',
        'image': '☕',
        'tags': ['Zero Waste', 'Plastic-free']
      },
      {
        'name': 'Natural Soap Bar',
        'description': 'Handmade soap with organic ingredients and essential oils. Plastic-free packaging and zero waste production.',
        'price': '\$8',
        'image': '🧼',
        'tags': ['Biodegradable', 'Fair Trade']
      },
      {
        'name': 'Cotton Napkins',
        'description': 'Set of 8 organic cotton napkins in earth tones. Machine washable and perfect replacement for paper napkins.',
        'price': '\$22',
        'image': '🧵',
        'tags': ['Sustainable', 'Zero Waste']
      },
      {
        'name': 'Glass Food Containers',
        'description': 'Set of 5 glass containers with bamboo lids. Perfect for food storage and meal prep. Microwave and dishwasher safe.',
        'price': '\$32',
        'image': '🥡',
        'tags': ['Plastic-free', 'Sustainable']
      },
      {
        'name': 'Herb Garden Kit',
        'description': 'Complete indoor herb garden starter kit with organic seeds, soil, and biodegradable pots. Grow your own herbs!',
        'price': '\$28',
        'image': '🌿',
        'tags': ['Local', 'Sustainable']
      },
      {
        'name': 'Natural Loofah',
        'description': 'Organic shower loofah grown without pesticides. Natural exfoliator that fully biodegrades.',
        'price': '\$6',
        'image': '🧴',
        'tags': ['Biodegradable', 'Plastic-free']
      },
      {
        'name': 'Recycled Paper Journal',
        'description': 'Handmade journal using 100% recycled paper. Includes a seed paper bookmark that you can plant!',
        'price': '\$15',
        'image': '📔',
        'tags': ['Zero Waste', 'Sustainable']
      },
      {
        'name': 'Wooden Dish Brush',
        'description': 'Biodegradable dish brush with replaceable head. Made from sustainably harvested beechwood.',
        'price': '\$9',
        'image': '🧹',
        'tags': ['Biodegradable', 'Zero Waste']
      },
      // ... other items remain the same
    ];

    final filteredItems = _getFilteredItems(items);

    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold transparent
      body: Stack(
        children: [
          // Background gradient that extends under the app bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor.withOpacity(0.1),
                  backgroundColor,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
          ),
          // Main content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Add extra space for app bar
              const SliverToBoxAdapter(
                child: SizedBox(height: kToolbarHeight + 60), // Adjust based on your app bar height
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: _buildSearchBar(),
                ),
              ),
              // Products grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildProductCard(filteredItems[index], context),
                    childCount: filteredItems.length,
                  ),
                ),
              ),
              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Make search bar slightly transparent
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: '',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () => _showFilterDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), // Slightly transparent cards
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.3),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'product_${product['name']}',
                        child: Text(
                          product['image'] as String,
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['price'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: (product['tags'] as List<String>)
                              .take(2)
                              .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 10,
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                              .toList(),
                        ),
                      ],
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

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F9F5),
    appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
    title: Text(
    widget.product['name'] as String,
    style: const TextStyle(color: Color(0xFF2E7D32)),
    ),
    ),
    body: SingleChildScrollView(
    child: Column(
    children: [
    Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.green.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: Hero(
    tag: 'product_${widget.product['name']}',
    child: Text(
    widget.product['image'] as String,
    style: const TextStyle(fontSize: 120),
    textAlign: TextAlign.center,
    ),
    ),
    ),
    Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.green.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    widget.product['name'] as String,
    style: const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2E7D32),
    ),
    ),
    const SizedBox(height: 16),
    Text(
    widget.product['description'] as String,
    style: TextStyle(
    fontSize: 16,
    color: Colors.grey.shade700,
    height: 1.5,
    ),
    ),
    const SizedBox(height: 24),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    widget.product['price'] as String,
    style: const TextStyle(
    fontSize: 24,
    color: Color(0xFF2E7D32),
    fontWeight: FontWeight.bold,
    ),
    ),
    Container(
    decoration: BoxDecoration(
    color: const Color(0xFFE8F5E9),
    borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
    children: [
    IconButton(
    icon: const Icon(Icons.remove),
    onPressed: () {
    if (quantity > 1) {
    setState(() => quantity--);
    }
    },
    color: const Color(0xFF2E7D32),
    ),
    Text(
    '$quantity',
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2E7D32),
    ),
    ),
    IconButton(
    icon: const Icon(Icons.add),
    onPressed: () {
    setState(() => quantity++);
    },
    color: const Color(0xFF2E7D32),
    ),
    ],
    ),
    ),
    ],
    ),
    const SizedBox(height: 24),
    Wrap(
    spacing: 8,
    runSpacing: 8,
    children: (widget.product['tags'] as List<String>).map((tag) =>
    Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
    ),
    decoration: BoxDecoration(
    color: const Color(0xFFE8F5E9),
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    tag,
    style: const TextStyle(
    color: Color(0xFF2E7D32),
    fontWeight: FontWeight.w500,
    ),
    ),
    ),
    ).toList(),
    ),
    ],
    ),
    ),
    const SizedBox(height: 24),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
    onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Added $quantity item(s) to cart! 🌱'),
    backgroundColor: const Color(0xFF2E7D32),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    );
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2E7D32),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    ),
    ),
      child: const Text(
        'Add to Cart',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    ),
    ),
      const SizedBox(height: 24),
      // Product Details Section
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Environmental Impact',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            _buildImpactItem(
              Icons.eco,
              'Eco-friendly',
              'This product helps reduce environmental impact',
            ),
            const SizedBox(height: 12),
            _buildImpactItem(
              Icons.recycling,
              'Recyclable',
              'Made from sustainable materials',
            ),
            const SizedBox(height: 12),
            _buildImpactItem(
              Icons.water_drop,
              'Water Saving',
              'Helps conserve water resources',
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      // Care Instructions
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Care Instructions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            _buildCareInstruction(
              Icons.wash,
              'Clean with mild soap and water',
            ),
            const SizedBox(height: 8),
            _buildCareInstruction(
              Icons.wb_sunny_outlined,
              'Air dry in shade',
            ),
            const SizedBox(height: 8),
            _buildCareInstruction(
              Icons.eco_outlined,
              'Store in a cool, dry place',
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
    ],
    ),
    ),
    );
  }

  Widget _buildImpactItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCareInstruction(IconData icon, String instruction) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF2E7D32),
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          instruction,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

// Rating Widget
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
              ? Icons.star_half
              : Icons.star_border,
          color: const Color(0xFF2E7D32),
          size: size,
        );
      }),
    );
  }
}