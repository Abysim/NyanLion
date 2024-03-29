## Google weather v1.0
## by Vertigo@RusNet
## last edited: 24-Aug-2010
## 覧覧覧覧覧覧覧覧覧覧覧覧覧
## for enable script: .chanset #channel +gw

namespace eval ::gw {

package require http 2.7

variable lang "ru"

bind pub - .w [namespace current]::gw:pub
bind pub - .� [namespace current]::gw:pub

setudef flag gw


proc gw:pub {nick uhost hand chan text} {

if {![channel get $chan gw]} {return}

if {[string is space $text]} {putserv "PRIVMSG $chan :$nick: ﾈ�����銛�: $::lastbind \<胛��臀> - ��胛萵 �� Google�."; return}

::http::config -useragent {Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.2.15 Version/10.60} -urlencoding utf-8

variable lang

set t_st [clock clicks -microseconds]
set token [::http::geturl "http://www.google.com/ig/api?weather=[::http::formatQuery $text]&hl=$lang" -timeout 10000]
set gwdata [::http::data $token]
::http::cleanup $token

set gwdata [string map "{\x0A} {} {<forecast_conditions>} {\x0A<forecast_conditions>}" $gwdata]

set city [lindex [regexp -nocase -inline -- {<postal_code data="(.+?)"/>} $gwdata] 1]
if {![string is space city]} {set city [string totitle $city]} {putserv "PRIVMSG $chan :$nick: ﾍ褪 竟����璋韋 蓁� '$text'"; return}

if {![regexp -- {<forecast_date data="(.+?)"/>} $gwdata -> date]} {set date [clock format [clock seconds] -format %Y-%m-%d]}

if {![regexp -nocase -- {<condition data="(.+?)"/>.*?<temp_c data="([\+\-]?\d+)"/><humidity data="(.+?)"/>.*?<wind_condition data="(.+?)"/>} $gwdata -> csky ctemp chum cwind]} {
if {[regexp -- {<problem_cause data="(.+?)"/>} $gwdata -> wmsg]} {
putserv "PRIVMSG $chan :$nick: $wmsg"
return
} else {
putserv "PRIVMSG $chan :$nick: ﾈ鈔竟頸�, 胛��� \"$text\" �� �琺蒟�."
return
}
}

set wlist [list]
foreach _ [split $gwdata \n] {
if {[regexp -- {<forecast_conditions><day_of_week data="(.+?)"/><low data="([\+\-]?\d+)"/><high data="([\+\-]?\d+)"/>.*?<condition data="(.+?)"/></forecast_conditions>} $_ -> day tnight tday sky]} {
lappend wlist "[string map -nocase {ﾏ� "� ���裝褄��韭" ﾂ� "粽 糘���韭" ﾑ� "� ��裝�" ﾗ� "� �褪粢��" ﾏ� "� ����頽�" ﾑ� "� \00304��矣���\003" ﾂ� "� \00304粽���褥褊�藹003"} $day]: 蓖褌: [gw:tcolor $tday] ｰC, �����: [gw:tcolor $tnight] ｰC; [string tolower $sky]"
}
}
set t_end "[format %.2f [expr ([clock clicks -microseconds] - $t_st)/1000.0]]��"

putquick "PRIVMSG $chan :ﾏ�胛萵 � 胛��蒟 \002$city\002 �� $date: [string tolower $csky]; [gw:tcolor $ctemp] ｰC; [string tolower $chum]; [string map {�, 粽��., �, 鈞�., �, ��., �, �裘., ��, �胛-粽��., ��, �胛-鈞�., ��, �裘.-粽��., ��, �裘.-鈞�.,} [string tolower $cwind]]. [string map {ｰc ｰC} [string totitle [join $wlist " \002::\002 "]]] ($t_end)."

}

proc gw:tcolor {t} {
set t [regsub -- {^([1-9]+)$} $t "\00304\+\\1\003"]
set t [regsub -- {^\-([1-9]+)$} $t "\00312\-\\1\003"]
return $t
}

return "[file tail [info script]] by Vertigo@RusNet loaded"
}