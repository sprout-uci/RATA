.PHONY: nacllib clean

HACL_HOME ?= ../..

#
# Compilation flags
#
CCOPTS = -Ofast -march=native -mtune=native -m64 -fwrapv -fomit-frame-pointer -funroll-loops
CCOPTS32 = -Ofast -mtune=generic -m32 -fwrapv -fomit-frame-pointer -funroll-loops

ifeq ($(SNAPSHOT_DIR),snapshots/hacl-c-compcert)
  LIBFLAGS=$(CCOPTS) $(CFLAGS)
  LIBFLAGS32=$(CCOPTS32) $(CFLAGS)
  OTHER=FStar.c -shared
else
  LIBFLAGS=$(CCOPTS) -fPIC
  LIBFLAGS32=$(CCOPTS32) -fPIC -DKRML_NOUINT128 -Wno-unused-function
  OTHER=-shared
endif

#
# Files
#

FILES = Hacl_Salsa20.c Hacl_Salsa20.h Hacl_Chacha20.c Hacl_Chacha20.h Hacl_Poly1305_32.c Hacl_Poly1305_32.h Hacl_Poly1305_64.c Hacl_Poly1305_64.h AEAD_Poly1305_64.c AEAD_Poly1305_64.h Hacl_SHA2_512.c Hacl_SHA2_512.h Hacl_Ed25519.c Hacl_Ed25519.h Hacl_Curve25519.c Hacl_Curve25519.h Hacl_Chacha20Poly1305.c Hacl_Chacha20Poly1305.h Hacl_Policies.c Hacl_Policies.h NaCl.c NaCl.h
TWEETNACL_HOME ?= $(HACL_HOME)/other_providers/tweetnacl

#
# Library (64 bits)
#

libhacl.so: $(FILES)
	$(CC) $(LIBFLAGS) \
	  Hacl_Salsa20.c -c -o Hacl_Salsa20.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Chacha20.c -c -o Hacl_Chacha20.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Poly1305_32.c -c -o Hacl_Poly1305_32.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Poly1305_64.c -c -o Hacl_Poly1305_64.o
	$(CC) $(LIBFLAGS) \
	  AEAD_Poly1305_64.c -c -o AEAD_Poly1305_64.o
	$(CC) $(LIBFLAGS) \
	  Hacl_SHA2_512.c -c -o Hacl_SHA2_512.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Ed25519.c -c -o Hacl_Ed25519.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Curve25519.c -c -o Hacl_Curve25519.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Chacha20Poly1305.c -c -o Hacl_Chacha20Poly1305.o
	$(CC) $(OTHER) $(LIBFLAGS) -I . -Wall \
	  hacl_test_utils.c \
	  Hacl_Salsa20.o Hacl_Poly1305_32.o Hacl_Poly1305_64.o Hacl_Chacha20.o AEAD_Poly1305_64.o Hacl_Chacha20Poly1305.o Hacl_SHA2_512.o Hacl_Ed25519.o Hacl_Curve25519.o kremlib.c Hacl_Policies.c NaCl.c randombytes.c haclnacl.c \
	  -o libhacl.so


#
# Library (64 bits), static
#

libhacl.a: $(FILES)
	$(CC) $(LIBFLAGS) \
	  Hacl_Salsa20.c -c -o Hacl_Salsa20.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Chacha20.c -c -o Hacl_Chacha20.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Poly1305_32.c -c -o Hacl_Poly1305_32.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Poly1305_64.c -c -o Hacl_Poly1305_64.o
	$(CC) $(LIBFLAGS) \
	  AEAD_Poly1305_64.c -c -o AEAD_Poly1305_64.o
	$(CC) $(LIBFLAGS) \
	  Hacl_SHA2_512.c -c -o Hacl_SHA2_512.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Ed25519.c -c -o Hacl_Ed25519.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Curve25519.c -c -o Hacl_Curve25519.o
	$(CC) $(LIBFLAGS) \
	  Hacl_Chacha20Poly1305.c -c -o Hacl_Chacha20Poly1305.o
	$(CC) $(OTHER) $(LIBFLAGS) -I . -Wall \
	  hacl_test_utils.c \
	  Hacl_Salsa20.o Hacl_Poly1305_32.o Hacl_Poly1305_64.o Hacl_Chacha20.o AEAD_Poly1305_64.o Hacl_Chacha20Poly1305.o Hacl_SHA2_512.o Hacl_Ed25519.o Hacl_Curve25519.o kremlib.c Hacl_Policies.c NaCl.c randombytes.c haclnacl.c \
	  -o libhacl.a

