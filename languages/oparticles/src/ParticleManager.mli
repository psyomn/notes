(* Particle Manager *)

open Coordinate;;

module ParticleManager : sig
  val tick : Particle.particle list -> unit
  val collision_check : Particle.particle list -> Coordinate.coordinate -> unit
end;;

