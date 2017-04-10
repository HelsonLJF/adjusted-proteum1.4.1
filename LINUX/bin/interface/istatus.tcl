#------------------------------------------------------------------------------#
#   ISTATUS.TCL
#   Procedures related with STATUS options.
#   author: Elisa Yumi Nakagawa
#   date: 02/23/96
#   last update: 05/03/96
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
#   STATUS_WINDOW
#   Create status window.
#   date: 02/23/96
#   last update: 05/06/96, 09/19/96, 01/27/97, 06/05/97, 06/06/97
#------------------------------------------------------------------------------#

proc Status_Window {w args} {
   toplevel $w
   wm title $w "Status" 
   wm iconname $w Status
   wm geometry $w 500x330
   wm geometry $w +10+65
   wm maxsize  $w 500 330
   wm minsize  $w 500 330

   global test 
   global out
   global maxtcase;        # Max number of test cases
   global MAXFUNCTIONS;    # Max number of functions
   global functions;       # Function name of program in test
   global index_func;      # 0 (function not tested), 1 (function tested)
   global f1;              # Font
   
   

   set infogeneral [Report GENERAL 0]

   # If error building report, return 
   if {[string length $infogeneral] == 0} {
      return
   } else {
       Disjoin_Infogeneral $infogeneral PART
   }  


   frame $w.f1
   pack  $w.f1 -pady 5
   
   frame $w.f1.f1 
   pack  $w.f1.f1 -fill x -pady 3
   label $w.f1.f1.l -text {Directory:}
   label $w.f1.f1.out -width 50 -text $test(dir) -font $f1 \
         -relief sunken -anchor w
   pack  $w.f1.f1.out $w.f1.f1.l -side right
   
   frame $w.f1.f2 
   pack  $w.f1.f2 -fill x -pady 3   
   label $w.f1.f2.l -text {Program Test Name:}
   label $w.f1.f2.out -width 50 -text $test(tfile) -font $f1 \
         -relief sunken -anchor w 
   pack  $w.f1.f2.out $w.f1.f2.l -side right

   frame $w.f1.f3 
   pack  $w.f1.f3 -fill x -pady 3   
   label $w.f1.f3.l -text {Source Program:}
   label $w.f1.f3.out -width 50 -text $test(src) -font $f1 \
         -relief sunken -anchor w 
   pack  $w.f1.f3.out $w.f1.f3.l -side right

   frame $w.f1.f4 
   pack  $w.f1.f4 -fill x -pady 3  
   label $w.f1.f4.l -text {Executable Program:}
   label $w.f1.f4.out -width 50 -text $test(exec) -font $f1 \
         -relief sunken -anchor w 
   pack  $w.f1.f4.out $w.f1.f4.l -side right

   frame $w.f1.f5 
   pack  $w.f1.f5 -fill x -pady 3   
   label $w.f1.f5.l -text {Compilation Command:}
   label $w.f1.f5.out -width 50 -text $test(comp) -font $f1 \
         -relief sunken -anchor w 
   pack  $w.f1.f5.out $w.f1.f5.l -side right

#   frame $w.f2
#   pack  $w.f2 -pady 5

#   frame $w.f2.f1
#   label $w.f2.f1.l -text "Functions:" 
#   pack  $w.f2.f1.l -side left

#   frame $w.f2.f2
#   pack  $w.f2.f1 $w.f2.f2 
#   text  $w.f2.f2.t -yscrollcommand "$w.f2.f2.s set" -width 30 \
#                   -height 7 -cursor top_left_arrow -state disabled
#   scrollbar $w.f2.f2.s -command "$w.f2.f2.t yview"
#   pack $w.f2.f2.s -side right -fill both
#   pack $w.f2.f2.t -expand true

#   for {set i 0} {$i < $MAXFUNCTIONS} {incr i} {
#      frame $w.f2.f2.t.$i
#      pack  $w.f2.f2.t.$i -fill x
#      $w.f2.f2.t window create end -window $w.f2.f2.t.$i 

#      if {![string compare $test(func) all] || $index_func($i)} {
#         label $w.f2.f2.t.$i.l$i -text $functions($i) -font $f1
#         pack  $w.f2.f2.t.$i.l$i -side left
#      }
#   }

   frame $w.f3
   pack  $w.f3 -pady 10

   frame $w.f3.f1
 
   frame $w.f3.f1.f1
   pack  $w.f3.f1.f1 -fill x -pady 3
   label $w.f3.f1.f1.l -text {Type:}
   label $w.f3.f1.f1.out -width 8 -text $test(type) -relief sunken -font $f1
   pack  $w.f3.f1.f1.out $w.f3.f1.f1.l -side right

   frame $w.f3.f1.f2
   pack  $w.f3.f1.f2 -fill x -pady 3
   label $w.f3.f1.f2.l -text {Total Mutants:}
   label $w.f3.f1.f2.out -width 8 -text $out(totmut) -relief sunken -font $f1
   pack  $w.f3.f1.f2.out $w.f3.f1.f2.l -side right

   frame $w.f3.f1.f3
   pack  $w.f3.f1.f3 -fill x -pady 3
   label $w.f3.f1.f3.l -text {Active Mutants:}
   label $w.f3.f1.f3.out -width 8 -text $out(actmut) -relief sunken -font $f1
   pack  $w.f3.f1.f3.out $w.f3.f1.f3.l -side right

   frame $w.f3.f1.f4
   pack  $w.f3.f1.f4 -fill x -pady 3
   label $w.f3.f1.f4.l -text {Equivalent Mutants:}
   label $w.f3.f1.f4.out -width 8 -text $out(equmut) -relief sunken -font $f1
   pack  $w.f3.f1.f4.out $w.f3.f1.f4.l -side right

   frame $w.f3.f2
   pack  $w.f3.f1 $w.f3.f2 -side left -anchor n -padx 10

   frame $w.f3.f2.f1
   pack  $w.f3.f2.f1 -fill x -pady 3
   label $w.f3.f2.f1.l -text {Test Cases:}
   label $w.f3.f2.f1.out -width 8 -text $maxtcase -relief sunken -font $f1
   pack  $w.f3.f2.f1.out $w.f3.f2.f1.l -side right

   frame $w.f3.f2.f2
   pack  $w.f3.f2.f2 -fill x -pady 3
   label $w.f3.f2.f2.l -text {Live Mutants:}
   label $w.f3.f2.f2.out -width 8 -text $out(livmut) -relief sunken -font $f1
   pack  $w.f3.f2.f2.out $w.f3.f2.f2.l -side right

   frame $w.f3.f2.f3
   pack  $w.f3.f2.f3 -fill x -pady 3
   label $w.f3.f2.f3.l -text {Anomalous Mutants:}
   label $w.f3.f2.f3.out -width 8 -text $out(anomut) -relief sunken -font $f1
   pack  $w.f3.f2.f3.out $w.f3.f2.f3.l -side right


   set tmp_score [string range $out(score) 0 4] 
   frame $w.f3.f2.f4
   pack  $w.f3.f2.f4 -fill x -pady 3
   label $w.f3.f2.f4.l -text {MUTATION SCORE:}
   label $w.f3.f2.f4.out -width 8 -text $tmp_score -relief sunken -font $f1
   pack  $w.f3.f2.f4.out $w.f3.f2.f4.l -side right


   frame  $w.f4 -bd 1 -relief sunken
   pack   $w.f4 -pady 10
   button $w.f4.ok -text "   OK   "  -command "
          set ok 1
          destroy $w"
   pack   $w.f4.ok -padx 2 -pady 2
 
   bind $w <Any-Motion> {focus %W}
   bind $w <Return> "$w.f4.ok invoke"

   wm protocol $w WM_DELETE_WINDOW {
      set ok 0
      destroy .proteum.status.dlg
   }
   grab  $w
   tkwait variable ok
   grab release $w

}

 
