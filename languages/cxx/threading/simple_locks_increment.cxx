#include <iostream>
#include <thread>
#include <functional>
#include <mutex>
#include <chrono>
#include <string>

using std::cout;
using std::endl;
using std::string;

class Counter {
  public:
  Counter(int iMax, string iLabel) :
    m_count(0),
    m_to_max(iMax),
    m_label(iLabel)
  {}

  void threaded_count() {
    std::thread t(&Counter::incrementor, this, 0);
    std::thread t2(&Counter::incrementor, this, 0);

    t.join();
    t2.join();
  }

  private:

  void incrementor(int t) {
    switch(t) {
    case 0:
      while (m_count <= m_to_max) {
        m_count_mutex.lock();
        if (m_count % 2 == 0) {
          cout << m_label << " : t1 incrementing from " << m_count;
          m_count += 1;
          cout << " to " << m_count << endl;
        }
        m_count_mutex.unlock();
        /* not my problem. the other should deal with this*/
        std::this_thread::yield();
      }
      break;
    default:
      while (m_count <= m_to_max) {
        m_count_mutex.lock();
        if (m_count % 2 == 1) {
          cout << m_label << " : t2 incrementing from " << m_count;
          m_count += 1;
          cout << " to " << m_count << endl;
        }
        m_count_mutex.unlock();
        std::this_thread::yield();
      }
      break;
    }
  }

  int m_count;
  int m_to_max;
  std::string m_label;
  std::mutex m_count_mutex;
};

int main(int argc, char** argv) {
  Counter cnt(1000, "1k counter"),
          cnt2(10, "10 counter");

  cnt.threaded_count();
  cnt2.threaded_count();

  return 0;
}
