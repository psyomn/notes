
pub fn recfib(nth: u64) -> u64 {
    0
}

pub fn itfib(nth: u64) -> u64 {
    let mut i: u64 = 0;
    let mut j: u64 = 1;

    for _ in 1..(nth) {
        let temp = i;
        i = j;
        j = temp + j;
    }

    i
}
