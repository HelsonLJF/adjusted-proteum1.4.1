# OBS: otimizar esse arquivo...
#------------------------------------------------------------------------------#
#   IMUTA.TCL
#   Procedures related with MUTANTS options.
#   author: Elisa Yumi Nakagawa
#   date: 02/27/96
#   last update: 05/28/96, 09/25/96
#------------------------------------------------------------------------------#

source $PROTEUMINTERFHOME/geral.tcl
source $PROTEUMINTERFHOME/iglobal.tcl
source $PROTEUMINTERFHOME/inter.tcl


#------------------------------------------------------------------------------#
#   MUTANTS_GENERATE_WINDOW {}
#
#   date: 02/27/96
#   last update: 04/03/96
#------------------------------------------------------------------------------#


proc Mutants_Generate_Window {w} {
   toplevel $w
   wm title $w "Mutants Generation"
   wm iconname $w "Generation"
   wm geometry $w 300x150
   wm geometry $w +10+65
   wm minsize  $w 300 150
   wm maxsize  $w 300 150
 
   global stat_tot

   set stat_tot 0

   frame $w.f1 
   pack  $w.f1 -fill x -pady 10

   frame  $w.f1.f1 
   frame  $w.f1.f2
   pack   $w.f1.f1 $w.f1.f2 -side left

   label $w.f1.f1.l -text "Classes:" 
   pack  $w.f1.f1.l 


   menubutton $w.f1.f2.r -menu $w.f1.f2.r.m -relief raised -cursor hand2
   pack $w.f1.f2.r -side left  
      menu $w.f1.f2.r.m -tearoff 0

      # if option "Statement Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Statement Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.stat]} {
            $v.f1.f2.l configure -text "Statement Mutations"
            Stat_Gen_Operator $v.stat
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.oper]} {
            destroy $v.oper
         } elseif {[winfo exists $v.var]} {
            destroy $v.var
         } elseif {[winfo exists $v.cons]} {
            destroy $v.cons
         }
       }


      # if option "Operator Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Operator Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.oper]} {
            $v.f1.f2.l configure -text "Operator Mutations"
            Oper_Gen_Operator $v.oper
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.stat]} {
            destroy $v.stat
         } elseif {[winfo exists $v.var]} {
            destroy $v.var
         } elseif {[winfo exists $v.cons]} {
            destroy $v.cons
         }
      } 


      # if option "Variable Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Variable Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.var]} {
            $v.f1.f2.l configure -text "Variable Mutations"
            Var_Gen_Operator $v.var
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.stat]} {
            destroy $v.stat
         } elseif {[winfo exists $v.oper]} {
            destroy $v.oper
         } elseif {[winfo exists $v.cons]} {
            destroy $v.cons
         }
      }


      # if option "Constant Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Constant Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.cons]} {
            $v.f1.f2.l configure -text "Constant Mutations"
            Cons_Gen_Operator $v.cons     
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.stat]} {
            destroy $v.stat
         } elseif {[winfo exists $v.oper]} {
            destroy $v.oper
         } elseif {[winfo exists $v.var]} {
            destroy $v.var
         }
      }
    
   label  $w.f1.f2.l -text "Statement Mutations" 
   pack   $w.f1.f2.l -side left
   Stat_Gen_Operator $w.stat

   frame  $w.f2    
   pack   $w.f2 -pady 5
   button $w.f2.confirm -text Generate -command {

     # Destroy mutation operator window
      set v .proteum.muta.m.dlg  
      if {[winfo exists $v.stat]} {
         destroy $v.stat
      } elseif {[winfo exists $v.oper]} {
         destroy $v.oper
      } elseif {[winfo exists $v.var]} {
         destroy $v.var
      } elseif {[winfo exists $v.cons]} {
         destroy $v.cons
      }   
      set confirm 1;          # Variable for user not interact with other window
      Generate_Mutants
   }

   button $w.f2.cancel  -text Cancel -command "
      destroy $w
      set confirm 0";         # Variable for user not interact with other window
   pack   $w.f2.confirm $w.f2.cancel -side left

   wm protocol $w WM_DELETE_WINDOW {
      set confirm 0
      destroy .proteum.muta.m.dlg
   }
 
   bind $w <Any-Motion> {focus %W}

   grab $w 
   tkwait variable confirm
   grab release $w
}


#------------------------------------------------------------------------------#
#  GENERATE_MUTANTS {}
#  Generate mutants using mutantion operators percentage.
#  date: 04/08/96
#  last update: 04/11/96, 06/07/97
#------------------------------------------------------------------------------#


proc Generate_Mutants {} {
   global stat oper var cons;                     # Percentage to generate
   global stat_data oper_data var_data cons_data; # Operator's name
   global stat_out  oper_out  var_out  cons_out;  # Number of generated mutants
   global stat_used oper_used var_used cons_used; # Flag used ou not used
   global USED NOT_USED   
   
   destroy .proteum.muta.m.dlg;     # Destroy last window
   set g_tot 0;                     # Total of generated mutants
 
   Set_Busy ON

   set i 1
      foreach op $stat_data {

          if {$stat($i)!=0 && $stat_used($i)==$NOT_USED} {

            # Takes operator's name
            set operator [string range $op 0 3]
            set stat_out($i) [Muta ADD $operator $stat($i)]
            puts "op: [string range $op 0 3] \t \
                  %: $stat($i) \t \
                  gen: $stat_out($i)"
            set g_tot [expr $g_tot + $stat_out($i)]; # Tot of generated mutants
            set stat_used($i) $USED
         }
         incr i
      }  

   set i 1
      foreach op $oper_data {

          if {$oper($i)!=0 && $oper_used($i)==$NOT_USED} {

            # Takes operator's name
            set operator [string range $op 0 3]
            set oper_out($i) [Muta ADD $operator $oper($i)]
            puts "op: [string range $op 0 3] \t \
                  %: $oper($i) \t \
                  gen: $oper_out($i)"
            set g_tot [expr $g_tot + $oper_out($i)]; # Tot of generated mutants
            set oper_used($i) $USED
          }
          incr i
      }

   set i 1
      foreach op $var_data {

          if {$var($i)!=0 && $var_used($i)==$NOT_USED} {
 
            # Takes operator's name
            set operator [string range $op 0 3]
            set var_out($i) [Muta ADD $operator $var($i)]
            puts "op: [string range $op 0 3] \t \
                  %: $var($i) \t \
                  gen: $var_out($i)"
            set g_tot [expr $g_tot + $var_out($i)]; # Tot of generated mutants
            set var_used($i) $USED
         }
         incr i
      }

   set i 1
      foreach op $cons_data {

          if {$cons($i)!=0 && $cons_used($i)==$NOT_USED} {
 
            # Takes operator's name
            set operator [string range $op 0 3]
            set cons_out($i) [Muta ADD $operator $cons($i)]
            puts "op: [string range $op 0 3] \t \
                  %: $cons($i) \t \
                  gen: $cons_out($i)"
            set g_tot [expr $g_tot + $cons_out($i)]; # Tot of generated mutants
            set cons_used($i) $USED
         }
         incr i
      }

#   destroy .proteum.muta.m.dlg;     # Destroy last window
   Set_Busy OFF

   message "$g_tot Generated Mutants"

   set infogeneral [Report GENERAL 0]

   # If error building report, return 
   if {[string length $infogeneral] == 0} {
      return
   } else {
       Disjoin_Infogeneral $infogeneral PART
   }    
}



