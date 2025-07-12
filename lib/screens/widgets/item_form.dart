import 'package:flutter/material.dart';
import '../../barcode/item.dart';
import '../barcode_scanner_page.dart';

final List<Map<String, dynamic>> salesOrders = [
  {
    'salesOrderNumber': 'F00000000074583',
    'currentDate': '2025-06-30',
    'salesOrderDate': '2025-06-30',
    'disbursementNumber': '2535',
    'warehouse': 'المخزن الرئيسي',
    'itemCode': 'FGPNETPROCP02-000365',
    'itemName': 'SAUCE CUP 2 OZ TRANS PET - SMART',
    'requestedQuantity': 1000,
    'dispensedQuantity': 1000,
    'remainingQuantity': 0,
    'availableQuantity': 64000,
    'incomingQuantity': 64,
    'actualIncomingQuantity': 64,
    'requesterDetails': 'تفاصيل الطالب',
    'clientName': 'شركه جولدن للتجاره',
    'listQuantity': 5000,
  },
];

class ItemForm extends StatefulWidget {
  final List<Item>? items; // Accepts items for editing an order
  const ItemForm({Key? key, this.items}) : super(key: key);

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentDateController;
  late TextEditingController _salesOrderDateController;
  late TextEditingController _disbursementNumberController;
  late TextEditingController _warehouseController;
  late TextEditingController _itemCodeController;
  late TextEditingController _itemNameController;
  late TextEditingController _requestedQuantityController;
  late TextEditingController _dispensedQuantityController;
  late TextEditingController _remainingQuantityController;
  late TextEditingController _availableQuantityController;
  late TextEditingController _incomingQuantityController;
  late TextEditingController _actualIncomingQuantityController;
  late TextEditingController _requesterDetailsController;
  late TextEditingController _clientNameController;
  late TextEditingController _listQuantityController;

  String? _selectedSalesOrderNumber;

  List<Item> addedProducts = [];
  int? editingIndex; // Track which item is being edited

  @override
  void initState() {
    super.initState();
    _currentDateController = TextEditingController();
    _salesOrderDateController = TextEditingController();
    _disbursementNumberController = TextEditingController();
    _warehouseController = TextEditingController();
    _itemCodeController = TextEditingController();
    _itemNameController = TextEditingController();
    _requestedQuantityController = TextEditingController();
    _dispensedQuantityController = TextEditingController();
    _remainingQuantityController = TextEditingController();
    _availableQuantityController = TextEditingController();
    _incomingQuantityController = TextEditingController();
    _actualIncomingQuantityController = TextEditingController();
    _requesterDetailsController = TextEditingController();
    _clientNameController = TextEditingController();
    _listQuantityController = TextEditingController();
    _selectedSalesOrderNumber = null;

    if (widget.items != null && widget.items!.isNotEmpty) {
      addedProducts = List<Item>.from(widget.items!);
    }
  }

  @override
  void dispose() {
    _currentDateController.dispose();
    _salesOrderDateController.dispose();
    _disbursementNumberController.dispose();
    _warehouseController.dispose();
    _itemCodeController.dispose();
    _itemNameController.dispose();
    _requestedQuantityController.dispose();
    _dispensedQuantityController.dispose();
    _remainingQuantityController.dispose();
    _availableQuantityController.dispose();
    _incomingQuantityController.dispose();
    _actualIncomingQuantityController.dispose();
    _requesterDetailsController.dispose();
    _clientNameController.dispose();
    _listQuantityController.dispose();
    super.dispose();
  }

  void _fillFromSalesOrder(Map<String, dynamic> order) {
    setState(() {
      _currentDateController.text = order['currentDate'] ?? '';
      _salesOrderDateController.text = order['salesOrderDate'] ?? '';
      _disbursementNumberController.text = order['disbursementNumber'] ?? '';
      _warehouseController.text = order['warehouse'] ?? '';
      _itemCodeController.text = '';
      _itemNameController.text = order['itemName'] ?? '';
      _requestedQuantityController.text = order['requestedQuantity'].toString();
      _dispensedQuantityController.text = order['dispensedQuantity'].toString();
      _remainingQuantityController.text = order['remainingQuantity'].toString();
      _availableQuantityController.text = order['availableQuantity'].toString();
      _incomingQuantityController.text = order['incomingQuantity'].toString();
      _actualIncomingQuantityController.text = order['actualIncomingQuantity'].toString();
      _requesterDetailsController.text = order['requesterDetails'] ?? '';
      _clientNameController.text = order['clientName'] ?? '';
      _listQuantityController.text = order['listQuantity'].toString();
      _selectedSalesOrderNumber = order['salesOrderNumber'];
    });
  }

