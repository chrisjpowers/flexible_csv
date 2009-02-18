class FlexibleCsv
  require 'faster_csv'
  require 'hacks.rb'
  
  # a Hash where the key is the method name, and the value is the array of possible headers
  attr_reader :column_hash
  
  def initialize
    @column_hash = {}
    yield self
  end
  
  # Developed by Chris Powers, Killswitch Collective on 02/17/2009
  #
  # <b>Description:</b> Parses a CSV data source, either a String or an IO object
  #
  # <b>Arguments:</b> CSV formatted String or IO of CSV file
  #
  # <b>Returns:</b> Parser object
  #
  # <em>Syntax: @parser = @flexible_csv.parse(File.open('path/to/file.csv'))</em>
  def parse(data)
    Parser.new(data, self)
  end
  
  # Developed by Chris Powers, Killswitch Collective on 02/17/2009
  #
  # <b>Description:</b> 
  #
  # <b>Arguments:</b> The hash key / method name and any number of possible header labels as strings
  #
  # <b>Returns:</b> nil
  #
  # <em>Syntax: csv.column :name, "Full Name", "Name", "Client Name"</em>
  def column(id, *args)
    @column_hash[id] = args.map {|item| clean_up(item) }
    nil
  end
  
  # Developed by Chris Powers, Killswitch Collective on 02/17/2009
  #
  # <b>Description:</b> Helper method to remove whitespace, capitalization and punctuation
  #
  # <b>Arguments:</b> a string
  #
  # <b>Returns:</b> a formatted string
  #
  # <em>Syntax: clean_up "My Column!" #=> 'mycolumn'</em>
  def clean_up(str)
    str.to_s.downcase.gsub(/[^a-z0-9]/, '')
  end
  
  # Wrapper class around the FasterCSV object
  class Parser
    
    def initialize(data, csv_parent)
      column_headers = []
      
      fcsv = FasterCSV.new(data.is_a?(String) ? data : data.read, :headers => true)

      # reformat headers to remove punctuation, capitalization and white space
      # Change header labels to the key used in the column config
      fcsv.header_convert do |field| 
        f = csv_parent.clean_up(field)
        csv_parent.column_hash.each_pair do |k,v|
          f = k.to_s and break if v.include?(f)
        end
        f
      end
      
      @table = fcsv.read
    end
    
    # proxy other methods to the @table object
    def method_missing(method_name, *args, &block)
      @table.send(method_name, *args, &block)
    end
    
  end
  
end