#------------------------------------------------------------------------------#
#   STAT_GEN_OPERATOR {}
#   Shows Statement Mutations operators list to select percentage.
#   date: 02/29/96
#   last update: 04/17/96
#------------------------------------------------------------------------------#


proc Stat_Gen_Operator {w} {
   toplevel $w
   wm title $w "Statement Mutants"
   wm iconname $w "Stat_Mut"
   wm geometry $w 500x350
   wm geometry $w +10+198
   wm maxsize  $w 500 350
   wm minsize  $w 500 350 
 
   global stat_data;      # Names of the mutation operators
   global default;        # Percentage default
   global stat;           # Percentage of mutations operator
   global stat_out;       # Number of generated mutants
   set tot     0;         # Total of generated mutants
   set default 0
 
   frame $w.f1 
   pack  $w.f1 -fill x

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default STAT GENERATE"
   entry  $w.f1.perc -width 5 -justify right -textvariable default 
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10

   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.stat.f1

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.stat.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled"
      } else {
         $v.dw config -state disabled
      } 
   }
   pack $w.f1.up $w.f1.dw -side left
   
   if {$default == 0} {
      .proteum.muta.m.dlg.stat.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.stat.f1.up config -state disabled
   }  

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 

   set i 1
   foreach item $stat_data {
      frame $w.t.$i
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow
      entry $w.t.$i.in -width 4 -justify right -textvariable stat($i)

      pack  $w.t.$i.out $w.t.$i.in -side left

      # Verify if operator has generated its mutants
      if {$stat($i) != 0} {
         $w.t.$i.out config -text $stat_out($i) -anchor e

         $w.t.$i.in config -state disabled
         set tot [expr $tot+$stat_out($i)]
      } else {
#         set stat($i) 0
      }
      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -text {TOTAL: }  -width 48 -anchor e
   label $w.t.f1.out -text $tot -width 4 -relief sunken -anchor e 
   pack  $w.t.f1.l $w.t.f1.out -side left

   bind $w <Any-Motion> {focus %W}
}


 

#------------------------------------------------------------------------------#
#   OPER_GEN_OPERATOR {}
#   Shows Operator Mutations operators list to select percentage.
#   date: 02/29/96
#   last update: 04/17/96
#------------------------------------------------------------------------------#

proc Oper_Gen_Operator {w} {
   toplevel $w
   wm title $w "Operator Mutants"
   wm iconname $w "Oper_Mut"
   wm geometry $w 500x350
   wm geometry $w +10+198
   wm maxsize  $w 500 350
   wm minsize  $w 500 350

   global oper_data;      # Names of the mutation operators 
   global default;        # Percentage default
   global oper;           # Percentage of mutations operator
   global oper_out;       # NUmber of generated mutants
   set tot     0;         # Total of generated mutants
   set default 0

   frame $w.f1
   pack  $w.f1 -fill x

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default OPER GENERATE"
   entry  $w.f1.perc -width 5 -justify right  -textvariable default
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10
 
   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.oper.f1

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.oper.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled"
      } else {
         $v.dw config -state disabled
      } 
   }
   pack   $w.f1.up $w.f1.dw -side left

   if {$default == 0} {
      .proteum.muta.m.dlg.oper.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.oper.f1.up config -state disabled
   }

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 

   set i 1
   foreach item $oper_data {
      frame $w.t.$i 
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow
      entry $w.t.$i.in  -width 4 -justify right -textvariable oper($i)
      pack  $w.t.$i.out $w.t.$i.in -side left

      if {$oper($i) != 0} {
         $w.t.$i.out config -text $oper_out($i) -anchor e
         $w.t.$i.in config -state disabled
         set tot [expr $tot+$oper_out($i)]
      } else {
#         set oper($i) 0
      }
      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -width 48 -text {TOTAL:  } -anchor e
   label $w.t.f1.out -width 4 -text $tot -relief sunken -anchor e  
   pack  $w.t.f1.l $w.t.f1.out -side left

   bind $w <Any-Motion> {focus %W}
}


#------------------------------------------------------------------------------#
#   VAR_GEN_OPERATOR {}
#   Shows Operator Mutations operators list to select percentage.
#   date: 02/29/96
#   last update: 04/17/96
#------------------------------------------------------------------------------#

proc Var_Gen_Operator {w} {
   toplevel $w
   wm title $w "Variable Mutants"
   wm iconname $w "Var_Mut"
   wm geometry $w 500x300
   wm geometry $w +10+198
   wm maxsize  $w 500 300
   wm minsize  $w 500 300 
 
   global var_data;       # Names of the mutation operators
   global default;        # Percentage default
   global var;            # Percentage of mutations operator
   global var_out;        # Number of generated mutants
   set tot     0;         # Total of generated mutants
   set default 0
 
   frame $w.f1 
   pack  $w.f1 -fill x 

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default VAR GENERATE"
   entry  $w.f1.perc -width 5 -justify right  -textvariable default
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10
   
   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.var.f1

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.var.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled"
      } else {
         $v.dw config -state disabled
      } 
   }
   pack   $w.f1.up $w.f1.dw -side left

   
   if {$default == 0} {
      .proteum.muta.m.dlg.var.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.var.f1.up config -state disabled
   }

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 
  
   set i 1
   foreach item $var_data {
 
      frame $w.t.$i
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow
      entry $w.t.$i.in  -width 4 -justify right -textvariable var($i)
      pack  $w.t.$i.out $w.t.$i.in -side left

      if {$var($i) != 0} {
         $w.t.$i.out config -text $var_out($i) -anchor e
         $w.t.$i.in config -state disabled
         set tot [expr $tot+$var_out($i)]
      } else {
         set var($i) 0
      }
      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -width 48 -text {TOTAL:  } -anchor e
   label $w.t.f1.out -width 4 -text $tot -relief sunken -anchor e  
   pack  $w.t.f1.l $w.t.f1.out -side left

   bind $w <Any-Motion> {focus %W}
}



