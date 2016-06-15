
require "~/lib_k247/K247_basic"

in_fn = "jegg500_142to143E_39to40N.nc"
  gp_dep0 = GPhys::IO.open( in_fn, "depth")
    gp_dep = gp_dep0.cut( "lat" => 39.0..39.5 )
    p gp_dep.max
    p gp_dep.min
  DCL.gropn( 2 ) # 1: display, 2: pdf
  #  GGraph.set_fig( 'viewport'=>[0.15, 0.65, 0.10, 0.60] )
    GGraph.set_fig( 'viewport'=>[0.15, 0.85, 0.15, 0.8] )
    DCL.udpset( 'lmsg', false ) # erase "contour interval ..."
    tlevs = 50.0 * NArray.sfloat( 40 ).indgen + 0.0
  # ouput
    GGraph.tone( gp_dep, true, "levels"=> tlevs, "title"=> "JEGG500 depth" )
    GGraph.contour( gp_dep, false, "levels"=> tlevs, "index"=>5 )
      GGraph.color_bar
  DCL.grcls
=begin
=end



