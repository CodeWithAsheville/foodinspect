require 'grape'

class API < Grape::API
  format :json
  
  get '/status.json' do
    { status: 'ok', facilities: Facility.count, inspections: Inspection.count }
  end
  
  post '/scrape' do
    Scraper.import_facility_ids
    { status: 'ok' }
  end
  
  get '/facilities' do
    Facility.all.map(&:to_json)
  end
  
  get '/inspections' do
    Inspection.all.map(&:to_json)
  end
  
  #add_swagger_documentation
end