#------------------------------------------------------------------------------#
#   CONS_GEN_OPERATOR {}
#   Shows Operator Mutations operators list to select percentage.
#   date: 02/29/96
#   last update: 04/17/96
#------------------------------------------------------------------------------#

proc Cons_Gen_Operator {w} {
   toplevel $w
   wm title $w "Constant Mutants"
   wm iconname $w "Const_Mut"
   wm geometry $w 500x230
   wm geometry $w +10+198
   wm maxsize  $w 500 230
   wm minsize  $w 500 230 
 
   global cons_data;      # Names of the mutation operators
   global default;        # Percentage default
   global cons;           # Percentage of mutations operator
   global cons_out;       # Number of generated mutants
   set tot     0;         # Total of generated mutants
   set default 0

   frame $w.f1 
   pack  $w.f1 -fill x

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default CONS GENERATE"
   entry  $w.f1.perc -width 5 -justify right -textvariable default
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10
 
   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.cons.f1 

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.cons.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled" 
      } else {
         $v.dw config -state disabled
      } 
   }
   pack   $w.f1.up $w.f1.dw -side left

   
   if {$default == 0} {
      .proteum.muta.m.dlg.cons.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.cons.f1.up config -state disabled
   }

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 

   set i 1
   foreach item $cons_data {
 
      frame $w.t.$i
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow
      entry $w.t.$i.in  -width 4 -justify right -textvariable cons($i)
      pack  $w.t.$i.out $w.t.$i.in -side left

      if {$cons($i) != 0} {
         $w.t.$i.out config -text $cons_out($i) -anchor e
         $w.t.$i.in config -state disabled
         set tot [expr $tot+$cons_out($i)]
      } else {
#         set cons($i) 0
      }
      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -width 48 -text {TOTAL:  } -anchor e
   label $w.t.f1.out -width 4 -text $tot -relief sunken -anchor e
   pack  $w.t.f1.l $w.t.f1.out -side left 

   bind $w <Any-Motion> {focus %W} 
}



#-----------------------------------------------------------------------------#
#   APPLY_DEFAULT {}
#   Apply default value for operators to generate or select mutants.
#   date: 04/06/96
#   last update:  05/28/96, 06/07/97
#------------------------------------------------------------------------------#

proc Apply_Default {class operation} {
   global default;                                # % default

   global stat oper var cons;                     # % of mutation operator
   global stat_out oper_out var_out cons_out;     # Number of generated mutants
   global stat_used oper_used var_used cons_used; # Flag used or not used

   global stat_sin oper_sin var_sin cons_sin;     # % of mutation operator
   global stat_sout oper_sout var_sout cons_sout; # Number of selected mutants

   global NSTAT NOPER NVAR NCONS;                 # Number operators for class
   global NOT_USED

   set i 1

   switch -exact $class {
      STAT { while {$i <= $NSTAT} {;         # Class Statement Mutations

                # if operation is generation of mutants
                if {[string compare $operation GENERATE] == 0} {

                   if {$stat_used($i) == $NOT_USED} {; # if operator wasn't used
                      set stat($i) $default
                   }
                } else {; # If operation is selection of mutants
                   if {![info exists stat_sout($i)]} {;# if operator wasn't used
                      set stat_sin($i) $default
                   }
                }
                incr i
           }
      }
      OPER { while {$i <= $NOPER} {;         # Class Operator Mutations

                # if operation id generation od mutants
                if {[string compare $operation GENERATE] == 0} {

                   if {$oper_used($i) == $NOT_USED} {; # if operator wasn't used
                      set oper($i) $default
                   }
                } else {; # If operation is selection of mutants
                   if {![info exists oper_sout($i)]} {;# if operator wasn't used
                      set oper_sin($i) $default
                   }
                }
                incr i
           }   
      }
      VAR  { while {$i <= $NVAR} {;          # Class Variable Mutations

                # if operation id generation od mutants
                if {[string compare $operation GENERATE] == 0} {                 
                   if {$var_used($i) == $NOT_USED} {;  # if operator wasn't used
                      set var($i) $default
                   }
                } else {; # If operation is selection of mutants
                   if {![info exists var_sout($i)]} {; # if operator wasn't used
                      set var_sin($i) $default
                   }
                }
                incr i
           }
      }   
      CONS { while {$i <= $NCONS} {;         # Class Constant Mutations

                # if operation id generation od mutants
                if {[string compare $operation GENERATE] == 0} {                 
                   if {$cons_used($i) == $NOT_USED} {; # if operator wasn't used
                      set cons($i) $default
                   }
                } else {; # If operation is selection of mutants
                   if {![info exists cons_sout($i)]} {;# if operator wasn't used
                      set cons_sin($i) $default
                   }
                }
                incr i
           }
      } 
   }
   return
}



#------------------------------------------------------------------------------#
#   MUTANTS_VIEW_WINDOW {}
#   View mutants.
#   date: 03/01/96
#   last update: 07/01/96
#------------------------------------------------------------------------------#


