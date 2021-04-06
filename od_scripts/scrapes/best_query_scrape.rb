class BestQueryScrape < BestScrape

  ROWS=100000

  ## examples of args:
  ## 'building-or'
  ## 'oregondigital:abcde1234'
  ## "desc_metadata__institution_sim:#{RSolr.escape('http://thing.org/blah/banana')} AND ..."
  ## call scrape to use

  def initialize(setid, sample_pid, params="")
    @set = RSolr.escape("http://oregondigital.org/resource/oregondigital:#{setid}")
    outname = setid
    @params = params
    super
  end

  def query
    @params = "AND " + @params unless @params.empty?
    "desc_metadata__primarySet_ssi:#{@set} AND reviewed_ssim:true" + @params
  end

  def run_loop
    ActiveFedora::SolrService.query(query, :fl=> 'id', :rows=>ROWS).map{|x| x['id']}.each do |pid|
      item = GenericAsset.find(pid)
      process(item)
    end
  end
end
