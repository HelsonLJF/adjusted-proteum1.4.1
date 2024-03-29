#------------------------------------------------------------------------------#
#   IPROGRAM.TCL
#   Procedures related with PROGRAMTEST options.
#   author: Elisa Yumi Nakagawa
#   date: 02/22/96
#   last update: 03/22/96, 09/25/96
#------------------------------------------------------------------------------#

source $PROTEUMINTERFHOME/iglobal.tcl
source $PROTEUMINTERFHOME/igeral.tcl
source $PROTEUMINTERFHOME/geral.tcl
source $PROTEUMINTERFHOME/inter.tcl


#------------------------------------------------------------------------------#
#   LOAD_WINDOW {}            
#   Load Test File
#   date: 02/22/96
#   last update: 05/10/96
#------------------------------------------------------------------------------#


proc Load_Window {w} {
   toplevel $w 
   wm title $w "Load Program Test"
   wm iconname $w "Load"
   wm geometry $w 790x200
   wm geometry $w +10+65
   wm minsize  $w 790 200
   wm maxsize  $w 790 200

   global ddirectory \
          in         \
          timeout

   set in(dir)   [Set_Directory $ddirectory];  # Sets directory name 
   set in(tfile) {};                           # Sets test file name
   set timeout   [Set_Timeout ""];             # Setstimeout
 
   frame $w.f1
   pack  $w.f1 -fill x
   label $w.f1.l -text "Directory:"
   entry $w.f1.in -width 50 -textvariable in(dir)
   pack  $w.f1.in $w.f1.l -side right

   frame $w.f2
   pack  $w.f2 -fill x
   label $w.f2.l -text "Program Test Name:" 
   entry $w.f2.in -width 50 -textvariable in(tfile)
   pack  $w.f2.in $w.f2.l -side right
 
   frame  $w.f3  
   pack   $w.f3 
   button $w.f3.confirm -text Confirm -command "
          Confirm_Load_Data $w
          set confirm 1"
   button $w.f3.cancel  -text Cancel  -command "
          destroy $w
          set confirm 0" 
   pack   $w.f3.confirm $w.f3.cancel -side left -pady 10
   
   bind $w <Any-Motion> {focus %W}

   bind $w.f1.in      <Tab> [list focus $w.f2.in]
   bind $w.f2.in      <Tab> [list focus $w.f3.confirm]
   bind $w.f3.confirm <Tab> [list focus $w.f3.cancel]
   bind $w.f3.cancel  <Tab> [list focus $w.f1.in]
 
   bind $w.f1.in <Return> [list focus $w.f2.in]
   bind $w.f2.in <Return> "$w.f3.confirm invoke"

   wm protocol $w WM_DELETE_WINDOW {
      set confirm 0
      destroy .proteum.ptest.m.dlg
   }
   grab $w
   tkwait variable confirm
   grab release $w
}


#------------------------------------------------------------------------------#
#   CONFIRM_LOAD_DATA {}
#   Verify loadtest data (directory and testfile).
#   date: 03/21/96
#   last update: 03/27/96
#------------------------------------------------------------------------------#


proc Confirm_Load_Data {w} {
 
   global test \
          in

   set in(dir)   [Blank_Space_Out $in(dir)]     
   set in(tfile) [Blank_Space_Out $in(tfile)]  

   set tmpfile_ptm $in(dir)/$in(tfile).PTM

   if {![file isdirectory $in(dir)]} {
       message "This Directory Does Not Exist !"
       return     
   } elseif {[string length $in(tfile)] == 0} {
      message "Invalid Program Test Name !"
      return
   } elseif {![file isfile $tmpfile_ptm]} {
      message "Program Test Does Not Exist !" 
      return
   }

   set test(dir) $in(dir)
   set test(tfile) $in(tfile)

   destroy $w
   Load_File_PTM

#   Load_Session_Data; ESSA FUNCAO PODERIA SER PARA LER DA SAIDA FORNECIDA 
#   PELO PTESTE, DIFERENTE DA DUNCAO Load_File_PTM QUE LE DIRETO DO ARQUIVO .PTM

   Init_Variables
   Enable_MenuButtons
}



