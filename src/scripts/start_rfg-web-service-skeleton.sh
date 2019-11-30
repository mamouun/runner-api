#!/bin/sh

export artifactID="runner-api"
# Defines defaults values
export APP_DIR="D:/test"
export APP_LIB="${APP_LIB:-$APP_DIR/runner-api/bin/java/$artifactID}"
export APP_LOG="${APP_LOG:-$APP_DIR/log}"
export APP_CONF="${APP_CONF:-$APP_DIR/bin/java/$artifactID/conf}"

set -x
JVM_ARGS="-XX:ErrorFile=${APP_LOG}/hs_err_pid%p.log     \
          -Xms256m                                      \
          -Xmx8G                                        \
          -XX:+UseG1GC                                  \
          -XX:MaxGCPauseMillis=200                      \
          -XX:ParallelGCThreads=8                       \
          -XX:ConcGCThreads=8                           \
          -XX:InitiatingHeapOccupancyPercent=70         \
          -Djava.io.tmpdir=${APP_TMP}"

JAR_FILE="${APP_LIB}/runner-api.jar"
SPRING_FILES="${APP_CONF}/application-dev.yml"

SYSOUT_FILE="$APP_DIR/${artifactID}_xxx.log"

echo "Starting the service '${artifactID}'"
echo "`java -version`"
#echo "User / Server      : $(whoami)  /  $(hostname)"
echo "Name of the Sysout : $SYSOUT_FILE"
echo "Jar file executed  : $JAR_FILE"

# Start application
(java    -server  ${JVM_ARGS}  -jar ${JAR_FILE}  --spring.config.location=${SPRING_FILES} > $SYSOUT_FILE 2>&1 )  &
returnCode=$?

exit $returnCode