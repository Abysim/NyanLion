# http://mainbot.net.ru
#
# Author: Rex (rex@doze.ru)
# �������� �� ���� Nerfbendr
########################################################################
#!����� - �����������
#!������� - ����������
#!������ - ������� �����������
#!������ - ������ ������� :)
########################################################################
#�����: ���������� ���������� ��� ������� ;)
#������ 1.3
#�������� ��������� ��� ������� ������ ����� ������, ������ ������������ ��������
#��������� � ��������� ������� � ������� � ��������.
#��������� ��������� ��������� ����� � ������������ ���������.
#������ ������ ����� ��� ���� ���� ������, �.�. ����� ��������� ������ ���� �� ������
#�� ��������� � set repeat �����
#������ 1.2
#��������� ������ �� �����
#������ 1.1
#��������� ����� � ���������.
#���� ���������� � ����� �� �������, ������ ������� !�����, !������� � 
#!������ ���� �������� � ������.
#
#������ 1.0
#������ ��������� ������ �������. 
########################################################################

bind pub - !hunt hunt
bind pub - !����� hunt
bind pub - !��������� hunt
bind pub - !cast fish
bind pub - !������� fish
bind pub - !������� fish
bind pub - !trophy trophy
bind pub - !������ trophy
bind pub - !����� trophy
bind pub - newmonth newmonth
bind pub - !������ dig
bind pub - !������ dig
bind pub - !dig dig

set digtargets {
	"������� ����������"
	"���� ������� �����������"
	"����� ��������� �������"
	"�������� � ����� �������"
	"������-���������"
	"������ �������"
	"������ ��"
	"���'���� ��������"
	"����� 76 ����"
	"������������"
	"��������������"
	"����� ������"
	"�������� �����"
	"����� ��� COM �����"
	"��������"
	"������ �����"
	"7 ������� ������"
	"����������"
	"��� ���� 65 ����"
	"���� P��� 733 ���"
	"����� ���'�� �� 32 ���������"
	"������ ����"
	"�����������"
	"��������� � ���������"
	"������ ������"
	"����-����������"
	"���� ���������"
	"��������� ��������"
	"���� �������"
	"���������� �����"
	"����������� ��������"
	"������ ���������"
	"��������� ����"
	"������� �����"
	"������ �������-�����"
	"���������� ����"
	"����� ��� �����"
	"������ ��� ���� ..."
	"������ � �� �����"
	"������ � ����� ��"
	"���� � ���������� ��������"
	"������ � �������"
	"������ ��������"
	"����� ������������"
	"������� � ���� ��������"
	"���������� �����"
	"�������� �� �����"
	"����������� ������"
	"������� �����"
	"�������"
	"�������� ���� ��� ���������"
	"�������� ��� ���������� ���"
	"�������"
	"����������"
	"�������� ������"
	"�������� �� ������"
	"�������"
	"������������"
	"��������"
	"��������� ����������"
	"��������� ������� � ���� �������"
	"���� ���������"
	"���� ��������"
	"���� ���"
	"������� ���������"
	"������� �� ��곿"
	"����� � ������������ �����"
	"���������� ������"
	"�����'����� ������"
	"���������� Windows 3.11"
	"������ ������"
	"��������� ������� �������"
	"�������� ������"
	"������� ���������"
	"��������� �� �����"
	"�������� ��������� ����"
}

set hunttargets {
"���������"
"������-�������"
"����"
"������"
"�����"
"������ ��������"
"����������"
"��������"
"�������� ����������"
"�������� �����"
"��������"
"�����"
"�������"
"��������"
"�����"
"�������� ��������"
"������"
"�������-���������"
"��������"
"���� ������"
"�����"
"�������� �����"
"������"
"�����"
"������a��"
"���������� ������"
"�������� ..."
"������"
"������"
"������������"
"�����"
"������ ���"
"���������"
"������"
"������� �������������"
"��������"
"������"
"���� � �������"
"�������"
"���������"
"��������"
"�������� ��������"
"���������"
"����-��������"
"������-������"
"�����"
"�����"
"������"
"�������"
"����� ����"
}

