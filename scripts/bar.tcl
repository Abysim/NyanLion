#################################################################################
# ��������: 
#	����������� ���, �������� � ���� ���������� ����� �������� � ���������� ��������
#	���������� ���-����. �������� ����� �������������� �������. ������ �� �������������
#	������� ���� �� ������������ ������. ��� �� ����� �������� �� ������� ���� !���� ����
#	� �.�., ������ ������� ����� �� ��, ���� �� ��� �� ������. ����������� ��������� 
#	������������� ������� !���� <���_������_����>.
#
# �������:
#	!���
#	!����
#	!�����
#	!������
#	!�������
#	!����
#	!����������
#	!����
#	!���
#	!���
#	!����
#
# ���������:
# http://www.hackersforce.com
# http://forum.hackersforce.com
# irc.hackersforce.com:6667 - #hackers
#
# �����:
#	����
#
# ����� ������:
#	.chanset #chan +nopubbar - �������� ����� ������� ���� �� ������ #chan
#	.chanset #chan -nopubbar - ������� ����� ������� ���� �� ������ #chan
#	������� �������� � partyline (DCC CHAT) � ����.
#
# ������: 
#	1.0
#################################################################################
# ������� ������:
#
# ������ 1.0
#	+ �� ������ ��� �� ���� ���� ��������� ��������� ������
#	+ ����������� ������� ������������� ���� �� ������������ ������
#	+ ����� ����� ��������� �������������� ������� �� ������.
#	+ �������� �� ����������� ���� �� ������, ����� �� ������ ��������: 
#	"!���� ���� � ������" � �.�.
#	+ �������� help ���-����, � ������������ ������ ��� ������.
#	+ ����������� ��������� ������������ ������� ���� �� ������� ������������� 
#	� ������� ����. ��� ����� �������� �������, � ������ ������� �������� �� ����� 
#	������������.
#################################################################################
setudef flag nopubbar

# ������� ����� �������������� ������
set bar(prefix) "!"

# ����� ����� ��������� �������������� ������ ���� (� ��������).
set bar(time) 0

# ������ ������ ����� �� ������� !��� (1 - �������������, 0 - ������������)
set bar(helpmode) 1

# ��� ������� ��� ������� ������������ ������� ���� � ������� ����. ������ !���� <��� ����>
# 0 - ��������� ������������ ���������� ���-�� � ���� ��� ����
# 1 - ��������� ������������ ���������� ���-�� � ���� ��� ����, ����� ��� ����� �������� �������
# �����, �� ��� ��� ������ ������. � ������ ������� �������� �� ���� ������������ �� ������.
set bar(botuse) 1

# ������ �����������
set bar(find) {
 {����� � ����}
 {����� � ����}
 {���� � ������}
 {���� � �����}
 {����� � ��������}
 {�������� � �������}
 {�����}
}

# ����� �������� ��������
set bar(put) {
 {�� �������}
 {�� ������������, �������}
 {�� ���������, �������}
 {�� ���������, �������}
 {�� �������}
 {�� ���������}
 {�� ����������� ����}
 {�� �������� ��������}
 {�� ���������� ������}
 {� �������� �������� �}
 {�� ������ ������� ������ �������}
 {��, ������� ������� ������, �������}
}

# ����� �����, ����� ����������� �������� ��. ����� ���� ���������� ���-�� ��� ���� (���� bar(botuse) = 1)
set bar(notceruser) {
 {���!}
 {����� ��� � ���}
 {����! ��� � ������ �� �����!}
 {���! � ���� ������!}
 }

# �������� ���� (::), ��� ������� ������������ ������� ���� � ������� ����, �� ���� ���� (���� bar(botuse) = 1)
set bar(erruser) {
 {����!}
 {������}
 {���� ������� ����� �� �����}
} 


set bar(version) 1.0
set bar(autors) MPAK
set bar(email) mpak@nordlines.ru



