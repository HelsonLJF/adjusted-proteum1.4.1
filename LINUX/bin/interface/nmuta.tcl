#!/opt/packages/local/bin/wish

wm withdraw .

source iglobal.tcl

   while {[file exists $TMP_DIR_FILE]} {
      set num [file size $TMP_DIR_FILE];       # Reads size of file
 puts stdout $num
      send -async proteum "set nmuta $num";    # Sends command to application
      after 1000;                              # Waits for 1 second
   }


puts "saiu e num e' igual a $num"
   exit
