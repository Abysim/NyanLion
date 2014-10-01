#####################################################################################
#
#		:::[  T h e   R u s s i a n   E g g d r o p  R e s o u r c e  ]::: 
#      ____                __                                                      
#     / __/___ _ ___ _ ___/ /____ ___   ___      ___   ____ ___ _     ____ __ __   
#    / _/ / _ `// _ `// _  // __// _ \ / _ \    / _ \ / __// _ `/    / __// // /   
#   /___/ \_, / \_, / \_,_//_/   \___// .__/ __ \___//_/   \_, / __ /_/   \___/    
#        /___/ /___/                 /_/    /_/           /___/ /_/                
#
#
#####################################################################################
#
# egglib_pub 1.5.5
#
# Description:
#	Support TCL library which provides useful functions.
#	Generally made for size-based optimization of the scripts.
#
# Installation:
#	Copy egglib_pub.tcl to 'scripts' directory and add 'source scripts/egglib_pub.tcl'
#	to your eggdrop.conf file.
#
# WARN: 'source scripts/egglib_pub.tcl' MUST BE BEFORE ANY SCRIPTS, WHICH USES EGGLIB.
#
# Authors: Shrike <shrike@eggdrop.org.ru>
#		   mrBuG <mrbug@eggdrop.org.ru>
#
# Official support: irc.eggdrop.org.ru @ #eggdrop
#
# It's an 1.5.5 version really. Just changed number to prevent newbie whines.
# 
#####################################################################################
#
# Version History:
#	
#  		SHR - Shrike
#		MRB - mrBuG
#	
#		Who		DATE	Changes
#   	---     ------  -------------------------------------------------------------
# v1.5.5
#		MRB		090903	Added ::egglib::urldecode
# v1.5.3
#		MRB		060815	Added more symbols to strip_special
#						Insert ::egglib::rus_duration by Shrike
#
# v1.5.2
#		MRB		050702	Added http-proxy support with authentication
#						Added Encode/Decode base64 for a string
#
# v1.5.1
#       SHR     050320  Added more tags to unhtml
#
# v1.5	SHR		040728	Added ::egglib::filelog
#						Added ::egglib::to_translit
# v1.4
#		SHR		040701	Now egglib is vd_patch compatible.
#
#		SHR		040626	Default protocol was degraded to HTTP/1.0. Some sites 
#						returned chunked content.
#						Added converting of '&quot; &gt; &lt; &copy;' in 
#						::egglib::unhtml.
# v1.3
#		SHR		040620	Minor fix: invalid command name "::egglib::meta_to_colors"
#
# v1.2
#		SHR		040616	Removed old socket functions
#						Rewrited to use socket functions in egglib_pub
#						Added http-proxy support
#						Improved urlencode to not convert english characters
#					
#   	SHR		040615	Added this header
#						Added http_post method
#						Added unhtml
#						Added urlencode
#	
#####################################################################################

# channel output
package require Tcl 8.3
package require eggdrop 1.6

foreach p [array names egglib *] { catch {unset egglib($p) } }

set egglib(http_timeout) 20
set egglib(http_debug) 1
set egglib(debug) 1

### DO NOT MODIFY ANYTHING AFTER THIS LINE, IF YOU'RE DON'T KNOW WHAT ARE YOU DOING #

set egglib(ver) "1.55"
set egglib(authors) "Shrike <shrike@eggdrop.org.ru>, mrBuG <mrbug@eggdrop.org.ru>"


if { [info exists egg_codepage] } {
	putlog "\[egglib\] vd patch detected, codepage: $egg_codepage"
	set egglib(vd_patch) 1	
} else {
	set egglib(vd_patch) 0	
}

setudef flag usecolors
namespace eval egglib {}

proc ::egglib::is_vd_patch { } {
	global egglib
	return $egglib(vd_patch)
}

proc ::egglib::idx2host { idx } {
	set lstdcc [dcclist]
	set ind 0

	while { $ind < [llength $lstdcc] } {
		if { [lindex [lindex $lstdcc $ind] 0] == $idx } { set hstdcc [lindex [lindex $lstdcc $ind] 2] }
		incr ind
	}

	return $hstdcc
}



proc ::egglib::outh {nick chan text params} {
	if { [regexp -- {^dcc:(\d+)$} $nick gr idx] } {
		::egglib::outhd $idx $text $params
	} elseif { [string equal $chan $nick] } {
		::egglib::outhm $nick $text $params
	} else {
		::egglib::outhc $nick $chan $text $params
	}
}

proc ::egglib::outhc {nick chan text params} {
	if {[channel get $chan usecolors]} {
		putserv "PRIVMSG $chan :\002$nick:\002 ���������: \0034$text\0035 $params\003"
	} else {
		putserv "PRIVMSG $chan :\002$nick:\002 ���������: \002$text\002 $params"
	}
}

