class Employee {
  final int id;
  final String name;
  final String department;
  final String role;
  final double salary;

  Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.role,
    required this.salary,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      department: json['department'],
      role: json['role'],
      salary: json['salary'].toDouble(),
    );
  }
}