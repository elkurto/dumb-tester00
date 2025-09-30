### dumb-tester00
#### Purpose:
- This project is a simple maven springboot webapp that validates compiling and running one junit test via a script while building the non-test part of the project with maven.
- Background: My current employer has broken multi-team projects so I created a work-around to enable unit-testing regardless.


#### Usage:
- git clone git@github.com:elkurto/dumb-tester00.git
- cd dumb-tester00/
- mvn clean package
- bash compile-test.sh    // compiles and runs a junit5 test.

```
# Sample Run
bash compile-test.sh

# OUTPUT:  
  PROJBASEDIR =/home/kurt5/jprogmore/testit/springboot-core/dumb-tester00
  compiling - a/b/dumbtester00/UtiltyATest.java
  running junit - a.b.dumbtester00.UtiltyATest
  
  💚 Thanks for using JUnit! Support its development at https://junit.org/sponsoring
  
  ╷
  ├─ JUnit Platform Suite ✔
  ├─ JUnit Jupiter ✔
  │  └─ UtiltyATest ✔
  │     └─ test() ✔
  └─ JUnit Vintage ✔
  
  Test run finished after 81 ms
  [         4 containers found      ]
  [         0 containers skipped    ]
  [         4 containers started    ]
  [         0 containers aborted    ]
  [         4 containers successful ]
  [         0 containers failed     ]
  [         1 tests found           ]
  [         0 tests skipped         ]
  [         1 tests started         ]
  [         0 tests aborted         ]
  [         1 tests successful      ]
  [         0 tests failed          ]
  
  
  WARNING: Delegated to the 'execute' command.
           This behaviour has been deprecated and will be removed in a future release.
           Please use the 'execute' command directly.

```


### Notes:
1. working attempt 1
cd dumb-tester00/
mvn -f pom.xml package
mvn -f pom2.xml jar:jar
java -jar junit-platform-console-standalone-1.13.0-M3.jar execute -cp .:target/classes:target/test-classes --select-class a.b.dumbtester00.service.UtilityATest