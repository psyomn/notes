#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdatomic.h>

size_t SHARED_COUNTER = 0;

static void *thread_func(void* data) {
    int count = 10000;

    while (count--) {
        SHARED_COUNTER += 1;
    }
}

int main(void) {
    const size_t num_threads = 4;
    pthread_t *threads = calloc(num_threads, sizeof(pthread_t));

    /* run thread */
    for (size_t i = 0; i < num_threads; ++i) {
        const int thread_ok =
            pthread_create(&threads[i], NULL, &thread_func, NULL);
        if (thread_ok) fprintf(stderr, "problem creating thread\n");
    }

    /* join threads */
    for (size_t i = 0; i < num_threads; ++i) {
        pthread_join(threads[i], NULL);
    }

    printf("Counter value: %zu\n", SHARED_COUNTER);

    return 0;
}
