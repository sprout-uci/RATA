#include <stdio.h>
#include "hardware.h"
#define WDTCTL_              0x0120    /* Watchdog Timer Control */
#define WDTHOLD             (0x0080)
#define WDTPW               (0x5A00)

extern void VRASED (uint8_t *challenge, uint8_t *auth_chal, uint8_t *response); 
extern void my_memset(uint8_t* ptr, int len, uint8_t val);

// Ideally, Prover receives challenge and authentication token from Verifier. 
// In this demo, we use sample challenge and authentication token.
// The below authentication token is computed using challenge[32]: {0x11, 0x11, ....., 0x11}.
static uint8_t auth_chal[32] = { 0x10, 0x1b, 0x73, 0xc2, 0x75, 0x1f, 0x74, 0x91, 
                                 0x57, 0xac, 0x01, 0x03, 0x32, 0xbe, 0x55, 0xac, 
                                 0xc5, 0x88, 0x4f, 0xae, 0x00, 0xb0, 0x9d, 0x69, 
                                 0xaa, 0x29, 0xc1, 0xe3, 0xea, 0x58, 0x68, 0xa8 };

int main() 
{
  // Switch off the WTD
  uint32_t* wdt = (uint32_t*)(WDTCTL_);
  *wdt = WDTPW | WDTHOLD;

  uint8_t response[32];
  uint8_t challenge[32];
  my_memset(challenge, 32, 0x11);
  
  // Call VRASED with challenge and auth_chal.
  VRASED(challenge, auth_chal, response);
  __asm__ volatile("br #0xfffe" "\n\t");

  return 0;
}