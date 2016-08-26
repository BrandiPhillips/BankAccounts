# August 23, 2016  Bank Account - Modules and classes
require "csv"
require "awesome_print"
require "date"
require 'Faker'

module Bank
  class Account
    attr_accessor :current_balance, :open_date, :account_number

    # initialize a new account, use raise to avoid a negative begining balance
    def initialize(account_number, initial_balance, open_date)
      if initial_balance < 0
        raise ArgumentError, "negative initial balance warning"
      end
      @account_number = account_number
      @current_balance = initial_balance
      @open_date = open_date

    end

    # to convert the cents from the data spreadsheet to dollars.
    def convert_to_dollars(amt)
      amt / 100.00
    end

    # getting the data from the csv file:
    def self.all

      @@all_data = []

      CSV.open("support/accounts.csv", 'r').each do |row|
        account_id = row[0].to_i
        balance = row[1].to_f
        date = row[2]

        @@all_data << self.new(account_id, balance, date)
      end
        return @@all_data
    end

    # class method to find an account by id:
    def self.find(account_id)

      @@all_data.each do |account|
        if account.account_number == account_id
          return account
        else
        return "Not a valid account id"
        end
      end

    end

    # method for a withdraw that will not allow a negative balance to occur

    def withdraw(withdraw_amt)
      if withdraw_amt < @current_balance
        @current_balance -= withdraw_amt
      else
        raise ArgumentError, "negative balance warning"
      end
      return @current_balance
    end

    # method for deposits, return updated acct bal
    def deposit(deposit_amt)
      @current_balance += deposit_amt
      return @current_balance
    end

    # method to output data in human readable form
    def to_s
      return "Account ID: #{@account_number}, Balance: #{@current_balance}, Date Created: #{@open_date}"
    end

  end

  class SavingsAccount < Account

    def initialize(account_number, initial_balance, open_date)
      if initial_balance < 10
        raise ArgumentError, "negative initial balance warning"
      end
        super
    end

    def withdraw(withdraw_amt)
      if @current_balance - withdraw_amt > 12.00
        @current_balance -= (withdraw_amt + 2.00)
      else
        raise ArgumentError, "balance below min. requirement warning"
      end
      return @current_balance
    end

    def add_interest(rate)
      interest = @current_balance * rate/100
      @current_balance += interest
      return interest
    end

  end

  class CheckingAccount < Account

    def initialize(account_number, initial_balance, open_date)
      super
      if initial_balance < 10
        raise ArgumentError, "negative initial balance warning"
      end
      @num_checks_used = 0
    end

    def withdraw(withdraw_amt)
      super
      @current_balance -= 1
    end

    # method for check withdraw
    def check_withdraw(ch_amount)

      if @num_checks_used >= 3 && @current_balance - ch_amount >= -12.00
        @current_balance -= (ch_amount + 2.00)
      elsif @num_checks_used < 3 && @current_balance - ch_amount >= - 10.00
        @current_balance -= ch_amount
        @num_checks_used += 1
      else
        raise ArgumentError, "negative balance warning"
      end
      return @current_balance
    end

    # method to reset the checks used
    def reset_checks
      if @num_checks_used == 3
        @num_checks_used = 0
      end
    end

  end

#end of module
end

# testing wave 1:

# bobs_account = Bank::Account.new(Faker::Number.number(10), 500.00)
# puts bobs_account.current_balance
#
# puts bobs_account.withdraw(600.00)

# testing first part of wave 2 to see how the program will handle the data, now I know that the date needs to be a string:

# n_account = Bank::Account.new(1212, 1235667, "3/27/1999")
# puts n_account.account_number
# puts n_account.open_date
# puts n_account.current_balance

# testing the account/wave 2:
# Bank::Account.all
# puts Bank::Account.find(1212)


# # testing for wave 3:
# Bank::SavingsAccount.all
# new_account = Bank::SavingsAccount.new(Faker::Number.number(10), 500.00, "August 8, 2016")
# puts new_account.current_balance
# new_account.withdraw(50.00)
# puts new_account.current_balance
#
# new_account.deposit(10000)
# puts new_account.current_balance
#
# puts new_account.add_interest(0.25)
# puts new_account.current_balance

# bettys_acct = Bank::CheckingAccount.new(Faker::Number.number(10), 500.00, "August 5, 2016")
# puts bettys_acct.current_balance
#
# puts bettys_acct.withdraw(50.00)
# puts bettys_acct.check_withdraw(20.00)
# puts bettys_acct.check_withdraw(20.00)
# puts bettys_acct.check_withdraw(20.00)
# puts bettys_acct.check_withdraw(20.00)
# bettys_acct.reset_checks
# puts bettys_acct.check_withdraw(20.00)
# puts bettys_acct.withdraw(600.00)
