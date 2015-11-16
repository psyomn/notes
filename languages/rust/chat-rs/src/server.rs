use std::net::{TcpListener, TcpStream};
use std::io::{Read, Write};
use std::io;
use std::thread;

const SUCCESS: u8 = 200u8;

pub struct Server {
    host: String,
    port: u16,
    listening_done: bool,
    //clients: Vec<Address>,
}

impl Server {
    pub fn new(h: String, p: u16) -> Server {
        Server {
            host: h,
            port: p,
            listening_done: false,
        }
    }

    pub fn listen(&mut self) -> () {
        println!("start: host {}, port {}", self.host, self.port);
        let mut listener: TcpListener =
            TcpListener::bind(format!("{}:{}", self.host, self.port).as_ref() as &str).unwrap();
        for stream in listener.incoming() {
            match stream {
                Ok(mut ss) => {
                    thread::spawn(move || { handle_client(ss) });
                },
                Err(mut e) => {
                    write!(io::stderr(), "Error!");
                },
            }
        }
    }
}

fn handle_client(mut s: TcpStream) -> () {
    let mut v8: [u8; 256] = [0; 256];

    let _ = s.read(&mut v8);
    let recv: String = String::from_utf8_lossy(&v8).into_owned();

    println!("Received something");
    let _ = io::stdout().flush();
    println!("{}", recv);
    println!("Done receiving things");
    match s.write(&[SUCCESS]) {
        Ok(..) => println!("Wrote to client!"),
        Err(..) => println!("Couldn't send ack to client"),
    }
}
