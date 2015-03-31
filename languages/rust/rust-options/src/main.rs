fn twice(v : Option<u32>) -> Option<u32> {
    match v {
        Some(k) => Some(k * 2),
        _       => None
    }
}

fn sub(v : Option<u32>, s : Option<u32>) -> Option<u32> {
    match (v, s) {
        (Some(k), Some(l)) => if (k > l) {Some(k - l)} else {Some(l - k)},
        (Some(k), None)    => Some(k),
        _                  => None
    }
}

fn complex_calculation(l: Option<u32>, m: Option<u32>,
                       n: Option<u32>, o: Option<u32>) -> Option<u32> {
    let first_calc  = twice(sub(twice(l), o));
    let second_calc = sub(sub(first_calc, n), sub(first_calc, o));
    let third_calc  = twice(second_calc);
    let ret = sub(third_calc, first_calc);
    ret
}

fn main() {
    let a: Option<u32> = Some(12u32);
    let b: Option<u32> = Some(4u32);
    let c: Option<u32> = Some(1u32);
    let d: Option<u32> = Some(8u32);

    match complex_calculation(a,b,c,d) {
        Some(k) => println!("{:?}", k),
        None    => println!("Failed!")
    }
}

#[test]
fn test_twice_ok() {
    let a = Some(12u32);
    let ta = twice(twice(a));
    match ta {
        Some(k) => assert!(k == 48),
        None    => panic!("should yield 48")
    }
}

#[test]
fn test_twice_none() {
    let a = None;
    let ta = twice(twice(a));
    match ta {
        Some(k) => panic!("should yield none"),
        None    => assert!(true)
    }
}

#[test]
fn test_sub_twice() {
    let a = Some(99u32);
    let b = Some(22u32);
    let r = sub(twice(a), b);
    match r {
        Some(val) => assert!(val == 176u32),
        None      => panic!("I sould have a value!")
    }
}

