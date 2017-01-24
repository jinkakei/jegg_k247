
# load libraries
require "numru/gphys"
require "numru/ggraph"
require "narray"
require "numru/dcl"
include NumRu
require "~/lib_k247/K247_basic"

watcher = K247_Main_Watch.new

# ToDo
#  - missing value

jegg_org    = "jegg500_142to143E_39to40N_20160523.txt"
  n_x = 100; n_y = 100
  lon_min = 142.0; lon_max = 143.0
  lat_min =  39.0; lat_max =  40.0
#jegg_org    = "jegg500_141to144E_38to40N_20160524.txt"
#  n_x = 300; n_y = 200
#  lon_min = 141.0; lon_max = 144.0
#  lat_min =  38.0; lat_max =  40.0
#jegg_org    = "jegg500_139to144E_34to40N_20170124b.txt"
#  # 3600 sec
#  n_x = 500; n_y = 600
#  lon_min = 139.0; lon_max = 144.0
#  lat_min =  34.0; lat_max =  40.0
#jegg_org    = "jegg500_sample.txt"
#jegg_sorted = "jegg500_sorted.txt"
  # use bash ( not necessary )
  #system( "sort -k2 #{jegg_org} > #{jegg_sorted}")  

dtypes =[]; lats = []; lons = []; deps = []
#File.open( jegg_sorted, "r" ) do |fu|
File.open( jegg_org   , "r" ) do |fu|
  fu.each_line do | line |
    dt, la, lo, dp = line.chomp.split( " " )
    dtypes << dt; lats << la; lons << lo; deps << dp
  end
end


na_lats = NArray.sfloat( lats.length )
na_lons = NArray.sfloat( lats.length )
na_deps = NArray.sfloat( lats.length )
for i in 0..lats.length-1
#  puts "#{i}: #{lats[i]}"
  na_lats[i] = lats[i].to_f 
  na_lons[i] = lons[i].to_f 
  na_deps[i] = deps[i].to_f 
end
  p na_lons.min; p na_lons.max
  p na_lats.min; p na_lats.max

dx = ( lon_max - lon_min ) / n_x.to_f
dy = ( lat_max - lat_min ) / n_y.to_f
miss_val = -9999.9; na_miss = NArray.sfloat(1).fill( miss_val )
dep_arr = NArray.sfloat( n_x, n_y ).fill( miss_val )
lon_arr = lon_min + 0.5 * dx + dx * NArray.sfloat( n_x ).indgen
lat_arr = lat_min + 0.5 * dy + dy * NArray.sfloat( n_y ).indgen
#  p lon_arr.max; p lon_arr.min
#  p lat_arr.max: p lat_arr.min

i_x = Array( n_x )
i_y = Array( n_y )
for i in 0..n_x-1
  i_x[i] = ( na_lons[ 0..-1 ] - lon_arr[i] ).abs.le( 0.5 * dx )
end # for i in 0..n_x-1
for j in 0..n_y-1
  i_y[j] = ( na_lats[ 0..-1 ] - lat_arr[j] ).abs.le( 0.5 * dy )
end # for j in 0..n_y-1
for i in 0..n_x-1
for j in 0..n_y-1
  if ( i_x[i] * i_y[j] ).sum != 0
    dep_arr[i,j] = na_deps[ i_x[i] * i_y[j] ].mean
  end # if ( i_x[i] * i_y[j] ).sum != 0
end # for j in 0..n_y-1
end # for i in 0..n_x-1


xgrad_arr = NArray.sfloat( n_x, n_y ).fill( miss_val )
  deg_to_km = 0.01
for i in 0..n_x-2
for j in 0..n_y-2
  if ( dep_arr[i, j] > miss_val ) and ( dep_arr[i+1, j] > miss_val )
    xgrad_arr[i,j] = ( dep_arr[ i+1, j] - dep_arr[i,j] ) / dx * deg_to_km
  end
end # for j in 0..n_y-1
end # for i in 0..n_x-1


ax_lon = Axis.new.set_pos( VArray.new( lon_arr, \
           { "long_name" => "longitude", "units" => "degE"}, "lon") )
ax_lat = Axis.new.set_pos( VArray.new( lat_arr, \
           { "long_name" => "latitude" , "units" => "degN"}, "lat") )
da_dep = VArray.new( dep_arr, \
                    { "long_name" => "depth", "missing_value" => na_miss, "units" => "m"}, \
                    "depth" )
gp_dep = GPhys.new( Grid.new( ax_lon, ax_lat ), da_dep )
da_xgrad = VArray.new( xgrad_arr, \
                    { "long_name" => "x gradient of depth", "missing_value" => na_miss, "units" => "m/km"}, \
                    "xgrad" )
gp_xgrad = GPhys.new( Grid.new( ax_lon, ax_lat ), da_xgrad )

fu = NetCDF.create( "output.nc" )
  GPhys::NetCDF_IO.write( fu, gp_dep )
  GPhys::NetCDF_IO.write( fu, gp_xgrad )
  fu.put_att( "org_filename", jegg_org )
fu.close
=begin
=end

watcher.end_process
