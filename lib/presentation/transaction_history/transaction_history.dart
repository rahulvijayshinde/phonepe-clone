import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_transaction_state.dart';
import './widgets/monthly_transaction_group.dart';
import './widgets/transaction_filter_bottom_sheet.dart';
import './widgets/transaction_filter_chip.dart';
import './widgets/transaction_search_bar.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allTransactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  Map<String, List<Map<String, dynamic>>> _groupedTransactions = {};
  Map<String, bool> _expandedGroups = {};
  Map<String, dynamic> _activeFilters = {};

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 2);
    _loadMockTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMockTransactions() {
    setState(() {
      _isLoading = true;
    });

    // Mock transaction data
    _allTransactions = [
      {
        "id": "txn_001",
        "type": "UPI",
        "merchantName": "Swiggy",
        "amount": 450.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "description": "Food delivery order",
        "upiId": "merchant@paytm",
      },
      {
        "id": "txn_002",
        "type": "Bank Transfer",
        "merchantName": "Rajesh Kumar",
        "amount": 2500.00,
        "isCredit": true,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
        "description": "Money received",
        "accountNumber": "****1234",
      },
      {
        "id": "txn_003",
        "type": "Mobile Recharge",
        "merchantName": "Airtel Prepaid",
        "amount": 199.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
        "description": "Mobile recharge for 9876543210",
        "phoneNumber": "9876543210",
      },
      {
        "id": "txn_004",
        "type": "Card Payment",
        "merchantName": "Amazon",
        "amount": 1299.00,
        "isCredit": false,
        "status": "Pending",
        "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        "description": "Online shopping",
        "cardNumber": "****5678",
      },
      {
        "id": "txn_005",
        "type": "Bill Payment",
        "merchantName": "BSES Electricity",
        "amount": 3200.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 2)),
        "description": "Electricity bill payment",
        "billNumber": "BIL123456789",
      },
      {
        "id": "txn_006",
        "type": "UPI",
        "merchantName": "Priya Sharma",
        "amount": 500.00,
        "isCredit": true,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 3)),
        "description": "Split bill payment",
        "upiId": "priya@oksbi",
      },
      {
        "id": "txn_007",
        "type": "Shopping",
        "merchantName": "Flipkart",
        "amount": 899.00,
        "isCredit": false,
        "status": "Failed",
        "timestamp": DateTime.now().subtract(const Duration(days: 4)),
        "description": "Electronics purchase",
        "orderId": "FLP123456",
      },
      {
        "id": "txn_008",
        "type": "Food",
        "merchantName": "Zomato",
        "amount": 320.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 5)),
        "description": "Food delivery",
        "restaurantName": "Pizza Hut",
      },
      {
        "id": "txn_009",
        "type": "Travel",
        "merchantName": "Uber",
        "amount": 180.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 7)),
        "description": "Cab ride",
        "tripId": "UBR789012",
      },
      {
        "id": "txn_010",
        "type": "Entertainment",
        "merchantName": "BookMyShow",
        "amount": 600.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 10)),
        "description": "Movie tickets",
        "movieName": "Avengers Endgame",
      },
      {
        "id": "txn_011",
        "type": "Fuel",
        "merchantName": "Indian Oil",
        "amount": 2000.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 12)),
        "description": "Petrol fill-up",
        "pumpName": "Indian Oil Pump",
      },
      {
        "id": "txn_012",
        "type": "UPI",
        "merchantName": "Amit Verma",
        "amount": 1500.00,
        "isCredit": true,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 15)),
        "description": "Loan repayment received",
        "upiId": "amit@paytm",
      },
      {
        "id": "txn_013",
        "type": "Bank Transfer",
        "merchantName": "Salary Credit",
        "amount": 45000.00,
        "isCredit": true,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 30)),
        "description": "Monthly salary",
        "companyName": "Tech Solutions Pvt Ltd",
      },
      {
        "id": "txn_014",
        "type": "Bill Payment",
        "merchantName": "Airtel Broadband",
        "amount": 999.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 32)),
        "description": "Internet bill payment",
        "planName": "Unlimited 100 Mbps",
      },
      {
        "id": "txn_015",
        "type": "Shopping",
        "merchantName": "Myntra",
        "amount": 2499.00,
        "isCredit": false,
        "status": "Success",
        "timestamp": DateTime.now().subtract(const Duration(days: 35)),
        "description": "Clothing purchase",
        "brandName": "Nike",
      },
    ];

    _applyFiltersAndSearch();

    setState(() {
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreTransactions();
    }
  }

  void _loadMoreTransactions() {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage++;
          // In real app, load more transactions from API
          if (_currentPage > 3) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered = List.from(_allTransactions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final merchantName =
            (transaction['merchantName'] as String? ?? '').toLowerCase();
        final description =
            (transaction['description'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return merchantName.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply other filters
    if (_activeFilters['type'] != null) {
      filtered = filtered
          .where((transaction) => transaction['type'] == _activeFilters['type'])
          .toList();
    }

    if (_activeFilters['status'] != null) {
      filtered = filtered
          .where((transaction) =>
              transaction['status'] == _activeFilters['status'])
          .toList();
    }

    if (_activeFilters['minAmount'] != null &&
        _activeFilters['maxAmount'] != null) {
      filtered = filtered.where((transaction) {
        final amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
        return amount >= _activeFilters['minAmount'] &&
            amount <= _activeFilters['maxAmount'];
      }).toList();
    }

    if (_activeFilters['startDate'] != null &&
        _activeFilters['endDate'] != null) {
      filtered = filtered.where((transaction) {
        final timestamp = transaction['timestamp'] as DateTime;
        return timestamp.isAfter(_activeFilters['startDate']) &&
            timestamp.isBefore(
                _activeFilters['endDate'].add(const Duration(days: 1)));
      }).toList();
    }

    // Sort by timestamp (newest first)
    filtered.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    _filteredTransactions = filtered;
    _groupTransactionsByMonth();
  }

  void _groupTransactionsByMonth() {
    _groupedTransactions.clear();
    _expandedGroups.clear();

    for (var transaction in _filteredTransactions) {
      final timestamp = transaction['timestamp'] as DateTime;
      final monthYear = '${_getMonthName(timestamp.month)} ${timestamp.year}';

      if (!_groupedTransactions.containsKey(monthYear)) {
        _groupedTransactions[monthYear] = [];
        _expandedGroups[monthYear] = true; // Expand current month by default
      }

      _groupedTransactions[monthYear]!.add(transaction);
    }

    // Collapse older months
    final currentMonth =
        '${_getMonthName(DateTime.now().month)} ${DateTime.now().year}';
    _expandedGroups.forEach((key, value) {
      if (key != currentMonth) {
        _expandedGroups[key] = false;
      }
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSearch();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFilterBottomSheet(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _activeFilters['startDate'] != null &&
              _activeFilters['endDate'] != null
          ? DateTimeRange(
              start: _activeFilters['startDate'] as DateTime,
              end: _activeFilters['endDate'] as DateTime,
            )
          : null,
    );

    if (picked != null) {
      setState(() {
        _activeFilters['startDate'] = picked.start;
        _activeFilters['endDate'] = picked.end;
      });
      _applyFiltersAndSearch();
    }
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _activeFilters.remove(filterKey);
      if (filterKey == 'dateRange') {
        _activeFilters.remove('startDate');
        _activeFilters.remove('endDate');
      }
    });
    _applyFiltersAndSearch();
  }

  void _onTransactionTap(Map<String, dynamic> transaction) {
    _showTransactionDetails(transaction);
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Amount',
                        '₹${(transaction['amount'] as num).toStringAsFixed(2)}'),
                    _buildDetailItem(
                        'Merchant', transaction['merchantName'] as String),
                    _buildDetailItem('Type', transaction['type'] as String),
                    _buildDetailItem('Status', transaction['status'] as String),
                    _buildDetailItem(
                        'Date',
                        _formatDetailDate(
                            transaction['timestamp'] as DateTime)),
                    _buildDetailItem(
                        'Transaction ID', transaction['id'] as String),
                    if (transaction['description'] != null)
                      _buildDetailItem(
                          'Description', transaction['description'] as String),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _downloadReceipt(transaction),
                            icon: CustomIconWidget(
                              iconName: 'download',
                              size: 18,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                            label: Text('Download Receipt'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _shareTransaction(transaction),
                            icon: CustomIconWidget(
                              iconName: 'share',
                              size: 18,
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                            label: Text('Share'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDetailDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _downloadReceipt(Map<String, dynamic> transaction) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt downloaded successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareTransaction(Map<String, dynamic> transaction) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction details shared'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onRefresh() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    _loadMockTransactions();
  }

  String _getDateRangeText() {
    if (_activeFilters['startDate'] != null &&
        _activeFilters['endDate'] != null) {
      final startDate = _activeFilters['startDate'] as DateTime;
      final endDate = _activeFilters['endDate'] as DateTime;
      return '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}';
    }
    return '';
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];

    if (_activeFilters['type'] != null) {
      chips.add(TransactionFilterChip(
        label: _activeFilters['type'] as String,
        isSelected: true,
        onTap: () {},
        onRemove: () => _removeFilter('type'),
      ));
    }

    if (_activeFilters['status'] != null) {
      chips.add(TransactionFilterChip(
        label: _activeFilters['status'] as String,
        isSelected: true,
        onTap: () {},
        onRemove: () => _removeFilter('status'),
      ));
    }

    if (_activeFilters['minAmount'] != null &&
        _activeFilters['maxAmount'] != null) {
      chips.add(TransactionFilterChip(
        label:
            '₹${(_activeFilters['minAmount'] as num).round()}-₹${(_activeFilters['maxAmount'] as num).round()}',
        isSelected: true,
        onTap: () {},
        onRemove: () {
          _removeFilter('minAmount');
          _removeFilter('maxAmount');
        },
      ));
    }

    if (_activeFilters['startDate'] != null &&
        _activeFilters['endDate'] != null) {
      chips.add(TransactionFilterChip(
        label: 'Date Range',
        isSelected: true,
        onTap: () {},
        onRemove: () => _removeFilter('dateRange'),
      ));
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Transaction History',
        variant: AppBarVariant.centered,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Home'),
                Tab(text: 'Scan'),
                Tab(text: 'History'),
                Tab(text: 'Profile'),
              ],
              indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              labelColor: AppTheme.lightTheme.colorScheme.primary,
              unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/home-dashboard');
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(context, '/qr-code-scanner');
                    break;
                  case 2:
                    // Current screen
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(
                        context, '/profile-settings');
                    break;
                }
              },
            ),
          ),
          TransactionSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
            onDateRangeTap: _showDateRangePicker,
            dateRangeText: _getDateRangeText(),
          ),
          if (_buildActiveFilterChips().isNotEmpty) ...[
            Container(
              height: 6.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _buildActiveFilterChips(),
              ),
            ),
          ],
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : _filteredTransactions.isEmpty
                    ? EmptyTransactionState(
                        title:
                            _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                                ? 'No transactions found'
                                : 'No transactions yet',
                        subtitle: _searchQuery.isNotEmpty ||
                                _activeFilters.isNotEmpty
                            ? 'Try adjusting your search or filters to find what you\'re looking for'
                            : 'Your transaction history will appear here once you start making payments',
                        isFiltered: _searchQuery.isNotEmpty ||
                            _activeFilters.isNotEmpty,
                        actionText:
                            _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                                ? 'Clear Filters'
                                : 'Make Payment',
                        onActionPressed:
                            _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                                ? () {
                                    setState(() {
                                      _searchQuery = '';
                                      _searchController.clear();
                                      _activeFilters.clear();
                                    });
                                    _applyFiltersAndSearch();
                                  }
                                : () => Navigator.pushNamed(
                                    context, '/qr-code-scanner'),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _onRefresh(),
                        color: AppTheme.lightTheme.colorScheme.primary,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _groupedTransactions.length +
                              (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _groupedTransactions.length) {
                              return Container(
                                padding: EdgeInsets.all(4.w),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              );
                            }

                            final monthYear =
                                _groupedTransactions.keys.elementAt(index);
                            final transactions =
                                _groupedTransactions[monthYear]!;
                            final isExpanded =
                                _expandedGroups[monthYear] ?? false;

                            return MonthlyTransactionGroup(
                              monthYear: monthYear,
                              transactions: transactions,
                              isExpanded: isExpanded,
                              onToggleExpanded: () {
                                setState(() {
                                  _expandedGroups[monthYear] = !isExpanded;
                                });
                              },
                              onTransactionTap: _onTransactionTap,
                              onViewReceipt: (transaction) =>
                                  _downloadReceipt(transaction),
                              onRepeatTransaction: (transaction) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Repeat transaction initiated'),
                                    backgroundColor:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                );
                              },
                              onDispute: (transaction) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Dispute raised for transaction'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                              onShare: (transaction) =>
                                  _shareTransaction(transaction),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/qr-code-scanner');
              break;
            case 2:
              // Current screen
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile-settings');
              break;
          }
        },
      ),
    );
  }
}