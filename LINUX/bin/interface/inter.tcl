#------------------------------------------------------------------------------#
#   INTER.TCL
#   Makes the interface between the user interface and executable files that
#   implements the funcionality of Proteum Tool.
#   author: Elisa Yumi Nakagawa
#   date: 03/28/96
#   last update: 05/20/96, 09/20/96, 11/04/96
#------------------------------------------------------------------------------#




#------------------------------------------------------------------------------#
#   PTESTE {}
#   Calls executable file PTEST that creates and handles program test files.
#   date: 03/28/96
#   last update: 03/29/96, 09/20/96, 11/04/96
#------------------------------------------------------------------------------#

proc Pteste {operation} {
   global test   
   global MAXFUNCTIONS
   global index_func
   global functions
   global PROTEUMHOME

   switch -exact $operation {

      CREATE {

# OBS: ESSE PROCEDIMENTO PODERIA SER OTIMIZADO QTO AO NUMERO DE LOC.
#      ESSA ATIMIZACAO NOA E' TAO SIMPLES ASSIM, APESAR DE PARECER MUITO TRIVIAL.

         if {[string compare $test(func) all] == 0} {      ;# tests all functions
            if [catch {exec $PROTEUMHOME/pteste -create        \
                                   -S $test(src)  \
                                   -E $test(exec) \
                                   -D $test(dir)  \
                                   -C $test(comp) \
                                   -all           \
                                   -$test(type)   \
                                   $test(tfile)} rpteste] {
               message $rpteste
               return 0
            } 
            return 1


         } else {                                     ;# tests selected functions
            set tmpfunc [Join_Function]

            if [catch {exec $PROTEUMHOME/pteste -create        \
                                   -S $test(src)  \
                                   -E $test(exec) \
                                   -D $test(dir)  \
                                   -C $test(comp) \
                                   -u $tmpfunc    \
                                   -$test(type)   \
                                   $test(tfile)} rpteste] {
               message $rpteste
               return 0
            } 
            return 1
         }
      }
      
      LIST {
         if [catch {exec $PROTEUMHOME/pteste -l             \
                                -D $test(dir)  \
                                $test(tfile)} rpteste] {
               message $rpteste
               return 0
            } 
            return $rpteste
      }
   }
}


 
#------------------------------------------------------------------------------#
#   Li {}
#   Calls executable file LI that transforms a C program into a intermediate
#   representation called LI.
#   date: 04/09/96
#   last update: 04/09/96, 09/16/96, 09/17/96, 11/04/96
#------------------------------------------------------------------------------#

proc Li {operation args} {
   global test
   global in
   global MAXFUNCTIONS
   global functions
   global index_func
   global PROTEUMHOME

   set test(dir) $in(dir)
   set test(src) $in(src)

   # take off ".c" of source filename
   # set tmpfile [string trimright $test(src) ".c"] ###% Modified, commented
   set tmpfile $test(src)

   switch -exact $operation {

      NEWSES {
         if [catch {exec $PROTEUMHOME/li -P __$tmpfile     \
                            -D $test(dir)     \
                            $tmpfile          \
                            __$tmpfile} rli] {;   
             message $rli
             return 0
         }
      }
      LISTFUNC {
         if [catch {exec $PROTEUMHOME/li -l                \
                            -D $test(dir)     \
                            __$tmpfile        \
                            __$tmpfile} rli] {;  # rli has list of functions
             message $rli
             return 0
         } else { 
            set rli $rli\n         
            set first [string first \n $rli]
            set end [string last \n $rli]
            set i 0
            while {$first != $end} {
               set first [string first \n $rli]
               set end [string last \n $rli]
               set functions($i) [string range $rli 0 [expr $first-1]]
               set rli [string range $rli [expr $first+1] $end]
               incr i
            }
            set MAXFUNCTIONS $i
         }
      }
   }
   return 1
}


#------------------------------------------------------------------------------#
#   LI2NLI {}
#   Calls executable file LI2NLI that creates the program graph and adds infor-
#   mation about program graph nodes to the intermediate representation (LI 
#   program).
#   date: 04/09/96
#   last update: 04/09/96, 11/04/96
#------------------------------------------------------------------------------#