set fish {
"����������� ���������"
"�������� �������"
"�������� �����������"
"����������"
"��������"
"����������� �����"
"�����-������ ����������"
"���������"
"�������"
"�����"
"���������"
"����������� ������"
"���������"
"�����"
"�������"
"���������� ..."
"����� ����"
"���������� ������"
"����� �����"
"������� �������� �� ��� �����"
"������� ����"
"������� ����"
"���� �����"
"���-������� ����������"
"���� �������"
"���� �������� � ��������� �� �������� �����������"
"������ �����"
"����"
"��������"
"��������"
"�����"
"���������� ��������� �����"
"������"
"�������� ������"
"���� ����������, ����������� � �������, ������� ���������� - ������"
"������ ��� �����"
"�����������"
"�������"
"�����"
"������� � ������"
"�����"
"���� �������� ���������"
"��������"
"�������"
"������������"
"������������������䳿��"
"���� �������"
"������� Գ�����"
"��������"
"�������� �����"
"���������� �������"
"����"
"�����"
"���������� � �����"
"����� � �������� ������� ������ �� ������ ������� �������"
"���������� ����"
"���������"
"�����������"
"��������"
"��������"
"���������� ��������"
"������ �����"
}

set digplaces {
	"� ������ ������������"
	"� ������ �������"
	"� ������ ���"
	"� �������� ����"
	"� ������� ������� ����"
	"� ����� �������� �����"
	"�� ��� ������"
	"��� �������"
	"� ����"
	"�� �������� ������"
	"� ������������ ���������"
	"� ������������ ������"
	"�� ������"
	"� ����"
}	
	

set huntplaces {
"������"
"�����"
"��"
"�����"
"�����"
"����� �����"
"��� ��������"
"������ ��������"
"���"
"���� ������"
"�������� ������"
"������ �������� ������"
"������� �����"
}

set fishplaces {
"����"
"�����"
"����"
"������� �����"
"ϳ������ ���������� �����"
"��������� �����"
"������� ������"
"�������"
"������"
}

proc time:replace { arg } {
regsub -all -- {seconds} $arg "������(�)" arg
regsub -all -- {minutes} $arg "������(�)" arg
regsub -all -- {minute} $arg "������" arg
return $arg
}