proc ::egglib::outhm {nick text params} {
	putserv "PRIVMSG $nick :���������: \0034$text\0035 $params\003"
}

proc ::egglib::outhd {idx text params} {
	putdcc $idx "���������: \0034$text\0035 $params\003"
}

proc ::egglib::out {nick chan text} {
	if { [regexp -- {^dcc:(\d+)$} $nick gr idx] } {
		::egglib::outd $idx $text
	} elseif { [string equal $chan $nick] } {
		::egglib::outm $nick $text
	} else {
		::egglib::outc $nick $chan $text
	}
}

proc ::egglib::outc {nick chan text} {
	global egglib
	if { $egglib(vd_patch) } {
		global egg_codepage
		set text [encoding convertto iso8859-1 $text]
		set text [encoding convertfrom $egg_codepage $text]
	}
	
	if {![channel get $chan usecolors]} {
		set text [::egglib::strip_colors $text]
	}
		
	if { $egglib(vd_patch) } {
		set text [encoding convertto $egg_codepage $text]
	}
	
	if { $nick == "" } {
		putserv "PRIVMSG $chan :$text"
	} else {
		putserv "PRIVMSG $chan :\002$nick:\002 $text"
	}
}

# msg output

proc ::egglib::outm {nick text} {
	putserv "PRIVMSG $nick :$text"
}

proc ::egglib::outd {idx text} {
	putdcc $idx "$text"
}

proc ::egglib::filelog {file nick chan comm params} {
	if { [string equal $chan $nick] } {
		::egglib::filemsglog $file $nick $comm $params
	} else {
		::egglib::filepublog $file $nick $chan $comm $params
	}
}

proc ::egglib::filepublog {file nick chan comm params} {
	set FH [open $file a+]
	puts $FH "pub:$comm \[$chan: $nick\] $params"
	close $FH
}

proc ::egglib::filemsglog {file nick comm params} {
	set FH [open $file a+]
	puts $FH "msg:$comm \[$nick\] $params"
	close $FH
}

proc ::egglib::log {nick chan comm params} {
	if { [regexp -- {^dcc:(\d+)$} $nick gr idx] } {
		::egglib::dcclog $idx $chan $comm $params
	} elseif { [string equal $chan $nick] } {
		::egglib::msglog $nick $comm $params
	} else {
		::egglib::publog $nick $chan $comm $params
	}
}	

proc ::egglib::publog {nick chan comm params} {
	putlog "pub:$comm \[$chan: $nick\] $params"
}

proc ::egglib::msglog {nick comm params} {
	putlog "msg:$comm \[$nick\] $params"
}

proc ::egglib::dcclog {idx hand comm params} {
	putlog "dcc:$comm \[$hand:$idx\] $params"
}

proc ::egglib::srcloadlog { srcname ver authors } {
	putlog "$srcname.tcl v$ver by $authors loaded"
}

# notice output
proc ::egglib::outn {nick text} {
	putserv "NOTICE $nick :$text"
}

# time functions

proc ::egglib::rus_duration { expire } {
	::egglib::conv_duration $expire 0
}

proc ::egglib::rus_duration_1 { expire } {
	::egglib::conv_duration $expire 1
}

