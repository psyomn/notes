use std::net::{TcpListener, TcpStream};
use std::io::{Read, Write};
use std::io;
use std::thread;
use std::thread::{Thread, JoinHandle};
use std::sync::mpsc::{Sender, Receiver, channel, SendError};

const SUCCESS: u8 = 200u8;

pub struct Server {
    host: String,
    port: u16,
    listening_done: bool,
    clients: Vec<JoinHandle<()>>,
    mess_handle_snd: Sender<String>,
    mess_handle: JoinHandle<()>,
}

impl Server {
    pub fn new(h: String, p: u16) -> Server {
        let (sender, receiver) = channel::<String>();

        let handle = thread::spawn(move || {
            message_relayer(receiver);
        });

        let mut srv = Server {
            host: h,
            port: p,
            listening_done: false,
            clients: vec![],
            mess_handle_snd: sender,
            mess_handle: handle,
        };

        srv
    }

    pub fn listen(&mut self) -> () {
        println!("start: host {}, port {}", self.host, self.port);

        let mut listener: TcpListener =
            TcpListener::bind(format!("{}:{}", self.host, self.port).as_ref() as &str).unwrap();

        for stream in listener.incoming() {
            match stream {
                Ok(mut ss) => {
                    let snd = self.mess_handle_snd.clone();
                    let t = thread::spawn(move || { handle_client(ss, snd) });
                    self.clients.push(t);
                },
                Err(mut e) => {
                    write!(io::stderr(), "Error!");
                },
            }
        }
    }
}

/// Handle each client in a connection
fn handle_client(mut s: TcpStream, sender: Sender<String>) -> () {
    loop {
        let mut v8: [u8; 256] = [0; 256];
        let _ = s.read(&mut v8);
        let recv: String = String::from_utf8_lossy(&v8).into_owned();
        println!("Recv: {}", recv);
        sender.send(recv);
        match s.write(&[SUCCESS]) {
            Ok(..) => println!("Wrote to client!"),
            Err(..) => {
                println!("Client disconnected");
                break;
            },
        }
    }
}

fn message_relayer(r: Receiver<String>) {
    loop {
        match r.recv() {
            Ok(s) => println!("I should relay this to all connected clients: {}", s),
            Err(..) => continue,
        }
    }
}

