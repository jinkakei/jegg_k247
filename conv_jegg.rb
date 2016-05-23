
# load libraries
require "numru/gphys"
require "numru/ggraph"
require "narray"
require "numru/dcl"
include NumRu
require "~/lib_k247/K247_basic"

watcher = K247_Main_Watch.new

jegg_org    = "jegg500_sample.txt"
jegg_sorted = "jegg500_sorted.txt"
# use bash
#system( "sort -k2 #{jegg_org} > #{jegg_sorted}")

dtypes =[]; lats = []; lons = []; deps = []
File.open( jegg_sorted, "r" ) do |fu|
  fu.each_line do | line |
    dt, la, lo, dp = line.chomp.split( " " )
    dtypes << dt; lats << la; lons << lo; deps << dp
  end
end

na_lats = NArray.sfloat( lats.length )
na_lons = NArray.sfloat( lats.length )
for i in 0..lats.length-1
#  puts "#{i}: #{lats[i]}"
  na_lats[i] = lats[i].to_f 
  na_lons[i] = lons[i].to_f 
end
p na_lats.length
#p na_lats.le( 39.1 )
i_a = na_lats[0..-1].le( 39.1 )
p i_a.sum
p na_lons[i_a].le( 142.1 ).sum
p na_lons[i_a].ge( 142.9 ).sum

watcher.end_process
