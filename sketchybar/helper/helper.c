#include "cpu.h"
#include "sketchybar.h"
#include <stdlib.h>

struct cpu g_cpu;

void handler(env env) {
  // Environment variables passed from sketchybar can be accessed as seen below
  char *name = env_get_value_for_key(env, "NAME");
  char *sender = env_get_value_for_key(env, "SENDER");
  char *info = env_get_value_for_key(env, "INFO");
  char *selected = env_get_value_for_key(env, "SELECTED");

  if ((strcmp(name, "cpu.percent") == 0)) {
    // CPU graph updates
    cpu_update(&g_cpu);

    if (strlen(g_cpu.command) > 0)
      system(g_cpu.command);
  }
}

int main(int argc, char **argv) {
  cpu_init(&g_cpu);

  while (true) {
    cpu_update(&g_cpu);
    if (strlen(g_cpu.command) > 0) {
      fprintf(stderr, "[helper] running: %s\n",
              g_cpu.command); // optional debug
      system(g_cpu.command);
    }
    sleep(3);
  }

  return 0;
}
