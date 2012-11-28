class Kalibro::Repository < Kalibro::Model
  
  attr_accessor :id, :name, :description, :license, :process_period, :type, :address, :configuration_id

  def self.repository_types
    request(:supported_repository_types)[:supported_type].to_a
  end

  def self.repository_of(processing_id)
    new request(:repository_of, {:processing_id => processing_id})[:repository]
  end
  
  def self.repositories_of(project_id)
    request(:repositories_of, {:project_id => project_id})[:repository].to_a.map { |repository| new repository }
  end

  def process_repository
    self.class.request(:process_repository, {:repository_id => self.id})
  end
  
  def cancel_processing_of_repository
    self.class.request(:cancel_processing_of_repository, {:repository_id => self.id})
  end

  def save(project_id)
    begin
      self.id = self.class.request(:save_repository, {:repository => self.to_hash, :project_id => project_id})[:repository_id]
      true
	  rescue Exception => exception
	    add_error exception
	    false
    end
  end

end
