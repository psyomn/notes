
fn my_i32_map(f: fn(i32) -> i32, v: &Vec<i32>) -> Vec<i32> {
    let mut newv = Vec::<i32>::new();

    for el in v.iter() {
        newv.push(f(*el));
    }

    return newv;
}

fn lambda_pass<F1>(mut c: F1, v: &Vec<i32>) -> Vec<i32>
    where F1: FnMut(i32) -> i32
{
    let mut newv = Vec::<i32>::new();

    for el in v.iter() {
        newv.push(c(*el));
    }

    return newv;
}

fn add_one(x: i32) -> i32 { x + 1 }

fn main() {
    let minifunc = |&:x:i32| -> i32 x + x;
    let v:    Vec<i32> = vec!(1, 2, 3, 4);
    let vsqr: Vec<i32> = vec!(1, 2, 3, 4, 5);

    let v2      = my_i32_map(add_one, &v);
    let vsqr_rt = lambda_pass(|x| x * x, &vsqr);

    println!("Minifunc: {}", minifunc(2));
    print!("Vec: ");

    for el in v2.iter() {
        print!("{}, ", el);
    }
    println!("");

    for el in vsqr_rt.iter() {
        print!("{}, ", el);
    }
    println!("");
}

/*
  Output:
  Minifunc: 4
  Vec: 2, 3, 4, 5,
*/
