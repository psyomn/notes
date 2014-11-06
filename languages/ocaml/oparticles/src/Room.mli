(* 
 * This is a container of all the particles. This object should define
 * the bounds in which the particles exist.
 *
 * @author Simon Symeonidis 
 *)

open Coordinate
open Particle
open ParticleManager
open ParticleBuilder;;

class room : 
  object
    val bounds : Coordinate.coordinate
    val mutable particles : Particle.particle list
    val maximum_ticks : int
    val mutable current_tick  : int

    method init  : unit -> unit
    method tick  : unit -> unit
    method start : unit -> unit
    method print : unit -> unit

  end;;

