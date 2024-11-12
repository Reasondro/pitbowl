import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Investment {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final double investmentAmount;
  final double returnRate;

  Investment({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.investmentAmount,
    required this.returnRate,
  });
}

final investmentProvider = Provider<List<Investment>>((ref) {
  return [
    Investment(
      id: '1',
      title: 'TechInnovators',
      description:
          'Invest in cutting-edge technology startup with high growth potential.',
      category: 'Technology',
      imageUrl:
          'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      investmentAmount: 5000000.0,
      returnRate: 12.5,
    ),
    Investment(
      id: '2',
      title: 'HealthPlus',
      description: 'Support advancements in healthcare and biotechnology.',
      category: 'Healthcare',
      imageUrl:
          'https://images.unsplash.com/photo-1512867957657-38dbae50a35b?q=80&w=1176&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      investmentAmount: 750000.0,
      returnRate: 15.0,
    ),
    Investment(
      id: '3',
      title: 'Greenergy',
      description:
          'Promote sustainable energy and environmentally friendly solutions.',
      category: 'Energy',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1661952346976-ac9d2ea8825a?q=80&w=1093&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      investmentAmount: 600000.0,
      returnRate: 10.0,
    ),
    Investment(
      id: '4',
      title: 'EduFuture',
      description:
          'Invest in educational technology and innovative learning platforms',
      category: 'Education',
      imageUrl:
          'https://images.unsplash.com/photo-1509062522246-3755977927d7?q=80&w=932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      investmentAmount: 4000000.0,
      returnRate: 8.0,
    ),
  ];
});

final categoryFilterProvider = StateProvider<String?>((ref) => null);

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investments = ref.watch(investmentProvider);
    final selectedCategory = ref.watch(categoryFilterProvider);

    //? Filter investments based on selected category and search query
    final filteredInvestments = investments.where((investment) {
      final matchesCategory =
          selectedCategory == null || investment.category == selectedCategory;
      return matchesCategory;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          //? Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryChip(
                  category: 'All',
                  isSelected: selectedCategory == null,
                  onSelected: () {
                    ref.read(categoryFilterProvider.notifier).state = null;
                  },
                ),
                CategoryChip(
                  category: 'Technology',
                  isSelected: selectedCategory == 'Technology',
                  onSelected: () {
                    ref.read(categoryFilterProvider.notifier).state =
                        'Technology';
                  },
                ),
                CategoryChip(
                  category: 'Healthcare',
                  isSelected: selectedCategory == 'Healthcare',
                  onSelected: () {
                    ref.read(categoryFilterProvider.notifier).state =
                        'Healthcare';
                  },
                ),
                CategoryChip(
                  category: 'Energy',
                  isSelected: selectedCategory == 'Energy',
                  onSelected: () {
                    ref.read(categoryFilterProvider.notifier).state = 'Energy';
                  },
                ),
                CategoryChip(
                  category: 'Education',
                  isSelected: selectedCategory == 'Education',
                  onSelected: () {
                    ref.read(categoryFilterProvider.notifier).state =
                        'Education';
                  },
                ),
                // Add more categories as needed
              ],
            ),
          ),
          const Divider(),
          // Investment Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: filteredInvestments.isEmpty
                  ? const Center(
                      child: Text(
                        'No investments found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: filteredInvestments.length,
                      itemBuilder: (context, index) {
                        final investment = filteredInvestments[index];
                        return InvestmentCard(investment: investment);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Category Chip Widget
class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

// Investment Card Widget
class InvestmentCard extends StatelessWidget {
  final Investment investment;

  const InvestmentCard({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Investment Detail Page (To Be Implemented)
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         InvestmentDetailScreen(investment: investment),
        //   ),
        // );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Investment Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: investment.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investment.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    investment.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp${investment.investmentAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${investment.returnRate.toStringAsFixed(1)}% shares',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: investment.returnRate >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Investment Detail Screen (Placeholder)
class InvestmentDetailScreen extends StatelessWidget {
  final Investment investment;

  const InvestmentDetailScreen({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(investment.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Investment Image
            CachedNetworkImage(
              imageUrl: investment.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    investment.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    investment.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Category: ${investment.category}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Investment Amount: \$${investment.investmentAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Return Rate: ${investment.returnRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: investment.returnRate >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Implement investment action (e.g., invest, contact)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Investment action tapped."),
                        ),
                      );
                    },
                    child: const Text('Invest Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Delegate for Investments
class InvestmentSearchDelegate extends SearchDelegate {
  final List<Investment> investments;

  InvestmentSearchDelegate(this.investments);

  @override
  String get searchFieldLabel => 'Search Investments';

  @override
  TextInputAction get textInputAction => TextInputAction.search;

  // Leading icon (back arrow)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  //? Action icons (clear button)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = ''; // Clear search query
          },
        ),
    ];
  }

  //? Display search results
  @override
  Widget buildResults(BuildContext context) {
    final results = investments.where((investment) {
      final titleLower = investment.title.toLowerCase();
      final descLower = investment.description.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          descLower.contains(searchLower);
    }).toList();

    return results.isEmpty
        ? const Center(
            child: Text(
              'No investments found.',
              style: TextStyle(fontSize: 16),
            ),
          )
        : MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final investment = results[index];
              return InvestmentCard(investment: investment);
            },
          );
  }

  // Suggestions while typing
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = investments.where((investment) {
      final titleLower = investment.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    return suggestions.isEmpty
        ? const Center(
            child: Text(
              'No suggestions available.',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final investment = suggestions[index];
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: investment.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                title: Text(investment.title),
                subtitle: Text(investment.category),
                onTap: () {
                  // Navigate to Investment Detail Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InvestmentDetailScreen(investment: investment),
                    ),
                  );
                },
              );
            },
          );
  }
}
