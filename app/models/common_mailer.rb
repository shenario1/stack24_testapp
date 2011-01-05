class CommonMailer < ActionMailer::Base
  
  def new_answer_email(email, name, question_id)
    recipients email
    from "Clari5<do-not-reply@clari5.com>"
    subject "Your question has been answered"
    sent_on Time.now
    body :name => name, :question_id => question_id
    content_type "text/html"
  end

  def create_profile(email, name)
    subject 'Thank you for creating an account'
    recipients email
    from "Clari5<do-not-reply@clari5.com>"
    sent_on Time.now
    body :name => name
    content_type "text/html"
  end

end
