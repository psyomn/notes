#include <iostream>
#include <thread>

using std::thread;
using std::cout;
using std::endl;

void work() {
  cout << "Work stuff" << endl;
}

int main() {
  thread t(work);

  t.join();

  return 0;
}
