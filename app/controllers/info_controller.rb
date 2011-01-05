class InfoController < ApplicationController
  layout 'application', :except => 'index'
  skip_before_filter :authenticate
  def about
  end
  
  def contact
  end
  
  def people
  end
  
  def terms
  end
  
  def index
  end

end
