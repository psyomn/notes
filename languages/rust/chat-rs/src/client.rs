use std::net::TcpStream;
use std::io::{Error, ErrorKind};
use std::io::{Write, Read};

#[derive(Debug)]
pub struct Client {
    connection: TcpStream,
    nick: String,
}

impl Client {
    pub fn from_address(address: String, n: String) -> Result<Client, Error> {
        match TcpStream::connect(address.as_ref() as &str) {
            Ok(v) => Ok(Client { connection: v, nick: n }),
            Err(e) => Err(e),
        }
    }

    pub fn listen(&self) -> () { }

    pub fn send(&mut self, message: String) -> Result<(), Error> {
        println!("Client: sending info");
        let _ = self.connection.write_all(&message.into_bytes());
        let mut b: [u8; 2] = [0, 0];
        println!("Waiting for ack from server");
        let _ = self.connection.read(&mut b);

        match b[0] {
            200 => Ok(()),
            e@_ => Err(Error::new(ErrorKind::Other, format!("Bad receive {:?}", e).as_ref())),
        }
    }
}
