(* Small helper to provide common functionalities for Coordinate tuples
 * @author Simon Symeonidis *) 

open String
open Coordinate;;

module CoordinateHelper = struct
    let hit_wall(px,py,pz) (wx,wy,wz) = true

    let fs (x,_,_) = x
    let sc (_,y,_) = y
    let th (_,_,z) = z
    
    let set_fs x (_,y,z) = (x,y,z)
    let set_sc y (x,_,z) = (x,y,z)
    let set_th z (x,y,_) = (x,y,z)

    let add_fs a (x,y,z) = (a+.x,y,z)
    let add_sc a (x,y,z) = (x,y+.a,z)
    let add_th a (x,y,z) = (x,y,z+.a)

    let to_string c = "(" ^ string_of_float (fs c)
      ^ ", " ^ string_of_float (sc c)
      ^ ", " ^ string_of_float (th c) ^ ")"

  end;;

