#include <iostream>
#include <thread>
#include <vector>
#include <random>
#include <cmath>

using std::cout;
using std::endl;
using std::thread;

void lamda_threads();
void func_threads();

int main(void) {
  lamda_threads();
  func_threads();

  return 0;
}

void work_fn(int threadnum) {
  std::random_device rng;
  std::default_random_engine e1(rng());
  std::uniform_int_distribution<int> uniform_dist(1, 10);
  int rn = uniform_dist(e1);

  for (int i = 0; i < 100000 * rn; ++i)
  for (int j = 0; j < 10000; ++j);
  cout << "Finished running " << threadnum << endl;
}

void func_threads() {
  int num = 4;
  std::vector<thread> threads;

  while(num--) {
    threads.push_back(std::thread(work_fn, num));
  }

  for (auto& t_el : threads) {
    t_el.join();
  }
}

void lamda_threads() {
  thread  t([](){ cout << "t1 some people call me a thread" << endl; }),
         t2([](){ cout << "t2 I'm some other thread as well!" << endl; }),
         t3([](){ cout << "t3 I am a potato" << endl; });
  t.join();
  t2.join();
  t3.join();
}

/* */