proc Mutants_View_Window {w args} {
   toplevel $w
   wm title $w "View Mutants"
   wm iconname $w "View_Mut"
   wm geometry $w +10+65


# OBS: TIRAR AS DUAS LINHAS ABAIXO DEPOIS ###% Tirado
#   global test;
#   exec cp $test(dir)/__$test(src)  $test(dir)/__$test(src).c

   global out;
   global mutant;                        # Number of current mutant
   global muta;                          # Mutant's information
   global type0 type1 type2 type3 type4; # Type of the mutants
   set mutant 0;         # Initializes number of current mutant 

   frame $w.f1
   frame $w.f1.f1 
   label $w.f1.f1.l1 -text "  Mutant:"
   entry $w.f1.f1.in -width 7 -textvariable mutant
   pack  $w.f1.f1.l1 $w.f1.f1.in -side left

   label $w.f1.f1.l -text "Type to Show:"
   checkbutton $w.f1.f1.c1 -selectcolor green -cursor hand2 -text Alive      \
                           -variable type0
   checkbutton $w.f1.f1.c2 -selectcolor green -cursor hand2 -text Dead       \
                           -variable type1
   checkbutton $w.f1.f1.c3 -selectcolor green -cursor hand2 -text Anomalous  \
                           -variable type2
   checkbutton $w.f1.f1.c4 -selectcolor green -cursor hand2 -text Equivalent \
                           -variable type3
   checkbutton $w.f1.f1.c5 -selectcolor green -cursor hand2 -text Inactive   \
                           -variable type4
   pack $w.f1.f1.c5 $w.f1.f1.c4 $w.f1.f1.c3 \
        $w.f1.f1.c2 $w.f1.f1.c1 $w.f1.f1.l -side right

   # Button for UP and DOWN of number of the mutant
   button $w.f1.f1.up -text up -command {
      set v .proteum.muta.m.dlg.f1.f1

      $v.dw config -state normal
      if {$mutant >= [expr $out(totmut)-1]} "set mutant [expr $out(totmut)-2]"
      incr mutant
      if {$mutant == $out(totmut)} "$v.up config -state disabled"
      Set_Busy ON
      Mount_Show_Mutant 1
      Set_Busy OFF
   }

   button $w.f1.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.f1.f1

      $v.up config -state normal
      if {$mutant <= 0} "set mutant 1"
      incr mutant -1
      if {$mutant == 0} "$v.dw config -state disabled"
      Set_Busy ON
      Mount_Show_Mutant -1
      Set_Busy OFF
   }
   pack $w.f1.f1.up $w.f1.f1.dw -side left

   frame $w.f1.f2
   label $w.f1.f2.l1 -text "   Status:"
   label $w.f1.f2.l2 -width 45 -relief sunken -anchor w
   checkbutton $w.f1.f2.c -selectcolor green -text Equivalent -variable equiv \
                          -onvalue 1 -offvalue 0 -cursor hand2
   pack $w.f1.f2.l1 $w.f1.f2.l2 $w.f1.f2.c -side left

   frame $w.f1.f3
   pack  $w.f1.f1 $w.f1.f2 $w.f1.f3 -expand true -fill x -padx 10
   label $w.f1.f3.l1 -text "Operator:"
   label $w.f1.f3.l2 -width 57 -relief sunken -anchor w
   pack  $w.f1.f3.l1 $w.f1.f3.l2 -side left

   frame $w.f2
   pack  $w.f1 $w.f2    -side top -expand true -fill x -pady 10

   frame  $w.f2.f1
   frame  $w.f2.f1.f1
   label  $w.f2.f1.f1.l -text "Original Program"
#   button $w.f2.f1.f1.b -text Execute -command "Exemuta ORIGINAL"
   pack   $w.f2.f1.f1.l 
#   pack   $w.f2.f1.f1.l $w.f2.f1.f1.b 

   frame $w.f2.f1.f2 
   pack $w.f2.f1.f1 $w.f2.f1.f2 -side top
   text      $w.f2.f1.f2.t -yscrollcommand "$w.f2.f1.f2.yscroll set" \
                           -width 80 -height 37 -bg white \
			   -cursor top_left_arrow -font fixed
   scrollbar $w.f2.f1.f2.yscroll -command "$w.f2.f1.f2.t yview"
   pack      $w.f2.f1.f2.yscroll -side right -fill y
   pack      $w.f2.f1.f2.t -expand true -fill both

   frame $w.f2.f2
   pack  $w.f2.f1 $w.f2.f2 -side left -padx 5

   frame  $w.f2.f2.f1
   label  $w.f2.f2.f1.l -text "Mutant Program"
#   button $w.f2.f2.f1.b -text Execute -command "Exemuta EXECONE $mutant"
   pack   $w.f2.f2.f1.l 
#   pack   $w.f2.f2.f1.l $w.f2.f2.f1.b 

   frame  $w.f2.f2.f2
   pack   $w.f2.f2.f1 $w.f2.f2.f2 -side top
   text      $w.f2.f2.f2.t -yscrollcommand "$w.f2.f2.f2.yscroll set" \
                           -width 80 -height 37 -bg white \
			   -cursor top_left_arrow -font fixed
   scrollbar $w.f2.f2.f2.yscroll -command "$w.f2.f2.f2.t yview"
   pack      $w.f2.f2.f2.yscroll -side right -fill y
   pack      $w.f2.f2.f2.t -expand true -fill both

   # Mutant number 0 is showed
   if {$mutant == 0} {
      $w.f1.f1.dw config -state disabled 
      Set_Busy ON
      Mount_Show_Mutant 0 
      Set_Busy OFF
   }

   # Equivalent checkbutton is selected
   bind $w.f1.f2.c <ButtonPress> {
      if {$equiv == 0} {
         Muta EQUIV $mutant
      } else {
         Muta NEQUIV $mutant
      }
   }
 
   # When <return> is pressed in field "number of mutant"
   bind $w.f1.f1.in <Return> {
       set v .proteum.muta.m.dlg.f1.f1

       if {$mutant < 0} {
	  set mutant 0
       } elseif {$mutant >= $out(totmut)} {
	  set mutant [expr $out(totmut)-1]
       }

       if {$mutant == 0} {
          $v.up config -state normal
          $v.dw config -state disabled
          Set_Busy ON
          Mount_Show_Mutant 0
          Set_Busy OFF

       }  elseif {$mutant == [expr $out(totmut)-1]} {
          $v.up config -state disabled
          $v.dw config -state normal
          Set_Busy ON
          Mount_Show_Mutant 0
          Set_Busy OFF

       } else {
          $v.up config -state normal
          $v.dw config -state normal
          Set_Busy ON
          Mount_Show_Mutant 0
          Set_Busy OFF

       }
   }
 
   bind $w <Any-Motion> {focus %W}

   wm protocol $w WM_DELETE_WINDOW {
      set ok 1
      destroy .proteum.muta.m.dlg
   }       

   grab $w 
   tkwait variable ok
   grab release $w
}



#------------------------------------------------------------------------------#
#   MOUNT_SHOW_MUTANT {}
#   Mounts mutants and its information, and shows them.
#   date: 04/18/96
#   last update: 06/28/96
#------------------------------------------------------------------------------#

