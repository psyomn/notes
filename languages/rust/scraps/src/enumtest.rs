/* from the book */
enum Message {
    Quit,
    ChangeColor(i32, i32, i32),
    Move { x: i32, y: i32 },
    Write(String),
}

enum BoardGameTurn {
    Move { squares: i32 },
    Pass,
}

pub fn run() {
    println!("Enumeration tests");

    let messages: Vec<Message> = vec![
        Message::Quit,
        Message::ChangeColor(1,2,3),
        Message::Move { x: 1, y: 2 },
        Message::Write("potato".to_string()),
    ];

    for m in messages {
        match m {
            Message::Quit => println!("There was a request to quit"),
            Message::ChangeColor(x,y,z) => println!("change to: r:{} g:{} b:{}", x, y, z),
            Message::Move{x,y} => println!("Move: x:{} y:{}", x, y),
            Message::Write(s) => println!("Write: {}", s),
        }
    }
}
