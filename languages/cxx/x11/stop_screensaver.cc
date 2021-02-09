// It seems -lXss is not very wel documented online, and that's the
// library that has the definitions of XScreenSaverSuspend
//
// You will require -lXext for DPMS functionality
//
//   g++ -lX11 -lXss -lXext stop_screensaver.cc
//
// This is basically a bunch of X11 programming that I put together
// from manuals or various internet sources, which might shed light
// on some of the usage of some of these functions.

#include <iostream>
#include <thread>
#include <chrono>

#include <X11/Xmd.h>
#include <X11/extensions/scrnsaver.h>
#include <X11/extensions/dpms.h>

class DisableScreenSavingContext {
public:
  DisableScreenSavingContext() : mDpy(nullptr) {
    mDpy = XOpenDisplay(0);
    if (!mDpy) {
      std::cout << "could not run display -- are you running headless?" << std::endl;
      return;
    }

    std::cout << "-- disable screensaver" << std::endl;
    XScreenSaverSuspend(mDpy, true);
  }

  ~DisableScreenSavingContext() {
    std::cout << "-- enable screensaver" << std::endl;
    XScreenSaverSuspend(mDpy, false);

    if (XCloseDisplay(mDpy)) {
      std::cout << "could not close display" << std::endl;
      return;
    }
  }

private:
  Display *mDpy;
};

class ScreenSaverInfo {
public:
  ScreenSaverInfo() : mDpy(XOpenDisplay(0)), mInfo(XScreenSaverAllocInfo()) {
    Refresh();
  }

  ~ScreenSaverInfo() {
    if (XCloseDisplay(mDpy)) std::cout << "error closing display" << std::endl;
    XFree(mInfo);
  }

  void Refresh() noexcept {
    XScreenSaverQueryInfo(mDpy, DefaultRootWindow(mDpy), mInfo);
  }

  std::uint32_t GetTilOrSince() const noexcept {
    return mInfo->til_or_since;
  }

  std::uint32_t GetIdle() const noexcept {
    return mInfo->idle;
  }

  std::uint32_t GetEventMask() const noexcept {
    return mInfo->eventMask;
  }

  void PrintStats() const noexcept {
    std::cout << "screensaver til or since secs: " << GetTilOrSince() << std::endl;
    std::cout << "screensaver idle         secs: " << GetIdle() << std::endl;
    std::cout << "screensaver event mask       : " << std::hex << GetEventMask() << std::dec << std::endl;
  }

private:
  Display *mDpy;
  XScreenSaverInfo *mInfo;
};

class DPMSUtil {
public:
  DPMSUtil() : mDpy(XOpenDisplay(0)) {
    Refresh();
  }

  ~DPMSUtil() {
    XCloseDisplay(mDpy);
  }

  void Refresh() noexcept {
    DPMSGetTimeouts(mDpy,
                    &mStandbySeconds,
                    &mSuspendSeconds,
                    &mOff);
  }

  std::uint16_t GetStandbyTimeouts() const noexcept {
    return mStandbySeconds;
  }

  std::uint16_t GetSuspendTimeouts() const noexcept {
    return mSuspendSeconds;
  }

  std::uint16_t GetOffTimeouts() const noexcept {
    return mOff;
  }

  // As man dpmsgettimeouts(3) says, 0 indicates that something is
  // disabled

  bool IsStandbyDisabled() const noexcept { return mStandbySeconds == 0; }
  bool IsSuspendDisabled() const noexcept { return mSuspendSeconds == 0; }
  bool IsOffDisabld() const noexcept { return mOff == 0; }

  void PrintStats() const noexcept {
    std::cout << "dpms standby secs: " << GetStandbyTimeouts() << std::endl;
    std::cout << "dpms suspend secs: " << GetSuspendTimeouts() << std::endl;
    std::cout << "dpms off     secs: " << GetOffTimeouts() << std::endl;
  }

private:
  Display* mDpy;
  CARD16 mStandbySeconds;
  CARD16 mSuspendSeconds;
  CARD16 mOff;
};

int main(int argc, char *argv[]) {
  (void) argc;
  (void) argv;

  if (false) { // screen saver counters should increase here
    DPMSUtil dpms;
    ScreenSaverInfo ssi;

    std::cout << "-- sleep" << std::endl;
    for (size_t i = 0; i < 30; ++i) {
      std::this_thread::sleep_for(std::chrono::seconds(6));

      std::cout << "=====================" << std::endl;
      dpms.PrintStats();
      std::cout << "=====================" << std::endl;
      ssi.PrintStats();

      dpms.Refresh();
      ssi.Refresh();
    }
    std::cout << "-- wake me up" << std::endl;
  }

  { // this in theory should show that the screen saver counters do not increase
    DisableScreenSavingContext ctx;
    DPMSUtil dpms;
    ScreenSaverInfo ssi;

    std::cout << "-- sleep" << std::endl;
    for (size_t i = 0; i < 30; ++i) {
      std::this_thread::sleep_for(std::chrono::seconds(6));

      std::cout << "=====================" << std::endl;
      dpms.PrintStats();
      std::cout << "=====================" << std::endl;
      ssi.PrintStats();

      dpms.Refresh();
      ssi.Refresh();
    }
    std::cout << "-- wake me up" << std::endl;
  }
  return 0;
}
