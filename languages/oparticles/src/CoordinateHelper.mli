(* 
 * Simple coordinate helper so that we can move things, and check if particles
 * have hit a wall / are in some bounds that they are not supposed to
 * @author Simon Symeonidis 
 *)

open Coordinate;;

module CoordinateHelper : sig
    val hit_wall : Coordinate.coordinate -> Coordinate.coordinate -> bool
    val fs : Coordinate.coordinate -> float
    val sc : Coordinate.coordinate -> float
    val th : Coordinate.coordinate -> float

    val set_fs : 'a -> 'a * 'a * 'a -> 'a * 'a * 'a
    val set_sc : 'a -> 'a * 'a * 'a -> 'a * 'a * 'a
    val set_th : 'a -> 'a * 'a * 'a -> 'a * 'a * 'a

    val add_fs : float -> Coordinate.coordinate -> Coordinate.coordinate
    val add_sc : float -> Coordinate.coordinate -> Coordinate.coordinate
    val add_th : float -> Coordinate.coordinate -> Coordinate.coordinate

    val to_string : Coordinate.coordinate -> string
  end;;