proc Li2nli {} {
   global test
   global PROTEUMHOME

   # take off ".c" of source filename
   #set tmpfile [string trimright $test(src) ".c"]  ###% commented
   set tmpfile $test(src)

   if [catch {exec $PROTEUMHOME/li2nli -D $test(dir) \
                          __$tmpfile} rli2nli] {
      message $rli2nli
      return 0
   }
   return 1
}


#------------------------------------------------------------------------------#
#   TCASE {}
#   Calls executable file TCASE that creates and handles test cases file.
#   date: 04/09/96
#   last update: 04/15/96, 11/04/96
#------------------------------------------------------------------------------#

proc Tcase {operation args} {
   global in;          # In data
   global test;        # Test program information
   global ntcase;      # Number of current test case
   global PROTEUMHOME

   switch -exact $operation {

      CREATE {
         if [catch {exec $PROTEUMHOME/tcase -create             \
                               -D $test(dir)       \
                               $test(tfile)} rtcase] {
            message $rtcase;       # Error creation test case
            return 0
         } else {
            return 1
         }
      }

      ADD {
#         if [catch {open "|$PROTEUMHOME/tcase -add                \
#                                 -DD $test(dir)      \
#                                 -E $test(exec)      \
#                                 -p [lindex $args 0] \
#                                 -D $test(dir)       \
#                                 $test(tfile)"} output] { 
#            message "$output!"
#            return 0
#         } else {
#            return $output
#         }

# OBS: O PROGRAMA TCASE ESTA' RETORNANDO ALGUM CODIGO QUE FAZ COM QUE O CATCH
# ACUSE ALGUM ERRO. ASSIM SEMPRE O RAMO THEN DO IF ESTA' SENDO EXECUTADO.

         if [catch {exec xterm -e $PROTEUMHOME/tcase -add                   \
                                  -DD $test(dir)      \
                                  -E $test(exec)      \
                                  -p [lindex $args 0] \
                                  -D $test(dir)       \
                                  $test(tfile) &} rtcase] {
#            puts =====>$rtcase
#            return 0
            return 1
         } else {
#            puts =====>$rtcase
            return 1
         }
      }

      VIEW {
         if [catch {exec $PROTEUMHOME/tcase -l                  \
                               -x [lindex $args 0] \
                               -D $test(dir)       \
                               $test(tfile)} rtcase] {

            message $rtcase; # Error view test case
            return 0
         } else {
            return $rtcase; # OBS: RETORNA A SAIDA PARA O PROGRAMA CHAMADOR
         }
      }

      ENABLE {
         if [catch {exec $PROTEUMHOME/tcase -e                  \
                               -x $ntcase          \
                               -D $test(dir)       \
                               $test(tfile)} rtcase] {

            message $rtcase; # Error enable test case
            return 0
         } else {
            return 1
         }
      }

      DISABLE {
         if [catch {exec $PROTEUMHOME/tcase -i                  \
                               -x $ntcase          \
                               -D $test(dir)       \
                               $test(tfile)} rtcase] {

            message $rtcase; # Error disable test case
            return 0
         } else {
            return 1
         }
      }

      DELETE {
         if [catch {exec $PROTEUMHOME/tcase -d                  \
                               -f [lindex $args 0] \
                               -t [lindex $args 1] \
                               -D $test(dir)        \
                               $test(tfile)} rtcase] {

            message $rtcase; # Error delection test case
            return 0
         } else {
            return 1
         }
      }

      IMPORT {
         switch -exact [lindex $args 0] {
            PROTEUM {
               catch {exec $PROTEUMHOME/tcase -proteum             \
                                 -DD [lindex $args 1] \
                                 -I  [lindex $args 2] \
				 -f  [lindex $args 3] \
				 -t  [lindex $args 4] \
                                 -DE $test(dir)       \
                                 -E  $test(exec)      \
                                 -D  $test(dir)       \
                                 $test(tfile)} rtcase
 
               return $rtcase;     # Number of imported test case from Proteum
            }
            POKE {
               catch {exec $PROTEUMHOME/tcase -poke                \
                                 -DD [lindex $args 1] \
				 -f  [lindex $args 2] \
				 -t  [lindex $args 3] \
                                 -D  $test(dir)       \
				 -E  $test(exec)      \
                                 $test(tfile)} rtcase
               return $rtcase;     # Number of imported test case from Poke-tool
            }
            ASCII {
	       set tmp ""
	       if { [string length [lindex $args 2] ] != 0} {
		   set tmp " -I  [lindex $args 2]"
	       }
	       if { [string length [lindex $args 3] ] != 0} {
		   set tmp " $tmp -p  [lindex $args 3]"
	       }
               catch {eval exec $PROTEUMHOME/tcase -ascii               \
                                 -DD [lindex $args 1] \
				$tmp 		      \
                                 -f  [lindex $args 4] \
                                 -t  [lindex $args 5] \
                                 -D  $test(dir)       \
				 -E  $test(exec)      \
                                 $test(tfile)} rtcase 
               return $rtcase;    # Number of imported test case from Ascii
            }
         }
      }
   }
   return
}


