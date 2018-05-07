class ContactMessagesController < ApplicationController
  def new
    @message = ContactMessage.new
  end

  def create
    @message = ContactMessage.new message_params
    @message.sent_at = Time.now
    if @message.valid? && verify_recaptcha(model: @message)
      MessageMailer.contact(@message).deliver
      MessageMailer.receipt(@message).deliver
      redirect_to contact_url
      flash[:success] = "We have received your message and will be in touch soon!"
    else
      flash[:notice] = "There was an error sending your message. Please try again."
      render :new
    end
  end

  private
  def message_params
    params.require(:contact_message).permit(:name, :email, :body)
  end
end