class BestScrape

  ## examples of args:
  ## 'oregondigital:abcde1234'
  ## call scrape to use

  def initialize(sample_pid)
    outname ||= Time.zone.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
    @f = File.open("/data1/batch/uoath_tiffs_jp2s/#{outname}-scrape.txt", 'w')
    @properties = property_hash
    @fields = fields(sample_pid)
  end

  def scrape
    print_header
    run_loop
    @f.close
  end

  def property_hash
    hash = {}
    Datastream::OregonRDF.properties.each do |key, prop|
      hash[prop.predicate.to_s] = key
    end
    hash
  end

  #iterate through all items, call process
  def run_loop
  end

  def process(item)
    return unless ((!item.nil?) && (item.is_a? GenericAsset) && (!item.soft_destroyed?))
    string = item.pid + "\t"

    @fields.each do |field|
      arr = []
      item.descMetadata.send(field.to_sym).each do |val|
        if val.respond_to? :rdf_subject
          arr << val.rdf_subject.to_s + "$" + val.rdf_label.first
        else
          arr << val
        end
      end
      string += arr.join('|')
      string += "\t"
    end
    @f.puts string
  end

  #override this if not all fields needed
  def fields(sample_pid)
    remove = ["http://www.iana.org/assignments/relation/next",
      "http://www.openarchives.org/ore/1.0/datamodel#proxyFor",
      "http://www.iana.org/assignments/relation/last",
      "http://www.iana.org/assignments/relation/first",
      "http://opaquenamespace.org/ns/set",
      "http://opaquenamespace.org/ns/primarySet",
      "http://opaquenamespace.org/ns/contents"]
    fields = []
    item = GenericAsset.find(sample_pid)
    item.descMetadata.graph.statements.each do |s|
      next if remove.include? s.predicate.to_s
      field = @properties[s.predicate.to_s]
      if field.nil? 
        @f.puts "warning: could not identify #{s.predicate.to_s} in #{item.pid}"
      else
        fields << field
      end
    end
    fields
  end

  def print_header
    @f.puts @fields.join("\t")
  end
end
