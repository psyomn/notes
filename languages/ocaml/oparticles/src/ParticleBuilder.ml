open Physics
open Particle
open Random;;

(*
 * Implementation of the particle builder. This provides some static 
 * creational patterns for creating particles. 
 *
 * @author Simon Symeonidis 
 *) 
module ParticleBuilder = struct
  (* Shorthand for a random float bounded by 'f' *)
  let rfloat f = Random.float f;;

  (* Shorthand for a random int bounded by 'i' *)
  let rint   i = Random.int i;;

  (* Create a new particle *)
  let create_particle () = new Particle.particle;;

  (* This is just a function that creates a particle with some predefined and
     hardcoded values. This is here mainly because I was fiddling around with
     the language *)
  let create_jonny () = 
    let n = new Particle.particle in 
      n # set_mass         0.2;
      n # set_label        "jonny";
      n # set_velocity     0.3;
      n # set_acceleration 0.0;
      n # set_group        0;
      n # set_angle_xz     0.0;
      n # set_angle_xy     0.0;
    n;;

  (* Create a fully randomized particle *)
  let create_random () =
    let n = new Particle.particle in
      n # set_mass         (rfloat 1.0);
      n # set_label        "random";
      n # set_velocity     (rfloat 2.0);
      n # set_acceleration (rfloat 1.0);
      n # set_group        (rint 4);
      n # set_angle_xz     (rfloat Physics.pi);
      n # set_angle_xy     (rfloat Physics.pi);
    n;;

  (* Recursive function to create a list of randomized particles *)
  let rec create_list amnt = 
    if amnt = 0 then [] else create_random() :: create_list (amnt - 1);;
  
  (* Recursive function to print out some particles *)
  let rec print_list plist =
    if plist = [] then () 
    else begin
      print_endline ((List.hd plist) # to_string);
      print_list (List.tl plist);
    end;;

end;; (* module ParticleBuilder *)

