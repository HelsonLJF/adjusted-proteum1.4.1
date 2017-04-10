#ifndef		_PROTEUM_

#define		_PROTEUM_

#define		__TRAP__		kill(getpid(), 9)

#define		TRAP_ON_STAT()		__TRAP__

#define		TRAP_ON_TRUE(x)		((x)? __TRAP__: 0)

#define		TRAP_ON_FALSE(x)	((x)? 1: __TRAP__)

#define		TRAP_ON_CASE()		__TRAP__

#define		TRAP_ON_NEGATIVE(x)	((x) < 0? __TRAP__: (x))

#define		TRAP_ON_POSITIVE(x)	((x) > 0? __TRAP__: (x))

#define		TRAP_ON_ZERO(x)		((x) == 0? __TRAP__: (x))

#define		PRED(x)			(x-1)

#define		SUCC(x)			(x+1)

#define		TRAP_AFTER_N_INTER(x)	{ if( _PROTEUM_LOCAL_VAR_++ >= (x)) __TRAP__; }

#define		FALSE_AFTER_N_INTER(x)	{ if( _PROTEUM_LOCAL_VAR_++ > (x)) continue;}

#define		BREAK_OUT_TO_N_LEVEL(x)		goto x

#define		CONTINUE_OUT_TO_N_LEVEL(x)	goto x

#define		_NUMERO_MUTANTE		atoi((char *) getenv("MUTANTTOEXEC"))

#endif