bind pub - $bar(prefix)���� pub:kofe
bind pub - $bar(prefix)kofe pub:kofe
bind pub - $bar(prefix)���� pub:kofe
bind pub - $bar(prefix)���� pub:kofe
bind pub - $bar(prefix)��� pub:sok
bind pub - $bar(prefix)sok pub:sok
bind pub - $bar(prefix)�� pub:sok
bind pub - $bar(prefix)juice pub:sok
bind pub - $bar(prefix)���� pub:sok
bind pub - $bar(prefix)��� pub:tea
bind pub - $bar(prefix)��� pub:tea
bind pub - $bar(prefix)tea pub:tea
bind pub - $bar(prefix)���� pub:voda
bind pub - $bar(prefix)���� pub:voda
bind pub - $bar(prefix)water pub:voda
bind pub - $bar(prefix)���� pub:voda



proc pub:pivo {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {��������� ���� '��������'}
 {������� ���� '��������'}
 {����� ���� '��������'}
 {��������� ���� 'LowenBrau'}
 {������� ���� 'LowenBrau'}
 {����� ���� 'LowenBrau'}
 {��������� ���� '������������'}
 {������� ���� '������������'}
 {����� ���� '������������'}
 {��������� ���� '������� �������'}
 {������� ���� '������� �������'}
 {����� ���� '������� �������'}
 {��������� ���� '�������� ������'}
 {������� ���� '�������� ������'}
 {����� ���� '�������� ������'}
 {��������� ���� '��������� 1715'}
 {������� ���� '��������� 1715'}
 {����� ���� '��������� 1715'}
 {������� ������� ������ ���� ��� ���}
 {����� ��� ����� �� �����, ������� ������ ������ ���� ��� ���}
 {��������� ���� '������'}
 {������� ���� '������'}
 {����� ���� '������'}
 {��������� ���� '������������ �����'}
 {������� ���� '������������ �����'}
 {����� ���� '������������ �����'}
 {��������� ���� 'Warsteiner'}
 {������� ���� 'Warsteiner'}
 {����� ���� 'Warsteiner'}
 {��������� ���� 'ZIP'}
 {������� ���� 'ZIP'}
 {����� ���� 'ZIP'}
 {��������� ���� '������������'}
 {������� ���� '������������'}
 {����� ���� '������������'}
 {��������� ���� 'Staropramen'}
 {������� ���� 'Staropramen'}
 {����� ���� 'Staropramen'}
 {��������� ���� '���������'}
 {��������� ���� 'Kozel'}
 {������� ���� 'Holsten'}
 {����� ���� 'Gold Pfeasant'}
 {����� ���� '�����������'}
 {����� ���� '������� N1'}
 {����� ���� '������� N2'}
 {����� ���� '������� N3'}
 {����� ���� '������� N4'}
 {����� ���� '������� N5'}
 {����� ���� '������� N6'}
 {����� ���� '������� N7'}
 {����� ���� '������� N8'}
 {����� ���� '������� N9'}
 {����� ���� '������� N10'}
 {����� ���� '������� N11'}
 {����� ���� '������� N12'}
 {����� ���� '���������� ������� ������'}
 {������� ���� '�����������'}
 {������� ���� '������� N1'}
 {������� ���� '������� N2'}
 {������� ���� '������� N3'}
 {������� ���� '������� N4'}
 {������� ���� '������� N5'}
 {������� ���� '������� N6'}
 {������� ���� '������� N7'}
 {������� ���� '������� N8'}
 {������� ���� '������� N9'}
 {������� ���� '������� N10'}
 {������� ���� '������� N11'}
 {������� ���� '������� N12'}
 {������� ���� '���������� ������� ������'}
 {������ ���� '�����������'}
 {������ ���� '������� N1'}
 {������ ���� '������� N2'}
 {������ ���� '������� N3'}
 {������ ���� '������� N4'}
 {������ ���� '������� N5'}
 {������ ���� '������� N6'}
 {������ ���� '������� N7'}
 {������ ���� '������� N8'}
 {������ ���� '������� N9'}
 {������ ���� '������� N10'}
 {������ ���� '������� N11'}
 {������ ���� '������� N12'}
 {������ ���� '���������� ������� ������'}
 {��������� ���� 'Zipfer'}
 {������� ���� 'Zipfer'}
 {����� ���� 'Zipfer'}
 {��������� ���� '������'}
 {������� ���� '������'}
 {����� ���� '������'}
 {��������� ���� 'Tuborg'}
 {������� ���� 'Tuborg'}
 {����� ���� 'Tuborg'}
 {��������� ���� 'Carlsberg'}
 {������� ���� 'Carlsberg'}
 {����� ���� 'Carlsberg'}
 {������ ������}
 {������ ������}
 {�������� � ���������}
 {����� ���� '�����������'}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017"
 }
}

