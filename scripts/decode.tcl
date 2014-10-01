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
	return [string map {� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �} [string tolower $text]]
}

proc ::decode::convert {text} {
	return [string map {q � w � e � r � t � y � u � i � o � p � \[ � \] � a � s � d � f � g � h � j � k � l � ; � \' � z � x � c � v � b � n � m � , � . � / . ` � ~ � \{ � \} � : � \" � < � > � � q � w � e � r � t � y � u � i � o � p � \[ � \] � a � s � d � f � g � h � j � k � l � ; � \' � z � x � c � v � b � n � m � , � . . / � ` � ~ � \{ � \} � : � \" � < � >} [::decode::tolower $text]]
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
	if {[string length $text] < 1} {::decode::out $nick "" "��������� !decode <�����>"; return}
	putlog "\[decode\] $nick/$chan $text"
	::decode::out $nick $chan [::decode::convert $text]
}

putlog "decode.tcl v$decode(ver) by $decode(authors) loaded"