proc ::egglib::conv_duration { expire mode } {	
	set ret ""
	set expire " $expire "
	if { [string match "*month*" $expire] } {
		regexp -nocase -- {.*\ ([0-9]+)\ month.*} $expire garb d
		set d [string trim $d]
		if { [expr $d == 1] } { 
			set dur "$d �����" 
		} elseif { [expr $d < 5] } {
			set dur "$d ������" 
		} else { 
			set dur "$d �������" 
		}
		set ret "[string trim $ret] $dur" 
	}
	if { [string match "*week*" $expire] } {
		regexp -nocase -- {.*\ ([0-9]+)\ week.*} $expire garb d
		set d [string trim $d]
		if { [expr $d == 1] } { 
			if { $mode == 0 } { set dur "$d ������" }
			if { $mode == 1 } { set dur "$d ������" }
		} else {
			set dur "$d ������" 
		}
		set ret "[string trim $ret] $dur"
	}
	if { [string match "*day*" $expire] } {
		regexp -nocase -- {.*\ ([0-9]+)\ day.*} $expire garb d
		set d [string trim $d]
		if { [expr $d == 1] } { 
			set dur "$d ����"
		} elseif { [expr $d < 5] } {
			set dur "$d ���" 
		} else {
			set dur "$d ����" 
		}
		set ret "[string trim $ret] $dur"
	}
	if { [string match "*hour*" $expire] } {
		regexp -nocase -- {.*\ ([0-9]+)\ hour.*} $expire garb d
		set d [string trim $d]
		if { [expr $d == 1 || $d == 21] } { 
			set dur "$d ���"
		} elseif { [expr $d < 5 || $d == 22 || $d == 23 ] } {
			set dur "$d ����" 
		} else {
			set dur "$d �����" 
		}
		set ret "[string trim $ret] $dur"
	}
	if { [string match "*minute*" $expire] } {
		regexp -nocase -- {.*\ ([0-9]+)\ minute.*} $expire garb d
		set d [string trim $d]
		set k $d
		while { [expr $k > 10] } { set k [expr $k - 10] }
		if { [expr $d > 10 && $d < 20] } {
			 set dur "$d �����" 
		} elseif { [expr $k == 1] } { 
			if { $mode == 0 } { set dur "$d ������" }
			if { $mode == 1 } { set dur "$d ������" }
		} elseif { [expr $k < 5] } {
			set dur "$d ������" 
		} else {
			set dur "$d �����" 
		}
		set ret "[string trim $ret] $dur"
	}
	if { [string match "*second*" $expire] } {
		regexp -nocase -- {.*\ ([0-9]+)\ second.*} $expire garb d
		set d [string trim $d]
		set k $d
		while { [expr $k > 10] } { set k [expr $k - 10] }
		if { [expr $d > 10 && $d < 20] } {
			 set dur "$d ������" 
		} elseif { [expr $k == 1] } { 
			if { $mode == 0 } {	set dur "$d �������" }
			if { $mode == 1 } {	set dur "$d �������" }
		} elseif { [expr $k < 5] } {
			set dur "$d �������" 
		} else {
			set dur "$d ������" 
		}
		set ret "[string trim $ret] $dur"
	}
	set ret [string trim $ret]
	return $ret
}


# string manipulation

proc ::egglib::strip_colors {t} {
	global egglib
	
	regsub -all -- {\003(\d){0,2}(,){0,1}(\d){0,2}} $t {} t
	regsub -all -- {\037} $t {} t; regsub -all -- {\002} $t {} t
	regsub -all -- {\026} $t {} t; regsub -all -- {\017} $t {} t
	

	return $t
}

proc ::egglib::tolower {t} {
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	
	regsub -all -- {A} $t {a} t; regsub -all -- {B} $t {b} t; regsub -all -- {C} $t {c} t
	regsub -all -- {D} $t {d} t; regsub -all -- {E} $t {e} t; regsub -all -- {F} $t {f} t
	regsub -all -- {G} $t {g} t; regsub -all -- {H} $t {h} t; regsub -all -- {I} $t {i} t
	regsub -all -- {J} $t {j} t; regsub -all -- {K} $t {k} t; regsub -all -- {L} $t {l} t
	regsub -all -- {M} $t {m} t; regsub -all -- {N} $t {n} t; regsub -all -- {O} $t {o} t
	regsub -all -- {P} $t {p} t; regsub -all -- {Q} $t {q} t; regsub -all -- {R} $t {r} t
	regsub -all -- {S} $t {s} t; regsub -all -- {T} $t {t} t; regsub -all -- {U} $t {u} t
	regsub -all -- {V} $t {v} t; regsub -all -- {W} $t {w} t; regsub -all -- {X} $t {x} t
	regsub -all -- {Y} $t {y} t; regsub -all -- {Z} $t {z} t

	return $t
}

proc ::egglib::toupper {t} {
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t; regsub -all -- {�} $t {�} t
	                                                                                   
	regsub -all -- {a} $t {A} t; regsub -all -- {b} $t {B} t; regsub -all -- {c} $t {C} t
	regsub -all -- {d} $t {D} t; regsub -all -- {e} $t {E} t; regsub -all -- {f} $t {F} t
	regsub -all -- {g} $t {G} t; regsub -all -- {h} $t {H} t; regsub -all -- {i} $t {I} t
	regsub -all -- {j} $t {J} t; regsub -all -- {k} $t {K} t; regsub -all -- {l} $t {L} t
	regsub -all -- {m} $t {M} t; regsub -all -- {n} $t {N} t; regsub -all -- {o} $t {O} t
	regsub -all -- {p} $t {P} t; regsub -all -- {q} $t {Q} t; regsub -all -- {r} $t {R} t
	regsub -all -- {s} $t {S} t; regsub -all -- {t} $t {T} t; regsub -all -- {u} $t {U} t
	regsub -all -- {v} $t {V} t; regsub -all -- {w} $t {W} t; regsub -all -- {x} $t {X} t
	regsub -all -- {y} $t {Y} t; regsub -all -- {z} $t {Z} t
	
	return $t
}

