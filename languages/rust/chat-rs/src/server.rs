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
        while !self.listening_done {
            println!("start: host {}, port {}", self.host, self.port);
        }
    }
}