  Future<void> _scanBarcode() async {
    final scannedBarcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );
    if (scannedBarcode != null && scannedBarcode.isNotEmpty) {
      setState(() {
        _itemCodeController.text = scannedBarcode;

      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إضافة الباركود: $scannedBarcode')),
      );
      if(_formKey.currentState != null && _formKey.currentState!.validate()){
        _addOrUpdateProduct();
      }
    }
  }

  void _addOrUpdateProduct() {
    if (_formKey.currentState!.validate()) {
      final item = Item(
        currentDate: _currentDateController.text,
        salesOrderDate: _salesOrderDateController.text,
        salesOrderNumber: _selectedSalesOrderNumber ?? '',
        disbursementNumber: _disbursementNumberController.text,
        warehouse: _warehouseController.text,
        itemCode: _itemCodeController.text,
        itemName: _itemNameController.text,
        requestedQuantity: int.tryParse(_requestedQuantityController.text) ?? 0,
        dispensedQuantity: int.tryParse(_dispensedQuantityController.text) ?? 0,
        remainingQuantity: int.tryParse(_remainingQuantityController.text) ?? 0,
        availableQuantity: int.tryParse(_availableQuantityController.text) ?? 0,
        incomingQuantity: int.tryParse(_incomingQuantityController.text) ?? 0,
        actualIncomingQuantity: int.tryParse(_actualIncomingQuantityController.text) ?? 0,
        requesterDetails: _requesterDetailsController.text,
        clientName: _clientNameController.text,
        listQuantity: int.tryParse(_listQuantityController.text) ?? 0,
      );
      setState(() {
        if (editingIndex != null) {
          addedProducts[editingIndex!] = item;
          editingIndex = null;
        } else {
          addedProducts.add(item);
        }
        _clearFormFields();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(editingIndex != null ? 'تم تحديث المنتج!' : 'تمت إضافة المنتج!')),
      );
    }
  }

  void _clearFormFields() {
    _currentDateController.clear();
    _salesOrderDateController.clear();
    _disbursementNumberController.clear();
    _warehouseController.clear();
    _itemCodeController.clear();
    _itemNameController.clear();
    _requestedQuantityController.clear();
    _dispensedQuantityController.clear();
    _remainingQuantityController.clear();
    _availableQuantityController.clear();
    _incomingQuantityController.clear();
    _actualIncomingQuantityController.clear();
    _requesterDetailsController.clear();
    _clientNameController.clear();
    _listQuantityController.clear();
    _selectedSalesOrderNumber = null;
  }