## ���. ��������� ��������� ����� � "������������" ���������.
proc service:detcl { text } {
  return [string map {\\ !1 \[ !2 \] !3 \{ !4 \} !5 \^ !6 \" !7 { } !8} $text]
}

set repeat "3600"
proc dig {nick uhost hand chan args} {
global lastcall repeat
  if { [info exist lastcall([service:detcl $nick])]&&[expr [unixtime]-$lastcall([service:detcl $nick])]<$repeat } { 
  set wtime [duration [expr $repeat-([unixtime]-$lastcall([service:detcl $nick]))]]
    putnotc $nick "����� �������, �� ��������� ��, ����� �� ���� [time:replace $wtime] �� ���������. ���� ����� ������ ������"
    return 0
  }
  set lastcall([service:detcl $nick]) [unixtime]
global digtargets dig digplaces hunttargets fish fishplaces huntplaces
	set digplace [lindex $digplaces [rand [llength $digplaces]]]
	set artefakt [lindex $digtargets [rand [llength $digtargets]]]
      if ![file exists "digtrophy"] {
       set f [open "digtrophy" w]
       puts $f "Rex 5 ������� ���"
       close $f
      }
	set f [open "digtrophy" r]
	gets $f digrecord
	close $f
	set maxweight [lindex $digrecord 1]
      set maxweight [expr $maxweight + 100]
	set weightnumber [rand $maxweight]
	putserv "PRIVMSG $chan :\00302�� ������ �������� $digplace, �� ������� ���� ������, �� ���� ��������... �� � ��?"
	if [rand 2] {
		putserv "privmsg $chan :\00302�������������,\00313 $nick!\00302 �� ����� �������� $artefakt, �� - $weightnumber!"
	} else {
		switch [rand 7] {
		0 { putserv "privmsg $chan :\00302����������� �� ��� ���� $digplace,\00313 $nick,\00302 ����� �� �� ��������! ����, ��������� � ������ ����?" }
		1 { putserv "privmsg $chan :\00302����������� �� ��� ���� $digplace,\00313 $nick,\00302 �� ���������� ���� ��������, �� �������� ���� ������ ���� ���������� ��� ������� � ��� � ���� ����" }
		2 { putserv "privmsg $chan :\00302����������� �� ��� ���� $digplace,\00313 $nick,\00302 �� ������ �� ����� ������ � ��� �� ������, �� ����������� � ������ ����� ������� ����, � ���� ������ �� ��� ����������..." }
		3 { putserv "privmsg $chan :\00302����������� �� ��� ���� $digplace,\00313 $nick,\00302 �� ���������� �� ���� ������ � ����������, ��������� ���� �� �������... �������, ��������� � ������ ����?" }
		4 { putserv "privmsg $chan :\00302����������� �� ��� ���� $digplace,\00313 $nick,\00302 ���������� �������� ����, ���� �� �� �� �������� - ���� ���������� �����..." }
		5 { putserv "privmsg $chan :\00302����������� �� ��� ���� $digplace,\00313 $nick,\00302 �� �������� ����, �� ���������� �� ����, � ��������, �� ���� ����� �������� �������� �����..." }
		6 { putserv "privmsg $chan :\00302����������� �� ��� ���� $digplace,\00313 $nick,\00302 �� �������� ���������������� ������, ���� ���������� ��������..." }
		}
		return 1
	}
set f [open "digtrophy" r]
gets $f digrecord
close $f
if { $weightnumber > [lindex $digrecord 1] } {
	putserv "privmsg $chan :\00304����������!!! �� ����� ������! ��� �������,\00313 $nick!\00304 ������ !����� ��� �� ��������!"
	#putserv "privmsg $chan :$chan ����� ������ � ��� ���� $artefakt  ����� � $weightnumber � ��������� ����� ������!"
	set f [open "digtrophy" w]
	puts $f "$nick $weightnumber $artefakt"
	close $f
	return 1
} else {
	putserv "privmsg $chan :\00302�������\00313 $nick, \00302��� �� �������� �� �����! ��������� ����� �����!"
	return 1
}
}


proc hunt {nick uhost hand chan args} {
global lastcall repeat
  if { [info exist lastcall([service:detcl $nick])]&&[expr [unixtime]-$lastcall([service:detcl $nick])]<$repeat } { 
  set wtime [duration [expr $repeat-([unixtime]-$lastcall([service:detcl $nick]))]]
    putnotc $nick "��������� [time:replace $wtime] �� ������� ������ ������ ���������."
    return 0
  }
  set lastcall([service:detcl $nick]) [unixtime]
global hunttargets fish fishplaces huntplaces
	set huntplace [lindex $huntplaces [rand [llength $huntplaces]]]
	set critter [lindex $hunttargets [rand [llength $hunttargets]]]
      if ![file exists "hunttrophy"] {
       set f [open "hunttrophy" w]
       puts $f "Nerfbendr 5 Ant"
       close $f
      }
	set f [open "hunttrophy" r]
	gets $f huntrecord
	close $f
	set maxweight [lindex $huntrecord 1]
      set maxweight [expr $maxweight + 75]
	set weightnumber [rand $maxweight]
	putserv "PRIVMSG $chan :\00302�� �������� � $huntplace, �� ���� ����... �� ��������!!!"
	if [rand 2] {
		putserv "privmsg $chan :\00302�������������,\00313 $nick!\00302 �� ����� ������� � ��� ���� $critter ����� � $weightnumber ���!"
	} else {
			switch [rand 10] {
			0 { 
			      putserv "privmsg $chan :\00302�� ��������� � ������������... ����� ��������� ������, ������� ����� ��������, �� �������, �� ������� ��� ������ ��� ������� �������, ������� � ���� ������� � ������ ������� ������, ����������� ������ ���������."
			      putserv "privmsg $chan :\00302    �i����� - ���������� �����������, �����-�����, ���� ����� ����� ��������� �� �� ���������� ����.."
			      putserv "privmsg $chan :\00302    �������� - ���-��������, ���� �� ����� ������ ����������� ��������� ����� �� ������."
			      putserv "privmsg $chan :\00302    ����� - �������, ���-����� �������, � ���� ��������� ������ �'����� ����� ���� ����� �������� � �������... � �������� �� ��� ���, �� �� ������ ����쳺��, �� ����� �� �����..."
		 	}
			1 {
			      putserv "privmsg $chan :\00302�� ���������... �� �� ����� ���� ��� ����� ������... �� ����� ��������� ������... "
			      putserv "privmsg $chan :\00302�� �������� ������������ ����� �� ���� �������� � �������� �����... ��� ���������� ���� ����� �� ����� ���������� ������ �����..."
			}
			2 {
			      putserv "privmsg $chan :\00302�� ���������, � ��������, �� ������� � ��������� ������... ���� ��� ����... ���������� ���� ���������... �������..."
			}
			3 {
			      putserv "privmsg $chan :\00302�� ��������� � ������������! �� �� ����� ��� ���� �� ������, �� ��� ���������� ���� � ������ ��� ��������� �������� �� �������, �� �� ����� ���������..."
			}
			4 {
			      putserv "privmsg $chan :\00302�� ��������� � ������������! �� �� ����� ��� ���� �� ������, �� ��� ���������� ���� � ������ ������ �������� ������ ��������, ������� �������������..."
			}
			5 {
			      putserv "privmsg $chan :\00302�� ��������� � ������������! �� ������ ����� ������ ������, ���� ����� �� �����, ��������� ��� ��� ��� ������, ������� � ��������..."
			}
			6 {
			      putserv "privmsg $chan :\00302������� �� ���������, � ���� ������� ��������� ���� �� ������������ �������� ���� ������ �����..."
			}
			7 {
			      putserv "privmsg $chan :\00302�� ��������� � ������������... ����� ��������� ������, ������� ����� ��������, �� ������� ���������� ���� � ���� ������... ������ �� �� �������... �� ���� ���� ���������� ������� ����..."
			}
			8 {
			      putserv "privmsg $chan :\00302�� ��������� � ������������... ����� ��������� ������, ������� ����� ��������, �� ������� ������� ��������� ������ � �������� ������������� �����... ³� �������� � ����� �� ��� ��� ���� �����������: \"�, ���� �'���, ��� ���� ����� ���� �����, �� ���� ��������� �������� ...\""
			}
			9 {
			      putserv "privmsg $chan :\00302�� ��������� � ������������... ������ ������� ���������..."
			      putserv "privmsg $chan :\00302���������� � ������ �� ��� ��������� ������ ������, ������� ��� �� ������ � ���������, �� �� ��������� ���������..."
			}
			}
		
		return 1
	}
set f [open "hunttrophy" r]
gets $f huntrecord
close $f
if { $weightnumber > [lindex $huntrecord 1] } {
	putserv "privmsg $chan :\00304���!!! �� ����� ������, ��� ������� \00313 $nick!\00304 ������ !����� ��� �� ��������!"
	#putserv "privmsg $chan :$chan ����� ������� � ��� ���� $critter  ����� � $weightnumber ������� �� ���������� ����� ������!"
	set f [open "hunttrophy" w]
	puts $f "$nick $weightnumber $critter"
	close $f
	return 1
} else {
	putserv "privmsg $chan :\00302���! �������\00313 $nick, \00302��� �� ������ �� �����."
	return 1
}
}


proc fish {nick uhost hand chan args} {
global lastcall repeat
  if { [info exist lastcall([service:detcl $nick])]&&[expr [unixtime]-$lastcall([service:detcl $nick])]<$repeat } { 
  set wtime [duration [expr $repeat-([unixtime]-$lastcall([service:detcl $nick]))]]
    putnotc $nick "�� ��������� ������� (�� ����� ���'���� ��) �������� [time:replace $wtime]. ϳ���� ����� ���� ������..."
    return 0
  }
  set lastcall([service:detcl $nick]) [unixtime]
global hunttargets fish fishplaces huntplaces
	set fishplace [lindex $fishplaces [rand [llength $fishplaces]]]
	set fishtocatch [lindex $fish [rand [llength $fish]]]
      if ![file exists "fishtrophy"] {
       set f [open "fishtrophy" w]
       puts $f "Nerfbendr 5 Guppie"
       close $f
      }
	set f [open "fishtrophy" r]
	gets $f fishrecord
	close $f
	set maxweight [lindex $fishrecord 1]
	set maxweight [expr $maxweight + 50]
	set weightnumber [rand $maxweight]
	putserv "PRIVMSG $chan :\00302�� �������� ���� ����� � $fishplace �� ������� ���� � �������� ���� ������ �������..."
	if [rand 2] {
		putserv "privmsg $chan :\00302Bi���,\00313 $nick!\00302 �� ����� ������� $fishtocatch! �� �� $weightnumber ���!"
	} else {
		  switch [rand 9] {
			0 { 
			      putserv "privmsg $chan :\00302���, ���� ����� ��������,\00313 $nick!\00302 �� ���, ����� ���������?"
			}
			1 {
			      putserv "privmsg $chan :\00302���� ���������� ��������� � ������� ����� � ����... ����� ���������... �������..."
			}
			2 {
			      putserv "privmsg $chan :\00302�� ��������� �������, ���� ����������� ��� ���� ������������, ��, ��������� ��� ���� �� ������, ���������� ����� � ����..."
			}
			3 {
			      putserv "privmsg $chan :\00302�� ������� �����, ������� ���� �-�� ����, ����� ���� �� ����� ���� ����, �������� �������� �����������"
			}
			4 {
			      putserv "privmsg $chan :\00302�� ����� �� �������, ������� �� ������ ����� ������� ��������� ����� \"���������, ������\" "
			}
			5 {
			      putserv "privmsg $chan :\00302�� �������� ���������� ����������� �����, �� ��� ��� ����� ���� �� ������, �� � �������� ����� � ����..."
			}
			6 {
			      putserv "privmsg $chan :\00302�� �������� ���� �������� ����������, �� ������� ������� �� ���� ���������� ��� �� ������."
			}
			7 {
			      putserv "privmsg $chan :\00302�� ��������� � ���� ����, � ��� � 3 ������� �� � ��������� �� �����... ���� �� ������error1s5w1g3%"
			}
			8 {
			      putserv "privmsg $chan :\00302�� ��������� � ���� �����, �� ��������� ��� ���� ������� ����� �� �������� �������� �� ���� ���� ����� � ���� ��� ������..."
			}
			}
		
		
		
		return 1
	}
set f [open "fishtrophy" r]
gets $f fishrecord
close $f
if { $weightnumber > [lindex $fishrecord 1] } {
	putserv "privmsg $chan :\00304��� ��� ���!!! �� � ����� ������! ����,\00313 $nick!\00304 ���� !����� �� � �� ��������."
	#putserv "privmsg $chan :$nick ����� ������� $fishtocatch �� $weightnumber ��� �� ��������� ����� ������!"
	set f [open "fishtrophy" w]
	puts $f "$nick $weightnumber $fishtocatch"
	close $f
	return 1
} else {
	putserv "privmsg $chan :\00302�������\00313 $nick,\00302 ��� �� �� ������! ������ �����, � ����������� ����'������ ���������!"
	return 1
}

}

proc newmonth {nick uhost hand chan args} {
global hunttargets fish fishplaces huntplaces
set f [open "fishtrophy" w]
puts $f "Nerfbendr 5 Guppie"
close $f
set f [open "digtrophy" w]
puts $f "Rex 5 ���"
close $f
set f [open "hunttrophy" w]
puts $f "Nerfbendr 5 Ant"
close $f
putserv "privmsg $chan :\00302��������� ����� ������� �����! ���� !cast �� !hunt ��� �����!"
return 1
}

proc trophy {nick uhost hand chan args} {
global hunttargets fish fishplaces huntplaces artefakt digplaces

if ![file exists "fishtrophy"] {
set f [open "fishtrophy" w]
puts $f "Nerfbendr 5 ���"
close $f
}
if ![file exists "digtrophy"] {
set f [open "digtrophy" w]
puts $f "Rex 5 ������� ���"
close $f
}
if ![file exists "hunttrophy"] {
set f [open "hunttrophy" w]
puts $f "Nerfbendr 5 ���"
close $f
}
set f [open "fishtrophy" r]
gets $f fishrecord
close $f
set f [open "digtrophy" r]
gets $f digrecord
close $f
set f [open "hunttrophy" r]
gets $f huntrecord
close $f
putserv "privmsg $chan :\00304[lindex $fishrecord 0] - ��� ��������� ������ ������ � �������, ������� - [lrange $fishrecord 2 end] �� [lindex $fishrecord 1] ���!"
putserv "privmsg $chan :\00304[lindex $huntrecord 0] - ��� ������� ���� ������������-���������, �������� [lrange $huntrecord 2 end]! ����� � [lindex $huntrecord 1] ���!"
putserv "privmsg $chan :\00304[lindex $digrecord 0] - ��� �������� ��������� ��������, ������� [lrange $digrecord 2 end]! B�� ��������� -  [lindex $digrecord 1]!"
return 1
}