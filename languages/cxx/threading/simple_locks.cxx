#include <iostream>
#include <thread>
#include <vector>

using std::thread;
using std::cout;
using std::endl;
using std::vector;

void work() {
  std::mutex m;
  cout << "Work stuff" << endl;
}

int main() {
  thread t(work);

  t.join();

  return 0;
}
