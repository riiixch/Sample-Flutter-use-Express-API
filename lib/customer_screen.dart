import 'package:flutter/material.dart';
import 'customer_model.dart';
import 'customer_service.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      List<Customer> data = await CustomerService.fetchCustomers();
      setState(() {
        customers = data;
        isLoading = false;
      });
    } catch (error) {
      print("Error: $error");
      setState(() => isLoading = false);
    }
  }

  void showCustomerDialog({Customer? customer}) {
    TextEditingController fnameController = TextEditingController(text: customer?.firstName ?? "");
    TextEditingController lnameController = TextEditingController(text: customer?.lastName ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(customer == null ? "เพิ่มลูกค้า" : "แก้ไขลูกค้า"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: fnameController, decoration: InputDecoration(labelText: "ชื่อ")),
              TextField(controller: lnameController, decoration: InputDecoration(labelText: "นามสกุล")),
            ],
          ),
          actions: [
            TextButton(
              child: Text("ยกเลิก"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(customer == null ? "เพิ่ม" : "บันทึก"),
              onPressed: () async {
                Customer newCustomer = Customer(
                  cId: customer?.cId ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  firstName: fnameController.text,
                  lastName: lnameController.text,
                  status: true,
                );

                bool stats;
                if (customer == null) {
                  stats = await CustomerService.addCustomer(newCustomer);
                } else {
                  stats = await CustomerService.editCustomer(newCustomer);
                }

                if (stats) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ดำเนินการสำเร็จ"), backgroundColor: Colors.green),
                  );
                  fetchCustomers();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("เกิดข้อผิดพลาด"), backgroundColor: Colors.red),
                  );
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void confirmDelete(String cId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ยืนยันการลบ"),
        content: Text("คุณต้องการลบลูกค้านี้หรือไม่?"),
        actions: [
          TextButton(child: Text("ยกเลิก"), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: Text("ลบ"),
            onPressed: () async {
              bool stats = await CustomerService.deleteCustomer(cId);

              if (stats) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("ลบข้อมูลสำเร็จ"), backgroundColor: Colors.green),
                );
                fetchCustomers();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("ลบข้อมูลไม่สำเร็จ"), backgroundColor: Colors.red),
                );
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("จัดการลูกค้า")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(customer.firstName[0])),
                  title: Text("${customer.firstName} ${customer.lastName}"),
                  subtitle: Text("ID: ${customer.cId}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => showCustomerDialog(customer: customer)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => confirmDelete(customer.cId)),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showCustomerDialog(),
      ),
    );
  }
}
