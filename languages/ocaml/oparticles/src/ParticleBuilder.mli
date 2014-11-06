(*
 * Particle builder, following the builder pattern, and providing functions
 * that can help us out a little. 
 * 
 * @author Simon Symeonidis
 *)

open Particle;;

module ParticleBuilder : sig
  val create_particle : unit -> Particle.particle
  val create_jonny    : unit -> Particle.particle
  val create_random   : unit -> Particle.particle
  val create_list     : int  -> Particle.particle list

  val print_list      : Particle.particle list -> unit

end;;

