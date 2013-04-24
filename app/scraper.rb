require 'nokogiri'
require 'open-uri'

class Scraper
  class << self
    def host
      "http://buncombe.digitalhealthdepartment.com"
    end
    
    def import_facility_ids
      base_uri = "#{host}/reports.cfm?q=alpha&a="

      all_queries = (1 .. 9).to_a + ('a' .. 'z').to_a

      facility_ids = all_queries.map do |q|
        doc = Nokogiri::HTML(open(base_uri + q.to_s).read)
        other_pages = doc.search('a.teaser').map{ |e| e['href'] unless e['href'] =~ /start=1\&/ }.compact

        docs = [doc, *other_pages.map{ |path| Nokogiri::HTML(open("#{host}/#{path}").read)  } ]
        hrefs = docs.map{ |d| d.search('a.bodytitle').map{ |e| e['href'] } }.flatten.uniq.compact
        puts hrefs.inspect

        hrefs
      end.flatten.uniq.compact.map{ |h| h.match('facilityID=(.*)')[1] }
      
      facility_ids.each do |f_id|
        Facility.create(original_id: f_id) unless Facility.where(original_id: f_id).exists?
      end
    end
    
    def import_facility_inspections(facility_id)
      
    end
  end
end