proc Mount_Show_Mutant {increment} {
   global test
   global mutant;                                 # Number of current mutant
   global muta;                                   # Information of mutant
   global out;                                    # Max number of mutant
   global cons_data oper_data stat_data var_data; # Operators' names
   global NCONS NOPER NSTAT NVAR;                 # Number of operator per class
   global type0 type1 type2 type3 type4;          # Type of the Mutant

   set flg_show 0
   set nline    0

   # OBS: VERIFICAR SE "mutant" CONTEM UM VALOR VALIDO E TIRAR ESPACOS EM BRANCO


   if {$mutant < 0} {
      set mutant [expr $mutant + 1]
      .proteum.muta.m.dlg.f1.f1.dw config -state disabled
      return
   }

   if {$mutant >= $out(totmut)} {
      set mutant [expr $mutant - 1]
      .proteum.muta.m.dlg.f1.f1.up config -state disabled
      return
   } 

   if {$increment >= 0} {
	set aux "-up"
   } else { 
	set aux "-down"
   }

   if {$type0} {
	set aux " $aux -alive"
   }

   if {$type1} {
	set aux " $aux -dead"
   }

   if {$type2} {
	set aux " $aux -anomalous"
   }

   if {$type3} {
	set aux " $aux -equiv"
   }

   if {$type4} {
	set aux " $aux -inactive"
   }

   set aux "$aux -f $mutant "
   set aux1 [Muta SEARCH $aux]
   set aux2 ""

   if {$increment == 0} {
   set aux [string range $aux [expr [string first "-up" $aux]+3] end]
   set aux " -down $aux"
   set aux2 [Muta SEARCH $aux]
   }

   if {[string length $aux1] != 0 && [string length $aux2] != 0} {
	if {[expr $aux1-$mutant] > [expr $mutant-$aux2]} {
	   set aux1 $aux2
	}
   } elseif {[string length $aux2] != 0} {
	set aux1 $aux2
   }

   if {[string length $aux1] != 0} {
      set mutant $aux1
   } else {
      set mutant [expr $mutant-$increment]
   }


   set infomuta [Muta LIST $mutant]
   set v .proteum.muta.m.dlg
   Disjoin_Infomuta $infomuta;             # Divides mutation information


       # If mutants is equivalent, selects checkbutton
       if {![string compare $muta(status0) "Equivalent"]} {
          $v.f1.f2.l2 config -text "Alive; $muta(status1)"
          $v.f1.f2.c select
       } else {
          $v.f1.f2.l2 config -text "$muta(status0); $muta(status1)"
          $v.f1.f2.c deselect 
       }
      # If mutant is not alive, disable checkbutton
      if {[string compare $muta(status0) "Alive"] == 0 || \
	  [string compare $muta(status0) "Equivalent"] == 0} {
	   $v.f1.f2.c config -state normal
      } else {
	   $v.f1.f2.c config -state disabled
      }



       # Looks for name of mutation operator
       if {$muta(num_op) <= [expr $NCONS-1]} {
          $v.f1.f3.l2 config -text \
            [lindex $cons_data $muta(num_op)]
       } elseif {$muta(num_op) <= [expr $NCONS+$NOPER-1]} {
          $v.f1.f3.l2 config -text \
            [lindex $oper_data [expr $muta(num_op) - $NCONS]] 
       } elseif {$muta(num_op) <= [expr $NCONS+$NOPER+$NSTAT-1]} {
          $v.f1.f3.l2 config -text \
            [lindex $stat_data [expr $muta(num_op) - [expr $NCONS+$NOPER]]]
       } else {
          $v.f1.f3.l2 config -text \
            [lindex $var_data [expr $muta(num_op) - [expr $NCONS+$NOPER+$NSTAT]]]
       }       

       if {![Exemuta BUILD $mutant]} {;        # Mounts mutant 
          return;         # Error
       }
   
       # Loads source code of original program
       set nline [Load_Src $test(dir)/__$test(src).c $v.f2.f1.f2.t $muta(d_init0)]
	HiLight $v.f2.f1.f2.t 0

       # Loads source code of mutant program
       Load_Src $test(dir)/muta[Blank_Space_Out $mutant]\_$test(tfile).c $v.f2.f2.f2.t [expr $muta(d_init0)+50]
	HiLight $v.f2.f2.f2.t 0
	exec rm $test(dir)/muta[Blank_Space_Out $mutant]\_$test(tfile).c

}

 

#------------------------------------------------------------------------------#
#   MUTANTS_EQUIVALENTS {}
#
#   date: 96/03/04
#   last update: 96/03/04
#------------------------------------------------------------------------------#


proc Mutants_Equivalents {w} {
   toplevel $w
   wm title $w "Set/Reset Equivalent Mutants"
   wm iconname $w "Equivalent"
   wm geometry $w +10+65

   global equiv nequiv

   set equiv  ""
   set nequiv ""

   frame $w.f1
   pack  $w.f1 -expand true -pady 5
   label $w.f1.l -text "      Set Equivalent:"
   entry $w.f1.in -width 50 -textvariable equiv
   pack  $w.f1.l $w.f1.in -side left

   frame $w.f2
   pack  $w.f2 -expand true
   label $w.f2.l -text "Set Not Equivalent:"
   entry $w.f2.in -width 50 -textvariable nequiv
   pack  $w.f2.l $w.f2.in -side left
  
   frame  $w.f3
   pack   $w.f3 -expand true
   button $w.f3.confirm -text Confirm -command "
          set confirm 1
          Set_Equiv_Nequiv .proteum.muta.m.dlg"
   button $w.f3.cancel  -text Cancel -command "
          set confirm 0
          destroy $w"
   pack   $w.f3.confirm $w.f3.cancel -side left -pady 10

   bind $w <Any-Motion> {focus %W}
   bind $w.f1.in      <Tab>    [list focus $w.f2.in]
   bind $w.f2.in      <Tab>    [list focus $w.f3.confirm]
   bind $w.f3.confirm <Tab>    [list focus $w.f3.cancel]
   bind $w.f3.cancel  <Tab>    [list focus $w.f1.in]
   bind $w.f1.in      <Return> [list focus $w.f2.in]
   bind $w.f2.in      <Return> "$w.f3.confirm invoke"

   wm protocol $w WM_DELETE_WINDOW {
      set confirm 1
      destroy .proteum.muta.m.dlg
   }
   grab $w 
   tkwait variable confirm
   grab release $w
}



#------------------------------------------------------------------------------#
#   SET_EQUIV_NEQUIV {}
#   Sets mutants for equivalent or not equivalent.
#   date: 04/23/96
#   last update: 04/24/96
#------------------------------------------------------------------------------#