proc ::egglib::to_translit {t} {
	regsub -all -- {�} $t {a} t; 	regsub -all -- {�} $t {A} t
	regsub -all -- {�} $t {b} t; 	regsub -all -- {�} $t {B} t
	regsub -all -- {�} $t {v} t; 	regsub -all -- {�} $t {V} t
	regsub -all -- {�} $t {g} t; 	regsub -all -- {�} $t {G} t
	regsub -all -- {�} $t {d} t; 	regsub -all -- {�} $t {D} t
	regsub -all -- {�} $t {e} t; 	regsub -all -- {�} $t {E} t
	regsub -all -- {�} $t {e} t; 	regsub -all -- {�} $t {E} t
	regsub -all -- {�} $t {zh} t; 	regsub -all -- {�} $t {ZH} t
	regsub -all -- {�} $t {z} t; 	regsub -all -- {�} $t {Z} t
	regsub -all -- {�} $t {i} t; 	regsub -all -- {�} $t {I} t
	regsub -all -- {�} $t {j} t; 	regsub -all -- {�} $t {J} t
	regsub -all -- {�} $t {k} t; 	regsub -all -- {�} $t {K} t
	regsub -all -- {�} $t {l} t;	regsub -all -- {�} $t {L} t
	regsub -all -- {�} $t {m} t; 	regsub -all -- {�} $t {M} t
	regsub -all -- {�} $t {n} t; 	regsub -all -- {�} $t {N} t
	regsub -all -- {�} $t {o} t; 	regsub -all -- {�} $t {O} t
	regsub -all -- {�} $t {p} t; 	regsub -all -- {�} $t {P} t
	regsub -all -- {�} $t {r} t; 	regsub -all -- {�} $t {R} t
	regsub -all -- {�} $t {s} t; 	regsub -all -- {�} $t {S} t
	regsub -all -- {�} $t {t} t; 	regsub -all -- {�} $t {T} t
	regsub -all -- {�} $t {u} t; 	regsub -all -- {�} $t {U} t
	regsub -all -- {�} $t {f} t; 	regsub -all -- {�} $t {F} t
	regsub -all -- {�} $t {h} t; 	regsub -all -- {�} $t {H} t
	regsub -all -- {�} $t {c} t; 	regsub -all -- {�} $t {C} t
	regsub -all -- {�} $t {ch} t; 	regsub -all -- {�} $t {4} t
	regsub -all -- {�} $t {sh} t; 	regsub -all -- {�} $t {SH} t
	regsub -all -- {�} $t {sch} t; 	regsub -all -- {�} $t {SCH} t
	regsub -all -- {�} $t {'} t; 	regsub -all -- {�} $t {'} t
	regsub -all -- {�} $t {y} t; 	regsub -all -- {�} $t {Y} t
	regsub -all -- {�} $t {'} t;	regsub -all -- {�} $t {'} t
	regsub -all -- {�} $t {e} t; 	regsub -all -- {�} $t {E} t
	regsub -all -- {�} $t {ju} t; 	regsub -all -- {�} $t {JU} t
	regsub -all -- {�} $t {ja} t; 	regsub -all -- {�} $t {JA} t
	return $t
}


