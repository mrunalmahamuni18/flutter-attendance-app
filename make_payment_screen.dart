import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ============================================================================
// MAKE PAYMENT SCREEN
// ============================================================================
class MakePaymentScreen extends StatefulWidget {
  final String employeeName;
  final String employeeMobile;
  final double? initialAmount;

  const MakePaymentScreen({
    Key? key,
    required this.employeeName,
    required this.employeeMobile,
    this.initialAmount,
  }) : super(key: key);

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  static const Color primaryColor = Color(0xFF5B4FCF);

  // ── Tabs ──────────────────────────────────────────────────────────────────
  int _selectedTab = 0;
  final List<String> _tabs = ['Salary', 'Advance Payment', 'Bonus', 'Loan'];

  // ── Payment mode ──────────────────────────────────────────────────────────
  String _selectedPaymentMode = 'Cash';
  final List<String> _paymentModes = [
    'Cash',
    'Card',
    'Net Banking',
    'UPI',
  ];

  // ── Bank accounts ─────────────────────────────────────────────────────────
  final List<String> _bankAccounts = [
    'HDFC-12345',
    'ICICI-99999',
    'SBI-54321',
    'Axis-67890'
  ];
  String _selectedBank = 'select Bank Account';

  // ── Controllers ───────────────────────────────────────────────────────────
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankRefController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  DateTime _selectedDate = DateTime(2026, 4, 21);
  bool _amountError = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _bankRefController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  bool get _showBankFields => _selectedPaymentMode != 'Cash';

  // ── Date picker ───────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: primaryColor, onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ── Bank picker bottom sheet ──────────────────────────────────────────────
  void _showBankPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Bank Account',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 12),
              ..._bankAccounts.map(
                (bank) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(bank,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87)),
                  trailing: _selectedBank == bank
                      ? const Icon(Icons.check, color: primaryColor)
                      : null,
                  onTap: () {
                    setState(() => _selectedBank = bank);
                    Navigator.pop(ctx);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add Remark dialog ─────────────────────────────────────────────────────
  void _showRemarkDialog() {
    final tempController = TextEditingController(text: _remarkController.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add Remark',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: tempController,
          maxLines: 3,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter remark...',
            hintStyle: const TextStyle(color: Colors.black38),
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() => _remarkController.text = tempController.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Save handler ──────────────────────────────────────────────────────────
  void _handleSave() {
    final amount = _amountController.text.trim();
    if (amount.isEmpty) {
      setState(() => _amountError = true);
      return;
    }
    setState(() => _amountError = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 10),
          Text('Payment saved successfully!',
              style: TextStyle(fontWeight: FontWeight.w500)),
        ]),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── UI ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Make Payment',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Employee info ─────────────────────────────────────────
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select Employee*',
                            style: TextStyle(
                                fontSize: 13.5, color: Colors.black54)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            const Icon(Icons.person_outline,
                                color: Colors.black45, size: 20),
                            const SizedBox(width: 10),
                            Text(widget.employeeName,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ]),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4FD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            const Icon(Icons.phone,
                                color: Color(0xFF1976D2), size: 18),
                            const SizedBox(width: 10),
                            Text('Mobile: ${widget.employeeMobile}',
                                style: const TextStyle(
                                    fontSize: 14.5, color: Colors.black87)),
                          ]),
                        ),
                      ],
                    ),
                  ),

                  // ── Payment Type ──────────────────────────────────────────
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                    child: const Text('Payment Type',
                        style:
                            TextStyle(fontSize: 13.5, color: Colors.black54)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_tabs.length, (i) {
                          final sel = _selectedTab == i;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 11),
                                decoration: BoxDecoration(
                                  color: sel ? primaryColor : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: sel
                                      ? null
                                      : Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1.2),
                                ),
                                child: Text(_tabs[i],
                                    style: TextStyle(
                                      color:
                                          sel ? Colors.white : Colors.black54,
                                      fontWeight: sel
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      fontSize: 14,
                                    )),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  _divider(),

                  // ── Amount ────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount*',
                            style: TextStyle(
                                fontSize: 13.5, color: Colors.black54)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            if (_amountError)
                              setState(() => _amountError = false);
                          },
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Amount',
                            hintStyle: const TextStyle(
                                color: Colors.black38, fontSize: 16),
                            prefixIcon: const Padding(
                              padding:
                                  EdgeInsets.only(left: 14, right: 8, top: 2),
                              child: Text('₹',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black54)),
                            ),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: _amountError
                                      ? Colors.red
                                      : Colors.grey.shade300,
                                  width: _amountError ? 1.5 : 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color:
                                      _amountError ? Colors.red : primaryColor,
                                  width: 1.5),
                            ),
                          ),
                        ),
                        if (_amountError) ...[
                          const SizedBox(height: 6),
                          const Text('Amount is required',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 13)),
                        ],
                      ],
                    ),
                  ),

                  _divider(),

                  // ── Payment mode ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('PAYMENT MODE',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                letterSpacing: 0.5)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPaymentMode,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black54),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontFamily: 'Roboto'),
                              items: _paymentModes
                                  .map((m) => DropdownMenuItem(
                                      value: m, child: Text(m)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedPaymentMode = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Bank fields (visible when not Cash) ───────────────────
                  if (_showBankFields) ...[
                    _divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        children: [
                          // Select bank account
                          GestureDetector(
                            onTap: _showBankPicker,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_selectedBank,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black87)),
                                  const Icon(Icons.chevron_right,
                                      color: Color(0xFF1976D2), size: 22),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Bank reference number
                          TextField(
                            controller: _bankRefController,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Bank Reference Number',
                              hintStyle: const TextStyle(
                                  color: Colors.black45, fontSize: 15),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 14),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  _divider(),

                  // ── Date ──────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date',
                            style: TextStyle(
                                fontSize: 13.5, color: Colors.black54)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87)),
                                const Icon(Icons.calendar_month_outlined,
                                    color: Colors.black54, size: 22),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _divider(),

                  // ── Add Remark ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _showRemarkDialog,
                          child: Row(children: const [
                            Icon(Icons.add, color: primaryColor, size: 20),
                            SizedBox(width: 4),
                            Text('Add Remark',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500)),
                          ]),
                        ),
                        if (_remarkController.text.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(_remarkController.text,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                        ],
                      ],
                    ),
                  ),

                  _divider(),

                  // ── Info banner ───────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFFFFBE6),
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'An expense under the category Employee Salary & Advance will automatically be created for this payment.',
                      style: TextStyle(
                          fontSize: 13.5, color: Colors.black54, height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Save button ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Save',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 8, color: const Color(0xFFF2F2F2));
}
