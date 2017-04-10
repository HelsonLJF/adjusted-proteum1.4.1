#------------------------------------------------------------------------------#
#   GERAL.TCL
#   General functions.
#   author: Elisa Yumi Nakagawa
#   date: 03/21/96
#   last update:  05/29/96 #------------------------------------------------------------------------------#



#------------------------------------------------------------------------------#
#   Set_Directory
#   Return directory name if it is not set.
#   date: 03/21/96
#   last update: 03/21/96
#------------------------------------------------------------------------------#

proc Set_Directory {dir} {  

   if {[string length $dir] == 0} {
      return [pwd]
   } else {
      return $dir
   }
}



#------------------------------------------------------------------------------#
#   Set_Timeout
#   Return timeout default if there is not defined value.
#   date: 03/25/96
#   last update: 03/25/96
#------------------------------------------------------------------------------#

proc Set_Timeout {timeout} {

   if {[string length $timeout] == 0} {
      return {5}
   } else {
      return $timeout
   }
}


#------------------------------------------------------------------------------#
#    BLANK_SPACE_OUT {}
#    Take out blank spaces of a given string.
#    date: 03/22/96
#    last update: 03/22/96
#------------------------------------------------------------------------------#

proc Blank_Space_Out {str} {

   regsub -all { } $str {} tmp
   return $tmp
}


#------------------------------------------------------------------------------#
#    LOAD_FILE_PTM {}
#    Load Test Data in File .PTM.
#    date: 03/27/96
#    last update: 03/27/96, 09/20/96 
#------------------------------------------------------------------------------#

proc Load_File_PTM {} {  
   global test
 
   set test(func) all
   set ptm $test(dir)/$test(tfile).PTM
 
   if [catch {open $ptm r} fid] {;     # open file .PTM for reading
      message "Cannot open file $ptm !"
      return
   } else {
      foreach i {1 2 3 4} {;  # HEADER LINES
         gets $fid line
      }
      gets $fid test(src) 
      gets $fid test(exec) 
      gets $fid test(comp) 
      gets $fid test(type)
      gets $fid test(anom)
      gets $fid tmpfunc 

      Disjoin_Func_Set_Maxfunction $tmpfunc

      close $fid
   }
}
 

#------------------------------------------------------------------------------#
#   DISJOIN_FUNC_SET_MAXFUNCTION {}
#   Disjoins functions name and sets the max number of functions.
#   date: 09/20/96
#   last update: 09/20/96
#------------------------------------------------------------------------------#

proc Disjoin_Func_Set_Maxfunction {listfunction} {
   global functions
   global MAXFUNCTIONS

   if {[string compare $listfunction "\n"] != 0} {
      set i 0   

      # Umount list of functions (ex: function1,function2,function3)

      set nextpos [string first "," $listfunction]
      while {$nextpos != -1} {
         set functions($i) [string range $listfunction 0 [expr $nextpos-1]]
         set listfunction [string range  $listfunction [expr $nextpos+1] \
                     [expr [string length $listfunction]-1]]
         set nextpos [string first "," $listfunction]
         incr i
      }
      set functions($i) $listfunction 
      set MAXFUNCTIONS [expr $i+1]
   } else {
      set MAXFUNCTIONS 0
   }
   return
}


#------------------------------------------------------------------------------#
#   JOIN_FUNCTION 
#   Joins functions name and "separa por virgula"
#   date: 09/20/96
#   last update: 09/20/96
#------------------------------------------------------------------------------#

proc Join_Function {} {
   global MAXFUNCTIONS
   global index_func
   global functions

   set listfunc ""

   for {set i 0} {$i < $MAXFUNCTIONS} {incr i} {
      if {$index_func($i) == 1} {                    ;# If function was selected
         set listfunc $listfunc$functions($i),
      }
   } 
    
   # Take off the last ","
   set listfunc [string range $listfunc 0 [expr [string length $listfunc]-2]]

   return $listfunc
}


#------------------------------------------------------------------------------#
#   DISJOIN_INFOMUTA {}
#   Disjoins informations about mutant information.
#   date: 04/19/96
#   last update: 04/18/96, 06/04/97
#------------------------------------------------------------------------------#

