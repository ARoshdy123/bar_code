class Item {
  // التاريخ الآن
  String currentDate;
  // تاريخ أمر البيع
  String salesOrderDate;
  // رقم أمر البيع
  String salesOrderNumber;
  // رقم الصرف
  String disbursementNumber;
  // المخزن
  String warehouse;
  // كود الصنف
  String itemCode;
  // اسم الصنف
  String itemName;
  // الكمية المطلوبة
  int requestedQuantity;
  // الكمية المصروفة
  int dispensedQuantity;
  // الكمية المتبقية
  int remainingQuantity;
  // الكمية المتاحة
  int availableQuantity;
  // الكمية الواردة
  int incomingQuantity;
  // الكمية الفعلية الواردة
  int actualIncomingQuantity;
  // تفاصيل الطالب
  String requesterDetails;
  String clientName; // اسم العميل
  int listQuantity; // قائمة الكمية

  Item({
    required this.currentDate,
    required this.salesOrderDate,
    required this.salesOrderNumber,
    required this.disbursementNumber,
    required this.warehouse,
    required this.itemCode,
    required this.itemName,
    required this.requestedQuantity,
    required this.dispensedQuantity,
    required this.remainingQuantity,
    required this.availableQuantity,
    required this.incomingQuantity,
    required this.actualIncomingQuantity,
    required this.requesterDetails,
    required this.clientName,
    required this.listQuantity,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      currentDate: map['currentDate'] ?? '',
      salesOrderDate: map['salesOrderDate'] ?? '',
      salesOrderNumber: map['salesOrderNumber'] ?? '',
      disbursementNumber: map['disbursementNumber'] ?? '',
      warehouse: map['warehouse'] ?? '',
      itemCode: map['itemCode'] ?? '',
      itemName: map['itemName'] ?? '',
      requestedQuantity: map['requestedQuantity'] ?? 0,
      dispensedQuantity: map['dispensedQuantity'] ?? 0,
      remainingQuantity: map['remainingQuantity'] ?? 0,
      availableQuantity: map['availableQuantity'] ?? 0,
      incomingQuantity: map['incomingQuantity'] ?? 0,
      actualIncomingQuantity: map['actualIncomingQuantity'] ?? 0,
      requesterDetails: map['requesterDetails'] ?? '',
      clientName: map['clientName'] ?? '',
      listQuantity: map['listQuantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentDate': currentDate,
      'salesOrderDate': salesOrderDate,
      'salesOrderNumber': salesOrderNumber,
      'disbursementNumber': disbursementNumber,
      'warehouse': warehouse,
      'itemCode': itemCode,
      'itemName': itemName,
      'requestedQuantity': requestedQuantity,
      'dispensedQuantity': dispensedQuantity,
      'remainingQuantity': remainingQuantity,
      'availableQuantity': availableQuantity,
      'incomingQuantity': incomingQuantity,
      'actualIncomingQuantity': actualIncomingQuantity,
      'requesterDetails': requesterDetails,
      'clientName': clientName,
      'listQuantity': listQuantity,
    };
  }
} 