#
# Library (32 bits)
#

libhacl32.so: $(FILES)
	$(CC) $(LIBFLAGS32) \
	  FStar.c -c -o FStar.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Salsa20.c -c -o Hacl_Salsa20.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Chacha20.c -c -o Hacl_Chacha20.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Poly1305_32.c -c -o Hacl_Poly1305_32.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Poly1305_64.c -c -o Hacl_Poly1305_64.o
	$(CC) $(LIBFLAGS32) \
	  AEAD_Poly1305_64.c -c -o AEAD_Poly1305_64.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_SHA2_512.c -c -o Hacl_SHA2_512.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Ed25519.c -c -o Hacl_Ed25519.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Curve25519.c -c -o Hacl_Curve25519.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Chacha20Poly1305.c -c -o Hacl_Chacha20Poly1305.o
	$(CC) -shared  $(LIBFLAGS32) -I . -Wall \
	  hacl_test_utils.c \
	  FStar.o Hacl_Salsa20.o Hacl_Poly1305_32.o Hacl_Poly1305_64.o Hacl_Chacha20.o AEAD_Poly1305_64.o Hacl_Chacha20Poly1305.o Hacl_SHA2_512.o Hacl_Ed25519.o Hacl_Curve25519.o kremlib.c Hacl_Policies.c NaCl.c randombytes.c haclnacl.c \
	  -o libhacl32.so

#
# Library (32 bits), static
#

libhacl32.a: $(FILES)
	$(CC) $(LIBFLAGS32) \
	  FStar.c -c -o FStar.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Salsa20.c -c -o Hacl_Salsa20.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Chacha20.c -c -o Hacl_Chacha20.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Poly1305_32.c -c -o Hacl_Poly1305_32.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Poly1305_64.c -c -o Hacl_Poly1305_64.o
	$(CC) $(LIBFLAGS32) \
	  AEAD_Poly1305_64.c -c -o AEAD_Poly1305_64.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_SHA2_512.c -c -o Hacl_SHA2_512.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Ed25519.c -c -o Hacl_Ed25519.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Curve25519.c -c -o Hacl_Curve25519.o
	$(CC) $(LIBFLAGS32) \
	  Hacl_Chacha20Poly1305.c -c -o Hacl_Chacha20Poly1305.o
	$(CC) -shared  $(LIBFLAGS32) -I . -Wall \
	  hacl_test_utils.c \
	  FStar.o Hacl_Salsa20.o Hacl_Poly1305_32.o Hacl_Poly1305_64.o Hacl_Chacha20.o AEAD_Poly1305_64.o Hacl_Chacha20Poly1305.o Hacl_SHA2_512.o Hacl_Ed25519.o Hacl_Curve25519.o kremlib.c Hacl_Policies.c NaCl.c randombytes.c haclnacl.c \
	  -o libhacl32.a

unit-tests: libhacl.so
	$(CC) $(CCOPTS) \
	-I . -I ../snapshots/kremlib -I $(TWEETNACL_HOME) \
	$(TWEETNACL_HOME)/tweetnacl.c hacl_test_utils.c \
	unit_tests.c libhacl.so -o unit_tests.exe
	LD_LIBRARY_PATH=. DYLD_LIBRARY_PATH=. ./unit_tests.exe

unit-tests32: libhacl32.so
	$(CC) $(CCOPTS32) \
	-I . -I ../snapshots/kremlib  -I $(TWEETNACL_HOME) \
	$(TWEETNACL_HOME)/tweetnacl.c hacl_test_utils.c \
	unit_tests.c libhacl32.so -o unit_tests32.exe
	LD_LIBRARY_PATH=. DYLD_LIBRARY_PATH=. ./unit_tests32.exe

clean:
	rm -rf *~ *.exe *.out *.o *.so *.a
