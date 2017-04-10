
set USED      1;
set NOT_USED  0;

set maxtcase  0;        # Max number of test cases

set MAXFUNCTIONS 0;
set MAXTCASES    0;

set TMP_DIR_FILE /tmp/proteum_exec


# Fonts para labes-pnud
set f1 -adobe-helvetica-medium-r-normal--0-0-75-75-p-0-iso8859-1
set f2 -adobe-helvetica-bold-r-normal--0-0-75-75-p-0-iso8859-1

# Fonts para caiapo e caiua
#set f1 "-b&h-lucidatypewriter-medium-r-normal-sans-0-0-0-0-m-0-iso8859-1"
#set f2 "-b&h-lucidatypewriter-bold-r-normal-sans-0-0-0-0-m-0-iso8859-1"


# Sets fonts
option add *Label.Font	     $f2
option add *Entry.Font       $f1
option add *Menu.Font        $f1
option add *Menubutton.Font  $f1
option add *Button.Font      $f2
option add *Checkbutton.Font $f1
option add *Radiobutton.Font $f1
option add *Text.Font        $f1
option add *Listbox.Font     $f1  


#--------------- Globals Variables -----------------#

 
set test(dir)      {};     # directory
set test(tfile)    {};     # program test
set test(src)      {};     # source file
set test(exec)     {};     # executable file
set test(comp)     {};     # compilation command
set test(type)     {};     # test type (test or research)
set test(func)     {};     # functions for test (all or select)
set test(anom)     {};     # anomalous
 
set muta(status0)  {};     # Status of mutant 
set muta(status1)  {};     # Status of mutant
set muta(mortis)   {};     # Mortis cause 
set muta(tcmortis) {};     # Test case mortis cause
set muta(dsize)    {};     # Descriptor size
set muta(begin)    {};     # Where the function start
set muta(node)     {};     # Program graph node
set muta(tcase)    {};     # Last used test case 
set muta(num_op)   {};     # Number of operator that generate this mutant
set muta(name_op)  {};     # Name of operator that generate this mutant
set muta(d_init0)  {};
set muta(d_init1)  {};     # Mutation Descriptor
set muta(d_init2)  {};


set tcase(status)  {};     # Test case status (enable/disable)
set tcase(param)   {};     # Parameter
set tcase(exec)    {};     # Execution Time (1/100 Sec)
set tcase(rcode)   {};     # Return code
set tcase(insize)  {};     # Input Size
set tcase(outsize) {};     # Output Size
set tcase(in)      {};     # Input
set tcase(out)     {};     # Output

set in(dir)        {}
set in(tfile)      {}
set in(src)        {}
set in(exec)       {};     # Variables for entry datas
set in(comp)       {}
set in(type)       {}
set in(anom)       {}
set in(tout)       {}
set in(from)       {}
set in(to)         {}

set out(totmut)	   {}
set out(anomut)    {}
set out(actmut)    {}
set out(alimut)    {};     # General information
set out(livmut)    {}
set out(equmut)    {}
set out(score)     {}
 


set ddirectory     {};     # default directory
set timeout        {};     # timeout for mutation execution



# Number of mutation operators for each class
set NCONS  3
set NOPER 46
set NSTAT 15
set NVAR   7



  
set cons_data {{Cccr - Constant for Constant Replacement} \
	      {Ccsr - Constant for Scalar Replacement} \
	      {CRCR - Required Constant Replacement}}

set oper_data {{OAAA - Arithmetic Assignment Mutation} \
	      {OAAN - Arithmetic Operator Mutation} \
	      {OABA - Arithmetic Assignment by Bitwise Assignment} \
	      {OABN - Arithmetic by Bitwise Operator} \
	      {OAEA - Arithmetic Assignment by Plain Assignment} \
	      {OALN - Arithmetic Operator by Logical Operator} \
	      {OARN - Arithmetic Operator by Relational Operator} \
	      {OASA - Arithmetic Assignment by Shift Assignment} \
	      {OASN - Arithmetic Operator by Shift Operator} \
	      {OBAA - Bitwise Assignment by Arithmetic Assignment} \
	      {OBAN - Bitwise Operator by Arithmetic Assignment} \
	      {OBBA - Bitwise Assignment Mutation} \
	      {OBBN - Bitwise Operator Mutation} \
	      {OBEA - Bitwise Assignment by Plain Assignment} \
	      {OBLN - Bitwise Operator by Logical Operator} \
	      {OBNG - Bitwise Negation} \
	      {OBRN - Bitwise Operator by Relational Operator} \
	      {OBSA - Bitwise Assignment by Shift Assignment} \
	      {OBSN - Bitwise Operator by Shift Operator} \
	      {OCNG - Logical Context Negation} \
	      {OCOR - Cast Operator by Cast Operator} \
	      {OEAA - Plain assignment by Arithmetic Assignment} \
	      {OEBA - Plain assignment by Bitwise Assignment} \
	      {OESA - Plain assignment by Shift Assignment} \
	      {Oido - Increment/Decrement Mutation} \
	      {OIPM - Indirection Operator Precedence Mutation} \
	      {OLAN - Logical Operator by Arithmetic Operator} \
	      {OLBN - Logical Operator by Bitwise Operator} \
	      {OLLN - Logical Operator Mutation} \
	      {OLNG - Logical Negation} \
	      {OLRN - Logical Operator by Relational Operator} \
	      {OLSN - Logical Operator by Shift Operator} \
	      {ORAN - Relational Operator by Arithmetic Operator} \
	      {ORBN - Relational Operator by Bitwise Operator} \
	      {ORLN - Relational Operator by Logical Operator} \
	      {ORRN - Relational Operator Mutation} \
	      {ORSN - Relational Operator by Shift Operator} \
	      {OSAA - Shift Assignment by Arithmetic Assignment} \
	      {OSAN - Shift Operator by Arithmetic Operator} \
	      {OSBA - Shift Assignment by Bitwise Assignment} \
	      {OSBN - Shift Operator by Bitwise  Operator} \
	      {OSEA - Shift Assignment by Plain Assignment} \
	      {OSLN - Shift Operator by Logical Operator} \
	      {OSRN - Shift Operator by Relational Operator} \
	      {OSSN - Shift Operator Mutation} \
	      {OSSA - Shift Assignment Mutation}}

set stat_data {{SBRC - break Replacement by continue} \
	      {SBRn - break Out to Nth Level}        \
	      {SCRB - continue Replacement by break} \
	      {SCRn - continue Out to Nth Level}     \
	      {SDWD - do-while Replacement by while} \
	      {SGLR - goto Label Replacement}        \
	      {SMTC - n-trip continue}               \
	      {SMTT - n-trip trap}                   \
	      {SMVB - Move Brace Up and Down}        \
	      {SRSR - return Replacement}            \
	      {SSDL - Statement Deletion}            \
	      {SSWM - switch Statement Mutation}     \
	      {STRI - Trap on if Condition}          \
	      {STRP - Trap on Statement Execution}   \
	      {SWDD - while Replacement by do-while}}

set var_data {{Varr - Mutate Array References} \
	     {VDTR - Domain Traps} \
	     {Vprr - Mutate Pointer References} \
	     {VSCR - Structure Component Replacement} \
	     {Vsrr - Mutate Scalar References} \
	     {Vtrr - Mutate Structure References} \
	     {VTWD - Twiddle Mutations}}

