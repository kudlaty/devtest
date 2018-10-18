require 'net/http'
require 'json'
class PanelProvider < ApplicationRecord
  
  CODES_URI = {
    'times_a' => "http://time.com",
    '10_arrays' => 'http://openlibrary.org/search.json?q=the+lord+of+the+rings',
    'times_html' => 'http://time.com'
  }
  
  validates :code, presence: true, uniqueness: true
  
  def price
    begin
      uri = URI(CODES_URI[code])
      response_body = Net::HTTP.get(uri)
      send("price_#{code}", response_body)
    rescue
      
    end
  end
  
  private
  
  def price_times_a response_body
    raise TypeError unless response_body.is_a? String
    response_body.count('a')/100.0
  end
  
  def price_10_arrays response_body, min_items_count=11
    raise TypeError unless response_body.is_a? String
    hash_obj = JSON.parse(response_body)
    count_arrays hash_obj, min_items_count
  end
  def count_arrays obj, min_items_count
    return 0 unless [Hash,Array].include?(obj.class)
    count = ((obj.is_a?(Array) and obj.size >= min_items_count) ? 1 : 0)
    if obj.is_a?(Hash)
      obj.map{ |k,v| count_arrays v, min_items_count }.inject(:+) + count
    else
      obj.map{|v| count_arrays v, min_items_count }.inject(:+) + count
    end
  end
  
  def price_times_html response_body
    raise TypeError unless response_body.is_a? String
    response_body.scan(/<[^\/][^>]*>/).count/100.0
  end
  

  
end
