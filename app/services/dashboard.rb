
class Dashboard
  def initialize(user)
    @user = user
  end

  def active_people_pie_chart
    Rails.cache.fetch('active_people_pie_chart', expires_in: 1.hour) do
      {
        active: Person.where(active: true).count,
        inactive: Person.where(active: false).count
      }
    end
  end

  def active_people_ids
    Rails.cache.fetch('active_people_ids', expires_in: 1.hour) do
      Person.where(active: true).select(:id).pluck(:id)
    end
  end

  def total_debts
    Rails.cache.fetch('total_debts', expires_in: 1.hour) do
      Debt.where(person_id: active_people_ids).sum(:amount)
    end
  end

  def total_payments
    Rails.cache.fetch('total_payments', expires_in: 1.hour) do
      Payment.where(person_id: active_people_ids).sum(:amount)
    end
  end

  def balance
    Rails.cache.fetch('balance', expires_in: 1.hour) do
      total_payments - total_debts
    end
  end

  def last_debts
    Rails.cache.fetch('last_debts', expires_in: 1.hour) do
      Debt.order(created_at: :desc).limit(10).map do |debt|
        [debt.id, debt.amount]
      end
    end
  end

  def last_payments
    Rails.cache.fetch('last_payments', expires_in: 1.hour) do
      Payment.order(created_at: :desc).limit(10).map do |payment|
        [payment.id, payment.amount]
      end
    end
  end

  def my_people
    Rails.cache.fetch("my_people_#{@user.id}", expires_in: 1.hour) do
      Person.where(user: @user).order(:created_at).limit(10)
    end
  end

  def top_person
    Rails.cache.fetch('top_person', expires_in: 1.hour) do
      Person.order(:balance).last
    end
  end

  def bottom_person
    Rails.cache.fetch('bottom_person', expires_in: 1.hour) do
      Person.order(:balance).first
    end
  end
end