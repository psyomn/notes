extern crate libc;

use std::ffi::CString;

use libc::{
    c_char,
    uint32_t,
    uint16_t,
    uint64_t,
};

#[repr(C)]
struct simple;

#[link(name="types", kind="static")]
extern {
    fn nothing() -> ();
    fn one_param(p: uint32_t) -> ();
    fn string_length(str: *const c_char) -> usize;
    fn create_simple() -> *mut simple;
    fn free_simple(s: *mut simple) -> ();
}

fn main() {
    let mut s_len: usize = 0;
    let mut owned_len: usize = 0;
    let mut owned_string: String = "kittens are pretty cute".into();

    unsafe {
        let sample_u32t: uint32_t = 12;

        // Some of the benign calls here
        nothing();
        one_param(sample_u32t);

        // With actual returns
        s_len = string_length(CString::new("test").unwrap().as_ptr());

        // How to pas a String (TODO: what does it mean if we pass a
        // owned String, and shove it in a CString? what does this
        // entail for the ownership?)
        owned_len = string_length(CString::new(owned_string).unwrap().as_ptr());
    }

    println!("string_length(\"test\") returns: {}", s_len);
    println!("string_length(String) returns: {}", owned_len);
}
