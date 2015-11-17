% Rust, Spawn, Sender-Receiver, And You!
% Simon Symeonidis

# Minor Notes on Concurrency (Rust 0.13)

We can spawn concurrently running things with the following line.

~~~~rust
    spawn(||{ println!("potato") });
~~~~

Similarly we can spawn functions in the background:

~~~~rust

    fn background_job() {
        /* ... */
    }

    fn main() {
        spawn(||{ background_job() });
    }

~~~~

We can use 'channels' which are built in rust in order to make spawned
procedures communicate. For example we can have the process in the background
send something to the main function. To do this we need to put the sender inside
the background job. To do this, we can add the sender in the type signature.

First off, to make a new channel of communication, we do the following:

~~~~rust
    use std::sync::mpsc::{Sender, Receiver, channel};
    fn main() {
        let (s, r) : (Sender<i32>, Receiver<i32>) = channel();
    }
~~~~

That will create the channel of communication. We can specify what kind of
values we want the channel to carry. For the case of this example, it is the
value between the angled brackets: 'int'. You could for example pass other
values such as floats, or even strings. We will show later an example with
strings, which is a naive implementation of an echo server.


We continue now with the simple example. By defining this tuple, we now know
that the sender 's' will send information to the receiver 'r'. Next what we want
to do is spawn the process, and pass the sender to the background function, so
that it can send the value to the main function. To do this, we use `s.send(42)`.

Finally, we also want to receive the value in the main function, and print it.
We do this by calling `r.recv()`.

~~~~rust
    fn back(s: Sender<int>) {
        s.send(42);
    }

    fn main() {
        let (s, r) : (Sender<int>, Receiver<int>) = channel();
        spawn(proc(){ back(s) });
        println!("{}", r.recv());
    }
~~~~

And that's that!

# A simple echo server

An echo server is a listening entity that replies the exact same message to the
sender. So essentially, our 'server' should have means to receive messages, as
well as send them back to the client.

Already we know that the type signature should have a sender and receiver. Since
we are interested in strings, we set the type 'String' between the angled
brackets. We already know that the type signature of the server should look
something like this:

~~~~rust
    fn echo(tx: Sender<String>, rc: Receiver<String>)
~~~~

So we implement the running server this way. We add the option that the client
may send 'graceful' for a graceful shutdown. We also tweak the server to send
back the string but in capitalized form.

~~~~rust
    use std::io;
    use std::ascii::AsciiExt;

    fn echo(tx: Sender<String>, rc: Receiver<String>) {
        let mut message: String;
        let mut running: bool = true;

        while running {
            message = rc.recv();
            println!("ECHOSRV: recv {}", message);

            tx.send(message.clone().as_slice().to_ascii_upper().to_string());

            if message == "graceful".to_string() {
                println!("Ending echo server");
                running = false;
                continue;
            }
        }
    }
~~~~

Finally we implement the main function. Since we want the client to be able to
communicate with the server, and the server to communicate back to the client,
we create two tuples.

~~~~rust
    fn main() {
        let (send_to_client, receiver):
            (Sender<String>, Receiver<String>)
            = channel();

        let (send_to_task, receive_at_task):
            (Sender<String>, Receiver<String>)
            = channel();

        let mut cmd: String = "default".to_string();

        spawn(proc(){ echo(send_to_client, receive_at_task) });

        while cmd != "graceful".to_string() {
            let mut reader = io::stdin();
            let input = reader.read_line().ok().unwrap_or("nothing".to_string());
            let to_trim: &[char] = &[' ', '\r', '\n'];
            let trimmed_input = input.as_slice().trim_chars(to_trim);
            send_to_task.send(trimmed_input.to_string());
            println!("Client Rcv: {}", receiver.recv());
            cmd = trimmed_input.to_string();
        }

    }
~~~~

And that pretty much concludes the echo server.

# Pipes and Filters

Inspired from pipes and filters [pipes], I also implemented another toy
application, which shows how we can chain different processes together in order
to get some final output.

First we want to define our source. We choose a function that generates random
integers, and sends them to the next filter.

~~~~rust
    use std::rand;
    use std::rand::Rng;
    use std::io::timer::sleep;
    use std::time::duration::Duration;

    /// A source, that generates random numbers. Numbers are from 0 to 100, and
    /// send it to the next filter. Notice there is no receiver.
    fn random_number_source(s: Sender<int>) {
        let mut r = rand::task_rng();

        loop {
            sleep(Duration::seconds(1));
            s.send(r.gen::<int>() % 200);
        }
    }
~~~~

The next filter simply multiplies by 10. The processed number is sent to the
next filter.

~~~~rust
    /// Whatever number is taken in, we multiply by 10, and send it to the next
    /// filter
    fn times_10_filter(s: Sender<int>, r: Receiver<int>) {
        loop {
            let n: int = r.recv() * 10;
            s.send(n);
        }
    }
~~~~

The filter receives the number, and simply adds 2.

~~~~rust
    /// Simply adds 2, to whatever number is received
    fn plus_2_filter(s: Sender<int>, r: Receiver<int>) {
        loop {
            let n: int = r.recv() + 2;
            s.send(n);
        }
    }
~~~~

The fitler takes in the number that was sent from the previous filter, and
generates a number witha magnitude of 0 to 40; negative or positive. This number
is subtracted from the previous number, and finally sent to the sink.

~~~~rust
    /// Substracts a random number, where the random number is max __magnitude__ of 40.
    /// NOTE: this might add numbers if gen returns a negative number
    fn minus_up_to_40_filter(s: Sender<int>, r: Receiver<int>) {
        loop {
            let mut rand = rand::task_rng();
            let sub: int = rand.gen::<int>() % 41;
            let rslt: int = r.recv() - sub;
            s.send(rslt);
        }
    }
~~~~

The sink receives the number and prints out on the command line the processed
value.

~~~~rust
    /// Main can be our sink. Let's have this setup:
    ///   randnumsource -> times10 -> plus2 -> minusupto40 -> sink
    fn main() {
        let (s_src, r_t10)  : (Sender<int>, Receiver<int>) = channel();
        let (s_t10, r_p2)   : (Sender<int>, Receiver<int>) = channel();
        let (s_p2,  r_m40)  : (Sender<int>, Receiver<int>) = channel();
        let (s_m40, r_sink) : (Sender<int>, Receiver<int>) = channel();

        spawn(proc(){ random_number_source(s_src)         });
        spawn(proc(){ times_10_filter(s_t10, r_t10)       });
        spawn(proc(){ plus_2_filter(s_p2, r_p2)           });
        spawn(proc(){ minus_up_to_40_filter(s_m40, r_m40) });

        println!("Sink is listening...");

        loop {
            let val: int = r_sink.recv();
            print!("{}, ", val);
            std::io::stdio::flush();
        }
    }
~~~~

I got to say, this is some pretty fun stuff!

# References

- \[pipes\] [http://en.wikipedia.org/wiki/Pipeline_%28software%29][pipes-ref]

[pipes-ref]: http://en.wikipedia.org/wiki/Pipeline_%28software%29
