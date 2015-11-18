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
    mess_handle_rcv: Option<Receiver<String>>,
    mess_handle_snd: Option<Sender<String>>,
    mess_handle: Option<JoinHandle<()>>,
}

impl Server {
    pub fn new(h: String, p: u16) -> Server {
        let (sender, receiver) = channel::<String>();

        let mut srv = Server {
            host: h,
            port: p,
            listening_done: false,
            clients: vec![],
            mess_handle_rcv: Some(receiver),
            mess_handle_snd: Some(sender),
            mess_handle: None,
        };

        srv.init_message_handler();

        srv
    }

    pub fn init_message_handler(&mut self) -> () {
        let recv = match self.mess_handle_rcv {
            Some(v) => v,
            None => return,
        };

        self.mess_handle_rcv = None;

        self.mess_handle = Some(thread::spawn(move || {
            message_relayer(recv);
        }));
    }

    pub fn listen(&mut self) -> () {
        println!("start: host {}, port {}", self.host, self.port);

        let mut listener: TcpListener =
            TcpListener::bind(format!("{}:{}", self.host, self.port).as_ref() as &str).unwrap();

        for stream in listener.incoming() {
            match stream {
                Ok(mut ss) => {
                    // let snd = match self.mess_handle_channel {
                    //     (ref sender, _) => sender.clone(),
                    // };
                    // let t = thread::spawn(move || { handle_client(ss, snd) });
                    // self.clients.push(t);
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
        match s.write(&[SUCCESS]) {
            Ok(..) => println!("Wrote to client!"),
            Err(..) => println!("Couldn't send ack to client"),
        }
    }
}

fn message_relayer(r: Receiver<String>) {
}