proc Set_Equiv_Nequiv {w} { 

   global equiv nequiv
  
   if {[string compare $equiv ""] != 0} {
      if {![Muta EQUIV $equiv]} {
         return 
      }
   }
   if {[string compare $nequiv ""] != 0} {
      if {![Muta NEQUIV $nequiv]} {
         return
      }
   }
   destroy $w
   return 
}



#------------------------------------------------------------------------------#
#   MUTANTS_EXECUTE_WINDOW {}
#   Execute mutants with test cases.
#   date: 03/04/96
#   last update: 20/05/96
#------------------------------------------------------------------------------#


proc Mutants_Execute_Window {w} {
   toplevel $w
   wm title $w "Execute"
   wm iconname $w "Ex_mut"
   wm geometry $w +200+230

   global test;                 # Information about test session
   global timeout;              # Timeout for mutant execution
   global nmuta;                # Number of current mutant in execution
   global out;                  # Max number of mutants
   global TMP_DIR_FILE
   global PROTEUMINTERFHOME
   global execcan;

# OBS: TIRAR AS DUAS LINHAS ABAIXO DEPOIS ###% Tirado
#   exec cp $test(dir)/__$test(src)  $test(dir)/__$test(src).c


   set nmuta  0
  
   set execcan 0
   frame $w.f1
   pack  $w.f1 -expand true -pady 5
   label $w.f1.l -text "Executing Mutants..."
   entry $w.f1.out -width 10 -textvariable nmuta -justify center 
   button $w.f1.cancel -text {Cancel} -command "set execcan 1"
   pack $w.f1.l $w.f1.out -side left -padx 10
   pack $w.f1.cancel -side top -pady 10
#   pack $w.f1.l -side left -padx 10

#   set pipe_execmuta [Exemuta EXEC $timeout];               # Executes mutants 
#   set pipe_nmuta [open "| $PROTEUMINTERFHOME/nmuta.tcl" w];# Returns number of

   update
                                                             # current mutant
#   Set_Busy ON
   Exemuta EXEC $timeout
#   Set_Busy OFF

   destroy $w


#   frame $w.f2
#   pack $w.f2 -expand true
#   button $w.f2.cancel -text Cancel -command "
#      exec rm $TMP_DIR_FILE;       # Removes temporary file
#      destroy $w
#      set cancel 1
#      exec kill -2 [pid $pipe_execmuta];      # kills process
#   "
#   pack $w.f2.cancel -pady 10
#   tkwait visibility $w.f2.cancel
#   bind $w <Any-Motion> {focus %W}
#   wm protocol $w WM_DELETE_WINDOW {
#      set cancel 1
#       destroy .proteum.muta.m.dlg
#   } 
#   grab $w 
#   tkwait variable cancel
#   grab release $w

}


#------------------------------------------------------------------------------#
#   MUTANTS_SELECT_OPER_MUTANTS {}
#   Selects mutants to be active. Others are marked as inactive and do not 
#   influence at computing mutation score.
#   date: 05/07/96
#   last update: 05/28/96
#------------------------------------------------------------------------------#

proc Mutants_Select_Oper_Window {w} {

   # OBS: ARRUMAR A PARTE DE SELECAO DE MUTANTES, POR ENQUANTO DEIXAR COMO
   #      FUNCAO NAO DISPONIVEL.

   message "Function Not Avaliable Yet!" 
   return


   toplevel $w
   wm title $w "Mutants Selection"
   wm iconname $w "Selection"
   wm geometry $w 450x300
   wm geometry $w +10+65
   wm minsize  $w 450 300
   wm maxsize  $w 450 300
 
   global stat_tot
   set stat_tot 0

   frame $w.f1 
   pack  $w.f1 -fill x -pady 10

   frame  $w.f1.f1 
   frame  $w.f1.f2
   pack   $w.f1.f1 $w.f1.f2 -side left

   label $w.f1.f1.l -text "Classes:" 
   pack  $w.f1.f1.l 

   menubutton $w.f1.f2.r -menu $w.f1.f2.r.m -relief raised -cursor hand2
   pack $w.f1.f2.r -side left  
      menu $w.f1.f2.r.m -tearoff 0

      # if option "Statement Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Statement Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.stat]} {
            $v.f1.f2.l configure -text "Statement Mutations"
            Stat_Sel_Operator $v.stat 
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.oper]} {
            destroy $v.oper
         } elseif {[winfo exists $v.var]} {
            destroy $v.var
         } elseif {[winfo exists $v.cons]} {
            destroy $v.cons
         }
       }

      # if option "Operator Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Operator Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.oper]} {
            $v.f1.f2.l configure -text "Operator Mutations"
            Oper_Sel_Operator $v.oper
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.stat]} {
            destroy $v.stat
         } elseif {[winfo exists $v.var]} {
            destroy $v.var
         } elseif {[winfo exists $v.cons]} {
            destroy $v.cons
         }
      }

      # if option "Variable Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Variable Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.var]} {
            $v.f1.f2.l configure -text "Variable Mutations"
            Var_Sel_Operator $v.var
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.stat]} {
            destroy $v.stat
         } elseif {[winfo exists $v.oper]} {
            destroy $v.oper
         } elseif {[winfo exists $v.cons]} {
            destroy $v.cons
         }
      }

      # if option "Constant Mutations" was choosen in menu
      $w.f1.f2.r.m add command -label "Constant Mutations" -command { \
         set v .proteum.muta.m.dlg

         if {![winfo exists $v.cons]} {
            $v.f1.f2.l configure -text "Constant Mutations"
            Cons_Sel_Operator $v.cons     
         }

         # Destroy windows of other class mutation operators
         if {[winfo exists $v.stat]} {
            destroy $v.stat
         } elseif {[winfo exists $v.oper]} {
            destroy $v.oper
         } elseif {[winfo exists $v.var]} {
            destroy $v.var
         }
      }
    
   label  $w.f1.f2.l -text "Statement Mutations" 
   pack   $w.f1.f2.l -side left
   Stat_Sel_Operator $w.stat

   frame  $w.f2    
   pack   $w.f2 -pady 5

   button $w.f2.confirm -text Select -command {

     # Destroy mutation operator window
      set v .proteum.muta.m.dlg  
      if {[winfo exists $v.stat]} {
         destroy $v.stat
      } elseif {[winfo exists $v.oper]} {
         destroy $v.oper
      } elseif {[winfo exists $v.var]} {
         destroy $v.var
      } elseif {[winfo exists $v.cons]} {
         destroy $v.cons
      }   
      set confirm 1;          # Variable for user not interact with other window
      Select_Mutants
   }

   button $w.f2.cancel  -text Cancel -command "
      destroy $w
      set confirm 0";         # Variable for user not interact with other window
   pack   $w.f2.confirm $w.f2.cancel -side left

   wm protocol $w WM_DELETE_WINDOW {
      set confirm 0
      destroy .proteum.muta.m.dlg
   }
 
   bind $w <Any-Motion> {focus %W}

   grab $w 
   tkwait variable confirm
   grab release $w
}



