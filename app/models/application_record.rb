class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.found_data_message
    "The data has been retrieved successfully"
  end

  def self.not_found_message
    "Data not found."
  end

  def self.invalid_message
    "Data invalid."
  end

  def self.locked_message
    "Item has locked."
  end

  def self.lock_success_message
    "Item has locked."
  end

  def self.unlock_success_message
    "Item has unlocked."
  end

  def self.create_success_message
    "Item has created successfully."
  end

  def self.exist_record_reference_message(model1, model2)
    "Item has reference data."
  end

  def self.destroy_success_message
    "Remove #{self.model_name.singular_route_key} successfully."
  end

  def self.update_success_message
    "Update #{self.model_name.singular_route_key} successfully."
  end
end
