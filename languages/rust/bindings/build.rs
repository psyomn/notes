extern crate gcc;

fn main() {
    gcc::Config::new().file("src/types.c").compile("libtypes.a");
}