#------------------------------------------------------------------------------#
#   NEW_WINDOW
#   Create new test file.
#   date: 02/22/96
#   last update: 05/10/96, 09/16/96
#------------------------------------------------------------------------------#

proc New_Window {w args} {
   toplevel $w 
   wm title $w "Create New Program Test"
   wm iconname $w "Create"
   wm geometry $w 600x327
   wm geometry $w +10+65
   wm minsize  $w 600 327
   wm maxsize  $w 600 327

   global in         \
          ddirectory \
          timeout

   set in(dir)   [Set_Directory $ddirectory];   # initialization of variables
   set in(tfile) {}
   set in(src)   {}
   set in(exec)  {}
   set in(comp)  {}
   set in(type)  {}
   set in(func)  {}
   set timeout   [Set_Timeout ""]

   frame $w.f1
   pack  $w.f1 -fill x
   label $w.f1.l -text {Directory:}
   entry $w.f1.in -width 50 -textvariable in(dir)
   pack  $w.f1.in $w.f1.l -side right

   frame $w.f2
   pack  $w.f2 -fill x
   label $w.f2.l -text {Program Test Name:} 
   entry $w.f2.in -width 50 -textvariable in(tfile)
   pack  $w.f2.in $w.f2.l -side right

   frame $w.f3
   pack  $w.f3 -fill x
   label $w.f3.l -text {Source Program:}
   entry $w.f3.in -width 50 -textvariable in(src)
   pack  $w.f3.in $w.f3.l -side right

   frame $w.f4
   pack  $w.f4 -fill x
   label $w.f4.l -text {Executable Program:}
   entry $w.f4.in -width 50 -textvariable in(exec)
   pack  $w.f4.in $w.f4.l -side right

   frame $w.f5
   pack  $w.f5 -fill x
   label $w.f5.l -text {Compilation Command:}
   entry $w.f5.in -width 50 -textvariable in(comp)
   pack  $w.f5.in $w.f5.l -side right


   frame $w.f6 
   pack  $w.f6 -fill x 
   label $w.f6.l -text {                         Type:}
   radiobutton $w.f6.r1 -text  test -variable in(type) \
                        -value test -selectcolor green -cursor hand2
   radiobutton $w.f6.r2 -text  research -variable in(type) \
                        -value research -selectcolor green -cursor hand2
   pack $w.f6.l $w.f6.r1 $w.f6.r2 -side left

   $w.f6.r1 select;     # default option "test" is selected

   frame $w.f7
   pack  $w.f7 -fill x
   label $w.f7.l -text {                  Functions:}
   set test_func all
   radiobutton $w.f7.r1 -text {all   } -variable in(func) -value all \
                        -command "Show_Func all $w" \
                        -selectcolor green -cursor hand2

   radiobutton $w.f7.r2 -text {select} -variable in(func) -value select \
                        -command "Show_Func select $w" \
                        -selectcolor green -cursor hand2

   pack $w.f7.l $w.f7.r1 $w.f7.r2 -side left
 
   $w.f7.r1 select;     # default option "all" is selected


   # Creates text area and scrollbars for name of functions
   frame $w.f8
   text $w.f8.t -yscrollcommand "$w.f8.sv set" -width 50 -height 7 -cursor hand2
   scrollbar $w.f8.sv -command "$w.f8.t yview"

   frame  $w.f9
   pack   $w.f9 
   button $w.f9.confirm -text Confirm -command "
          Confirm_New_Data $w
          set confirm 1"
   button $w.f9.cancel  -text Cancel  -command "
          destroy $w
          set confirm 0"
   pack   $w.f9.confirm $w.f9.cancel -side left -pady 10


   bind $w <Any-Motion> {focus %W}

   bind $w.f1.in      <Tab> [list focus $w.f2.in]
   bind $w.f2.in      <Tab> [list focus $w.f3.in]
   bind $w.f3.in      <Tab> [list focus $w.f4.in]
   bind $w.f4.in      <Tab> [list focus $w.f5.in]
   bind $w.f5.in      <Tab> [list focus $w.f6.r1]
   bind $w.f6.r1      <Tab> [list focus $w.f6.r2]
   bind $w.f6.r2      <Tab> [list focus $w.f7.r2]
   bind $w.f7.r1      <Tab> [list focus $w.f7.r2]
   bind $w.f7.r2      <Tab> [list focus $w.f9.confirm]
   bind $w.f9.confirm <Tab> [list focus $w.f9.cancel]
   bind $w.f9.cancel  <Tab> [list focus $w.f1.in]
 
   bind $w.f1.in <Return> [list focus $w.f2.in]
   bind $w.f2.in <Return> [list focus $w.f3.in]
   bind $w.f3.in <Return> [list focus $w.f4.in]
   bind $w.f4.in <Return> [list focus $w.f5.in]
   bind $w.f5.in <Return> [list focus $w.f6.r1]
   bind $w.f6.r1 <Return> [list focus $w.f6.r2]
   bind $w.f6.r2 <Return> [list focus $w.f7.r1]
   bind $w.f7.r1 <Return> [list focus $w.f7.r2]
   bind $w.f7.r2 <Return> [list focus $w.f9.confirm] 

   wm protocol $w WM_DELETE_WINDOW {
      set confirm 0
      destroy .proteum.ptest.m.dlg
   }
   grab $w
   tkwait variable confirm 
   grab release $w 
}


