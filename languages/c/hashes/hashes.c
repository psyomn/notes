#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>

uint64_t 
knr_lose_lose(uint8_t *_data) {
	uint64_t hash = 0;
	uint8_t c = 0;

	while(c = *_data++)
		hash = c + (hash << 6) + (hash << 16) - hash;

	return hash;
}

size_t
rand_range(size_t min, size_t max) {
	const size_t k = rand() % max;
	return k < min ? min + k : k;
}

void
rand_string(char * _arr, size_t _len) {
	for (size_t x = 0; x < _len; ++x) {
		_arr[x] = rand_range(0, 26) + 'A';
	}

	_arr[_len-1] = 0;
}

int main(void) {
	srand(1337);
	const uint64_t N = 1 << 20;
	uint8_t buff[32];

	for (size_t x = 0; x < N; ++x) {
		rand_string(buff, sizeof(buff));
		printf("lose_lose:%s:%zu\n", buff, knr_lose_lose(buff));
	}

	return 0;
}
