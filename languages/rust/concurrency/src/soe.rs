//! Just some idea I had in the mean time that if one number is found to divide the next term, then
//! the parallel parts may bail, and wait for the next order from the master thread

fn main() -> () {
    println!("{:?}", simple_soe(10000));
}

fn simple_soe(max: u64) -> Vec<u64> {
    let mut n: u64 = 1;
    let mut v: Vec<u64> = vec![1, 2];
    let mut divides: bool = false;

    while n < max {
        n += 2;
        for x in v.iter() {
            divides |= n % x == 0;
            if divides { break; }
        }

        if !divides {
            v.push(n);
            divides = false;
        }
    }

    v
}

