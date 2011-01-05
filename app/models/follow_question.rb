require 'common_functions.rb'
class FollowQuestion < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :question
  belongs_to :profile
  
  def self.add_follow_question(question_id,profile_id)
    follow_question = FollowQuestion.new
    follow_question.question_id = question_id
    follow_question.profile_id = profile_id
    if follow_question.save
       find_followers(question_id)
    else
      -1
    end
  end
   
  def self.find_followers(question_id)
    followers = Profile.find_by_sql("Select distinct p.email,p.name from profiles p, follow_questions fq where p.id = fq.profile_id and fq.question_id = #{question_id}")
    if !followers.nil?
      followers.each do |follower|
        send_email(follower.email, follower.name, question_id)
      end
    end
    followers
  end
  
  def self.send_email(email, name, question_id)
    #code to send email to the 'email' parameter
    CommonMailer.deliver_new_answer_email(email, name, question_id)
  end
  
end
