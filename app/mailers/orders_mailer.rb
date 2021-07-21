class OrdersMailer < ApplicationMailer

  def boleto_email(params, user)
    @user = user
    puts @user
    @logo_url = ENV['LOGO_URL']
    @boleto_url = params[:boleto_pdf]
    mail(to: @user.email, subject: "Na Cesta - Boleto para pagamento")
  end

end
