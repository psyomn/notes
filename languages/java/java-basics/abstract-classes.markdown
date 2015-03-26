## Abstract classes

Abstract classes are something that are a mix of classes, and interfaces. That
is we have some implementation, and we define some methods to be implemented
when the class in question is subclassed. Therefore it behaves as a class, as
well as an interface at the same time.

What we mean by this, is that we can freely implement any method in a class, and
omit functionality to the methods we do not wish to implement in the base class.
On a more concrete example, you may have some class that provides common
functionality, depending on what another method yields. For example, imagine you
are writing a small robot to scrape over html pages, over the internet. You want
it to be able to detect links, and visit all the links it finds, in order to
investigate all the possible paths. How you do this scraping, and what links you
find, might not be important to the knowledge of the robot-scrapper - what it
just wants, are list of links.

You could have two implementations: the robot that wants to look at all the
links on the site, and the robot, who is only interested in crawling through the
links that are hosted on the same domain (ie: first robot doesn't really care
what links it finds - it just passes them to the implementation; whereas the
second gets the links, filters the uninteresting ones, and then passes them to
the behavior).

One thing to note: just like interfaces, you can not instantiate abstract
classes.

Here is a sample abstract class:

~~~~java
    public abstract class AbstractScraper {

        public AbstractScraper(List<String> links) {
            mLinks = links;
        }

        public void scrape() {
            System.out.println("Doing work...");
            List<String> links = selectLinks();

            for (String link : links) {
                System.out.println("Fetching: " + link + " ...");
            }
        }

        public abstract List<String> selectLinks();
        protected List<String> mLinks;
    }
~~~~

Notice that we set `mLinks` to protected. And here is the concrete
implementation:

~~~~java
    public class FetchAllScraper extends AbstractScraper {
        public FetchAllScraper(List<String> links) {
            super(links);
        }
        @Override
        public List<String> selectLinks() {
            return mLinks;
        }
    }
~~~~

Since this is the scraper that is to include all links, we may just return the
`mLinks` member variable, when we are using `selectLinks()`. In turn, this list
will be used in `void scrape()`, reusing the rest of the parts of the
`AbstractScraper` class.

On the other hand, we can make a comparison using `Regular Expressions` in Java,
and omit any link that is not from the particular domain we are interested in.
This way we filter out some items from the list and provide the user of this
small 'contraption', the wanted links:

~~~~java
    public class DomainOnlyScraper extends AbstractScraper {

        public DomainOnlyScraper(List<String> links, String interestedDomainName) {
            super(links);
            domainName = interestedDomainName;
        }

        @Override
        public List<String> selectLinks() {
            Pattern pat = Pattern.compile(".*" + domainName + ".*");
            List<String> filteredList = new ArrayList<String>();
            Matcher m;

            for (String el : mLinks) {
                m = pat.matcher(el);
                if (m.matches()) {
                    filteredList.add(el);
                }
            }

            return filteredList;
        }

        private String domainName;
    }
~~~~

And finally, the driver for the application, which we use to demonstrate the
above:

~~~~java
    public class Main {
        public static void main(String[] args) {
            AbstractScraper absFetchAll, absSelective;
            List<String> links = new ArrayList<String>();

            links.add("domain1");
            links.add("domain2");
            links.add("domain3");
            links.add("domain4");
            links.add("cooldomain");
            links.add("notsocooldomain");

            absFetchAll = new FetchAllScraper(links);
            absSelective = new DomainOnlyScraper(links, "cooldomain");

            absFetchAll.scrape();
            absSelective.scrape();
        }
    }
~~~~

Recall since both implementations of the `AbstractScraper` respect the its
interface, then we can in the runtime, cast either one of the implementations
(either `FetchAllScraper`, or `DomainOnlyScraper`) to the declared type. Both
run the `scrap()` method, and we can observe the output. The fetch-all
implementation will yield all the links. The second one will look for links
which have the string 'cooldomain' somewhere within them.

~~~~nocode
    Doing work...
    Fetching: domain1 ...
    Fetching: domain2 ...
    Fetching: domain3 ...
    Fetching: domain4 ...
    Fetching: cooldomain ...
    Fetching: notsocooldomain ...
    Doing work...
    Fetching: cooldomain ...
    Fetching: notsocooldomain ...
~~~~

Notice how the second part only yields those two links (_cooldomain_,
_notsocooldomain_).

### Alternate nomenclature

Abstract in Java is what is called `virtual` in C++.