proc ::egglib::strip_special {t} {
	regsub -all -- {\!} $t {} t; regsub -all -- {\"} $t {} t; regsub -all -- {\#} $t {} t
	regsub -all -- {\.} $t {} t; regsub -all -- {%} $t {} t; regsub -all -- {\^} $t {} t
	regsub -all -- {\&} $t {} t; regsub -all -- {\*} $t {} t; regsub -all -- {\(} $t {} t
	regsub -all -- {\)} $t {} t; regsub -all -- {\}} $t {} t; regsub -all -- {\{} $t {} t
	regsub -all -- {\]} $t {} t; regsub -all -- {\[} $t {} t; regsub -all -- {\:} $t {} t
	regsub -all -- {\;} $t {} t; regsub -all -- {\'} $t {} t; regsub -all -- {\`} $t {} t
	regsub -all -- {\~} $t {} t; regsub -all -- {\+} $t {} t; regsub -all -- {\=} $t {} t
	regsub -all -- {\-} $t {} t; regsub -all -- {\|} $t {} t; regsub -all -- {\\} $t {} t
	regsub -all -- {\?} $t {} t; regsub -all -- {\,} $t {} t; regsub -all -- {\<} $t {} t 
	regsub -all -- {\>} $t {} t; regsub -all -- {\/} $t {} t; regsub -all -- {\�} $t {} t
	regsub -all -- {\�} $t {} t; regsub -all -- {\�} $t {} t; regsub -all -- {\�} $t {} t
	regsub -all -- {\�} $t {} t; regsub -all -- {\�} $t {} t; regsub -all -- {\@} $t {} t
	regsub -all -- {\�} $t {} t; regsub -all -- {\_} $t {} t; regsub -all -- {\$} $t {} t
	regsub -all -- {\�} $t {} t; regsub -all -- {\�} $t {} t; regsub -all -- {\�} $t {} t
	return $t
}


proc ::egglib::join_args {x start end} {
	set c ""
	set a [lrange $x $start $end]
	foreach b $a {
		while { ![string equal [lindex $b 0] $b] } { set b [lindex $b 0] }
		append c " $b"
	}
	set c [string trim $c]
	return $c
}

proc ::egglib::backslash {x} {
	regsub -all -- {\\} $x {\\} x; regsub -all -- {\"} $x {\"} x; regsub -all -- {\[} $x {\[} x
	regsub -all -- {\]} $x {\]} x; regsub -all -- {\}} $x {\}} x; regsub -all -- {\{} $x {\{} x
	regsub -all -- {\(} $x {\(} x; regsub -all -- {\)} $x {\)} x; regsub -all -- {\.} $x {\.} x
	regsub -all -- {\*} $x {.*} x; regsub -all -- {\,} $x {\,} x; regsub -all -- {\?} $x {.?} x
	return $x
}

proc ::egglib::colors_to_meta {t} {
	regsub -all -- \002 $t %b t; regsub -all -- \037 $t %u t
	regsub -all -- \026 $t %i t; regsub -all -- \017 $t %k t
	regsub -all -- \003 $t %c t
	return $t
}

proc ::egglib::meta_to_colors {t} {
	regsub -all -- %b $t \002 t; regsub -all -- %u $t \037 t
	regsub -all -- %i $t \026 t; regsub -all -- %k $t \017 t
	regsub -all -- %c $t \003 t
	return $t
}

proc ::egglib::host_color { t } {
	if { [regexp {^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$} $t] } {
		regsub -all -- {^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$} $t {%c12%b%b\1%c4.%c12%b%b\2%c4.%c12%b%b\3%c4.%c12%b%b\4%c} t
	} elseif { [regexp {\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d+$} $t] } {
		regsub -all -- {^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}):(.*)$} $t {%c12%b%b\1%c4.%c12%b%b\2%c4.%c12%b%b\3%c4.%c12%b%b\4%c4:%c5%b%b\5%c} t
	} else {
		if { [regexp {^.*?\:\d+$} $t] } {
			regsub -all -- {^(.*?)\:(\d+)$} $t {%c6%b%b\1%c4:%c5%b%b\2%c} t
		} else {
			set t "%c6%b%b$t%c"
		}
	}
	set t [::egglib::meta_to_colors $t]
	return $t
}

proc ::egglib::version_color { t } {
	set out ""
	if { [regexp -- {^(.*?)(\(.*?\))(.*?)$} $t gr a1 a2 a3] } {
		regsub -all -- {\ } $a2 {%s} a2
		set t "$a1$a2$a3"	
	}
	
	foreach i [split $t] {
		set i [string trim $i]
		
		if { [regexp -- {^\(.*?\)$} $i] } {
			set i "%c4$i%c"
		} elseif { [ regexp -- {^.*/\d+\.\d+\.\d+$} $i] } {
			regsub -all -- {^(.*?)/(\d+)\.(\d+)\.(\d+)$} $i {%c2%b%b\1%c/%c5%b%b\2%c4.%c5%b%b\3%c4.%c5%b%b\4%c} i
		} elseif { [ regexp -- {^.*/\d+\.d+$} $i] } {
			regsub -all -- {^(.*?)/(\d+)\.(\d+)$} $i {%c2%b%b\1%c/%c5%b%b\2%c4.%c5%b%b\4%c} i
		} elseif { [ regexp -- {^.*/.*$} $i] } {
			regsub -all -- {^(.*?)/(.*?)$} $i {%c2%b%b\1%c/%c5%b%b\2%c} i
		} elseif { [ regexp -- {^\(.*\)$} $i] } {
			regsub -all -- {^\((.*?)\)$} $i {%c2(%c6%b%b\1%c2)%c} i
		}
		
		set out "$out$i "
	}
	regsub -all -- {%s} $out { } out
	set out [string trim $out] 
	set out [::egglib::meta_to_colors $out]
	return $out
}

proc ::egglib::optimize_colors {t} {
	regsub -all -- {} $t {} t
	regsub -all -- {3 } $t { } t
	regsub -all -- {} $t {} t
	return $t
}

proc ::egglib::readdata {file} {
    if {![file exists $file]} {
         return ""
    } else {
         set fileio [open $file r]
         set lines ""
         while {![eof $fileio]} {
              set line [gets $fileio]
              if {$line != ""} { set lines [linsert $lines end $line] }
         }
         close $fileio
         return $lines
    }
}

