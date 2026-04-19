class AppValidators {
  //AUTH VALIDATORS
  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Standard Regex for Email
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  //INVENTORY VALIDATORS
  // Password Validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  // Barcode / ID
  static String? validateBarcode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Barcode is required';
    }
    return null;
  }

  // Title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  // Price
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Enter valid number';
    }

    if (price <= 0) {
      return 'Price must be greater than 0';
    }

    return null;
  }

  // Quantity
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }

    final qty = int.tryParse(value);
    if (qty == null) {
      return 'Enter valid number';
    }

    if (qty < 0) {
      return 'Quantity cannot be negative';
    }

    return null;
  }
}
