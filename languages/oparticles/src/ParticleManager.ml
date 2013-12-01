(* 
 * The particle manager is supposed to handle all the actions that are to
 * be performed on the particles on a tick of the simulation.
 * @author Simon Symeonidis
 *)

open CoordinateHelper
open Physics;;

module ParticleManager = struct
  (* Iterate each particle, and apply its tick *)
  let rec tick particles = 
    if particles = [] then () else begin
      Physics.apply (List.hd particles);
      tick (List.tl particles);
    end;;

  (* Bounce against X wall *)
  let bounce_x b p =
    if p # get_x > CoordinateHelper.fs b || p # get_x < 0.0
    then p # set_angle_xy (p # get_angle_xy +. Physics.half_pi)
    else ();;

  (* Bounce against Y wall *)
  let bounce_z b p = 
    if p # get_z > CoordinateHelper.th b || p # get_z < 0.0
    then p # set_angle_xz (p # get_angle_xz +. Physics.half_pi)
    else ();;

  (* Bounce against Z wall *)
  let bounce_y b p = 
    if p # get_y > CoordinateHelper.sc b || p # get_y < 0.0
    then p # set_angle_xy (p # get_angle_xy +. Physics.half_pi)
    else ();;

  let bounce bounds particle =
    bounce_x bounds particle;
    bounce_y bounds particle;
    bounce_z bounds particle;;

  (* Check collisions with the wall *)
  let rec collision_check particles bounds = 
    if particles = [] then () else begin
      bounce bounds (List.hd particles);
      collision_check (List.tl particles) bounds;
    end;;
end;;

