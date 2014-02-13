module AdminsHelper

  def get_category_name(category_id)
    cat = Jobcategorymaster.find(:first, :conditions=>{:id=>category_id})
    rlt = 'deleted'
    if cat
      rlt = cat.category 
    end
    rlt
  end

  def get_user_name(user_id)
    usr = User.find(:first, :conditions=>{:id=>user_id})
    rlt = 'deleted'
    if usr
      rlt = usr.first_name + ' ' + usr.last_name    
    end
    rlt
  end
  def get_job_title(job_id)
    #job = Job.find(job_id)
    job = Job.find(:first, :conditions=>{:id=>job_id})
    rlt = 'deleted'
    if job
      rlt = job.job_title
    end
    rlt
  end
  def get_suggestion_title(suggestion_id)
    sug = BrandslipSuggestion.find(:first, :conditions=>{:id=>suggestion_id})
    rlt = 'deleted'
    if sug
      rlt = sug.title
    end
    rlt
  end
end
