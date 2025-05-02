#include <mach/mach.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define MAX_TOPPROC_LEN 28

static const char TOPPROC[] = {"/bin/ps -Aceo pid,pcpu,comm -r"};
static const char FILTER_PATTERN[] = {"com.apple."};

struct cpu {
  host_t host;
  mach_msg_type_number_t count;
  host_cpu_load_info_data_t load;
  host_cpu_load_info_data_t prev_load;
  bool has_prev_load;

  char command[256];
};

static inline void cpu_init(struct cpu *cpu) {
  cpu->host = mach_host_self();
  cpu->count = HOST_CPU_LOAD_INFO_COUNT;
  cpu->has_prev_load = false;
  snprintf(cpu->command, 100, "");
}

static inline void cpu_update(struct cpu *cpu) {
  kern_return_t error = host_statistics(cpu->host, HOST_CPU_LOAD_INFO,
                                        (host_info_t)&cpu->load, &cpu->count);

  if (error != KERN_SUCCESS) {
    fprintf(stderr, "Error: Could not read cpu stats.\n");
    return;
  }

  double percent = 0;

  if (cpu->has_prev_load) {
    uint32_t delta_user = cpu->load.cpu_ticks[CPU_STATE_USER] -
                          cpu->prev_load.cpu_ticks[CPU_STATE_USER];
    uint32_t delta_system = cpu->load.cpu_ticks[CPU_STATE_SYSTEM] -
                            cpu->prev_load.cpu_ticks[CPU_STATE_SYSTEM];
    uint32_t delta_idle = cpu->load.cpu_ticks[CPU_STATE_IDLE] -
                          cpu->prev_load.cpu_ticks[CPU_STATE_IDLE];

    double total = delta_user + delta_system + delta_idle;
    percent = ((delta_user + delta_system) / total) * 100.0;
  }

  snprintf(cpu->command, sizeof(cpu->command),
           "sketchybar --set cpu.percent label=\"%.0f%%\"", percent);

  cpu->prev_load = cpu->load;
  cpu->has_prev_load = true;
}
