CC=gcc
CFLAGS="-g -Wall -Werror"

$CC $CFLAGS producer.c -o producer
$CC $CFLAGS consumer.c -o consumer
