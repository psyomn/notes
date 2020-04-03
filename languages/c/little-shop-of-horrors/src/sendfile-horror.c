#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/sendfile.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <getopt.h>

void server(void);

int main(void) {

  return 0;
}

void server(void) {
int server_fd;
  struct sockaddr_in address = {
    .sin_family = AF_INET,
    .sin_addr.s_addr = htonl(INADDR_LOOPBACK), // im not completely crazy ;)
    .sin_port = htons(9001),
  };

  server_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (server_fd == -1) {
    perror("could not create socket");
    exit(EXIT_FAILURE);
  }

  int sopt = 1;
  if(setsockopt(server_fd, SOL_SOCKET,
                SO_KEEPALIVE |
                SO_REUSEADDR |
                SO_REUSEPORT,
                &sopt, sizeof(sopt)) != 0) {
    perror("could not setsockopt");
    exit(EXIT_FAILURE);
  }

  socklen_t addrlen = sizeof(address);
  if (bind(server_fd, (struct sockaddr *)&address, addrlen) != 0) {
    perror("could not bind");
    exit(EXIT_FAILURE);
  }

  if (listen(server_fd, 1) == -1) {
    perror("could not listen");
    exit(EXIT_FAILURE);
  }

  printf("listening...\n");

  while (1) {
    int accept_fd = accept(server_fd, (struct sockaddr *)&address, &addrlen);
    if (accept_fd == -1) {
      perror("unacceptable");
      exit(EXIT_FAILURE);
    }

    int obj = open("object", O_CREAT);
    if (obj == -1) {
      perror("could not create object");
      exit(EXIT_FAILURE);
    }

    int read_ret = 0;
    do {
      char buffer[4096] = {0};
      read_ret = read(accept_fd, buffer, sizeof(buffer));
      if (read_ret == -1) {
        perror("problem reading form socket");
        exit(EXIT_FAILURE);
      }

      if (write(accept_fd, buffer, read_ret - 1) == -1) {
        perror("problem writing");
        exit(EXIT_FAILURE);
      }
    } while (read_ret > 0);

    if (close(obj) != 0) {
      perror("could not close file");
      exit(EXIT_FAILURE);
    }

    if (close(accept_fd) == -1) {
      perror("could not close socket");
      exit(EXIT_FAILURE);
    }
  }
}
