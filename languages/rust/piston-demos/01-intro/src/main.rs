extern crate piston_window;
extern crate rand;

use piston_window::*;
use rand::Rng;

struct Coord {
    x: f64,
    y: f64,
}


fn main() {
    let mut window: PistonWindow =
        WindowSettings::new("Hello world, you suck.", [400, 400])
          .exit_on_esc(true)
          .build()
          .unwrap();

    const BLACK: [f32; 4] = [0.0, 0.0, 0.0, 1.0];
    const RED:   [f32; 4] = [1.0, 0.0, 0.0, 1.0];
    const GREEN: [f32; 4] = [0.0, 1.0, 0.0, 1.0];
    const BLUE:  [f32; 4] = [0.0, 0.0, 1.0, 1.0];

    let mut color = BLACK;

    let mut coord = Coord { x: 0.0, y: 0.0 };

    while let Some(e) = window.next() {

        match e {
            Input::Press(but) => {
                match but {
                    Button::Keyboard(Key::Up) => {
                        color = BLACK;
                        coord.y -= 1.0;
                    },
                    Button::Keyboard(Key::Down) => {
                        color = RED;
                        coord.y += 1.0;
                    },
                    Button::Keyboard(Key::Left) => {
                        color = GREEN;
                        coord.x -= 1.0;
                    },
                    Button::Keyboard(Key::Right) => {
                        color = BLUE;
                        coord.x += 1.0;
                    },
                    _ => { },
                }
            },
            _ => {}
        }

        window.draw_2d(&e, |c, g| {

            clear([1.0; 4], g);

            rectangle(
                color,
                [coord.x, coord.y, coord.x + 10.0, coord.y + 10.0],
                c.transform, g);

        });
    }
}