#------------------------------------------------------------------------------#
#   Muta {}
#   Calls executable file MUTA that creates and handles files of mutants
#   descriptors and executable file OPMUTA that applies mutation operators 
#   to source file.
#   date: 04/09/96
#   last update: 04/23/96, 11/04/96
#------------------------------------------------------------------------------#

proc Muta {operation args} {
   global test
   global PROTEUMHOME

   switch -exact $operation {

      CREATE {
         if [catch {exec $PROTEUMHOME/muta -create     \
                           -D $test(dir)  \
                           $test(tfile)} rmuta] {
            message $rmuta;      # Error creation mutants file descriptor
            return 0
         } else {
            return 1
         }
      }
      ADD {
         # take off ".c" of source filename
         # set tmpfile [string trimright $test(src) ".c"] ###% commented
	 set tmpfile $test(src)
 

# OBS: O IF ABAIXO NAO ESTA' FUNCIONANDO OK

         if {[string compare $test(func) all] == 0} {
            set tmpfunc ""
         } else {
            set tmpfunc "-u [Join_Function]"
         }

# OBS: TEM DE PASSAR PARA O OPMUTA O NOME DAS FUNCOES OU PASSAR NADA
# QUANDO E' PARA TESTAR TODAS AS FUNCOES.
 
         if [catch {exec $PROTEUMHOME/opmuta -[lindex $args 0] \
                                [lindex $args 1]  \
                                -D $test(dir)     \
                                __$tmpfile        \
                                __$tmpfile | $PROTEUMHOME/muta -add          \
                                                  -D $test(dir) \
                                                  $test(tfile)} rmuta] {


#            message $rmuta;         # Return number of generated mutants
            return [string range $rmuta 1 [expr [string first " " $rmuta]-1]]

         } else {
            # Return number of generated mutants
            return [string range $rmuta 0 [expr [string first " " $rmuta]-1]]
         }
      }
      LIST {
         if [catch {exec $PROTEUMHOME/muta -l                  \
                              -x [lindex $args 0] \
                              -D $test(dir)       \
                              $test(tfile)} rmuta] {
             message $rmuta;  # Error taking information about mutant
             return 0
         } else {
             return $rmuta;   # Returns information about mutant
         }

      }
      SEARCH {
	 set var ""
	 foreach value $args {append var $value}
	 if [catch {eval exec $PROTEUMHOME/muta $var \
			 -D $test(dir) \
			 $test(tfile)} rmuta] {
             message $rmuta;  # Error taking information about mutant
             return 0
         } else {
             return $rmuta;   # Returns information about mutant
         }

      }

      EQUIV {
         if [catch {exec $PROTEUMHOME/muta -equiv                \
                              -x [lindex $args 0] \
                              -D $test(dir)         \
                              $test(tfile)} rmuta] {
            message $rmuta;   # Error 
            return 0
         } else {
            return 1
         }
      }
      NEQUIV {
         if [catch {exec $PROTEUMHOME/muta -nequiv               \
                              -x [lindex $args 0] \
                              -D $test(dir)         \
                              $test(tfile)} rmuta] {
            message $rmuta;   # Error 
            return 0
         } else {
            return 1
         }
      }
      VERIFY {

         # ESSA FUNCAO AINDA NAO ESTA DISPONIVEL NOS SCRIPTS DA PROTEUM V. 1.2.3
 
      }
    
   }
   return
}


