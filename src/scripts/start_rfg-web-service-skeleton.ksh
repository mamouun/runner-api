#!/bin/ksh

export artifactID="...to complete..."
# Defines defaults values
export APP_DIR="${APP_DIR:-$(basename $HOME)}"
export APP_LIB="${APP_LIB:-$APP_DIR/bin/java/$artifactID}"
export APP_LOG="${APP_LOG:-$APP_DIR/log}"
export APP_CONF="${APP_CONF:-$APP_DIR/bin/java/$artifactID/conf}"

set -x
JVM_ARGS="-XX:ErrorFile=${APP_LOG}/hs_err_pid%p.log     \
          -Xms256m                                      \
          -Xmx2G                                        \
          -XX:+UseG1GC                                  \
          -XX:MaxGCPauseMillis=200                      \
          -XX:ParallelGCThreads=8                       \
          -XX:ConcGCThreads=8                           \
          -XX:InitiatingHeapOccupancyPercent=70         \
          -Djava.io.tmpdir=${APP_TMP}"

JAR_FILE="${APP_LIB}/runner-api.jar"
SPRING_FILES="${APP_CONF}/application-${ENV}.yml"

SYSOUT_FILE="$APP_LOG/${artifactID}_$(hostname).sysout"

echo "Starting the service '${artifactID}'"
echo "`$JAVA_HOME_WS/bin/java -version`"
echo "User / Server      : $(whoami)  /  $(hostname)"
echo "Name of the Sysout : $SYSOUT_FILE"
echo "Jar file executed  : $JAR_FILE"

# Start application
(java    -server  ${JVM_ARGS}  -jar ${JAR_FILE}  --spring.config.location=${SPRING_FILES} > $SYSOUT_FILE 2>&1 )  &
returnCode=$?

#-----------------------------------------------------------------------------------------------------------------------------------
# GET THE STATUS of the WEB SERVICE
#-----------------------------------------------------------------------------------------------------------------------------------
echo "Waiting for the status of the START ..."
sleep 2
n_cpt=0
v_Msg="WebService '$artifactID' -> Unknown status"
while [ $n_cpt -lt 60 ] ; do
   if [ -f "$SYSOUT_FILE" ]; then
      if [ -n "$(grep -Ei '.*: Started [^ ]*App ' "$SYSOUT_FILE")" ]; then
         v_Msg="WebService started !"
         break
      elif [ -n "$(grep -Ei '.*: Failed to start ' "$SYSOUT_FILE")" ]; then
         v_Msg="WebService start failed !"
         returnCode=3
         break
      fi
   fi
   ((++n_cpt))
   sleep 1
done
sleep 1
echo "$v_Msg"

echo "WebService '$artifactID' with returnCode : $returnCode"
exit $returnCode
