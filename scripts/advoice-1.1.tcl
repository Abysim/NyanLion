#
# Auto Devoice 1.1
#
# Author: CrazyCat <crazycat@c-p-f.org>
# http://www.eggdrop.fr
# irc.zeolia.net #c-p-f
#
# Auto voice users on join
# Auto devoice users after an idle delay
#
# Usage:
#  - Console:
#   .chanset #channel advoice XX
# With XX in minutes (set to 0 to disable on the channel)
# - Message:
#   You need to be known as channel operator in eggdrop
#   or to have the operator status on the channel
#   Help:
#      /msg eggdrop delay help
#   Enable:
#      /msg eggdrop delay #channel on (use default value)
#      /msg eggdrop delay #channel XX
#   Disable:
#      /msg eggdrop delay #channel off|0
#
# N.B.: the advoice default setting is 0 (disabled)

# Changelog
# 1.1 : corrected some returns which blocked the log
#

namespace eval advoice {

	# Default idle time
	variable default 30


	# May we deop inactive ops ?
	variable opasvoice 0

	# Use chanserv to deop ?
	variable chanserv ""

	# Protected users
	variable protected "$::botnick"

	##############################
	#                            #
	# DO NOT EDIT ANYTHING BELOW #
	#                            #
	##############################

	setudef int advoice

	variable author "CrazyCat"
	variable versionNum "1.1"
    variable versionName "AutoDeVoice"

	#bind join - * ::advoice::join
	bind time - * ::advoice::check
	bind pubm - * ::advoice::voice
	bind ctcp - "ACTION" ::advoice::act
	bind msg - "delay" ::advoice::setdelay

 bind mode - * ::advoice::modeprocfix

  proc modeprocfix {nick uhost hand chan mode {target ""}} {
		if {[channel get $chan advoice]==0} {
			return 0
		}
    if {$target != ""} {append mode " $target"}
    ::advoice::modeproc $nick $uhost $hand $chan $mode
  }
  proc modeproc {nick uhost hand chan mode} {
set args [split $mode]
set nickp [lindex $args 1]
set modep [lindex $args 0]
#putlog "$nickp $modep [getchanjoin $nickp $chan] [expr [clock seconds]-3]"
		if {$nickp == $::botnick} {
			return 0
		}
if { $modep == "+o"} {
if { [getchanjoin $nickp $chan] >= [expr [clock seconds]-3]} { ::advoice::deop $nickp $chan}
 }
}


	proc setdelay {nick uhost handle arg} {
		set args [split $arg]
		set chan [string tolower [lindex $args 0]]
		if {![string first $chan "#"] == -1 && $chan ne "help"} {
			putserv "PRIVMSG $nick :Please, type /msg $::botnick delay help"
			return 0
		}
		if { $chan eq "help"} {
			putserv "PRIVMSG $nick :\002/msg $::botnick delay #chan on\002 to turn the AutoDeVoice on (with default delay: $::advoice::default minutes)";
			putserv "PRIVMSG $nick :\002/msg $::botnick delay #chan off|0\002 to turn the AutoDeVoice off";
			putserv "PRIVMSG $nick :\002/msg $::botnick delay #chan XX\002 to turn the AutoDeVoice on with a delay of XX minutes (between 1 and 999)";
			putserv "PRIVMSG $nick :\002/msg $::botnick delay #chan\002 to see the status"
			return 0
		}
		if {![validchan $chan]} {
			putserv "PRIVMSG $nick :Sorry, I'm not on $chan"
			return 0
		}
		if {![isop $nick $chan] && ![matchattr $handle o $chan]} {
			putserv "PRIVMSG $nick :Sorry, you're not operator (@) on $chan"
			return 0
		}
		set delay [lindex $args 1]
		switch -regexp -- $delay {
			^on$ {
				channel set $chan advoice $::advoice::default
				putserv "PRIVMSG $nick :Delay is now [channel get $chan advoice] minutes"
			}
			^off$ -
			^0$ {
				channel set $chan advoice 0
				putserv "PRIVMSG $nick :Ok, $::advoice::versionName disabled"
			}
			{^\d{1,3}$} {
				channel set $chan advoice $delay
				putserv "PRIVMSG $nick :Delay is now [channel get $chan advoice] minutes"
			}
			default {putserv "PRIVMSG $nick :The idle delay on $chan is actually [channel get $chan advoice] minutes";}
		}
	}

