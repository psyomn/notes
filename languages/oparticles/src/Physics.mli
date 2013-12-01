(* @author Simon Symeonidis *) 

open Particle;;
open CoordinateHelper;;

module Physics : sig
  val v1 : float -> float -> float -> float
  val s1 : float -> float -> float -> float
  val s2 : float -> float -> float -> float
  val s3 : float -> float -> float -> float
  val v2 : float -> float -> float -> float

  val apply : Particle.particle -> unit

  val pi : float
  val half_pi : float
  val vecx : float -> float -> float
  val vecy : float -> float -> float
  val vecz : float -> float -> float
end;;

