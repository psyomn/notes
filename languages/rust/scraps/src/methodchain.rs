use std::f64::consts::PI;

struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {

    fn area(&self) -> f64 {
        return PI * (self.radius * self.radius)
    }

    fn grow(&self, increment: f64) -> Circle {
        Circle {x: self.x, y: self.y, radius: self.radius + increment}
    }

}

pub fn run() {
    let c = Circle { x: 0.0, y: 0.0, radius: 2.0 };
    println!("");
    println!("Running the growing method chaining");
    println!("{}", c.area());
    println!("chain {}", c.grow(2.0).area());
}