  void _saveAll() {
    if (addedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إضافة منتج واحد على الأقل!'), backgroundColor: Colors.red),
      );
      return;
    }
    Navigator.pop(context, addedProducts);
    // Optionally show a snackbar here, but likely not needed since popping the page
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType, bool required = true, Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
        ),
        validator: required
            ? (value) => value == null || value.isEmpty ? 'يرجى إدخال $label' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: const Text('إضافة منتجات للطلب'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedSalesOrderNumber,
                            decoration: const InputDecoration(
                              labelText: 'رقم أمر البيع',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: salesOrders.map((order) {
                              return DropdownMenuItem<String>(
                                value: order['salesOrderNumber'],
                                child: Text(order['salesOrderNumber']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSalesOrderNumber = value;
                                final order = salesOrders.firstWhere((o) => o['salesOrderNumber'] == value);
                                _fillFromSalesOrder(order);
                              });
                            },
                            validator: (value) => value == null || value.isEmpty ? 'يرجى اختيار رقم أمر البيع' : null,
                          ),
                          _buildTextField(_currentDateController, 'تاريخ الآن'),
                          _buildTextField(_salesOrderDateController, 'تاريخ أمر البيع'),
                          _buildTextField(_disbursementNumberController, 'رقم الصرف'),
                          _buildTextField(_warehouseController, 'المخزن'),
                          _buildTextField(
                            _itemCodeController,
                            'كود الصنف',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.qr_code_scanner),
                              onPressed: _scanBarcode,
                            ),
                          ),
                          _buildTextField(_itemNameController, 'اسم الصنف'),
                          _buildTextField(_requestedQuantityController, 'الكمية المطلوبة', keyboardType: TextInputType.number),
                          _buildTextField(_dispensedQuantityController, 'الكمية المصروفة', keyboardType: TextInputType.number),
                          _buildTextField(_remainingQuantityController, 'الكمية المتبقية', keyboardType: TextInputType.number),
                          _buildTextField(_availableQuantityController, 'الكمية المتاحة', keyboardType: TextInputType.number),
                          _buildTextField(_incomingQuantityController, 'الكمية الواردة', keyboardType: TextInputType.number),
                          _buildTextField(_actualIncomingQuantityController, 'الكمية الفعلية الواردة', keyboardType: TextInputType.number),
                          _buildTextField(_requesterDetailsController, 'تفاصيل الطالب', required: false),
                          _buildTextField(_clientNameController, 'اسم العميل'),
                          _buildTextField(_listQuantityController, 'قائمة الكمية', keyboardType: TextInputType.number),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _addOrUpdateProduct,
                              icon: Icon(editingIndex == null ? Icons.add : Icons.edit),
                              label: Text(
                                editingIndex == null ? 'إضافة منتج' : 'تحديث المنتج',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Table of added products (scrolls both ways)
                  if (addedProducts.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('كود الصنف')),
                                DataColumn(label: Text('اسم الصنف')),
                                DataColumn(label: Text('الكمية')),
                                DataColumn(label: Text('المخزن')),
                                DataColumn(label: Text('رقم أمر البيع')),
                                DataColumn(label: Text('تاريخ الصرف')),
                                DataColumn(label: Text('تعديل')),
                                DataColumn(label: Text('حذف')),
                              ],
                              rows: addedProducts.asMap().entries.map(
                                    (entry) {
                                  final i = entry.key;
                                  final item = entry.value;
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.itemCode)),
                                      DataCell(Text(item.itemName)),
                                      DataCell(Text(item.requestedQuantity.toString())),
                                      DataCell(Text(item.warehouse)),
                                      DataCell(Text(item.salesOrderNumber)),
                                      DataCell(Text(item.currentDate)),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.amber),
                                          onPressed: () {
                                            setState(() {
                                              editingIndex = i;
                                              // Populate form fields with item data
                                              _currentDateController.text = item.currentDate;
                                              _salesOrderDateController.text = item.salesOrderDate;
                                              _disbursementNumberController.text = item.disbursementNumber;
                                              _warehouseController.text = item.warehouse;
                                              _itemCodeController.text = item.itemCode;
                                              _itemNameController.text = item.itemName;
                                              _requestedQuantityController.text = item.requestedQuantity.toString();
                                              _dispensedQuantityController.text = item.dispensedQuantity.toString();
                                              _remainingQuantityController.text = item.remainingQuantity.toString();
                                              _availableQuantityController.text = item.availableQuantity.toString();
                                              _incomingQuantityController.text = item.incomingQuantity.toString();
                                              _actualIncomingQuantityController.text = item.actualIncomingQuantity.toString();
                                              _requesterDetailsController.text = item.requesterDetails;
                                              _clientNameController.text = item.clientName;
                                              _listQuantityController.text = item.listQuantity.toString();
                                              _selectedSalesOrderNumber = item.salesOrderNumber;
                                            });
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              addedProducts.removeAt(i);
                                              // If you delete the row you are editing, reset editing state
                                              if (editingIndex == i) editingIndex = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _saveAll,
                      icon: const Icon(Icons.save),
                      label: const Text('حفظ', style: TextStyle(fontSize: 18)),
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
