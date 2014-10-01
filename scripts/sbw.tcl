# ������ 2.6.7  ( ������ ��������� ���������/ ������ ����������� ����� / ������ ������������ )
#       .chanset #furrydc +badwords        - turn on antimat
#       .chanset #chan -badwords        - turn off antimat
# ������� �� ��� �������� � ��������� ���������; - ���� ����� ;)
# ����������� ������� (������� ������ � ������ 1.0.1)
# remake by Dark_Agent ;)
# 
# 1.0.0 - ������������ ��������� ������������� �������
# 1.0.1 - �������� �������� �� halfop/op ��� ����, ������� kickbanned, warnbanned
# 1.0.2 - ������� ������� !bwoff !bwon (�������� ��������� ������� �� ������). ������� �������� ������ ����,
#   ����������� �� ����: .chattr handle +o #channel, ��������� ������ ������� ����� �����������.
# 1.0.3 �������: chanban dolzhen vistavlyaetsa v ljubom slu4ae imho, mozh on po botnetu na shared bots peredastsa a te s opom (thx 2 CoolCold)
# 1.0.4 �� �������� ����������, ������� ���� banbadwords (������ �� ��� / ��� �� ������ ������ :) : .chanset #chan +/-banbadwords
# 2.0.0 ������� ������... ������ ���� ��� � �����... (bw.txt) (���� - Shrike)
#       ����� �������: !bwstats (���-�� ����������) !bwadd (�������� ���) !bwdel
#       ������ ��� �������� (������� ��������� ����������� ����� ���� - ����� ��� ������� =)) ������ ����� ���������� putcmdlog($var) - ��� ��� ������ �����
#       ����� ���� banbadwords - ������ ��� ��� � !bwmode =)
# 2.1.1 ������� ����� ���+��� (!bwmode kb) ��� ���� ����� ����������� ���� enforcebans �������� =) ���� ��������� ��������� ������ ����� � var..
# 2.2.1 ��������� ��� � �������� -)
# 2.2.2 ������ ������ exepts (����������) - ������� !bweadd, !bwedel (���������� !bwadd, !bwdel), !bwstats ���������� ������ �� ������ ��� �� � ����������.
#       � ������� �������� ����� ���� ���� ����� "����", ������� �� ����� ����������� ��� ������� whois'a
# 2.2.3 �������� ���������� %) ������ [eq gblh gbplf � �.�. ����������� ��� ���
# 2.2.4 ��� ������: !bwwarnmsg / !bwbanmsg =)
# 2.3.4 ��������� ��� � �������. ������ "����� � ��," �� ��� �� ��������� ;)
# 2.4.4 ��������� ��� � ������ vs ��� (��� tigra �� ��������� ���)
# 2.4.5 ���������: ���������� ������� �� ������ ���������� (!bwstats), !bwhelp � "�������", ���� warnops ������� �� ������� � ������� !bwwarnops 1/0 (�������������)
# 2.4.6 !!!��������������!!! !bwwarn 0/1 (����/��� - �� ������� ���������), ���� ���� "����" - ������ ��� ���������� - ������������ - ������ ��� - ������ ��� ���������� ������������
# 2.5.7 1) ��������� ��������� ��������� �������� ������ (� ������ �������� � �������������) 2) ������ ����� ������������� (bwcp1251), !��������, ��� ������������� ��������������� ���������
# 2.6.7 �������� ���... ��������� � ������� ������ (��������� � ��������� �������� text_has_rus

namespace eval smartrm {
  set Version 2.6.7
        # ����� ��������� �� ������� ������������� ������ - 1 = cp1251, 0 - koi8-r
  set bwcp1251 1
  setudef flag badwords
  setudef flag bwwarn
  setudef str badword-action 
  setudef str badword-warnmode
  setudef str bw-WarnMessage
  setudef str bw-banpubmsg
        # ������������� �� ���� �� ��� � ����� ��������������
  setudef flag bwwarnops
  set WarnOpMessage "��� ��� ��� � ���!"
	# ����� ���� ���: ������� (reg), �������� (half), � ������ (voice) � �������
  set BanTime 60
  set BanTimeReg 60
  set BanTimeHalf 30
  set BanTimeVoice 60
        # ����� �������� �������� �������������� ����������� �������� %)
  set bwwarntime 60
  set BanPubText "��� ��������!"
  set BanPubMessage ""
	# ���� � ����� ;)
  set bwfile "bw.txt"
        # ���� ���������� ;)
  set bwefile "bwe.txt"
  set kickcount 0
        # �������� �� �������� �������� ����� ���� =) (��� ����� �� �����)
  set sbanmask 1 
	# 1 - *!*@some.host.com
	# 2 - *!*@*.host.com
	# 3 - *!*ident@some.domain.com
	# 4 - *!*ident@*.host.com
	# 5 - *!*ident*@*.host.com
	# 6 - *!*ident*@some.host.com
	# 7 - nick*!*@*.host.com
	# 8 - *nick*!*@*.host.com
	# 9 - nick*!*@some.host.com
	# 10 - *nick*!*@some.host.com
	# 11 - nick!ident@some.host.com
	# 12 - nick!ident@*.host.com
	# 13 - *nick*!*ident@some.host.com
	# 14 - nick*!*ident*@some.host.com
	# 15 - *nick*!*ident*@some.host.com
	# 16 - nick!*ident*@some.host.com
	# 17 - nick*!*ident@*.host.com
	# 18 - nick*!*ident*@*.host.com
	# 19 - *nick*!*ident@*.host.com
	# 20 - *nick*!*ident*@*.host.com

