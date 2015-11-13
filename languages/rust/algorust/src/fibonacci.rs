/// Recursive definition, slower.
pub fn recfib(nth: u64, prev: u64, next: u64) -> u64 {
    if nth <= 0 { return prev }
    return recfib(
        nth - 1,
        next,
        next + prev);
}

/// Faster iterative definition
pub fn itfib(nth: u64) -> u64 {
    let mut i: u64 = 0;
    let mut j: u64 = 1;

    for _ in 0..(nth) {
        let temp = i;
        i = j;
        j = temp + j;
    }

    i
}