proc ::egglib::writedata {file data} {
    set fileio [open $file w]
    foreach line $data {
         puts $fileio $line
    }
    flush $fileio
    close $fileio
}

proc ::egglib::unique_id { base } { return "$base[expr [rand 32000]+[rand 32000]*[rand 20000]]" }

# HTTP Functions (non-blocking)

proc ::egglib::urlencode { a } {
	set q ""
	foreach n [split $a {}] { 
		if { $n == "+" || $n == " " } {
			append q "+"
		} elseif { [regexp -- {[A-Za-z0-9]} $n]} {
			append q "$n"
		} else {
			binary scan $n "H2" n
			append q "%$n"
		}
	}
	return $q	
}

proc ::egglib::urldecode { a } {
	regsub -all {%C2%A0} $a { } a
	regsub -all {\+} $a { } a
	regsub -all {%([[:xdigit:]]{2})} $a \
		{[format %c 0x\1]} a
	return [subst $a]
}

proc ::egglib::unhtml { t } {
	global egglib
	
	regsub -all -nocase -- {<.*?>(.*?)</.*?>} $t {\1} t
	regsub -all -nocase -- {<.*?>} $t {} t
	regsub -all -nocase -- {&quot;} $t {'} t
	regsub -all -nocase -- {&gt;} $t {>} t
	regsub -all -nocase -- {&lt;} $t {<} t
	regsub -all -nocase -- {&copy;} $t {�} t
	regsub -all -nocase -- {\&\#169;} $t {�} t
	regsub -all -nocase -- {\&\#183;} $t {-} t
	regsub -all -nocase -- {&amp;} $t {&} t
	regsub -all -nocase -- {&#[0]*33;} $t {!} t
	regsub -all -nocase -- {&#[0]*58;} $t {:} t
	regsub -all -nocase -- {&#[0]*36;} $t {$} t
	
	regsub -all -nocase -- {&.*?;} $t {} t

	
	return $t
}

proc ::egglib::http_init { prefix } {
	global egglib
	set id [::egglib::unique_id "http"]
	set egglib(http,$id,prefix) $prefix
	if { $egglib(http_debug) } { putlog "\[egglib\] Initialized HTTP session ($prefix, $id)" }
	return $id
}

proc ::egglib::http_cleanup { id } {
	global egglib
	if { ![info exists egglib(http,$id,prefix)] } { return }
	if { $egglib(http_debug) } { putlog "\[egglib\] Destroying HTTP Session ($egglib(http,$id,prefix), $id)" }
	catch { close $egglib(http,$id,sock) }
	catch { killutimer $egglib(http,$id,timer) }
	catch { unset egglib(http,$id,prefix) }
	catch { unset egglib(http,$id,agent) }
	catch { unset egglib(http,$id,host) }
	catch { unset egglib(http,$id,cdata) }
	catch { unset egglib(http,$id,data) }
	catch { unset egglib(http,$id,sock) }
	catch { unset egglib(http,$id,path) }
	catch { unset egglib(http,$id,params) }
	catch { unset egglib(http,$id,timer) }
	catch { unset egglib(http,$id,method) }
	catch { unset egglib(http,$id,proxy_h) }
	catch { unset egglib(http,$id,proxy_p) }
	catch { unset egglib(http,$id,proxy_n) }
	catch { unset egglib(http,$id,proxy_a) }
	catch { unset egglib(http,$id,timeout) }
	catch { unset egglib(http,$id,protocol) }
	
	if { $egglib(http_debug) } {
		putlog "\[egglib\] Non destroyed variables:"
		foreach p [array names egglib http,*] { putlog "egglib($p)" }
		putlog "\[egglib\] HTTP Session succesfuly destroyed."
	}
}

proc ::egglib::http_set_agent { id agent } { 
	global egglib	
	if { $egglib(http_debug) } { putlog "\[egglib\] Setting up User-Agent: $agent" }
	set egglib(http,$id,agent) $agent 
}
	
proc ::egglib::http_set_method { id method } { 
	global egglib
	if { $egglib(http_debug) } { putlog "\[egglib\] Setting up HTTP-Method: $method" }
	set egglib(http,$id,method) $method 
}

proc ::egglib::http_set_protocol { id protocol } { 
	global egglib 
	if { $egglib(http_debug) } { putlog "\[egglib\] Setting up Protocol: $protocol" }
	set egglib(http,$id,protocol) $protocol 
}

proc ::egglib::http_set_params { id params } { 
	global egglib
	if { $egglib(http_debug) } { putlog "\[egglib\] Setting up POST-Data: $params" }
	set egglib(http,$id,params) $params 
}

proc ::egglib::http_set_proxy { id host port} { 
	global egglib

	if { [regexp -nocase -- {^(.*?)\:(.*?)\@(.*?)$} $host gr login pass host] } {
		set egglib(http,$id,proxy_h) $host
		set egglib(http,$id,proxy_n) $login
		set egglib(http,$id,proxy_a) $pass
	} else {
		set egglib(http,$id,proxy_h) $host
	}

	set egglib(http,$id,proxy_p) $port

	if { $egglib(http_debug) } { putlog "\[egglib\] Setting up Proxy-Server: $egglib(http,$id,proxy_h) $port" }
}

proc ::egglib::http_set_timeout { id timeout } { 
	global egglib
	if { $egglib(http_debug) } { putlog "\[egglib\] Setting up Connection-Timeout: $timeout sec" }
	set egglib(http,$id,timeout) $timeout 
}

proc ::egglib::http_post {id url params custom_data} {
	::egglib::http_set_params $id $params
	::egglib::http_set_method $id "POST"
	::egglib::http_get $id $url $custom_data
}

proc ::egglib::http_get {id url custom_data} {
	global egglib
	if {![regexp -nocase {^(http://)?([^:/]+)(:([0-9]+))?(/.*)?$} $url x protocol host y port path]} { return }
	if {[string length $port] == 0} { set port 80 }	
	
	
	set egglib(http,$id,host) $host
	set egglib(http,$id,path) $path
	
	if { [info exists egglib(http,$id,proxy_h)] } { 
		set egglib(http,$id,path) "http://$host$path"
		::egglib::http_set_protocol $id "HTTP/1.0"
		set host $egglib(http,$id,proxy_h)
		set port $egglib(http,$id,proxy_p)
	}
	
	set egglib(http,$id,data) ""
	set egglib(http,$id,sock) 0
	set egglib(http,$id,cdata) $custom_data

	if { ![info exists egglib(http,$id,agent)] } { ::egglib::http_set_agent $id "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 1.0.3705)" }
	if { ![info exists egglib(http,$id,method)] } { ::egglib::http_set_method $id "GET" }
	if { ![info exists egglib(http,$id,timeout)] } { ::egglib::http_set_timeout $id $egglib(http_timeout) }
	if { ![info exists egglib(http,$id,protocol)] } { ::egglib::http_set_protocol $id "HTTP/1.0" }

	if { $egglib(http_debug) } { putlog "\[egglib\] Connecting to $host:$port" }
	
	if {[catch {set s [socket -async $host $port]} error] == 0} {
		fconfigure $s -blocking 0 -buffering line
		set egglib(http,$id,sock) $s
		fileevent $s writable [list ::egglib::http_on_write $id]
		fileevent $s readable [list ::egglib::http_on_read $id]
		set egglib(http,$id,timer) [utimer $egglib(http,$id,timeout) [list ::egglib::http_on_error $id]]		
	} else {
		::egglib::http_on_error $id
	}
}

proc ::egglib::http_on_write {id} {
	global egglib
	set s $egglib(http,$id,sock)
	if { [catch {
		if { $egglib(http_debug) } { putlog "\[egglib\] Requesting $egglib(http,$id,path)" }
		puts $s "$egglib(http,$id,method) $egglib(http,$id,path) $egglib(http,$id,protocol)"
		if { [info exists egglib(http,$id,proxy_n)] } { puts $s "Authorization: Basic [::egglib::base64_encode $egglib(http,$id,proxy_n):$egglib(http,$id,proxy_a)]" }
		puts $s "Accept: */*"
		puts $s "Host: $egglib(http,$id,host)"
		puts $s "User-Agent: $egglib(http,$id,agent)"
		puts $s "Connection: close"
		if { [info exists egglib(http,$id,params)] } {
			if { $egglib(http_debug) } { putlog "\[egglib\] POST Data: $egglib(http,$id,params)" }
			puts $s "Content-Type: application/x-www-form-urlencoded"
			puts $s "Content-Length: [string length $egglib(http,$id,params)]"
			puts $s ""
			puts $s $egglib(http,$id,params)
		} else {
			puts $s ""
		}
		
		flush $s
		if { $egglib(vd_patch) } {
			fconfigure $s -blocking 0
		} else {
			fconfigure $s -encoding binary -translation {auto binary}
		}
		catch {killutimer $egglib(http,$id,timer)}
  		set egglib(http,$id,timer) [utimer $egglib(http,$id,timeout) [list ::egglib::http_on_error $id]]
		catch {fileevent $s writable {}}
	} err ] } {
		::egglib::http_on_error $id
	}
}

proc ::egglib::http_on_read {id} {
   global egglib
   set s $egglib(http,$id,sock)
   if { [catch {
       if {![eof $s]} {
           if { $egglib(http_debug) } { putlog "\[egglib\] getting data ($id)" }
           while {![eof $s]} {
               gets $s newdata    
               if {[fblocked $s]} {break}
               if { $newdata != "" } {
                   if { $egglib(vd_patch) } {
                       global egg_codepage
                   }
                   append egglib(http,$id,data) "\n" 
                   append egglib(http,$id,data) $newdata
               }
           }
           catch {killutimer $egglib(http,$id,timer)}
           set egglib(http,$id,timer) [utimer $egglib(http,$id,timeout) [list ::egglib::http_on_error $id]]
       } else {
           if { $egglib(http_debug) } { putlog "\[egglib\] got all data. executing callback... ($egglib(http,$id,prefix)on_data)" }
           catch {fileevent $s readable {}}
           close $s
           if { [catch { eval [concat $egglib(http,$id,prefix)on_data $id \$egglib(http,$id,data) $egglib(http,$id,cdata)] } err ] } {
               if { $err != "" && $err != "1" && $err != "0" } { if { $egglib(http_debug) } { putlog "\[egglib\] error executing callback: $err" } }
           }
           ::egglib::http_cleanup $id
       }
   }] } {
       catch {killutimer $egglib(http,$id,timer)}
       ::egglib::http_on_error $id
   }
}

proc ::egglib::http_on_error {id} {
	global egglib
	if { $egglib(http_debug) } { putlog "\[egglib\] HTTP Error... executing callback... ($egglib(http,$id,prefix)on_error)" }
	catch { eval [concat $egglib(http,$id,prefix)on_error $id $egglib(http,$id,cdata)] } err
	if { $egglib(http_debug) } { if { $err != "" } { putlog "\[egglib\] error executing callback: $err" } }
	::egglib::http_cleanup $id
}

catch { 
proc bgerror {err} {
	putlog "\[egglib\]: Catched BGError: $err"
}
}


# Base64 encoding for a string

set i 0
foreach char {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
	      a b c d e f g h i j k l m n o p q r s t u v w x y z \
	      0 1 2 3 4 5 6 7 8 9 + /} {
	set base64($char) $i
	set base64_en($i) $char
	incr i
}

proc ::egglib::base64_encode { string } {
    ::egglib::base64_encodeinit state old length
    set result [::egglib::base64_encodeblock $string state old length]
    append result [::egglib::base64_encodetail state old length]
    return $result
}

proc ::egglib::base64_encodeinit { statevar oldvar lengthvar } {
	upvar 1 $statevar state
    upvar 1 $oldvar old
    upvar 1 $lengthvar length
    set state 0
    set length 0
    if {[info exists old]} { unset old }
}

proc ::egglib::base64_encodeblock { string statevar oldvar lengthvar } {
    global base64_en
    upvar 1 $statevar state
    upvar 1 $oldvar old
    upvar 1 $lengthvar length
    set result {}
    foreach {c} [split $string {}] {
	scan $c %c x
	switch [incr state] {
	    1 {	append result $base64_en([expr {($x >>2) & 0x3F}]) }
	    2 { append result $base64_en([expr {(($old << 4) & 0x30) | (($x >> 4) & 0xF)}]) }
	    3 { append result $base64_en([expr {(($old << 2) & 0x3C) | (($x >> 6) & 0x3)}])
		append result $base64_en([expr {($x & 0x3F)}])
                incr length
		set state 0
              }
	}
	set old $x
	incr length
	if {$length >= 72} {
	    append result \n
	    set length 0
	}
    }
    return $result
}

proc ::egglib::base64_encodetail { statevar oldvar lengthvar } {
    global base64_en
    upvar 1 $statevar state
    upvar 1 $oldvar old
    upvar 1 $lengthvar length
    set result ""
    switch $state {
	0 { # OK }
	1 { append result $base64_en([expr {(($old << 4) & 0x30)}])== }
	2 { append result $base64_en([expr {(($old << 2) & 0x3C)}])=  }
    }
    return $result
}

proc ::egglib::base64_decode { string } {
    global base64

    set output {}
    set group 0
    set pad 0
    set j 18
    foreach char [split $string {}] {
	if {[string compare $char "\n"] == 0} {
          continue
        }
	if [string compare $char "="] {
	    set bits $base64($char)
	    set group [expr {$group | ($bits << $j)}]
	} else {
	    incr pad
	}

	if {[incr j -6] < 0} {
		set i [scan [format %06x $group] %2x%2x%2x a b c]
		switch $pad {
		    2 { append output [format %c $a] }
		    1 { append output [format %c%c $a $b] }
		    0 { append output [format %c%c%c $a $b $c] }
		}
		set group 0
		set j 18
	}
    }
    return $output
}

::egglib::srcloadlog "egglib_pub" $egglib(ver) $egglib(authors)