#------------------------------------------------------------------------------#
#   SELECT_MUTANTS {}
#   Selects mutants to remain active.
#   date: 05/28/96
#   last update: 05/28/96
#------------------------------------------------------------------------------#

proc Select_Mutants {} {
   global stat_sin oper_sin var_sin cons_sin;       # Percentage to select
   global stat_data oper_data var_data cons_data;   # Operator's name
   global stat_sout oper_sout var_sout cons_sout;   # Number of selected mutants

   set list_oper {}

   destroy .proteum.muta.m.dlg;      # Destroy last window

puts -----------------------------------
   set i 1
   if {[info exists stat_sin($i)]} {
      foreach op $stat_data {
         if {[string compare $stat_sin($i) "100"] != 0} {
            # Takes operator's name
            set operator [string range $op 0 3]
            lappend list_oper -$operator $stat_sin($i)
puts "op: [string range $op 0 3] \t%: $stat_sin($i)"
         }
         incr i  
      }
   }
puts -----------------------------------
   set i 1
   if {[info exists oper_sin($i)]} {
      foreach op $oper_data {
         if {[string compare $oper_sin($i) "100"] != 0} {
            # Takes operator's name
            set operator [string range $op 0 3]
            lappend list_oper -$operator $oper_sin($i)
puts "op: [string range $op 0 3] \t%: $oper_sin($i)"
         }
         incr i  
      }
   }
puts -----------------------------------
   set i 1
   if {[info exists var_sin($i)]} {
      foreach op $var_data { 
         if {[string compare $var_sin($i) "100"] != 0} {    
            # Takes operator's name
            set operator [string range $op 0 3]
            lappend list_oper -$operator $var_sin($i)
puts "op: [string range $op 0 3] \t%: $var_sin($i)"
         }
         incr i
      }  
   }
puts -----------------------------------
   set i 1
   if {[info exists cons_sin($i)]} {
      foreach op $cons_data {
         if {[string compare $cons_sin($i) "100"] != 0} {
            # Takes operator's name
            set operator [string range $op 0 3]
            lappend list_oper -$operator $cons_sin($i)
puts "op: [string range $op 0 3] \t%: $cons_sin($i)"
         }
         incr i
      }  
   }
   Exemuta SELECT $list_oper
}


#------------------------------------------------------------------------------#
#   STAT_SEL_OPERATOR {}
#   Shows Statement Mutations operators list to select percentage
#   date: 05/28/96
#   last update: 05/28/96
#------------------------------------------------------------------------------#


proc Stat_Sel_Operator {w} {
   toplevel $w
   wm title $w "Statement Mutants"
   wm iconname $w "Stat_Mut"
   wm geometry $w 550x400
   wm geometry $w +10+198
   wm maxsize  $w 550 400
   wm minsize  $w 550 400
 
   global stat_data;      # Names of the mutation operators
   global default;        # Percentage default
   global stat_sin;       # Percentage of mutations operator
   global stat_sout;      # Number of generated mutants
   set tot     0;         # Total of generated mutants
   set default 0
 
   frame $w.f1 
   pack  $w.f1 -fill x

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default STAT SELECT"
   entry  $w.f1.perc -width 5 -justify right -textvariable default 
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10

   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.stat.f1

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.stat.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled"
      } else {
         $v.dw config -state disabled
      } 
   }
   pack $w.f1.up $w.f1.dw -side left

   
   if {$default == 0} {
      .proteum.muta.m.dlg.stat.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.stat.f1.up config -state disabled
   }

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 

   set i 1
   foreach item $stat_data {
      frame $w.t.$i
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow

      # If not exists variable for selection percentage, set it 100%
      if {![info exists stat_sin($i)]} {
         set stat_sin($i) 100
      }

      entry $w.t.$i.in  -width 4 -justify right -textvariable stat_sin($i)

      pack  $w.t.$i.out $w.t.$i.in -side left

      if {[info exists stat_sout($i)]} {
         $w.t.$i.out config -text $stat_sout($i) -anchor e
         set tot [expr $tot+$stat_sout($i)]
      }      

      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -text {TOTAL: }  -width 48 -anchor e
   label $w.t.f1.out -text $tot -width 4 -relief sunken -anchor e 
   pack  $w.t.f1.l $w.t.f1.out -side left

   bind $w <Any-Motion> {focus %W}
}



#------------------------------------------------------------------------------#
#   OPER_SEL_OPERATOR {}
#   Shows Operator Mutations operators list to select percentage
#   date: 05/28/96
#   last update: 05/28/96
#------------------------------------------------------------------------------#


proc Oper_Sel_Operator {w} {
   toplevel $w
   wm title $w "Operator Mutants"
   wm iconname $w "Oper_Mut"
   wm geometry $w 550x400
   wm geometry $w +10+198
   wm maxsize  $w 550 400
   wm minsize  $w 550 400 

   global oper_data;      # Names of the mutation operators
   global default;        # Percentage default
   global oper_sin;       # Percentage of mutations operator
   global oper_sout;      # Number of generated mutants
   set tot     0;         # Total of generated mutants
   set default 0
 
   frame $w.f1 
   pack  $w.f1 -fill x

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default OPER SELECT"
   entry  $w.f1.perc -width 5 -justify right -textvariable default 
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10


   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.oper.f1

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.oper.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled"
      } else {
         $v.dw config -state disabled
      } 
   }
   pack $w.f1.up $w.f1.dw -side left

   
   if {$default == 0} {
      .proteum.muta.m.dlg.oper.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.oper.f1.up config -state disabled
   }

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 

   set i 1
   foreach item $oper_data {
      frame $w.t.$i
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      # If not exists variable for selection percentage, set it 100%
      if {![info exists oper_sin($i)]} {
         set oper_sin($i) 100
      }  

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow
      entry $w.t.$i.in -width 4 -justify right -textvariable oper_sin($i)

      pack  $w.t.$i.out $w.t.$i.in -side left

      if {[info exists oper_sout($i)]} {
         $w.t.$i.out config -text $oper_sout($i) -anchor e
         set tot [expr $tot+$oper_sout($i)]
      }
      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -text {TOTAL: }  -width 48 -anchor e
   label $w.t.f1.out -text $tot -width 4 -relief sunken -anchor e 
   pack  $w.t.f1.l $w.t.f1.out -side left

   bind $w <Any-Motion> {focus %W}
}


