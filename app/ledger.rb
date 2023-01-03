require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      unless expense.key?('payee') && expense.key?('amount') && expense.key?('date')
        if !expense.key?('payee')
          missing_key = 'payee'
        elsif !expense.key?('amount')
          missing_key = 'amount'
        elsif !expense.key?('date')
          missing_key = 'date'
        end
        message = "Invalid expense: `#{missing_key}` is required"

        return RecordResult.new(false, nil, message)
      end
      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end
