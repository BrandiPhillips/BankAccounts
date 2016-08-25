# August 23, 2016  Bank Account - Modules and classes
require "csv"
require "awesome_print"
#require 'Faker'

module Bank
  class Account
    attr_accessor :current_balance, :open_date, :account_number, :all_accounts

    # initialize a new account, use raise to avoid a negative begining balance
    def initialize(account_number, initial_balance, open_date)
      if initial_balance < 0
        raise ArgumentError, "negative initial balance warning"
      end
      @account_number = account_number
      @current_balance = initial_balance
      @open_date = open_date

    end

    def to_s
      return "Account ID: #{@account_number}, Balance: #{@current_balance}, Date Created: #{@open_date}"
    end


    # getting the data from the csv file:
    def self.all
      all_data = []

      CSV.open("support/accounts.csv", 'r').each do |row|
        account_id = row[0].to_i
        balance = row[1].to_i
        date = row[2]

        all_data << self.new(account_id, balance, date)
      end
        return all_data
    end

    # class method to find an account by id:
    def self.find(account_id)
      accounts = self.all
      accounts.each do |account|
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

  end
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
Bank::Account.all
puts Bank::Account.find(1212)