#------------------------------------------------------------------------------#
#   EXEMUTA {}
#   Executes, selects or builds mutants.
#   date: 04/18/96
#   last update: 07/02/96, 11/04/96
#------------------------------------------------------------------------------#

proc Exemuta {operation args} {
   global test;
   global output;
   global TMP_DIR_FILE;
   global PROTEUMHOME
   global OK
   global nmuta
   global execcan

# OBS: NOS RAMOS ORIGINAL E EXECONE, ARRUMAR PARA SER EXECUTADO INTERATIVAMENTE
# NA JANELA EM TK E NAO NO SHELL

   switch -exact $operation {

      EXEC {;         # Executes all mutants
	 set fileid [open "|$PROTEUMHOME/exemuta -exec             \
                                 -T [lindex $args 0] \
                                 -D $test(dir)       \
                                 -v .                \
                                 $test(tfile)" r]
	if { $fileid > 0 } {
	set nmuta 0
	while { [eof $fileid] != 1} {
	   set data [read $fileid 1]
	   if { $execcan != 0} {
		break
	   }
	   if { $data == "." } {
		set nmuta [expr $nmuta+1]
	   } else break
	   update
	}
	catch "close $fileid" 
	return 0
	} else {
	   return 1
	}
	

         if [catch "exec $PROTEUMHOME/exemuta -exec             \
                                 -T [lindex $args 0] \
                                 -D $test(dir)       \
                                 -v .                \
                                 $test(tfile)" rexemuta] {
            message "$rexemuta !"
            return 0
         } else {
            return 1
         }
      }

      SELECT {;        # Selects mutants
         if [catch "exec $PROTEUMHOME/exemuta -select             \
                                 -D $test(dir)       \
                                 [lindex $args 0]    \
                                 $test(tfile)" rexemuta] { 
            message "$rexemuta !"
            return 0
         } else {
            return 1
         }
      }

      BUILD {;         # Builds one mutant
         if [catch {exec $PROTEUMHOME/exemuta -build              \
                                 -x [lindex $args 0] \
                                 -D $test(dir)       \
                                 $test(tfile)} rexemuta] {
            message "$rexemuta !"
            return 0
         } else {
            return 1
         }
      }

      ORIGINAL {
         if [catch {exec $test(dir)/$test(exec)} rexemuta] {
            message "$rexemuta !"
            return 0
         } else {
            message "$rexemuta !"
            return 1
         }

      }

      EXECONE {
         Exemuta BUILD [lindex $args 0]
         set exec_name "muta[lindex $args 0]_$test(tfile).exe"
         if [catch {exec $test(dir)/$exec_name} rexemuta] {
            message "$rexemuta !"
            return 0
         } else {
            message "$rexemuta !"
            return 1
         }
      }
   }

}


#------------------------------------------------------------------------------#
#   REPORT {}
#   Build a file with a report about test cases effectiveness.
#   date: 04/25/96
#   last update: 04/25/96, 11/04/96, 06/05/97
#------------------------------------------------------------------------------#

proc Report {operation args} {

   global test
   global PROTEUMHOME

   switch -exact $operation {
      TCASE {
        if [catch {exec $PROTEUMHOME/report -tcase       \
                               -L [lindex $args 0]       \
                               -D $test(dir)             \
                               $test(tfile)} rreport] {
           message $rreport
           return 0     
        } else {
           return 1
        }
      }
  
      GENERAL {
        if [catch {exec $PROTEUMHOME/report -g           \
                               -D $test(dir)             \
                               $test(tfile)} rreport] {
           message $rreport
           return 0     
        } else {
           return $rreport
        }
      }
   }   
}