proc pub:vodka {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {������� ����� '��������', ������ ������}
 {������� ����� '5 ������', �������� ������}
 {������� ����� '�������', ������ � �������}
 {������� ����� '�������', ������ � �����}
 {������� ����� '��������', ������ � �������� ������}
 {������� ����� '������', ������ � ������}
 {������� ����� '���� ����������', �������� � ������}
 {������� ����� '�������', ������������� ������ � �������,}
 {������� ����� '��������', ������ � �����}
 {������� ����� '������� ���', �������� � �����}
 {������ ������, �������� � �����}
 {����� ��������, �������� � �����}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:voda {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {�������� ���� '���� ̳������', ����� � �������}
 {�� ������ �������� ���� '��� ����'}
 {���� '���������'}
 {������ � ����� '������', ����� � �����}
 {������ ���� '������'}
 {������ ������ ���� '�������', ����� � �������}
 {���� '���������-7', ����� � ������}
 {������ ���� '������', ����� � ������}
 {�������� ������� '���������-3', ������������ ����� � �����}
 {���� '������������', ������� � �������}
 {������� ���� 'Pepsi'}
 {�������� ���� 'Coca-Cola'}
 {�������� ���� 'Pepsi', ����� � �������}
 {�������� ���� 'Coca-Cola', �������� ����� � �������}
 {������� 'Sprite'}
 {������ ������ ���� '7 UP', ����� � �������}
 {���� 'Fanta', ����� � �����}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:kokteil {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {�������� '�������� ����'}
 {������� ��������'��������'}
 {����� �������� '����� ������'}
 {�������� '����� ����'}
 {������� �������� '�����'}
 {�������� '���������'}
 {�������� '��������'}
 {����� �������� '��������'}
 {�������� 'Bravo'}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:vino {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(find) {
 {������� �� ����}
 {�������� �� ����}
 {����� � �����}
 {����� �� �����}
 {������� �� �������}
 {������� �� ��������}
 {�������� �� ��������}
 {�������� �� ��������}
 {������}
}

set bar(drink) {
 {������� ���� '�����', ������ �����}
 {������� ���� '��������', ��������� ������ �����}
 {���� '�����', ��������� ������ �����}
 {������� ���� '����� ������a', ������ �����}
 {���� '������� �����', ������ �����}
 {������� ���� '��������� �����', ��������� ������ �����}
 {���� '������� �����', ������ �����}
 {������� ���� '������� �����', ��������� ������ ���������}
 {���� '���� �� ���', ������ �����}
 {������� ���� '������� �����', ��������� ������, ������ �����}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:kofe {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {����� 'Nescafe', �������� ������, ���������� ������� ( http://fun-gallery.com/wp-content/uploads/2011/06/Cat-Coffee-Art.jpg )}
 {����� 'Nescafe', ���������� ������� �������� ���� ( http://fun-gallery.com/wp-content/uploads/2011/06/Bunny-Coffee-Art.jpg )}
 {����� ���� 'Jacobs', ���������� ������� ( http://fun-gallery.com/wp-content/uploads/2011/06/Panda-Coffee-Art.jpg )}
 {���� 'Chibo', ���������� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-8.jpg )}
 {'�������', ������� ������� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-7.jpg )}
 {����� ������� ����, �������, ���������� ������� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-6.jpg )}
 {����� ������� ����, �������, ���������� ������� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-5.jpg )}
 {������ ����, ���������� ������� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-4.jpg )}
 {����, ���� ���������� ����, ����� ������� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-2.jpg )}
 {������� ����, ����������� � �� ����� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-3.jpg )}
 {������� ����, ���� ����� ��� ���... ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-1.jpg )}
 {������ � �����, ����� � ����� � ������� ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-.jpg )}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:sok {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� ��������� �� ������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {����� ���� 'Jaffa', ����� � �������}
 {�� '�������', �������� ����� � �������}
 {������������ ��}
 {����� ������������� ����, ����� � �������}
 {����� ���� '������', �������� ����� � �����}
 {����� ���� 'Santal', ����� � �������}
 {�� '�����'}
 {���������� ��, ����� � ���������}
 {�� '��������� ���', ����� � �������}
 {�� 'Rich', ����� � ������}
 {�� 'Rich', �������� ����� � �������}
 {��� '������ �������', ����������� ������� � �������}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:koniak {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� ��������� �� ������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033���� ��� ������� ���� ���� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {������ '�������', �������� �����}
 {������� ������� '����', ��������� ������ �����}
 {������ '������������', ������ ������}
 {������ '�������', ��������� ������ ������}
 {������� ������� '������', ������ �����}
 {������� ������� '�������', ������� ������ ����� }
 {������ '�����', ������ �������}
 {������� ������� '����-������', ��������� ������ �����}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:shampanskoe {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {���������� '��������', ������ �����}
 {'���������' ����������, ��������� ������ �����}
 {������� ����������� '������', ������ �����}
 {���������� '������', ��������� ������ �����}
 {������� '���� �������', ������� ������ �����}
 {���������� '����� �����', ������ �����}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:tea {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {���(��)} temp 
	        regsub -all -- {hour} $temp {���} temp 
		regsub -all -- {minutes} $temp {�����(�)} temp
        	regsub -all -- {minute} $temp {������} temp
		regsub -all -- {seconds} $temp {������(�)} temp
		regsub -all -- {second} $temp {�������} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033����� ������� ���� ����� �������� ����� \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {��� 'Lipton', ������� ������}
 {��� '�����', ������� ������}
 {��� '�����', ������� � ������}
 {��� '̳�����', ������� ������}
 {'���������' ���, �������}
 {������� ���, ������ �����, ������ ���, ������ � �����'� �� ������}
 {����������� ��� ���� ���������� �� ��������� ������� �� ������ ��䳿}
 {����� ����� �����}
 {����� �������}
 {����� �� ������� ����� � ��������}
 {���� �� ������ ����� �������� �������}
}

set bar(action) [list [lindex $bar(find) [rand [llength $bar(find)]]] [lindex $bar(drink) [rand [llength $bar(drink)]]] [lindex $bar(put) [rand [llength $bar(put)]]]]
set bar(procnotceruser) [lindex $bar(notceruser) [rand [llength $bar(notceruser)]]]
set bar(procerruser) [lindex $bar(erruser) [rand [llength $bar(erruser)]]]

regsub -all -- {\{} $bar(action) {} bar(action)
regsub -all -- {\}} $bar(action) {} bar(action)

 if {$args == ""} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $nick\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 1} {
  putserv "NOTICE $nick :$bar(procnotceruser)"
  putserv "PRIVMSG $chan :\001ACTION :: $nick $bar(procerruser)\001"
 return 0
 }
 if {$args == $botnick && $bar(botuse) == 0} {
   putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 return 0
 }
 if {[onchan $args $chan]} {
  putserv "PRIVMSG $chan :\001ACTION $bar(action) $args\001"
 } else {
  putserv "NOTICE $nick :\0037\002$args\002\00310 ������� �� ����� \0037\002$chan\017" 
 }
}

proc pub:barhelp {nick uhost hand chan args} {
 global botnick bar

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return 
 }

 if {$bar(helpmode) == 1} {
  putserv "PRIVMSG $nick :���� ���� � \002$botnick\002"
  putserv "PRIVMSG $nick :\002$bar(prefix)���\002 - ���� ���� � $botnick"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� ������ ��� ������������ ����"
  putserv "PRIVMSG $nick :\002$bar(prefix)�����\002 - ��� ������ ��� ����������� �����"
  putserv "PRIVMSG $nick :\002$bar(prefix)������\002 - ��� ������ ��� ������"
  putserv "PRIVMSG $nick :\002$bar(prefix)�������\002 - ��� �������� � �������� ��� ������ ��� ��������"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� �������� � ������ ���� ���������� ��� ���"
  putserv "PRIVMSG $nick :\002$bar(prefix)����������\002 - ��� ������ ��� �����������"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� ���������� ��������� ��� ����"
  putserv "PRIVMSG $nick :\002$bar(prefix)���\002 - ��� ���������� ��� ���"
  putserv "PRIVMSG $nick :\002$bar(prefix)���\002 - ��� �������� ��� ������ ��� ���"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� �������� � �������� ��� ��� ������ ����"
  putserv "PRIVMSG $nick :�������������: \002$bar(prefix)����\002 - $botnick ������ ��� ����, \002$bar(prefix)���� <���>\002 - $botnick ������ ���� \002<���>\002"
 return
 } else {
  putserv "NOTICE $nick :\00310������� ���� � \002$botnick\002: \0037$bar(prefix)����, $bar(prefix)�����, $bar(prefix)������, $bar(prefix)�������, $bar(prefix)����, $bar(prefix)����������, $bar(prefix)����, $bar(prefix)���, $bar(prefix)���, $bar(prefix)����\017"
  putserv "NOTICE $nick :\00310�������� �������������:\0037 $bar(prefix)����\00310 - $botnick ������ ��� ����,\0037 $bar(prefix)���� <���>\00310 - $botnick ������ ���� <���>\017"
 }
}

proc msg:barhelp {nick uhost hand args} {
 global botnick bar

 if {$bar(helpmode) == 1} {
  putserv "PRIVMSG $nick :���� ���� � \002$botnick\002"
  putserv "PRIVMSG $nick :\002$bar(prefix)���\002 - ���� ���� � $botnick"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� ������ ��� ������������ ����"
  putserv "PRIVMSG $nick :\002$bar(prefix)�����\002 - ��� ������ ��� ����������� �����"
  putserv "PRIVMSG $nick :\002$bar(prefix)������\002 - ��� ������ ��� ������"
  putserv "PRIVMSG $nick :\002$bar(prefix)��������\002 - ��� �������� � �������� ��� ������ ��� ��������"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� �������� � ������ ���� ���������� ��� ���"
  putserv "PRIVMSG $nick :\002$bar(prefix)����������\002 - ��� ������ ��� �����������"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� ���������� ��������� ��� ����"
  putserv "PRIVMSG $nick :\002$bar(prefix)���\002 - ��� ���������� ��� ���"
  putserv "PRIVMSG $nick :\002$bar(prefix)���\002 - ��� �������� ��� ������ ��� ���"
  putserv "PRIVMSG $nick :\002$bar(prefix)����\002 - ��� �������� � �������� ��� ��� ������ ����"
  putserv "PRIVMSG $nick :�������������: \002$bar(prefix)����\002 - $botnick ������ ��� ����, \002$bar(prefix)���� <���>\002 - $botnick ������ ���� \002<���>\002"
 return
 } else {
  putserv "NOTICE $nick :\00310������� ���� � \002$botnick\002: \0037$bar(prefix)����, $bar(prefix)�����, $bar(prefix)������, $bar(prefix)��������, $bar(prefix)����, $bar(prefix)����������, $bar(prefix)����, $bar(prefix)���, $bar(prefix)���, $bar(prefix)����\017"
  putserv "NOTICE $nick :\00310�������� �������������:\0037 $bar(prefix)����\00310 - $botnick ������ ��� ����,\0037 $bar(prefix)���� <���>\00310 - $botnick ������ ���� <���>\017"
 }
}

proc pub:barnone {nick uhost hand chan args} {
 global botnick bar

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310�� ������ \0037\002$chan\002\00310 ��� �������� �� ��������.\017\017"
 return 
 }
  putserv "NOTICE $nick :\0033����� ������� � ���� ���� ���. ����������� \0037\002$bar(prefix)���\002\0033 ��� ������������ � \0037'���� ���� � $botnick'\017"
}

proc bar:reset { uhost } {
 global bar
 catch {killutimer $bar(timer,$uhost)}
 catch {unset bar(timer,$uhost)}
 catch {unset bar(host,$uhost)}
}


putlog "bar.tcl v$bar(version) by $bar(autors) loaded - $bar(email)"