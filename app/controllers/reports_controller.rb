class ReportsController < ApplicationController
  #  def balance
  #    redirect_to root_path, notice: 'Não implementado'
  #  end
  # end
  
    def balance
        UserMailer.balance_report_email(current_user).deliver_later
      redirect_to root_path, notice: 'Relatório enviado para o e-mail cadastrado.'
    end
  end