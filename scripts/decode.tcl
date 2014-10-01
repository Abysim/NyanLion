################################################################################
#                                                                              #
#      :::[  T h e   R u s s i a n   E g g d r o p  R e s o u r c e  ]:::      #
#    ____                __                                                    #
#   / __/___ _ ___ _ ___/ /____ ___   ___      ___   ____ ___ _     ____ __ __ #
#  / _/ / _ `// _ `// _  // __// _ \ / _ \    / _ \ / __// _ `/    / __// // / #
# /___/ \_, / \_, / \_,_//_/   \___// .__/ __ \___//_/   \_, / __ /_/   \___/  #
#      /___/ /___/                 /_/    /_/           /___/ /_/              #
#                                                                              #
################################################################################
#                                                                              #
# decode.tcl 1.0                                                               #
#                                                                              #
# Author: Stream@Rusnet <stream@eggdrop.org.ru>                                #
#                                                                              #
# Official support: irc.eggdrop.org.ru @ #eggdrop                              #
#                                                                              #
################################################################################

namespace eval decode {}

setudef flag nopubdecode

#################################################

bind pub - !decode	::decode::pub_decode
bind msg - !decode	::decode::msg_decode
bind pub - !d		::decode::pub_decode
bind msg - !d		::decode::msg_decode

#################################################
##### DON'T CHANGE ANYTHING BELOW THIS LINE #####
#################################################

set decode(ver)		"1.0"
set decode(authors)	"Stream@RusNet <stream@eggdrop.org.ru>"

#################################################

proc ::decode::out {nick chan text} {
	if {[validchan $chan]} {putserv "PRIVMSG $chan :\002$nick\002: $text"
	} elseif {$nick == $chan} {putserv "PRIVMSG $nick :$text"
	} else {putserv "NOTICE $nick :$text"}
}

proc ::decode::tolower {text} {
	return [string map {А а Б б В в Г г Д д Е е Ё ё Ж ж З з И и Й й К к Л л М м Н н О о П п Р р С с Т т У у Ф ф Х х Ц ц Ч ч Ш ш Щ щ Ъ ъ Ы ы Ь ь Э э Ю ю Я я} [string tolower $text]]
}

proc ::decode::convert {text} {
	return [string map {q й w ц e у r к t е y н u г i ш o щ p з \[ х \] ъ a ф s ы d в f а g п h р j о k л l д ; ж \' э z я x ч c с v м b и n т m ь , б . ю / . ` ё ~ ё \{ х \} ъ : ж \" э < б > ю й q ц w у e к r е t н y г u ш i щ o з p х \[ ъ \] ф a ы s в d а f п g р h о j л k д l ж ; э \' я z ч x с c м v и b т n ь m б , ю . . / ё ` ё ~ х \{ ъ \} ж : э \" б < ю >} [::decode::tolower $text]]
}

#################################################

proc ::decode::pub_decode {nick uhost hand chan args} {
	if {[channel get $chan nopubdecode]} {return}
	::decode::decode $nick $chan $args
}

proc ::decode::msg_decode {nick uhost hand args} {
	::decode::decode $nick $nick $args
}

proc ::decode::decode {nick chan text} {
	set text [join $text]
	if {[string length $text] < 1} {::decode::out $nick "" "Используй !decode <текст>"; return}
	putlog "\[decode\] $nick/$chan $text"
	::decode::out $nick $chan [::decode::convert $text]
}

putlog "decode.tcl v$decode(ver) by $decode(authors) loaded"

