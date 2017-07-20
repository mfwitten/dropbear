#ifndef TOMCRYPT_CUSTOM_H_
#define TOMCRYPT_CUSTOM_H_

/* compile options depend on Dropbear options.h */
#include "options.h"

/* macros for various libc functions you can change for embedded targets */
#ifndef XMALLOC
   #ifdef malloc 
   #define LTC_NO_PROTOTYPES
   #endif
#define XMALLOC  malloc
#endif
#ifndef XREALLOC
   #ifdef realloc 
   #define LTC_NO_PROTOTYPES
   #endif
#define XREALLOC realloc
#endif
#ifndef XCALLOC
   #ifdef calloc 
   #define LTC_NO_PROTOTYPES
   #endif
#define XCALLOC  calloc
#endif
#ifndef XFREE
   #ifdef free
   #define LTC_NO_PROTOTYPES
   #endif
#define XFREE    free
#endif

#ifndef XMEMSET
   #ifdef memset
   #define LTC_NO_PROTOTYPES
   #endif
#define XMEMSET  memset
#endif
#ifndef XMEMCPY
   #ifdef memcpy
   #define LTC_NO_PROTOTYPES
   #endif
#define XMEMCPY  memcpy
#endif
#ifndef XMEMCMP
   #ifdef memcmp 
   #define LTC_NO_PROTOTYPES
   #endif
#define XMEMCMP  memcmp
#endif
#ifndef XSTRCMP
   #ifdef strcmp
   #define LTC_NO_PROTOTYPES
   #endif
#define XSTRCMP strcmp
#endif

#ifndef XCLOCK
#define XCLOCK   clock
#endif
#ifndef XCLOCKS_PER_SEC
#define XCLOCKS_PER_SEC CLOCKS_PER_SEC
#endif

   #define LTC_NO_PRNGS
   #define LTC_NO_PK
#if DROPBEAR_SMALL_CODE
#define LTC_SMALL_CODE
#endif
/* These spit out warnings etc */
#define LTC_NO_ROLC
#ifndef XQSORT
   #ifdef qsort
   #define LTC_NO_PROTOTYPES
   #endif
#define XQSORT qsort
#endif


/* Enable self-test test vector checking */
/* Not for dropbear */
/*#define LTC_TEST*/

/* clean the stack of functions which put private information on stack */
/* #define LTC_CLEAN_STACK */

/* disable all file related functions */
#define LTC_NO_FILE

/* disable all forms of ASM */
/* #define LTC_NO_ASM */

/* disable FAST mode */
/* #define LTC_NO_FAST */

/* disable BSWAP on x86 */
/* #define LTC_NO_BSWAP */


#if DROPBEAR_BLOWFISH
#define LTC_BLOWFISH
#endif

#if DROPBEAR_AES
#define LTC_RIJNDAEL
#endif

#if DROPBEAR_TWOFISH
#define LTC_TWOFISH

/* _TABLES tells it to use tables during setup, _SMALL means to use the smaller scheduled key format
 * (saves 4KB of ram), _ALL_TABLES enables all tables during setup */
/* enabling just TWOFISH_SMALL will make the binary ~1kB smaller, turning on
 * TWOFISH_TABLES will make it a few kB bigger, but perhaps reduces runtime
 * memory usage? */
#define LTC_TWOFISH_SMALL
/*#define LTC_TWOFISH_TABLES*/
#endif

#if DROPBEAR_3DES
#define LTC_DES
#endif

#define LTC_CBC_MODE

#if DROPBEAR_ENABLE_CTR_MODE
#define LTC_CTR_MODE
#endif

#define LTC_SHA1

#if DROPBEAR_MD5
#define LTC_MD5
#endif

#if DROPBEAR_SHA256
#define LTC_SHA256
#endif
#if DROPBEAR_SHA384
#define LTC_SHA384
#endif
#if DROPBEAR_SHA512
#define LTC_SHA512
#endif

#define LTC_HMAC

#if DROPBEAR_ECC
#define LTC_MECC
#define LTC_ECC_SHAMIR
#define LTC_ECC_TIMING_RESISTANT
#define MPI
#define LTM_DESC
#if DROPBEAR_ECC_256
#define ECC256
#endif
#if DROPBEAR_ECC_384
#define ECC384
#endif
#if DROPBEAR_ECC_521
#define ECC521
#endif
#endif

/* Various tidbits of modern neatoness */
#define LTC_BASE64

/* default no pthread functions */
#define LTC_MUTEX_GLOBAL(x)
#define LTC_MUTEX_PROTO(x)
#define LTC_MUTEX_TYPE(x)
#define LTC_MUTEX_INIT(x)
#define LTC_MUTEX_LOCK(x)
#define LTC_MUTEX_UNLOCK(x)
#define FORTUNA_POOLS 0

/* Debuggers */

/* define this if you use Valgrind, note: it CHANGES the way SOBER-128 and LTC_RC4 work (see the code) */
/* #define LTC_VALGRIND */

#endif



/* $Source$ */
/* $Revision$ */
/* $Date$ */
