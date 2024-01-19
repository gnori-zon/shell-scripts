CUR_DATE=$(date +"%Y-%m-%d")
CONTAINER_NAME=#<container-name> ex: my-container
PID=#<pid> ex: 1
DIRECTORY=#<directory-path-in-system-for-heap-dump> ex: /home/user/heapdumps
DIRECTORY_IN_CONTAINER=#<directory-path-in-container-for-heap-dump> ex: /home/app
HEAP_DUMP_SUFFIX=.hprof

HEAP_DUMP_FILENAME=${CONTAINER_NAME}_${CUR_DATE}${HEAP_DUMP_SUFFIX}
HEAP_DUMP_PATH=${DIRECTORY}/${HEAP_DUMP_FILENAME}
HEAP_DUMP_PATH_IN_CONTAINER=${DIRECTORY_IN_CONTAINER}/${HEAP_DUMP_FILENAME}

# get container id
CONTAINER_ID=$(docker ps | grep $CONTAINER_NAME | awk '{print $1}')

# delete old heap-dumps in system
rm ${DIRECTORY}/${CONTAINER_NAME}_*${HEAP_DUMP_SUFFIX}

# check or create heap-dump directory in system
if [ ! -d $DIRECTORY ]; then
    mkdir $DIRECTORY
fi

# delete old heap-dumps in container
docker exec ${CONTAINER_ID} rm -rf ${DIRECTORY_IN_CONTAINER}/${CONTAINER_NAME}_*${HEAP_DUMP_SUFFIX}

# get heap-dump in docker container
docker exec ${CONTAINER_ID} jcmd $PID GC.heap_dump $HEAP_DUMP_PATH_IN_CONTAINER

# copy heap-dump to system from docker container
docker cp ${CONTAINER_ID}:$HEAP_DUMP_PATH_IN_CONTAINER $HEAP_DUMP_PATH