(* 
 * This contains particles, and should take care of the function ticks
 *
 * @author Simon Symeonidis 
 *)

open Coordinate
open Particle
open ParticleManager
open ParticleBuilder;;

class room = 
  object(self)
    (* Bounds of the room *)
    val bounds = (100.0, 100.0, 100.0)

    (* Maximum ticks of the simulation *)
    val maximum_ticks = 10_000

    (* Current tick in the current room instance *)
    val mutable current_tick  = 0

    (* The particles that exist in the room, simulation *)
    val mutable particles : Particle.particle list = [];

    (* Initialize with the list of particles *)
    method init () = particles <- ParticleBuilder.create_list 10

    (* Start the simulation *)
    method start () = self # start_backend()

    (* A tick in the simulation, with a single step *)
    method tick () = 
      current_tick <- current_tick + 1;
      ParticleManager.tick particles;
      ParticleManager.collision_check particles bounds;
      print_endline ("Tick # " ^ string_of_int current_tick);

    (* Print all the information in the room - essentially what happens in
       the builder *)
    method print () = ParticleBuilder.print_list particles

    (* Recursive function that prints out all the particles, and makes them
       interact in the system by a step *)
    method private start_backend () = 
      let rec tick_tock it =
        self # tick ();
        self # print ();
        if it > 0 then tick_tock (it - 1) else ()
      in tick_tock maximum_ticks;
  end;;

