#include <stdio.h>
#include "hardware.h"
#define WDTCTL_              0x0120    /* Watchdog Timer Control */
#define WDTHOLD             (0x0080)
#define WDTPW               (0x5A00)

//extern void hmac(uint8_t *mac, uint8_t *key, uint32_t keylen, uint8_t *data, uint32_t datalen);
extern void VRASED (uint8_t *challenge, uint8_t *auth_chal, uint8_t *response); 
extern void my_memset(uint8_t* ptr, int len, uint8_t val);
extern void my_memcpy(uint8_t* dst, uint8_t* src, int size);

static uint8_t auth_chal[32] = { 0x59, 0x76,  0xac, 0x8c,  0x4b, 0xd5,  0x5e, 0x69,  0xea, 0xa9,  0x03, 0x86,  0x29, 0x80,  0x03, 0x29,  0x0b, 0x9e,  0x4f, 0x37,  0x6d, 0xe7,  0x47, 0x8e,  0xd0, 0x9c,  0x96, 0x04,  0x39, 0x3c,  0x2a, 0x3f};



int main() 
{
  uint32_t* wdt = (uint32_t*)(WDTCTL_);
  *wdt = WDTPW | WDTHOLD;

  uint8_t key[64];
  uint8_t challenge[32];
  uint8_t response[32];
  my_memset(challenge, 32, 0xff);
  int i;
  for(i=0; i<32; i++) {
	  if(challenge[i] != 0xff)
  		__asm__ volatile("br #0xffff" "\n\t");
  }
  //TODO: figure out auth_chal value
  VRASED(challenge, auth_chal, response);
  __asm__ volatile("br #0xfffe" "\n\t");

  return 0;
}
