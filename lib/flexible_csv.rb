class FlexibleCsv
  require 'rubygems'
  require 'faster_csv'
  
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
  
  # This is the enumerator class for looping through CSV rows
  class Parser
    
    include Enumerable
    
    def initialize(data, csv_parent)
      column_headers = []
      
      fcsv = FasterCSV.new(data.is_a?(String) ? data : data.read, :headers => true)

      # reformat headers to remove punctuation, capitalization and white space
      # This block doesn't run until fcsv.read is used
      fcsv.header_convert do |field| 
        f = csv_parent.clean_up(field)
        column_headers << f
        f
      end
      
      @table = fcsv.read
            
      @final_map = {}
      column_headers.each do |ch|
        csv_parent.column_hash.each_pair do |k,v|
          @final_map[k] = ch and break if v.include?(ch)
        end
      end
    end
    
    # loops through CSV rows, yields block to a new Row object for each CSV row
    def each
      @table.each do |row|
        my_row = Row.new(row, @final_map)
        yield my_row
      end
    end
    
    # Provides a simple key/value interface by method name or bracket access
    class Row
      def initialize(csv_row, map)
        @map = map
        @csv_row = csv_row
      end
      
      def [](key)
        find_value(key)
      end
      
      def method_missing(method_name)
        find_value(method_name)
      end
      
      private
      
      def find_value(key)
        @csv_row[@map[key]]
      end
    end
    
  end
  
  
  
end