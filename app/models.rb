require 'mongoid'

Mongoid.load! "config/mongoid.yml"

class Facility
  include Mongoid::Document
  
  has_many :inspections
  
  field :original_id, type: String
end

class Inspection
  include Mongoid::Document
  
  belongs_to :facility
  
  field :score,           type: Integer
  field :inspection_date, type: Date
end