  # ������ ����������� ���� - ������������ � �����, ���������� ����� ��� ���������� ������ �������
  set BadWords ""
  # ������ ����������.
  set BadExepts ""
  set totalbw 0
}

proc ::smartrm::checkmodes {chan} {
 variable WarnOpMessage; variable BanPubText;
 set mode [channel get $chan badword-action]
 if { [string match $mode "none"] } { return 0 }
 if { ![string match $mode "none"] && ![string match $mode "kick"] && ![string match $mode "warn"] && ![string match $mode "ban"] && ![string match $mode "kb"] }  { channel set $chan badword-action "none" } 
 set wmode [channel get $chan badword-warnmode]
 if { ![string match $wmode "notice"] && ![string match $wmode "private"] && ![string match $wmode "channel"] }  { channel set $chan badword-warnmode "channel" }
 set wtext [channel get $chan bw-WarnMessage]
 if { [llength $wtext] == 0 } { channel set $chan bw-WarnMessage "$WarnOpMessage" }
 set ptext [channel get $chan bw-banpubmsg]
 if { [llength $ptext] == 0 } { channel set $chan bw-banpubmsg "$BanPubText" }
}

proc ::smartrm::changemode {nick uhost hand chan text} {
  ::smartrm::checkmodes $chan
  if { [llength $text] == 0 } {
       putserv "NOTICE $nick :������������ ������� �����: ������ ������ ���������:"
       putserv "NOTICE $nick :!bwmode none - ��������� ��������� (���������� !bwoff)"
       putserv "NOTICE $nick :!bwmode kick - ���� ��������� - ���"
       putserv "NOTICE $nick :!bwmode warn - ���� ��������� - ��������������"
       putserv "NOTICE $nick :!bwmode ban  - ���� ��������� - ���"
       putserv "NOTICE $nick :!bwmode kb   - ���� ��������� - ���+���"
       putserv "NOTICE $nick :������ ������ ��������� ��� ������� ban � warn"
       putserv "NOTICE $nick :!bwmode notice  - �������������� �������"
       putserv "NOTICE $nick :!bwmode private - �������������� � ������"
       putserv "NOTICE $nick :!bwmode channel - �������������� � �����"
       set mode [channel get $chan badword-action]
       set wmode [channel get $chan badword-warnmode]     
       putserv "NOTICE $nick :������� ������ ���������\[��������\/��������������\] \: $mode \/ $wmode "
       return
       }
  set text [tolower $text]
  if {[isop $nick $chan]} { 
  if {[string match $text "none"] || [string match $text "kick"] || [string match $text "warn"] || [string match $text "ban"] || [string match $text "kb"]} { 
  channel set $chan badword-action $text }
  if {[string match $text "notice"] || [string match $text "private"] || [string match $text "channel"]} {
  channel set $chan badword-warnmode $text }
  putserv "NOTICE $nick :������� ������� ����� ��\: $text"
  }
  return
}

proc ::smartrm::changewarnmsg {nick uhost hand chan text} {
  ::smartrm::checkmodes $chan
  if {[isop $nick $chan]} { 
  if { [llength $text] == 0 } {
   putserv "NOTICE $nick :������������\: !bwwarnmsg �����"
   putserv "NOTICE $nick :������ �����, ������� ���������� ���������� ���� �� �������� ������"
   return
   }
  channel set $chan bw-WarnMessage "$text"
  putserv "NOTICE $nick :������ ������� ��������� ��� WarnOpMessage\: $text "
  savechannels
  }
  return 
}

proc ::smartrm::changebanmsg {nick uhost hand chan text} {
  ::smartrm::checkmodes $chan
  if {[isop $nick $chan]} { 
  if { [llength $text] == 0 } {
   putserv "NOTICE $nick :������������\: !bwbanmsg �����"
   putserv "NOTICE $nick :������ �����, ������� ���������� ���������� ��� ���\/���"
   return
   }
  channel set $chan bw-banpubmsg "$text"
  putserv "NOTICE $nick :������ ������� ��������� ��� BanMessage\: $text "
  savechannels
  }
  return 
}

