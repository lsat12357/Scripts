class BestListScrape < BestScrape

  ## examples of args:
  ## 'filename.txt'
  ## 'oregondigital:abcde1234'
  ## call scrape to use

  def initialize(filename, sample_pid)
    @filename = filename
    outname = File.basename(filename, '.txt')
    super(sample_pid)
  end

 
  def run_loop
    File.readlines(@filename).each do |pid|
      item = GenericAsset.find(pid.strip)
      process(item)
    end
  end
end
