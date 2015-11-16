use std::net::TcpStream;
use std::io::Error;
use std::io::Write;

pub struct Client {
    connection: TcpStream,
}

impl Client {
    pub fn from_address(address: String) -> Result<Client, Error> {
        match TcpStream::connect(address.as_ref() as &str) {
            Ok(v) => Ok(Client { connection: v }),
            Err(e) => Err(e),
        }
    }

    pub fn listen(&self) -> () { }

    pub fn send(&mut self, message: String) -> Result<usize, Error> {
        self.connection.write(&message.into_bytes())
    }
}
