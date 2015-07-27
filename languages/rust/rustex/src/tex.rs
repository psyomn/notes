pub struct Info {
    title: String,
    authors: Vec<String>,
    date: String,
}

impl Info {
    pub fn new(t: String, a: Vec<String>, d: String) -> Info {
        Info {
            title: t,
            authors: a,
            date: d
        }
    }

    pub fn to_string(&self) -> String {
        let author_line : String = tag("author", self.authors.connect(" ").as_ref());
        let title_line : String = tag("title", self.title.as_ref());
        let date_line : String = tag("date", self.date.as_ref());
        let text : String = vec![title_line, author_line, date_line].connect("\n");
        text
    }

    pub fn print(&self) -> () {
        println!("{}", self.to_string());
    }
}

pub fn begin(s: &str) -> () {
    println!("{}", tag("begin", s));
}

pub fn end(s: &str) -> () {
    println!("{}", tag("end", s));
}


/// header
pub fn h(text: &str) {
    println!("{}", tag("section", text));
}

/// subsection
pub fn s(text: &str) {
    println!("{}", tag("subsection", text));
}

/// subsubsection
pub fn ss(text: &str) {
    tag("subsubsection", text);
    nl();
}

/// Print raw
pub fn r(text: &str) {
    println!("{}", text);
    nl();
}

/// Itemize stuff
pub fn items(items: Vec<&str>) {
    tag("begin", "itemize");
    nl();
    for el in items.iter() {
        print!("  \\item ");
        println!("{}", el);
    }
    tag("end", "itemize");
    nl();
}

/// Common way of having simple tags
#[inline]
fn tag(tag: &str, text: &str) -> String {
    format!("\\{}{{{}}}", tag, text)
}

#[inline]
fn nl() -> String {
    return "\n".to_string();
}

pub fn pkg(ps: Vec<&str>) -> () {
    for p in ps {
        let es : Vec<&str> = p.split(":").collect();

        if es.len() > 1 {
            let pkg_name = es[0];
            let pkg_conf = es[1];
            println!("\\usepackage[{}]{{{}}}", pkg_conf, pkg_name);
        }
        else {
            println!("\\usepackage{{{}}}", p);
        }
    }
}