#------------------------------------------------------------------------------#
#   CONFIRM_NEW_DATA {}
#   Verify newtest data.
#   date: 03/22/96
#   last update: 03/28/96
#------------------------------------------------------------------------------#

proc Confirm_New_Data {w} {

   global test \
          in

   set in(dir)   [Blank_Space_Out $in(dir)]
   set in(tfile) [Blank_Space_Out $in(tfile)]
   set in(src)   [Blank_Space_Out $in(src)]
   set in(exec)  [Blank_Space_Out $in(exec)]
 
 

   if {![file isdirectory $in(dir)]} {
       message "Not Exist Directory !"    
       return
   } elseif {[string length $in(tfile)] == 0} {
       message "Invalid Program Test Name !"
       return
   } else {				 ###% Modified
       set tmpfile $in(dir)/$in(src).c;  # concat directory and source filename
       if {![file isfile $tmpfile]} {
          message "Source File Does Not Exist !"
          return
       } else {
          set tmpfile $in(dir)/$in(exec);  # concat directory and exec filename
          if {![file executable $tmpfile]} {
             message "Executable File Does Not Exist !"
             return
          } else {
             set tmpfile_ptm $in(dir)/$in(tfile).PTM;   #concat dir and ptm file
             if {[file isfile $tmpfile_ptm]} {
                message_2b $w "Program Test Already Exist !" 
                return
             }
          } 
       }
   }
   destroy $w
   Create_New_Session
}



#------------------------------------------------------------------------------#
#   CREATE_NEW_SESSION {}
#   Calls functions to create new test session (program test, intermediate 
#   representation (LI), test case, mutant descriptors.
#   date: 04/12/96
#   last update: 04/12/96, 09/16/96, 06/04/97
#------------------------------------------------------------------------------#


proc Create_New_Session {} {
   global test in

   set test(dir)   $in(dir)
   set test(tfile) $in(tfile)
   set test(src)   $in(src)
   set test(exec)  $in(exec)
   set test(comp)  $in(comp)
   set test(type)  $in(type)
   set test(func)  $in(func)

   Set_Busy ON

   Pteste CREATE
   Li NEWSES
   Li LISTFUNC
   Li2nli
   Tcase CREATE
   Muta CREATE

   Init_Variables
   Enable_MenuButtons

   Set_Busy OFF
}
 
