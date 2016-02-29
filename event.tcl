package require mysqltcl


wm maxsize . 1200 600
wm minsize . 1200 600

global handle

proc drawline {} {
.displayScreen insert end "\n-------------------------------------------------------"
}

proc connect {user password} {
global handle
set handle [mysqlconnect -user $user -db mydb -password $password]
mysqluse $handle mydb;

}


proc view_data { } {

global handle 
global gold
global silver 
global bronze
set view_query "SELECT DISTINCT EVENT_PLACE FROM EVENT"
set data_list [mysqlsel $handle $view_query -list]

puts $data_list
 
 .displayScreen insert end "\tCITY\t|\tGOLD\t|\tSILVER\t|\tBRONZE\t |\n"
 .displayScreen insert end "-----------------------------------------------------------------------------------------------------------------------------------------------"
 foreach city $data_list {
   set format_query "SELECT EVENT_POSITION FROM EVENT WHERE EVENT_PLACE='$city'"
   set new_list [mysqlsel $handle $format_query -list]
        
		   set len [llength $new_list]
		  
		   set i 0
		   set gold 0
		   set silver 0
		   set bronze 0
		   while {$i<$len} {
		  
		   
		   if { [lindex $new_list $i] == 1 } {
		   global gold
		   set gold [expr $gold + 1]
		  
		   }
		   
		    if { [lindex $new_list $i] == 2 } {
		   global silver
		   set silver [expr $silver + 1]
		     }
		   
		    if { [lindex $new_list $i] == 3 } {
		   global bronze
		   set bronze [expr $bronze + 1]
		   
		   }
		   
		   incr i
		   };#ending foreach
		   
		   .displayScreen insert end "\t\t\t$city\t|\t    $gold\t|\t    $silver\t|\t    $bronze\t  |\n"
		   .displayScreen insert end "-----------------------------------------------------------------------------------------------------------------------------------------------"
		   #puts "$city || GOLD $gold || SILVER $silver || BRONZE $bronze" 
		   
    };#ending foreach loop
 
};#ENDING FUNCTION


proc confirmation_dialog {title text} {
set ans [tk_dialog .confirm $title $text questhead 0 "OK"]
}


proc insert_data {event_no event_name event_place event_position} {
global handle
set insert_query "INSERT INTO EVENT VALUES('$event_no','$event_name','$event_place','$event_position')"
mysqlexec $handle $insert_query 

}

connect "root" "reverse"
font create buttonFont1 -family Nanum -size 12 -weight bold
font create buttonFont -family Nanum -size 16 -weight bold
font create textFont -family Helvetica -size 11 -weight bold

frame .entryFrame -relief raised -borderwidth 10 -height 320 -width 400
place .entryFrame -x 30 -y 30

label .entryFrame.title -text "EVENT ENTRY SECTION" 
.entryFrame.title configure -font subheadingFont -background orange 
place .entryFrame.title -x 50 -y 5

label .entryFrame.eventNo -text "EVENT NUMBER-" 
.entryFrame.eventNo configure -font subheadingFont -foreground navy 
place .entryFrame.eventNo -x 10 -y 50

entry .entryFrame.entryEventNo -font fieldFont -textvariable event_no -width 21 -borderwidth 5
place .entryFrame.entryEventNo -x 170 -y 45

label .entryFrame.eventName -text "EVENT NAME-" 
.entryFrame.eventName configure -font subheadingFont -foreground navy 
place .entryFrame.eventName -x 10 -y 90

entry .entryFrame.entryEventName -font fieldFont -textvariable event_name -width 21 -borderwidth 5
place .entryFrame.entryEventName -x 170 -y 85

label .entryFrame.eventPlace -text "EVENT PLACE-" 
.entryFrame.eventPlace configure -font subheadingFont -foreground navy 
place .entryFrame.eventPlace -x 10 -y 130

entry .entryFrame.entryEventPlace -font fieldFont -textvariable event_place -width 21 -borderwidth 5
place .entryFrame.entryEventPlace -x 170 -y 125

label .entryFrame.eventPosition -text "POSITION-" 
.entryFrame.eventPosition configure -font subheadingFont -foreground navy 
place .entryFrame.eventPosition -x 10 -y 170

entry .entryFrame.entryEventPosition -font fieldFont -textvariable event_position -width 21 -borderwidth 5
place .entryFrame.entryEventPosition -x 170 -y 165

button .entryFrame.submitButton -text "SUBMIT RECORD" -font buttonFont1  -command {

insert_data $event_no $event_name $event_place $event_position
confirmation_dialog "DATA INSERTION CONFIRMATION" "DATA INSERTED SUCCESSFULLY!!"
}
.entryFrame.submitButton configure -width 15 -background green -foreground yellow
place .entryFrame.submitButton -x 10 -y 210

button .entryFrame.viewButton -text "VIEW RECORDS" -font buttonFont1  -command {

view_data
}
.entryFrame.viewButton configure -width 15 -background green -foreground yellow
place .entryFrame.viewButton -x 200 -y 210

button .entryFrame.resetButton -text "RESET" -font buttonFont1  -command {
set event_no ""
set event_name ""
set event_place ""
set event_position ""
.displayScreen delete 1.0 end
}
.entryFrame.resetButton configure -width 15 -background green -foreground yellow
place .entryFrame.resetButton -x 10 -y 250

button .entryFrame.exitButton -text "EXIT" -font buttonFont1  -command { exit }
.entryFrame.exitButton configure -width 15 -background green -foreground yellow
place .entryFrame.exitButton -x 200 -y 250

text .displayScreen -width 90 -height 28 -background lightgreen -borderwidth 10 -relief ridge
.displayScreen configure  -font textFont -foreground navy
place .displayScreen -x 450 -y 60

label .mytitle -text "RECORD BOOK SECTION" 
.mytitle configure -font headingFont -foreground navy
place .mytitle -x 710 -y 15

