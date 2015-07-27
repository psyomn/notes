extern crate rustex;
use rustex::tex::*;

fn main() {
    let authors : Vec<String> = vec!["jon smith", "mary maryson"].iter().map(|&e| e.to_string()).collect();
    let title =
        Info::new("My lovely Title, yes.".to_string(),
                  authors,
                  "Wed Aug  5 19:30:31 EDT 2015".to_string());

    title.print();

    pkg(vec![
        "geometry:margin=1in",
        "listings",
        "color",
        "colorlinks",
        "graphicx"]);

    begin("document");

    h("My fist Section");

    r(" For the most of time anna was a very shy girl. She never really cared about what they said.
    Never cared for what they do. Never cared for what they know. And she knows. For as long as she
    can remember, she had a list of things she wished to do: ");

    items(vec!(
        "find the person she really liked",
        "decide whether her feelings were not completely stupid",
        "rationalize a little more",
        "finally find some conclusion for everyone to be happy"));

    r("But then she remembered a few other things that she had in mind. She was thinking and she was
    thinking, and yet she continued to think on. Finally she remembered the following:");

    items(vec!(
        "She missed the awesomeness of potatoes",
        "She really wanted some potatoes",
        "Did you know that potatoes are awesome?"));

    end("document");

}
