(* Main entry point! *) 

open Room;;
open Coordinate;;

let _ = Random.self_init()
let simulation = new Room.room

let main = 
  simulation # init();
  simulation # start();;

