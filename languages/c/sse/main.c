#include <time.h>
#include <assert.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#define TIME_FUNC(label, call)                          \
    do {                                                \
        time_t now = 0;                                 \
        time_t after = 0;                               \
        time(&now);                                     \
        call;                                           \
        time(&after);                                   \
        printf("[%s] time: %zu\n", label, after - now); \
    } while(0)                                          \

void scalar_vector_sum(size_t x_elements,
                       size_t y_elements,
                       void* elements)
{
    volatile uint64_t sum = 0;
    uint32_t* els = (uint32_t*) elements;

    for (size_t x = 0; x < x_elements; ++x) {
        for (size_t y = 0; y < y_elements; ++y) {
            sum += *(els + (y * x) + x);
        }

        printf("%zu ", sum);
        sum = 0;
    }

    printf("\n");
}

void vectorized_vector_sum(size_t x_elements,
                           size_t y_elements,
                           void* elements)
{
    // sse magic
}

int main()
{
    const uint32_t x = 3000, y = 200000;
    uint32_t* vec = calloc(1, (x * y) * sizeof(uint32_t));

    TIME_FUNC("scalar", scalar_vector_sum(x, y, vec));
    TIME_FUNC("vectorized", vectorized_vector_sum(x, y, vec));

    free(vec);

    return 0;
}