proc ::smartrm::getcmode {chan} {
  ::smartrm::checkmodes $chan
  set mode [channel get $chan badword-action]
  if { [string match $mode "none"] } { return 0 }
  if { [string match $mode "kick"] } { return 1 }
  if { [string match $mode "warn"] } { return 2 }
  if { [string match $mode "ban"]  } { return 3 }
  if { [string match $mode "kb"] } { return 4 }
} 

proc ::smartrm::getwmode {chan} {
 ::smartrm::checkmodes $chan
 set wmode [channel get $chan badword-warnmode]
 if {[string match $wmode "notice"]} { return 0 }
 if {[string match $wmode "private"]} { return 1 }
 if {[string match $wmode "channel"]} { return 2 }
} 




# ��������� ������ ������ ����
proc ::smartrm::bwload { } {
    variable BadWords; variable bwfile; variable bwefile; variable BadExepts; variable bwcp1251;
    if { $bwcp1251 == 1 } {
       encoding system iso8859-1
       } else {
       encoding system koi8-r
       }
    set file [open $bwfile]
    set BadWords [read $file]
    close $file
    set file [open $bwefile]
    set BadExepts [read $file]
    close $file
}

proc ::smartrm::bwadd {nick uhost hand chan text} {
 variable bwfile; variable BadWords;
 if {[llength $text] == 0 } {
   putserv "NOTICE $nick :!bwadd <�����>"
   return 0
   }
 set file [open $bwfile]
 set BadWords [read $file]
 close $file
 set text [tolower $text]
 set line $text
 regsub -all " " $line !SP! line
 regsub -all {\\} $line !SL! line
 regsub -all {\<} $line !LT! line
 regsub -all {\>} $line !GT! line
 regsub -all {\"} $line !QT! line
 regsub -all {\(} $line !LP! line
 regsub -all {\)} $line !RP! line
 regsub -all {\{} $line !LB! line
 regsub -all {\}} $line !RB! line
 regsub -all {\[} $line !LF! line
 regsub -all {\]} $line !RF! line
 regsub -all {\;} $line !QL! line
 regsub -all {\:} $line !CO! line 
 foreach bw $BadWords {
 if {[string match $bw $line]} {
     putserv "PRIVMSG $chan :$nick, ����� ���������� ��� ���� � �������"
     return 0
     }
 } 
 set file [open $bwfile a+]
# ����� ��� � �������� ��������� ���� ����..
 set line "$line  "
 puts $file $line
 close $file 
 putserv "PRIVMSG $chan :���������� ��������� ;)"
 set file [open $bwfile]
 set BadWords [read $file]
 close $file
 return 1
}

proc ::smartrm::bweadd {nick uhost hand chan text} {
 variable bwefile; variable BadExepts;
 if {[isop $nick $chan]} { 
 if {[llength $text] == 0 } {
   putserv "NOTICE $nick :!bweadd <�����>"
   return 0
   }
 set file [open $bwefile]
 set BadExepts [read $file]
 close $file
 set text [tolower $text]
 set line $text
 regsub -all " " $line !SP! line
 regsub -all {\\} $line !SL! line
 regsub -all {\<} $line !LT! line
 regsub -all {\>} $line !GT! line
 regsub -all {\"} $line !QT! line
 regsub -all {\(} $line !LP! line
 regsub -all {\)} $line !RP! line
 regsub -all {\{} $line !LB! line
 regsub -all {\}} $line !RB! line
 regsub -all {\[} $line !LF! line
 regsub -all {\]} $line !RF! line
 regsub -all {\;} $line !QL! line
 regsub -all {\:} $line !CO! line 
 foreach bw $BadExepts {
 if {[string match $bw $line]} {
     putserv "PRIVMSG $chan :$nick, ����� ���������� ��� ���� � �������"
     return 0
     }
 } 
 set file [open $bwefile a+]
# ����� ��� � �������� ��������� ���� ����..
 set line "$line  "
 puts $file $line
 close $file 
 putserv "PRIVMSG $chan :���������� ��������� ;)"
 set file [open $bwefile]
 set BadExepts [read $file]
 close $file
 }
 return 1
}


proc ::smartrm::bwdel {nick uhost hand chan text} {
 variable BadWords; variable bwfile;
 if {[isop $nick $chan]} { 
 if {[llength $text] == 0 } {
    putserv "NOTICE $nick :!bwdel <�����>"
    return 0
    }
 set file [open $bwfile]
 set BadWords [read $file]
 close $file
 set line $text
 regsub -all " " $line !SP! line
 regsub -all {\\} $line !SL! line
 regsub -all {\<} $line !LT! line
 regsub -all {\>} $line !GT! line
 regsub -all {\"} $line !QT! line
 regsub -all {\(} $line !LP! line
 regsub -all {\)} $line !RP! line
 regsub -all {\{} $line !LB! line
 regsub -all {\}} $line !RB! line
 regsub -all {\[} $line !LF! line
 regsub -all {\]} $line !RF! line
 regsub -all {\;} $line !QL! line
 regsub -all {\:} $line !CO! line 
 set bwind [lsearch $BadWords $line]  
 if {$bwind < 0} {
    putserv "PRIVMSG $chan :$nick, ���������� �� �������: $line"
    return 0
    }
 set BadWords [lreplace $BadWords $bwind $bwind]
 set file [open $bwfile w]
# fconfigure $file -encoding binary
 foreach i $BadWords {
   set i "$i  "
   puts $file $i
 }
 close $file

 putserv "PRIVMSG $chan :$nick, ���������� �������"
 set file [open $bwfile]
 set BadWords [read $file]
 close $file
 }
}

proc ::smartrm::bwedel {nick uhost hand chan text} {
 variable BadExepts; variable bwefile;
 if {[isop $nick $chan]} { 
 if {[llength $text] == 0 } {
    putserv "NOTICE $nick :!bwedel <�����>"
    return 0
    }
 set file [open $bwefile]
 set BadExepts [read $file]
 close $file
 set line $text
 regsub -all " " $line !SP! line
 regsub -all {\\} $line !SL! line
 regsub -all {\<} $line !LT! line
 regsub -all {\>} $line !GT! line
 regsub -all {\"} $line !QT! line
 regsub -all {\(} $line !LP! line
 regsub -all {\)} $line !RP! line
 regsub -all {\{} $line !LB! line
 regsub -all {\}} $line !RB! line
 regsub -all {\[} $line !LF! line
 regsub -all {\]} $line !RF! line
 regsub -all {\;} $line !QL! line
 regsub -all {\:} $line !CO! line 
 set bwind [lsearch $BadExepts $line]  
 if {$bwind < 0} {
    putserv "PRIVMSG $chan :$nick, ���������� �� �������: $line"
    return 0
    }
 set BadExepts [lreplace $BadExepts $bwind $bwind]
 set file [open $bwefile w]
 foreach i $BadExepts {
   set i "$i  "
   puts $file $i
 }
 close $file
 putserv "PRIVMSG $chan :$nick, ���������� �������"
 set file [open $bwefile]
 set BadExepts [read $file]
 close $file
 }
}

# ������� ���������� �����
proc ::smartrm::bwcount {nick uhost hand chan text} {
 if {![bw:active $chan]} { return }
 set kickcount [getglobalcounter $chan]
 putserv "NOTICE $nick :����� �� ���� ������ ���������� $kickcount ���"
}

# ������� ������� ���������� ����� %)
proc ::smartrm::bwstats {nick uhost hand chan text} {
 variable totalbw; variable BadWords; variable BadExepts;
 if {![bw:active $chan]} { return }
 set mode [channel get $chan badword-action]
 set wmode [channel get $chan badword-warnmode]
 set totalbw 0
 foreach element $BadWords {
 incr totalbw
 }
 set totalbe 0
 foreach element $BadExepts {
 incr totalbe
 }
 putserv "NOTICE $nick :���������� ���������:"
 putserv "NOTICE $nick : $totalbw ������ ���������� \: $totalbe ����������"
 putserv "NOTICE $nick :����� ��������\: $mode \: ����� ��������������\: $wmode"
 set kickcount [getglobalcounter $chan]
 putserv "NOTICE $nick :����� �� ���� ������ ���������� $kickcount ���"
}

# ������� ������ ���������� (� ������) <- ���������� ��� ������������ (������ ����)
proc ::smartrm::bwelist {nick uhost hand text } {
 variable BadExepts;
 foreach element $BadExepts {
 putserv "PRIVMSG $nick :$element"
 }
 return 0
}

# �������� chanset +badwords
proc bw:active {chan} {
  foreach setting [channel info $chan] {	
    if {[regexp -- {^[\+-]} $setting]} {
      if {$setting == "+badwords"} { return 1 }
    }
  }
  return 0
}



# ����� ��������� ��� �� ���� (����� ��� ����� ��� �� ������� !seen ����� ��� ������ ������ ��� �� "�!�" =)
proc check:bots {hand chan} {
		set flag_ch [chattr $hand $chan]
	if {![regexp "b" "$flag_ch"]} {	return 1 }
	return 0
	}

# ����� ������������ ���-����� ��� ������
proc ::smartrm::select_banmask {uhost nick} {
 variable sbanmask
   switch -- $sbanmask {
     1 { set banmask "*!*@[lindex [split $uhost @] 1]" }
     2 { set banmask "*!*@[lindex [split [maskhost $uhost] "@"] 1]" }
     3 { set banmask "*!*$uhost" }
     4 { set banmask "*!*[lindex [split [maskhost $uhost] "!"] 1]" }
     5 { set banmask "*!*[lindex [split $uhost "@"] 0]*@[lindex [split [maskhost $uhost] "@"] 1]" }
     6 { set banmask "*!*[lindex [split $uhost "@"] 0]*@[lindex [split $uhost "@"] 1]" }
     7 { set banmask "$nick*!*@[lindex [split [maskhost $uhost] "@"] 1]" }
     8 { set banmask "*$nick*!*@[lindex [split [maskhost $uhost] "@"] 1]" }
     9 { set banmask "$nick*!*@[lindex [split $uhost "@"] 1]" }
    10 { set banmask "*$nick*!*@[lindex [split $uhost "@"] 1]" }
    11 { set banmask "$nick*!*[lindex [split $uhost "@"] 0]@[lindex [split $uhost @] 1]" }
    12 { set banmask "$nick*!*[lindex [split $uhost "@"] 0]@[lindex [split [maskhost $uhost] "@"] 1]" }
    13 { set banmask "*$nick*!*$uhost" }
    14 { set banmask "$nick*!*[lindex [split $uhost "@"] 0]*@[lindex [split $uhost "@"] 1]" }
    15 { set banmask "*$nick*!*[lindex [split $uhost "@"] 0]*@[lindex [split $uhost "@"] 1]" } 
    16 { set banmask "$nick!*[lindex [split $uhost "@"] 0]*@[lindex [split $uhost "@"] 1]" } 
    17 { set banmask "$nick![lindex [split $uhost "@"] 0]@[lindex [split [maskhost $uhost] "@"] 1]" }
    18 { set banmask "$nick!*[lindex [split $uhost "@"] 0]*@[lindex [split [maskhost $uhost] "@"] 1]" } 
    19 { set banmask "*$nick*!*[lindex [split $uhost "@"] 0]@[lindex [split [maskhost $uhost] "@"] 1]" }
    20 { set banmask "*$nick*!*[lindex [split $uhost "@"] 0]*@[lindex [split [maskhost $uhost] "@"] 1]" } 
    default { set banmask "*!*@[lindex [split $uhost @] 1]" }
    return $banmask
   }
}

# �� ��� ��� ��������� � "����������� ������"
proc ::smartrm::tolower {text} { return [string map {� � � � � �} [string tolower $text]] }

# ��� ����� ����� ��� ����� ������������� - ������� ����� ������ ,kzlm? [eq � �.�.
proc ::smartrm::lat2rus {text} { return [string map {q � w � e � r � t � y � u � i � o � p � [ � ] � a � s � d � f � g � h � j � k � l � ; � ' � z � x � c � v � b � n � m � , � . � / . Q � W � E � R � T � Y � U � I � O � P � \{ � \} � A � S � D � F � G � H � J � K � L � : � \" � Z � X � C � V � B � N � M � < � > � ? , ^ : & ? ` � ~ � $ ;} $text] }

proc ::smartrm::is_rus {letter} {
  set caps {� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �}
  if {[lsearch -exact $caps $letter] > -1} {
	return 1
  } else {
	return 0
  }
}


proc ::smartrm::text_has_rus {text} {
  set len [string length $text]
  set cnt 0
  while {$cnt < $len} {
    if {[is_rus [string index $text $cnt]]} { return 1 }
    incr cnt
  }
  return 0
}

proc ::smartrm::is_rus {letter} {
  set caps {� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �}
  if {[lsearch -exact $caps $letter] > -1} { return 1  } else { return 0  }
}

# proc ::smartrm::text_has_rus {text} {
# if {[regexp -nocase {[qwertyuiopasdfghjklzxcvbnm]} $text]} {return 0}
# return 1
# }

proc ::smartrm::DetectMat {text} {
  variable BadWords; variable BadExepts;
  set text [encoding convertfrom [encoding system] $text]
  set text2 "$text"
  if {![text_has_rus $text2]} {
  set text2 "[lat2rus $text2]"
  regsub -all {([ \�\`\~\!\@\#\$\%\^\&\*\(\)\_\-\+\=\{\}\[\]\;\:\'\"\<\>\.\,\/\?\|\\])+} $text2 " " text2;
  }
  regsub -all {[\x02\x16\x1f]|\x03\d{0,2}(,\d{0,2})?} $text "" text
  regsub -all {[\x02\x16\x1f]|\x03\d{0,2}(,\d{0,2})?} $text2 "" text2
  set text [string map {A � a � B � C � c � E � e � H � K � k � M � O � o � P � p � T � U � u � X � x � Y � y � 3 � 4 � 6 � 0 � b � g � n �} $text]
  set text2 [string map {A � a � B � C � c � E � e � H � K � k � M � O � o � P � p � T � U � u � X � x � Y � y � 3 � 4 � 6 � 0 � b � g � n �} $text2]
  set text [tolower $text]
  set text " $text "
  set text2 [tolower $text2]
  set text2 " $text2 "
  regsub -all {([ \�\`\~\!\@\#\$\%\^\&\*\(\)\_\-\+\=\{\}\[\]\;\:\'\"\<\>\,\.\/\?\|\\])+} $text " " text;
  set res ""
  set ch ""
  for {set i 0} {$i < [string length $text]} {incr i} {
    set newch [string index $text $i]
    if {$ch != $newch} {
      append res $newch
    }
    set ch $newch
  }
  set text $res
  for {set i 0} {$i < [string length $text2]} {incr i} {
    set newch [string index $text2 $i]
    if {$ch != $newch} {
      append res $newch
    }
    set ch $newch
  }
  set text2 $res
  set returncode 0
  set bwecount 0
  foreach i $BadWords {
    regsub -nocase -all {!SP!} $i " " i
    regsub -nocase -all {!PD!} $i \. i
    regsub -nocase -all {!CO!} $i \: i
    regsub -nocase -all {!SQ!} $i \' i
    regsub -nocase -all {!QL!} $i \; i
    regsub -nocase -all {!QT!} $i \" i
    regsub -nocase -all {!LT!} $i \< i
    regsub -nocase -all {!GT!} $i \> i
    regsub -nocase -all {!LP!} $i \( i
    regsub -nocase -all {!RP!} $i \) i
    regsub -nocase -all {!LB!} $i \{ i
    regsub -nocase -all {!RB!} $i \} i
    regsub -nocase -all {!LF!} $i \[ i
    regsub -nocase -all {!RF!} $i \] i
    regsub -nocase -all {!SL!} $i \\ i

    set mask [split [string trim $i] {}]
    regsub -all { } $mask {\s*} mask
    set mask ".*\\s+$mask\\s+.*"
    if {[regexp $mask $text] || [string match *$i* $text] || [regexp $mask $text2] || [string match *$i* $text2]} {
     incr bwecount
     }
  }
  set mask ""
  set text $res
  set bweecount 0
  foreach i $BadExepts {
    regsub -nocase -all {!SP!} $i " " i
    regsub -nocase -all {!PD!} $i \. i
    regsub -nocase -all {!CO!} $i \: i
    regsub -nocase -all {!SQ!} $i \' i
    regsub -nocase -all {!QL!} $i \; i
    regsub -nocase -all {!QT!} $i \" i
    regsub -nocase -all {!LT!} $i \< i
    regsub -nocase -all {!GT!} $i \> i
    regsub -nocase -all {!LP!} $i \( i
    regsub -nocase -all {!RP!} $i \) i
    regsub -nocase -all {!LB!} $i \{ i
    regsub -nocase -all {!RB!} $i \} i
    regsub -nocase -all {!LF!} $i \[ i
    regsub -nocase -all {!RF!} $i \] i
    regsub -nocase -all {!SL!} $i \\ i

    set mask [split [string trim $i] {}]
    regsub -all { } $mask {\s*} mask
    set mask ".*\\s+$mask\\s+.*"
    if {[regexp $mask $text] || [string match *$i* $text] || [regexp $mask $text2] || [string match *$i* $text2]}  {
    incr bweecount
    }
  }
  if {$bweecount < $bwecount} { return 1 } else { return 0 }
}

proc ::smartrm::checktimers { arg } {
 if {[string match *bw:$arg* [timers]]} {
    return 1
  } else { return 0 }
}

proc ::smartrm::addtimers { arg } {
 variable bwwarntime
 timer $bwwarntime bw:$arg
 return
}


proc ::smartrm::PunishUser { nick uhost hand chan text } {
  global botnick;  variable WarnOps;  variable BanTimeReg;  variable BanTimeHalf; variable BanTimeVoice
  variable BanPubText; variable BanTime; variable BanPubMessage; variable WarnOpMessage;
  variable kickcount;
  if { [getcmode $chan] == 0 } { return }
  if {![check:bots $hand $chan]} { return }
  if {($nick == "*") || ($nick == $botnick)} { return }
  set kickcount [globalcounter $chan]
  set WarnOpMessage [channel get $chan bw-WarnMessage]
  set BanPubText [channel get $chan bw-banpubmsg]
  # ��� ��� ����� ���������� � ��� (� � ��������� ;) �� ��� ���������� �������� =) ������ �� ��� ������� ������� ���� =)
  putcmdlog "11>$nick> $chan = 4BADWORD DETECTED:11 $text "
  
  if {[isop $nick $chan]} { 
     if {![channel get $chan bwwarnops]} { return }
     if {[getwmode $chan] == 0 } { putserv "NOTICE $nick :$WarnOpMessage" }
     if {[getwmode $chan] == 1 } { putserv "PRIVMSG $nick :$WarnOpMessage" }
     if {[getwmode $chan] == 2 } { putserv "PRIVMSG $chan :$nick, $WarnOpMessage" }
     return 
     }
  set banmask [select_banmask $uhost $nick]

  if {[getcmode $chan] == 2} {
     if {[getwmode $chan] == 0 } { putserv "NOTICE $nick :$BanPubText" }
     if {[getwmode $chan] == 1 } { putserv "PRIVMSG $nick :$BanPubText" }
     if {[getwmode $chan] == 2 } { putserv "PRIVMSG $chan :$nick, $BanPubText" }
    }
  if {[channel get $chan bwwarn]} {
     if {![checktimers $banmask]}  {
         ::smartrm::addtimers $banmask
         if {[getwmode $chan] == 0 } { putserv "NOTICE $nick :$WarnOpMessage" }
         if {[getwmode $chan] == 1 } { putserv "PRIVMSG $nick :$WarnOpMessage" }
         if {[getwmode $chan] == 2 } { putserv "PRIVMSG $chan :$nick, $WarnOpMessage" }
         putserv "KICK $chan $nick :$BanPubText"         
         return 0     
         }
     }
  if {([getcmode $chan] == 3) || ([getcmode $chan] == 4)} {
     set BanTime $BanTimeReg
     if {[isvoice $nick $chan]} { set BanTime $BanTimeVoice }
     if {[ishalfop $nick $chan]} { set BanTime $BanTimeHalf }
     set BanPubMessage "$BanPubText ��� �� $BanTime �����."
     newchanban $chan $banmask $botnick $BanPubMessage $BanTime 
     if {[getwmode $chan] == 0 } { putserv "NOTICE $nick :$BanPubMessage" }
     if {[getwmode $chan] == 1 } { putserv "PRIVMSG $nick :$BanPubMessage" }
     if {[getwmode $chan] == 2 } { putserv "PRIVMSG $chan :$nick, $BanPubMessage" }
    }
  set BanPubMessage "$BanPubText"
  if {([botisop $chan] == [botishalfop $chan])} { return  }  
  if {([getcmode $chan] == 1) || ([getcmode $chan] == 4)} { 
   putserv "KICK $chan $nick :$BanPubMessage \:bwkick\: \#$kickcount \:" 
   }
}


# ��� ��� ���� ����� - ��� �� ��� ) � ����� ���� ����� ���������

proc ::smartrm::CatchMsg {nick uhost hand chan text} {
  if [bw:active $chan] {  if [DetectMat $text] { PunishUser $nick $uhost $hand $chan $text }  }
}

proc ::smartrm::CatchAction {nick uhost hand chan key text} {
  CatchMsg $nick $uhost $hand $chan $text
}


proc ::smartrm::CatchNick {nick uhost hand chan {newnick ""}} {
  variable text
  if {$newnick == ""} {set newnick $nick}
  set text [lindex [split $newnick] 0]
  CatchMsg $nick $uhost $hand $chan $text
}


proc ::smartrm::CatchTopic {nick uhost hand chan text} {
  variable Topics
  if {![bw:active $chan]} { return }
  if [DetectMat $text] {
  	 if {![check:bots $hand $chan]} {
  	 putcmdlog "11>$nick> $chan = 4������ ���� ������ = < ������ > "
  	 return 0
  	  }
    PunishUser $nick $uhost $hand $chan $text
    if {![info exists Topics($chan)] || [DetectMat $Topics($chan)]} {
      set Topics($chan) ""
    }
  # putserv "TOPIC $chan :$Topics($chan)"
  } else {
    set Topics($chan) [topic $chan]
  }
}




proc ::smartrm::BadWordsOn {nick uhost hand chan arg} {
catch {
 if {![validchan $chan]} {
  return 0
  }
  if {[isop $nick $chan]} { 
  channel set $chan +badwords
  savechannels
  putserv "NOTICE $nick :������� �� ������ �������"
  }
  return 
 } 
}

proc ::smartrm::BadWordsOff {nick uhost hand chan arg} {
catch {
 if {![validchan $chan]} {  return 0  }
 if {[isop $nick $chan]} { 
  channel set $chan -badwords
  savechannels
  putserv "NOTICE $nick :������� �� ������ ��������"
 }
 return
 }
}

proc ::smartrm::changewarnops {nick uhost hand chan text} {
if {![validchan $chan]} {  return 0  }
if {[isop $nick $chan]} { 
 if {[llength $text] == 0 } { 
     if [channel get $chan bwwarnops] { putserv "NOTICE $nick :�������������� ���������� ��������" } else { putserv "NOTICE $nick :�������������� ���������� ���������" }
     putserv "NOTICE $nick :������ �����: !bwwarnops 1 ��� !bwwarnops 0 (���/����)"
     return 0
     }
 set switched "[lindex $text 0]"
 if {$switched == "1" } {
     channel set $chan +bwwarnops
     putserv "NOTICE $nick :�������������� ���������� ��������"
     }
 if {$switched == "0" } {
     channel set $chan -bwwarnops
     putserv "NOTICE $nick :�������������� ���������� ���������"
     }
 savechannels
 }
 return 
}

proc ::smartrm::changewarn {nick uhost hand chan text} {
if {![validchan $chan]} {  return 0  }
if {[isop $nick $chan]} { 
 if {[llength $text] == 0 } { 
     if [channel get $chan bwwarn] { putserv "NOTICE $nick :�������������� ����� ����� ��������" } else { putserv "NOTICE $nick :�������������� ����� ����� ���������" }
     putserv "NOTICE $nick :������ �����: !bwwarn 1 ��� !bwwarn 0 (���/����)"
     return 0
     }
 set switched "[lindex $text 0]"
 if {$switched == "1" } {
     channel set $chan +bwwarn
     putserv "NOTICE $nick :�������������� ����� ����� ��������"
     }
 if {$switched == "0" } {
     channel set $chan -bwwarn
     putserv "NOTICE $nick :�������������� ����� ����� ���������"
     }
 savechannels
 }
 return 
}


#############################
# just a f**kin counters ;) #
#############################
proc ::smartrm::globalcounter {chan} {
 global botnick
 set bwcounterfile "$chan.bwc"
   if {![file exists $bwcounterfile]} {
     putlog "���� �������� �� ������, ������� �����"
     set file [open $bwcounterfile "w"]
     puts $file 1
     close $file 
     }
    set file [open $bwcounterfile "r"]
    set currentkicks [gets $file]
    close $file
    set file [open $bwcounterfile "w"]
    puts $file [expr $currentkicks + 1]
    close $file
    set file [open $bwcounterfile "r"]
    set currentkicks [gets $file]
    close $file
   return $currentkicks
}

proc ::smartrm::getglobalcounter {chan} {
 global botnick
 set bwcounterfile "$chan.bwc"
   if {![file exists $bwcounterfile]} {
     putlog "���� �������� �� ������, ������� �����"
     set file [open $bwcounterfile "w"]
     puts $file 1
     close $file 
     }
    set file [open $bwcounterfile "r"]
    set currentkicks [gets $file]
    close $file
   return $currentkicks
}

################################

proc ::smartrm::bwhelp {nick uhost hand chan text} {
 variable Version;
 putserv "NOTICE $nick :��������� ������ $Version"
 if {[isop $nick $chan]} { 
 putserv "NOTICE $nick :��������/���������                     : !bwon !bwoff"
 putserv "NOTICE $nick :��������/��������� �������������� ���� : !bwwarnops 1/0"
 putserv "NOTICE $nick :�������� ������� ������ ����������     : !bwadd / !bwdel"
 putserv "NOTICE $nick :��������/��������� ��������������      : !bwwarn 1/0"
 putserv "NOTICE $nick :�������� ������� ���������� ���������� : !bweadd / !bwedel"
 }
 putserv "NOTICE $nick :������ �������                         : !bwversion !bwver"
 putserv "NOTICE $nick :���������� ���������                   : !bwstats"
 if {[isop $nick $chan]} { 
 putserv "NOTICE $nick :������������ �������                   : !bwmode"
 putserv "NOTICE $nick :����� ��������� ��� ������             : !bwbanmsg / !bwwarnmsg"
 }
}

proc ::smartrm::bwver {nick uhost hand chan text} {
 variable Version;
 putserv "NOTICE $nick :��������� ������ $Version: �� ������ smartbadwords �� S0lver'a"
 putserv "NOTICE $nick :�����\: Dark_Agent (mailto:darkagent@yandex.ru)"
 putserv "NOTICE $nick :��������� � ����: Handbrake aka crackadil, Shrike, CoolCold, tigra"
}

bind join - * ::smartrm::CatchNick
bind nick - * ::smartrm::CatchNick
bind pubm - * ::smartrm::CatchMsg
bind ctcp - ACTION ::smartrm::CatchAction
bind topc - * ::smartrm::CatchTopic
bind msg - !bwelist ::smartrm::bwelist
bind pub - !bwoff ::smartrm::BadWordsOff
bind pub - !bwon ::smartrm::BadWordsOn
bind pub - !bwmode ::smartrm::changemode
bind pub - !bwcount ::smartrm::bwcount
bind pub - !bwstats ::smartrm::bwstats
bind pub mn !bwadd ::smartrm::bwadd
bind pub mn !bwdel ::smartrm::bwdel
bind pub mn !bweadd ::smartrm::bweadd
bind pub mn !bwedel ::smartrm::bwedel
bind pub - !bwhelp ::smartrm::bwhelp
bind pub - !bwver ::smartrm::bwver
bind pub - !bwversion ::smartrm::bwver
bind pub - !bwbanmsg ::smartrm::changebanmsg
bind pub - !bwwarnmsg ::smartrm::changewarnmsg
bind pub - !bwwarnops ::smartrm::changewarnops
bind pub - !bwwarn ::smartrm::changewarn

::smartrm::bwload


putlog "TCL Script> ������� ��������."
# � �� ����� (c)
# ������� ������� �� ��� ;) � ����� ���� ���������� ��� ����