	proc join {nick uhost handle chan} {
		if {[lsearch -nocase [::advoice::filt [split $::advoice::protected]] [::advoice::filt [split $nick]]] >= 0} {
			return 0
		}
		if {[channel get $chan advoice]==0} {
			return 0
		}
	#putlog "[isop $nick $chan]"
		after 1000 {set delayed ok}

 		vwait delayed
  

		if {[isop $nick $chan]} {
		#	pushmode $chan -o $nick
		}
   # putserv "mode $chan -o $nick"
 #putlog "[isop $nick $chan]"
	}

	proc check {min hour day month year} {
		foreach chan [channels] {
			set idlemax [channel get $chan advoice]
			if {$idlemax==0} { continue; }
			foreach nick [chanlist $chan] {
				if {[lsearch -nocase [::advoice::filt [split $::advoice::protected]] [::advoice::filt [split $nick]]] >= 0} {continue;}
				if {[isop $nick $chan]} {
					if {$::advoice::opasvoice == 0} {
						continue
					} elseif {[getchanidle $nick $chan] > $idlemax} {
						::advoice::deop $nick $chan
						continue
					}
				}
				if {[ishalfop $nick $chan]} {
					if {$::advoice::opasvoice == 0} {
						continue
					} elseif {[getchanidle $nick $chan] > $idlemax} {
						::advoice::dehalfop $nick $chan
						continue
					}
				}
				if {![isvoice $nick $chan]} {continue;}
				if {[getchanidle $nick $chan] > $idlemax} {
					::advoice::devoice $nick $chan
					continue
				}
			}
		}
	}

	proc act {nick uhost handle chan key text} {
		::advoice::voice $nick $uhost $handle $chan $text
	}

	proc voice {nick uhost handle chan text} {
		if {[channel get $chan advoice]==0} { return 0; }
		if {[lsearch -nocase [::advoice::filt [split $::advoice::protected]] [::advoice::filt [split $nick]]] >= 0} {return 0;}
		if {[isop $nick $chan]} {return 0;}
		if {[ishalfop $nick $chan]} {return 0;}
		if {![isvoice $nick $chan]} {
			pushmode $chan +v $nick
		}
	}
	
	proc deop {nick chan} {
		if {$::advoice::chanserv ne ""} {
			putserv "PRIVMSG $::advoice::chanserv :deop $chan $nick"
		} else {
			pushmode $chan -o $nick
		}
	}

	proc dehalfop {nick chan} {
		if {$::advoice::chanserv ne ""} {
			putserv "PRIVMSG $::advoice::chanserv :dehalfop $chan $nick"
		} else {
			pushmode $chan -h $nick
		}
	}

	proc devoice {nick chan} {
		if {$::advoice::chanserv ne ""} {
			putserv "PRIVMSG $::advoice::chanserv :devoice $chan $nick"
		} else {
			pushmode $chan -v $nick
		}
	}

	proc filt {data} {
        regsub -all -- \\\\ $data \\\\\\\\ data
        regsub -all -- \\\[ $data \\\\\[ data
        regsub -all -- \\\] $data \\\\\] data
        regsub -all -- \\\} $data \\\\\} data
        regsub -all -- \\\{ $data \\\\\{ data
        regsub -all -- \\\" $data \\\\\" data
        return $data
    }

	putlog "$::advoice::versionName $::advoice::versionNum $::advoice::author loaded"
}
