# August 23, 2016  Bank Account - Modules and classes

require 'Faker'

module Bank
  class Account
    attr_reader :current_balance
    # initialize a new account, use raise to avoid a negative begining balance
    def initialize(account_number, initial_balance)
      if initial_balance < 0
        raise ArgumentError, "negative initial balance warning"
      end
      @account_number = account_number
      @current_balance = initial_balance

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

  end
end

bobs_account = Bank::Account.new(Faker::Number.number(10), 500.00)
puts bobs_account.current_balance

puts bobs_account.withdraw(600.00)
