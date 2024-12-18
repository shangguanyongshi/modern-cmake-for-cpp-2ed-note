#include "tui.h"
#include <ftxui/component/screen_interactive.hpp>

int main(int argc, char **argv) {
  ftxui::ScreenInteractive::FitComponent().Loop(getTui());
}