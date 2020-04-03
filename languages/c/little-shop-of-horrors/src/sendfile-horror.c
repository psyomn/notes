#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/sendfile.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

#include <linux/limits.h>

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

#include <getopt.h>

const int PORT = 6666;
void server(void);
void client(char*);

int main(int argc, char *argv[]) {
  int opt = 0;
  char *path = NULL;
  bool found_path = false;
  bool found_client = false;
  bool found_server = false;

  while ((opt = getopt(argc, argv, "scf:")) != -1) {
    switch (opt) {
    case 's':
      found_server = true;
      break;
    case 'c':
      found_client = true;
      break;
    case 'f':
      found_path = true;
      path = optarg;
      break;
    default:
      goto error;
    }
  }

  if (found_server)
    server();
  else if (found_client && found_path)
    client(path);
  else
    goto error;

  return 0;

error:
  printf("usage: \n");
  printf("  %s (-s|-c|-f)", argv[0]);
  exit(EXIT_FAILURE);
  return -1;
}

void client(char *path) {
  (void) path;

  int client_fd = 0;
  struct sockaddr_in server = {
    .sin_family = AF_INET,
    .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
    .sin_port = htons(PORT)
  };

  client_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (client_fd == -1) {
    perror("client could not create socket");
    exit(EXIT_FAILURE);
  }

  if (connect(client_fd, (struct sockaddr *)&server, sizeof(server)) == -1) {
    perror("could not connect");
    exit(EXIT_FAILURE);
  }

  const char *message = "hello there stalker";
  send(client_fd, message, strlen(message), 0);
  close(client_fd);
}

void server(void) {
  int server_fd = 0;
  struct sockaddr_in address = {
    .sin_family = AF_INET,
    .sin_addr.s_addr = htonl(INADDR_LOOPBACK), // im not completely crazy ;)
    .sin_port = htons(PORT),
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

    int obj = open("object", O_CREAT | O_WRONLY, 0755);
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

      if (write(obj, buffer, read_ret) == -1) {
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
