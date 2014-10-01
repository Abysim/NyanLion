## Google weather v1.0
## by Vertigo@RusNet
## last edited: 24-Aug-2010
## ��������������������������
## for enable script: .chanset #channel +gw

namespace eval ::gw {

package require http 2.7

variable lang "ru"

bind pub - .w [namespace current]::gw:pub
bind pub - .� [namespace current]::gw:pub

setudef flag gw


proc gw:pub {nick uhost hand chan text} {

if {![channel get $chan gw]} {return}

if {[string is space $text]} {putserv "PRIVMSG $chan :$nick: ���������: $::lastbind \<�����\> - ������ �� Google�."; return}

::http::config -useragent {Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.2.15 Version/10.60} -urlencoding utf-8

variable lang

set t_st [clock clicks -microseconds]
set token [::http::geturl "http://www.google.com/ig/api?weather=[::http::formatQuery $text]&hl=$lang" -timeout 10000]
set gwdata [::http::data $token]
::http::cleanup $token

set gwdata [string map "{\x0A} {} {<forecast_conditions>} {\x0A<forecast_conditions>}" $gwdata]

set city [lindex [regexp -nocase -inline -- {<postal_code data="(.+?)"/>} $gwdata] 1]
if {![string is space city]} {set city [string totitle $city]} {putserv "PRIVMSG $chan :$nick: ��� ���������� ��� '$text'"; return}

if {![regexp -- {<forecast_date data="(.+?)"/>} $gwdata -> date]} {set date [clock format [clock seconds] -format %Y-%m-%d]}

if {![regexp -nocase -- {<condition data="(.+?)"/>.*?<temp_c data="([\+\-]?\d+)"/><humidity data="(.+?)"/>.*?<wind_condition data="(.+?)"/>} $gwdata -> csky ctemp chum cwind]} {
if {[regexp -- {<problem_cause data="(.+?)"/>} $gwdata -> wmsg]} {
putserv "PRIVMSG $chan :$nick: $wmsg"
return
} else {
putserv "PRIVMSG $chan :$nick: ��������, ����� \"$text\" �� ������."
return
}
}

set wlist [list]
foreach _ [split $gwdata \n] {
if {[regexp -- {<forecast_conditions><day_of_week data="(.+?)"/><low data="([\+\-]?\d+)"/><high data="([\+\-]?\d+)"/>.*?<condition data="(.+?)"/></forecast_conditions>} $_ -> day tnight tday sky]} {
lappend wlist "[string map -nocase {�� "� �����������" �� "�� �������" �� "� �����" �� "� �������" �� "� �������" �� "� \00304�������\003" �� "� \00304�����������\003"} $day]: ����: [gw:tcolor $tday] �C, �����: [gw:tcolor $tnight] �C; [string tolower $sky]"
}
}
set t_end "[format %.2f [expr ([clock clicks -microseconds] - $t_st)/1000.0]]��"

putquick "PRIVMSG $chan :������ � ������ \002$city\002 �� $date: [string tolower $csky]; [gw:tcolor $ctemp] �C; [string tolower $chum]; [string map {�, ����., �, ���., �, ��., �, ���., ��, ���-����., ��, ���-���., ��, ���.-����., ��, ���.-���.,} [string tolower $cwind]]. [string map {�c �C} [string totitle [join $wlist " \002::\002 "]]] ($t_end)."

}

proc gw:tcolor {t} {
set t [regsub -- {^([1-9]+)$} $t "\00304\+\\1\003"]
set t [regsub -- {^\-([1-9]+)$} $t "\00312\-\\1\003"]
return $t
}

return "[file tail [info script]] by Vertigo@RusNet loaded"
}