Screen
======

Screen is awesome. I've been using it for a while now. Basically it allows you
to have a similar experience as that of a graphical desktop, where you can
minimize different sessions, but this in terminal mode. When we take this into
consideration, along with the powerful tools that a Linux system usually
provides, our mind travels to a reasonable infinite set of perverse
possibilities. 

The command as you might have guessed, to invoke this tool is 

````bash 
screen
````

*Small forenote:* C-a is `ctrl-a`.

This would bring you to a session you can detach yourself from. You might
notice that the screen flashes instead of beeping on weird keystrokes. To
switch from flashing to beeping (which hopefully is disabled), you can simply
press `C-a, C-g`. 

### Detaching

Execute the command `screen`, if you haven't already. 

````bash
screen
````

Now say we're connected to a server, and we'd like to leave something running
in the background, in which we'd eventually like to get back to, and interact
with.  For the sake of this example, let it be this simple bash line: 

````bash
for (( ;; )) do sleep 3s; echo "ZzzzzZZZzzzz ..."; done
````

We can enter the following sequence: `C-a, C-d`, and detach from the session.
We're back at the terminal where we started from!

Now, let's say we've completed the other jobs we wanted to take care of, and 
need to reconnect to the screen session. The way to do this is to first query
what screens exist

### Naming Screens


### More than One Window


### Naming Windows


### Schrodinger Screen


In some cases, the bad and ugly happens, and a screen session is disrupted from
some chaos. For example your coworker tripping over the wires of your computer,
and severing the connection between you and the server. Though funny, this can
sometimes mark the screen as `Attached` when you're trying to reconnect, and
block you. If you're sure that something has probably gone wrong, you need to
'wipe' the screen. This is achieved by supplying the `-D` flag.

````bash
screen -D screen-name-or-id
````

### SPYING ON PEOPLE



