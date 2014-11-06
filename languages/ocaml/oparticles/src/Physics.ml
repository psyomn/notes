(* Some elementary physics functions that we use in order to make particles 
 * move around 
 * 
 * @author Simon Symeonidis *)

open CoordinateHelper
open Particle;;

module Physics = struct
  (* SUVAT Equations *)

  let v1 u a t = u +. a *. t;; 
  let v2 u a s = sqrt((u *. u) +. 2.0 *. a *. s)

  let s1 u a t = u *. t +. 0.5 *. a *. t *. t;;
  let s2 u v t = 0.5 *. (u +. v) *. t;;
  let s3 u a t = u *. t -. 0.5 *. a *. t *. t;;

  (* Thanks to 
   * http://caml.inria.fr/mantis/view.php?id=5173 *) 
  let pi = 4. *. atan 1.

  (* quickhand *)
  let half_pi = pi /. 2.

  (* Get the x vector value from a 3d vec *)
  let vecx theta v = cos(pi /. 2. -. theta) *. v

  (* Get the y vector value from a 3d vec *)
  let vecy theta v = cos(theta) *. v

  (* Get the z vector value from a 3d vec *)
  let vecz theta v = sin(theta) *. v

  (* Apply the physics on one particle *) 
  let apply particle = 
    let vel = particle # get_velocity in
    let angle_xy = particle # get_angle_xy in
    let angle_xz = particle # get_angle_xz in
    particle # move_x (vecx angle_xy vel);
    particle # move_y (vecy angle_xy vel);
    particle # move_z (vecz angle_xz vel);;
end;;