proc Disjoin_Infomuta {infomuta} {
   global muta;             # Mutant's data

 
   if {[scan $infomuta "\nMUTANT # %d                      \n 
                       Status %s %s                        \n
                       Descriptor size.: %d                \n
                       Function start at: %d               \n
                       Program graph node: %d              \n
                       Last test case used: %d             \n
                       Operator: %d %s                     \n
                       Descriptor:                         \n
                       Offset: %d, get out %d characters"  \
                       mutant                              \
                       muta(status0)                       \
                       muta(status1)                       \
                       muta(dsize)                         \
                       muta(begin)                         \
                       muta(node)                          \
                       muta(tcase)                         \
                       muta(num_op)                        \
                       muta(name_op)                       \
                       muta(d_init0)                       \
                       muta(d_init1)] != 11} {

      if {[scan $infomuta "\nMUTANT # %d                      \n 
                          Status %s %s                        \n
                          Causa Mortis: %s - Test Case %d     \n
                          Descriptor size.: %d                \n
                          Function start at: %d               \n
                          Program graph node: %d              \n
                          Last test case used: %d             \n
                          Operator: %d %s                     \n
                          Descriptor:                         \n
                          Offset: %d, get out %d characters"  \
                          mutant                              \
                          muta(status0)                       \
                          muta(status1)                       \
                          muta(mortis)                        \
                          muta(tcmortis)                      \
                          muta(dsize)                         \
                          muta(begin)                         \
                          muta(node)                          \
                          muta(tcase)                         \
                          muta(num_op)                        \
                          muta(name_op)                       \
                          muta(d_init0)                       \
                          muta(d_init1)] != 13} {

         message "Problem with Mutant Information !"
         return
      }  
   }
 
   set len [string length $muta(status0)]
   set muta(status0) [string range $muta(status0) 0 [expr $len-2]] 
   return 

}


#------------------------------------------------------------------------------#
#   DISJOIN_INFOGENERAL {}
#   Disjoins general informations.
#   date: 06/05/97
#   last update: 06/05/97, 06/07/97
#------------------------------------------------------------------------------#

proc Disjoin_Infogeneral {infogeneral type} {
   global out;                                # General informations
   global maxtcase;                           # Max number of test cases
   global stat oper var cons;                 # Percentage of generated mutants 
   global stat_out oper_out var_out cons_out; # Number of generated mutants 
   global stat_used oper_used var_used cons_used; # Flag used ou not used   
   global USED NOT_USED

   switch -exact $type {
      PART {
         if {[scan $infogeneral "\n%d                      
                                 \n%d
                                 \n%d
                                 \n%d
                                 \n%s
                                 \n%d
                                 \n%d"                   \
                                 maxtcase                \
                                 out(totmut)             \
                                 out(actmut)             \
                                 out(equmut)             \
                                 out(score)              \
                                 out(livmut)             \
                                 out(anomut)] != 7} {
            message "Problem Restauring Information !"
            return
         }
      }
      ALL {

         if {[scan $infogeneral "\n%d                      
                                 \n%d
                                 \n%d
                                 \n%d
                                 \n%s
                                 \n%d
                                 \n%d"                   \
                                 maxtcase                \
                                 out(totmut)             \
                                 out(actmut)             \
                                 out(equmut)             \
                                 out(score)              \
                                 out(livmut)             \
                                 out(anomut)] != 7} {
            message "Problem Restauring Information !"
            return
         } else {


            set tmpstring [string range $infogeneral 1 \
                          [expr [string length $infogeneral]-1]]
            set nextpos [string first "\n" $tmpstring]
 

            # Takes out general information
            for {set i 1} {$i <= 7} {incr i} {
               set tmpnumber [string range $tmpstring 0 [expr $nextpos-1]]
               set tmpstring [string range $tmpstring [expr $nextpos+1] \
                        [expr [string length $tmpstring]-1]]
               set nextpos [string first "\n" $tmpstring]
            }


            # Takes out constant mutation operator information
            for {set i 1} {$i <= 3} {incr i} {
               if {[scan $tmpstring "%d %d" cons_out($i) cons($i)] != 2} {
                  message "Problem Restauring Information !"
                  return
               }
               set tmpstring [string range $tmpstring [expr $nextpos+1] \
                        [expr [string length $tmpstring]-1]]
               set nextpos [string first "\n" $tmpstring]
               if {$cons($i) != 0} {
                  set cons_used($i) $USED
               } else {
                  set cons_used($i) $NOT_USED
               }
#puts __$cons_out($i)__$cons($i)__
            }


            # Takes out operator mutation operator information
            for {set i 1} {$i <= 46} {incr i} {
               if {[scan $tmpstring "%d %d" oper_out($i) oper($i)] != 2} {
                  message "Problem Restauring Information !"
                  return
               }
               set tmpstring [string range $tmpstring [expr $nextpos+1] \
                        [expr [string length $tmpstring]-1]]
               set nextpos [string first "\n" $tmpstring]
               if {$oper($i) != 0} {
                  set oper_used($i) $USED
               } else {
                  set oper_used($i) $NOT_USED
               }
#puts __$oper_out($i)__$oper($i)__
            }


            # Takes out statement mutation operator information
            for {set i 1} {$i <= 15} {incr i} {
               if {[scan $tmpstring "%d %d" stat_out($i) stat($i)] != 2} {
                  message "Problem Restauring Information !"
                  return
               }
               set tmpstring [string range $tmpstring [expr $nextpos+1] \
                        [expr [string length $tmpstring]-1]]
               set nextpos [string first "\n" $tmpstring]
               if {$stat($i) != 0} {
                  set stat_used($i) $USED
               } else {
                  set stat_used($i) $NOT_USED
               }
#puts __$stat_out($i)__$stat($i)__
            }


            # Takes out variable mutation operator information
            for {set i 1} {$i <= 7} {incr i} {
               if {[scan $tmpstring "%d %d" var_out($i) var($i)] != 2} {
                  message "Problem Restauring Information !"
                  return
               }
               set tmpstring [string range $tmpstring [expr $nextpos+1] \
                        [expr [string length $tmpstring]-1]]
               set nextpos [string first "\n" $tmpstring]
               if {$var($i) != 0} {
                  set var_used($i) $USED
               } else {
                  set var_used($i) $NOT_USED
               }
#puts __$var_out($i)__$var($i)__
            }

         }                              
      }
   }
       
#puts "maxtcase $maxtcase"
#puts "total $out(totmut)"
#puts "liv $out(actmut)"
#puts "equ $out(equmut)"
#puts "score $out(score)"
#puts "liv $out(livmut)"
#puts "ano $out(anomut)\n"             

}

#------------------------------------------------------------------------------#
#   INIT_VARIABLES {}
#   Initializes variables for next test session.
#   date: 05/29/96
#   last update: 06/28/96, 06/05/97
#------------------------------------------------------------------------------#

proc Init_Variables {} {
   global stat stat stat_out
   global oper open oper_out
   global var  var  var_out
   global cons cons cons_out
   global type0 type1 type2 type3 type4; # Type of mutant for show 
   global out

   global NSTAT NOPER NVAR NCONS
 
#   for {set i 1} {$i <= $NSTAT} {incr i 1} {
#      if {[info exists stat($i)]} {
#         unset stat_in($i)
#      }
#      if {[info exists stat_out($i)]} {
#         unset stat_out($i)
#      }
#   }
#   for {set i 1} {$i <= $NOPER} {incr i 1} {
#      if {[info exists oper($i)]} {
#         unset oper_in($i)
#      }
#      if {[info exists oper_out($i)]} {
#         unset oper_out($i)
#      }
#   }
#   for {set i 1} {$i <= $NVAR} {incr i 1} {
#      if {[info exists var($i)]} {
#         unset var_in($i)
#      }
#      if {[info exists var_out($i)]} {
#         unset var_out($i)
#      }
#   }
#   for {set i 1} {$i <= $NCONS} {incr i 1} {
#      if {[info exists cons($i)]} {
#         unset cons_in($i)
#      }
#      if {[info exists cons_out($i)]} {
#         unset cons_out($i)
#      }
#   }

   set type0 1
   set type1 1
   set type2 1
   set type3 1
   set type4 0


   set infogeneral [Report GENERAL 0]

   # If error building report, return 
   if {[string length $infogeneral] == 0} {
      return
   } else {
       Disjoin_Infogeneral $infogeneral ALL
   } 
}


