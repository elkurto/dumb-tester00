#!/bin/bash

# helper links
# https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.13.0-M3/
# https://www.baeldung.com/junit-run-from-command-line
# https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.13.0-M3/junit-platform-console-standalone-1.13.0-M3.jar
# https://web.mit.edu/java_v1.1.6/www/tools/javac.html





JAVAFILETEST=a/b/dumbtester00/UtiltyATest.java
CLASSFILETEST=a.b.dumbtester00.UtiltyATest

CURRDIR=`dirname $0`
PROJBASEDIR=`realpath ${CURRDIR}`
echo PROJBASEDIR =${PROJBASEDIR}
cd ${PROJBASEDIR}

export WEBINFDIR=${PROJBASEDIR}/target/dumb-tester00-0.0.1-SNAPSHOT/WEB-INF
export SRCDIR=${PROJBASEDIR}/src/test/java
#javac -classpath ${SRCDIR}:${WEBINFDIR}/classes:${WEBINFDIR}/lib/junit-jupiter-5.12.2.jar:${WEBINFDIR}/lib/junit-jupiter-api-5.12.2.jar:${WEBINFDIR}/lib/hamcrest-3.0.jar:${WEBINFDIR}/lib/apiguardian-api-1.1.2.jar a/b/dumbtester00/UtiltyATest.jav

pushd ${SRCDIR} > /dev/null
echo compiling - ${JAVAFILETEST}
javac -d ${PROJBASEDIR}/target/test-classes -classpath ${SRCDIR}:${WEBINFDIR}/classes:${PROJBASEDIR}/junit-platform-console-standalone-1.13.0-M3.jar a/b/dumbtester00/UtiltyATest.java
popd > /dev/null


echo running junit - ${CLASSFILETEST}
#echo "java -jar ${PROJBASEDIR}/junit-platform-console-standalone-1.13.0-M3.jar -p ${WEBINFDIR}/lib -cp ${WEBINFDIR}/classes ${CLASSFILETEST}"
java -jar ${PROJBASEDIR}/junit-platform-console-standalone-1.13.0-M3.jar -p ${WEBINFDIR}/lib -cp ${WEBINFDIR}/classes:target/test-classes --select-class ${CLASSFILETEST}

