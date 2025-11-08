// Interface (abstract class) for accounts that earn interest
abstract class InterestBearing {
  void calculateInterest(); // every interest-bearing account must define this
}

// Abstract base class
abstract class BankAccount {
  // Private fields (Encapsulation)
  final String _accountNumber;
  final String _accountHolder;
  double _balance;

  // Constructor
  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  // Getters (to access private fields safely)
  String get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  // Setter for balance (controls how balance is changed)
  set balance(double value) {
    if (value < 0) {
      print("Balance cannot be negative!");
    } else {
      _balance = value;
    }
  }

  // Abstract methods (Abstraction)
  void deposit(double amount);
  void withdraw(double amount);

  // Display account info
  void displayInfo() {
    print("\nAccount No: $_accountNumber");
    print("Holder: $_accountHolder");
    print("Balance: \$${_balance.toStringAsFixed(2)}");
  }
}

// ---------------- SUBCLASSES ----------------

// Savings Account
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500;
  static const double interestRate = 0.02;
  int withdrawCount = 0; // only 3 withdrawals per month allowed

  SavingsAccount(super.accNo, super.holder, super.balance);

  @override
  void deposit(double amount) {
    // add deposit amount to balance
    balance = balance + amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to $accountHolder");
  }

  @override
  void withdraw(double amount) {
    // check withdrawal limit and balance
    if (withdrawCount >= 3) {
      print("You have reached your 3-withdrawal limit this month!");
      return;
    }
    if (balance - amount < minBalance) {
      print("Cannot withdraw below minimum balance of \$$minBalance");
      return;
    }
    balance = balance - amount;
    withdrawCount++;
    print("Withdrawn \$${amount.toStringAsFixed(2)} from $accountHolder");
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    balance = balance + interest;
    print(
      "Interest of \$${interest.toStringAsFixed(2)} added to $accountHolder",
    );
  }
}

// Checking Account
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35;

  CheckingAccount(super.accNo, super.holder, super.balance);

  @override
  void deposit(double amount) {
    balance = balance + amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to $accountHolder");
  }

  @override
  void withdraw(double amount) {
    balance = balance - amount;
    if (balance < 0) {
      balance = balance - overdraftFee;
      print("Overdraft! \$${overdraftFee.toStringAsFixed(2)} fee applied.");
    }
    print("Withdrawn \$${amount.toStringAsFixed(2)} from $accountHolder");
  }
}

// Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double interestRate = 0.05;

  PremiumAccount(super.accNo, super.holder, super.balance);

  @override
  void deposit(double amount) {
    balance = balance + amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to $accountHolder");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      print("Insufficient balance!");
      return;
    }
    balance = balance - amount;
    print("Withdrawn \$${amount.toStringAsFixed(2)} from $accountHolder");
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    balance = balance + interest;
    print(
      "Interest of \$${interest.toStringAsFixed(2)} added to $accountHolder",
    );
  }
}

// Student Account
class StudentAccount extends BankAccount {
  static const double maxBalance = 5000;

  StudentAccount(super.accNo, super.holder, super.balance);

  @override
  void deposit(double amount) {
    if (balance + amount > maxBalance) {
      print("Failed Cannot exceed maximum balance of \$$maxBalance");
      return;
    }
    balance = balance + amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to $accountHolder");
  }

  @override
  void withdraw(double amount) {
    if (amount > balance) {
      print("Not enough balance to withdraw!");
      return;
    }
    balance = balance - amount;
    print("Withdrawn \$${amount.toStringAsFixed(2)} from $accountHolder");
  }
}

// ---------------- BANK CLASS ----------------

class Bank {
  List<BankAccount> accounts = []; // list to store all accounts

  // Create a new account
  void addAccount(BankAccount account) {
    accounts.add(account);
    print("Account created for ${account.accountHolder}");
  }

  // Find account by account number
  BankAccount? findAccount(String accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) {
        return acc;
      }
    }
    print("Account not found!");
    return null;
  }

  // Transfer money between accounts
  void transfer(String fromAccNo, String toAccNo, double amount) {
    var fromAcc = findAccount(fromAccNo);
    var toAcc = findAccount(toAccNo);

    if (fromAcc != null && toAcc != null) {
      fromAcc.withdraw(amount);
      toAcc.deposit(amount);
      print(
        "Transferred \$${amount.toStringAsFixed(2)} from ${fromAcc.accountHolder} to ${toAcc.accountHolder}",
      );
    }
  }

  // Apply monthly interest to all interest-bearing accounts
  void applyMonthlyInterest() {
    for (BankAccount acc in accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).calculateInterest(); // polymorphism in action
      }
    }
  }

  // Display all accounts
  void showAllAccounts() {
    print("\n=====  All Bank Accounts =====");
    for (var acc in accounts) {
      acc.displayInfo();
    }
  }
}

// ---------------- MAIN FUNCTION ----------------

void main() {
  // Create Bank object
  var bank = Bank();

  // Create different types of accounts
  SavingsAccount acc1 = SavingsAccount("Saving Acc-101", "Shyam", 1000);
  CheckingAccount acc2 = CheckingAccount("Checking Acc-102", "Chakra", 200);
  PremiumAccount acc3 = PremiumAccount("Premium Acc-103", "Pujan", 15000);
  StudentAccount acc4 = StudentAccount("Student Acc-104", "Samir", 3000);

  // Add accounts to the bank
  bank.addAccount(acc1);
  bank.addAccount(acc2);
  bank.addAccount(acc3);
  bank.addAccount(acc4);

  bank.showAllAccounts();
  // Perform some actions
  acc1.withdraw(200); // savings withdraw
  acc2.withdraw(500); // checking withdraw (may trigger overdraft)
  acc3.deposit(2000); // premium deposit
  acc4.deposit(2500); // student deposit (within limit)

  // Transfer money between accounts
  bank.transfer("Premium Acc-103", "Saving Acc-101", 1000);

  bank.showAllAccounts();

  // Apply monthly interest to all interest-bearing accounts
  bank.applyMonthlyInterest();

  // Show all account info
  bank.showAllAccounts();
}
