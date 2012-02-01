class Kite < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  @@writeDirectory = "public/uploaded_images"
  @@referenceDirectory = "/uploaded_images/"
  
  def upload(uploaded_file)
    name = uploaded_file.original_filename
    just_filename = Digest::SHA1.hexdigest(Time.now.to_s)
    
    path = File.join(@@writeDirectory, just_filename)
    File.open(path, "wb") { |f| f.write(uploaded_file.read) }
    
    return @@referenceDirectory.concat(just_filename)
  end
  
  def complete
    update_attribute(:Completed, 1)
    update_attribute(:CompleteDate, Date.today)
    self.save!
  end
  
  def cleanup
    cleanName = self.ImageLocation
    fixedWriteDir = @@writeDirectory.concat("/")
    cleanName.sub!(@@referenceDirectory, fixedWriteDir)
    if File.exists?(cleanName)
      File.delete(cleanName)
    end
  end
  
end
