\title{AspectJ Notes for soen6441} 
\author{Simon Symeonidis}
\maketitle

In order to extract some information on possible join points I did the
following. 

````java

before() : within(Book) {
  System.out.println("Something happened inside Book | " + thisJoinPoint);
}

````
Gives us some of the following ouptut 

````
Something happened inside of book | staticinitialization(cc.domain.Book.<clinit>)
Something happened inside of book | preinitialization(cc.domain.Book(String, String, String, String, String))
Something happened inside of book | set(String cc.domain.Book.author)
Something happened inside of book | execution(cc.domain.Book(String, String, String, String, String))
Something happened inside of book | initialization(cc.domain.Book(String, String, String, String, String))
````

# Basic examples

This is the class we will be messing with: 

````java
package dom;

public class Pet
{
  /** Make some pet noise */
  public void noise(){
    System.out.println( "WARGABL GABL");
  }
                
  /* Pets do not talk... But they do with aspects. */
  public String talk(){
    return "WOOF WOOF WOOF.";
  }
}
````

This is the driver we are using: 

````java
package dom;

import java.io.PrintStream;

public class Test
{
 private static PrintStream p = System.out;
    public static void main(String[] args){
    Pet pet = new Pet();
    pet.noise();
    p.println(pet.talk()); 
  }
}

````

````java
package aspects;

import java.io.PrintStream;

import dom.*;

public aspect TestAspect {
  private static PrintStream p = System.out;
  before() : call(void Pet.noise()) {p.println("Pet.noise called");};
  after()  : execution(void Pet.noise()) {p.println("Pet.noise executed");};
  String around() : call(String Pet.talk()) {
    return "HELLO THERE FINE FELLOW.";
  }
}

````


