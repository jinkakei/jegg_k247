
require "~/lib_k247/K247_basic"


in_fn = "jegg500_142to143E_39to40N.nc"
  gp_dep = GPhys::IO.open( in_fn, "depth")
    xn, yn = gp_dep.shape
    xname = gp_dep.coord(0).name
    yname =  gp_dep.coord(1).name; yval = gp_dep.coord(1).val
    p gp_dep.max
    p gp_dep.min
  DCL.gropn( 2 ) # 1: display, 2: pdf
  #  GGraph.set_fig( 'viewport'=>[0.15, 0.65, 0.10, 0.60] )
    GGraph.set_fig( 'viewport'=>[0.15, 0.85, 0.15, 0.8] )
    DCL.udpset( 'lmsg', false ) # erase "contour interval ..."
    tlevs = 50.0 * NArray.sfloat( 40 ).indgen + 0.0
  ystep = 1
  #for j0 in 0..yn-1
  for j0 in 0..(yn/ystep)-1
    j = j0*ystep
    GGraph.line( 1.0 * gp_dep.cut(yname=>yval[j]), \
                true, "index"=> 9, "max"=>0, "min"=>1000,\
                "title"=> "JEGG500 depth: #{yval[j].round(2)}N" )
  end
  DCL.grcls
=begin
=end

=begin
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
=end



