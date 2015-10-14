/// Implementation of insert sort
pub fn insort(mut v: Vec<i32>) -> Vec<i32> {
    if v.len() < 2 { return v }

    for j in 2..v.len()+1 {
        let key = v[j - 1];
        let mut i = j - 1;
        while i > 0 && v[i-1] > key {
            v[i] = v[i-1];
            i = i - 1;
        }
        v[i] = key;
    }

    v
}

#[test]
pub fn insort_test_i32_normal() -> () {
   assert_eq!(
       insort(vec![4,1,6,2,9]),
       vec![1,2,4,6,9]);
}

#[test]
pub fn insort_test_i32_all_reverse() -> () {
    assert_eq!(
        insort(vec![9,8,7,6,5,4,3]),
        vec![3,4,5,6,7,8,9]);
}

#[test]
pub fn insort_test_i32_all_fringe() -> () {
   assert_eq!(
       insort(vec![1,2]),
       vec![1,2]);
}
