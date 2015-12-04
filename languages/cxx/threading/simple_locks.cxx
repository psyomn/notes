#include <iostream>
#include <thread>
#include <vector>
#include <mutex>

using std::thread;
using std::cout;
using std::endl;
using std::vector;

void run_example(std::function<void(int)>);

int counter = 0;
std::mutex m;

void work(int);
void work2(int);

int main() {
  /*
   * Examine both functions. One has work, and the other has work2. The first
   * work function places the mutex within the for loop. The second places it
   * outside the for loop. It's somewhat obvious, but basically what you see is
   * that a small change has a big semantic impact: one says the critical
   * section is adding, and the other means the critical section is until the
   * whole function increments the counter.
   */
  run_example(work);
  run_example(work2);
  return 0;
}

void run_example(std::function<void(int)> work_fn) {
  const int thread_count = 10;
  vector<thread> jobs;

  int curr_threads = thread_count;

  while (--curr_threads) {
    jobs.push_back(thread(work_fn, curr_threads));
  }

  for (auto& t : jobs) {
    t.join();
  }

  cout << endl;
  cout << "After working a lot, the value of the counter is: " << counter << endl;
}

void work(int thread_id) {
  for (int i = 0; i < 100; ++i) {
    m.lock();
    counter += 1;
    m.unlock();
    cout << thread_id << std::flush;
  }
}

void work2(int thread_id) {
  m.lock();
  for (int i = 0; i < 100; ++i) {
    counter += 1;
    cout << thread_id << std::flush;
  }
  m.unlock();
}