#------------------------------------------------------------------------------#
#   VAR_SEL_OPERATOR {}
#   Shows Variable Mutations operators list to select percentage
#   date: 05/28/96
#   last update: 05/28/96
#------------------------------------------------------------------------------#


proc Var_Sel_Operator {w} {
   toplevel $w
   wm title $w "Variable Mutants"
   wm iconname $w "Var_Mut"
   wm geometry $w 550x378
   wm geometry $w +10+198
   wm maxsize  $w 550 378
   wm minsize  $w 550 378 

 
   global var_data;       # Names of the mutation operators
   global default;        # Percentage default
   global var_sin;        # Percentage of mutations operator
   global var_sout;       # Number of generated mutants
   set tot     0;         # Total of generated mutants
   set default 0
 
   frame $w.f1 
   pack  $w.f1 -fill x

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default VAR SELECT"
   entry  $w.f1.perc -width 5 -justify right -textvariable default 
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10

   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.var.f1

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.var.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled"
      } else {
         $v.dw config -state disabled
      } 
   }
   pack $w.f1.up $w.f1.dw -side left
   if {$default == 0} {
      .proteum.muta.m.dlg.var.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.var.f1.up config -state disabled
   }

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 

   set i 1
   foreach item $var_data {
      frame $w.t.$i
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      # If not exists variable for selection percentage, set it 100%
      if {![info exists var_sin($i)]} {
         set var_sin($i) 100
      }

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow
      entry $w.t.$i.in -width 4 -justify right -textvariable var_sin($i)

      pack  $w.t.$i.out $w.t.$i.in -side left

      if {[info exists var_sout($i)]} {
         $w.t.$i.out config -text $var_sout($i) -anchor e
         set tot [expr $tot+$var_sout($i)]
      }
      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -text {TOTAL: }  -width 48 -anchor e
   label $w.t.f1.out -text $tot -width 4 -relief sunken -anchor e 
   pack  $w.t.f1.l $w.t.f1.out -side left

   bind $w <Any-Motion> {focus %W}
}


#------------------------------------------------------------------------------#
#   CONS_SEL_OPERATOR {}
#   Shows Constant Mutations operators list to select percentage
#   date: 05/28/96
#   last update: 05/28/96
#------------------------------------------------------------------------------#


proc Cons_Sel_Operator {w} {
   toplevel $w
   wm title $w "Constant Mutants"
   wm iconname $w "Cons_Mut"
   wm geometry $w 550x280
   wm geometry $w +10+198
   wm maxsize  $w 550 280
   wm minsize  $w 550 280 

   global cons_data;      # Names of the mutation operators
   global default;        # Percentage default
   global cons_sin;       # Percentage of mutations operator
   global cons_sout;      # Number of generated mutants
  
   set tot     0;         # Total of generated mutants
   set default 0
   frame $w.f1 
   pack  $w.f1 -fill x

   button $w.f1.default -text "Apply Default" -command "
      Apply_Default CONS SELECT"
   entry  $w.f1.perc -width 5 -justify right -textvariable default 
   pack   $w.f1.default $w.f1.perc -side left -padx 10 -pady 10

   # Button for UP and DOWN of default percentage 
   button $w.f1.up -text up -command {
      set v .proteum.muta.m.dlg.cons.f1

      $v.dw config -state normal
      if {$default < 100} {
         incr default
         if {$default == 100} "$v.up config -state disabled"
      } else {
         $v.up config -state disabled
      }
   }
   button $w.f1.dw -text dw -command {
      set v .proteum.muta.m.dlg.cons.f1

      $v.up config -state normal
      if {$default > 0} {
         incr default -1
         if {$default == 0} "$v.dw config -state disabled"
      } else {
         $v.dw config -state disabled
      } 
   }
   pack $w.f1.up $w.f1.dw -side left

   if {$default == 0} {
      .proteum.muta.m.dlg.cons.f1.dw config -state disabled
   } elseif {$default == 100} {
      .proteum.muta.m.dlg.cons.f1.up config -state disabled
   }

   # Create text area to insert operators name, in and out field 
   text $w.t -yscrollcommand "$w.s set" -relief sunken -bd 1 -state disabled \
             -cursor top_left_arrow
   scrollbar $w.s -command "$w.t yview" 
   pack $w.s -side right -fill both
   pack $w.t -expand yes 

   set i 1
   foreach item $cons_data {
      frame $w.t.$i
      pack  $w.t.$i 
      $w.t window create end -window $w.t.$i 

      label $w.t.$i.l -text $item -width 48 -anchor w
      pack  $w.t.$i.l -side left

      # If not exists variable for selection percentage, set it 100%
      if {![info exists cons_sin($i)]} {
         set cons_sin($i) 100
      }

      label $w.t.$i.out -width 4 -relief sunken -cursor top_left_arrow
      entry $w.t.$i.in -width 4 -justify right -textvariable cons_sin($i)

      pack  $w.t.$i.out $w.t.$i.in -side left

      if {[info exists cons_sout($i)]} {
         $w.t.$i.out config -text $cons_sout($i) -anchor e
         set tot [expr $tot+$cons_sout($i)]
      }
      incr i
   }

   frame $w.t.f1 
   pack  $w.t.f1
   $w.t window create end -window $w.t.f1 -pady 10

   label $w.t.f1.l -text {TOTAL: }  -width 48 -anchor e
   label $w.t.f1.out -text $tot -width 4 -relief sunken -anchor e 
   pack  $w.t.f1.l $w.t.f1.out -side left

   bind $w <Any-Motion> {focus %W}
}


#------------------------------------------------------------------------------#
#   MUTANTS_BLOCK_WINDOW {}
#   
#   date:
#   last update:
#------------------------------------------------------------------------------#


proc Mutants_Select_Block_Window {w} {
   message "This function is not disponible !!!..."
   return
}

