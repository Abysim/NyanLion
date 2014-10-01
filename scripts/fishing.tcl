# http://mainbot.net.ru
#
# Author: Rex (rex@doze.ru)
# Основано на идее Nerfbendr
########################################################################
#!охота - поохотиться
#!рыбалка - порыбачить
#!копать - занятся археологией
#!трофеи - просто рекорды :)
########################################################################
#Планы: Раздельная статистика для каналов ;)
#Версия 1.3
#Изменены сообщения при слишком частом вводе команд, теперь отображаются забавные
#сообщения с указанием времени в минутах и секундах.
#Добавлена процедура обработки ников с запрещенными символами.
#Таймер теперь общий для всех трех команд, т.е. можно выполнять только одну из команд
#за указанное в set repeat время
#Версия 1.2
#Добавлена защита от флуда
#Версия 1.1
#Добавлены цвета в сообщения.
#Игра перенесена в канал из привата, теперь команды !охота, !рыбалка и 
#!копать надо отдавать в канале.
#
#Версия 1.0
#Первая публичная версия скрипта. 
########################################################################

bind pub - !hunt hunt
bind pub - !охота hunt
bind pub - !полювання hunt
bind pub - !cast fish
bind pub - !рыбалка fish
bind pub - !рибалка fish
bind pub - !trophy trophy
bind pub - !трофеи trophy
bind pub - !трофеї trophy
bind pub - newmonth newmonth
bind pub - !копать dig
bind pub - !копати dig
bind pub - !dig dig

set digtargets {
	"гумовий нацюцюрник"
	"мумію фараона Тутанхамона"
	"хутро невинного зайчика"
	"кольчугу з луски дракона"
	"котило-муркотило"
	"скелет пращура"
	"кривий ніж"
	"кам'яний мікроскоп"
	"Волгу 76 року"
	"порнослоника"
	"гандонокосилку"
	"петлю удавку"
	"повзучий лишай"
	"мишку для COM порту"
	"редуктор"
	"опорну балку"
	"7 дюймову трубку"
	"барокамеру"
	"мот Урал 65 року"
	"проц PІІІ 733 мгц"
	"лінійку пам'яті на 32 мегабайта"
	"пляжку пива"
	"презерватив"
	"прокладку з крильцями"
	"брудну білизну"
	"лича-некроманта"
	"яйце динозавра"
	"астральну проекцію"
	"мумію кактуса"
	"гоблінський носок"
	"ельфійський підгузник"
	"прапор гондураса"
	"конопляне поле"
	"моржову кістку"
	"бивень мамонта-їфера"
	"стрибаючий горіх"
	"гітару без струн"
	"плюшку яку їфав ..."
	"сервер з їф артом"
	"сервер з базою даі"
	"диск з системними утилітами"
	"ялинку в горщику"
	"горщик покемона"
	"лівчик неандерталки"
	"плюмбум в формі кавелика"
	"стрибаючий камінь"
	"гусеницю від танку"
	"коматозного барана"
	"газовий балон"
	"страпон"
	"лицарські лати без нажопника"
	"нажопник для лицарських лат"
	"мамонта"
	"мамонтятко"
	"льодяний палець"
	"льодяний не палець"
	"диплока"
	"птеродактиля"
	"метеорит"
	"шкарпетки прапорщика"
	"астральну сутність у формі гномика"
	"муху невмируху"
	"муху цокотуху"
	"синій мох"
	"місячний лепризорій"
	"зарядку до нокії"
	"трубу з туркменським газом"
	"індійського робота"
	"дерев'яного коника"
	"інсталятор Windows 3.11"
	"скелет хумана"
	"природний ядерний реактор"
	"вогнемет Редвіса"
	"каністру прометіума"
	"компромат на тигра"
	"гримучий смугастий хвіст"
}

set hunttargets {
"моралфага"
"ктулху-онаніста"
"муху"
"снарка"
"ситха"
"самицю черепахи"
"шериданівця"
"черепаху"
"пахучого мордосвина"
"літаючого свина"
"носорога"
"краба"
"онаніста"
"мисливця"
"пікачу"
"бджолину королеву"
"лісника"
"ведмедя-растамана"
"педобира"
"воєна упячки"
"їфера"
"розбитий унітаз"
"гобліна"
"ельфа"
"моралфaга"
"індійського демона"
"відгризені ..."
"наруто"
"бджолу"
"достоєвського"
"мерця"
"сейлор мун"
"мойдодира"
"чубаку"
"онтолле збентеженного"
"генерала"
"майора"
"бабу з тряпкою"
"маршала"
"некрофіла"
"механоїда"
"зеленого гуманоїда"
"супермена"
"сича-бараболю"
"людину-павука"
"упиря"
"гнома"
"хумана"
"туриста"
"сірого лиса"
}

set fish {
"семикрилого лускатого"
"водяного таргана"
"розумний конденсатор"
"сальмонелу"
"оселедця"
"жовтоперего тунця"
"синьо-зелену сальмонелу"
"головника"
"барбуса"
"окуня"
"верховода"
"коричневого чобота"
"полярника"
"плітку"
"зубатку"
"засоленого ..."
"стару шину"
"мариновану корягу"
"лампу джина"
"любовне послання на три літери"
"морську зірку"
"гумовий виріб"
"труп їфера"
"Лох-Несське чидовисько"
"поня синього"
"поня зеленого з крильцями та нажопним маркуванням"
"уламок Лемурії"
"кита"
"кальмара"
"дельфіна"
"ската"
"козацького підводного човна"
"медузу"
"водяного коника"
"поня педального, фарбованого в голубий, нажопне маркування - відсутнє"
"велику білу акулу"
"аквалангіста"
"монстра"
"віруса"
"сирника в сметані"
"куширі"
"якор штучного супутника"
"водяного"
"русалку"
"хабрахабрівця"
"мортировнавлілллудддіїда"
"манію молюска"
"геймера Фішкина"
"водомірку"
"водяного їфера"
"затонулого педобіра"
"вужа"
"йорша"
"саламандру з ножем"
"краба з людською головою схожою на одного відомого політика"
"незрозуміле щось"
"моралфага"
"вогнегасник"
"тентаклю"
"мацальце"
"єпитрахіль Амаранта"
"візитку Яроша"
}

set digplaces {
	"в чомусь незрозумілому"
	"в погребі Оніщенка"
	"в пустелі Гобі"
	"в місячному сяйві"
	"в архівах кривавої гебні"
	"в підвалі верховної зради"
	"на горі арарат"
	"біля погосту"
	"в морзі"
	"під пташиним гніздом"
	"в підмортирному загашнику"
	"в ельфійському погребі"
	"на Майдані"
	"в пеклі"
}	
	

set huntplaces {
"очереті"
"тундрі"
"СЛ"
"савані"
"кущах"
"гілках тополі"
"норі носорога"
"сліпому полюванні"
"норі"
"кроні дерева"
"зарослях коноплі"
"тліючих заростях коноплі"
"переході метро"
}

set fishplaces {
"потік"
"озеро"
"річку"
"підземне озеро"
"Північний Льодовитий океан"
"Індійський океан"
"тропічну калюжу"
"акваріум"
"фонтан"
}

proc time:replace { arg } {
regsub -all -- {seconds} $arg "секунд(и)" arg
regsub -all -- {minutes} $arg "хвилин(и)" arg
regsub -all -- {minute} $arg "хвилин" arg
return $arg
}

## Доп. процедура обработки ников с "запрещенными" символами.
proc service:detcl { text } {
  return [string map {\\ !1 \[ !2 \] !3 \{ !4 \} !5 \^ !6 \" !7 { } !8} $text]
}

set repeat "3600"
proc dig {nick uhost hand chan args} {
global lastcall repeat
  if { [info exist lastcall([service:detcl $nick])]&&[expr [unixtime]-$lastcall([service:detcl $nick])]<$repeat } { 
  set wtime [duration [expr $repeat-([unixtime]-$lastcall([service:detcl $nick]))]]
    putnotc $nick "Кроти їфуться, не заважайте їм, дайте їм часу [time:replace $wtime] на відпочинок. Потім знову можете копати"
    return 0
  }
  set lastcall([service:detcl $nick]) [unixtime]
global digtargets dig digplaces hunttargets fish fishplaces huntplaces
	set digplace [lindex $digplaces [rand [llength $digplaces]]]
	set artefakt [lindex $digtargets [rand [llength $digtargets]]]
      if ![file exists "digtrophy"] {
       set f [open "digtrophy" w]
       puts $f "Rex 5 автомат ППШ"
       close $f
      }
	set f [open "digtrophy" r]
	gets $f digrecord
	close $f
	set maxweight [lindex $digrecord 1]
      set maxweight [expr $maxweight + 100]
	set weightnumber [rand $maxweight]
	putserv "PRIVMSG $chan :\00302Ви почали розкопки $digplace, ви гребете всіма лапами, ви щось зачепили... що ж це?"
	if [rand 2] {
		putserv "privmsg $chan :\00302Поздоровляємо,\00313 $nick!\00302 Ви щойно викопали $artefakt, вік - $weightnumber!"
	} else {
		switch [rand 7] {
		0 { putserv "privmsg $chan :\00302Закопавшись по самі вуха $digplace,\00313 $nick,\00302 нічого ви не викопали! Може, пощастить в іншому місці?" }
		1 { putserv "privmsg $chan :\00302Закопавшись по самі вуха $digplace,\00313 $nick,\00302 ви несподівано щось зачепили, це виявився злий гномик який відлушперив вас лопатою і втік в свою нору" }
		2 { putserv "privmsg $chan :\00302Закопавшись по самі вуха $digplace,\00313 $nick,\00302 ви відчули що земля просідає у вас під лапами, ви провалились в печеру повну їфливих щурів, і вони радісно на вас накинулися..." }
		3 { putserv "privmsg $chan :\00302Закопавшись по самі вуха $digplace,\00313 $nick,\00302 ви наткнулися на щось тверде і незрозуміле, проломити його не вдалося... можливо, пощастить в іншому місці?" }
		4 { putserv "privmsg $chan :\00302Закопавшись по самі вуха $digplace,\00313 $nick,\00302 несподівано викопали мумію, поки ви на неї дивились - вона закопалася знову..." }
		5 { putserv "privmsg $chan :\00302Закопавшись по самі вуха $digplace,\00313 $nick,\00302 ви викопали ЩОСЬ, ви подивились на ЩОСЬ, і зрозуміли, що його краще тихенько закопати назад..." }
		6 { putserv "privmsg $chan :\00302Закопавшись по самі вуха $digplace,\00313 $nick,\00302 ви викопали майнкрафтівського кріпера, який несподівано вибухнув..." }
		}
		return 1
	}
set f [open "digtrophy" r]
gets $f digrecord
close $f
if { $weightnumber > [lindex $digrecord 1] } {
	putserv "privmsg $chan :\00304РРРрррииии!!! Це новий рекорд! Так тримати,\00313 $nick!\00304 Напиши !трофеї щоб це побачити!"
	#putserv "privmsg $chan :$chan щойно поклав в свій мішок $artefakt  вагою в $weightnumber і встановив новий рекорд!"
	set f [open "digtrophy" w]
	puts $f "$nick $weightnumber $artefakt"
	close $f
	return 1
} else {
	putserv "privmsg $chan :\00302Вибачай\00313 $nick, \00302але на артефакт не тягне! Пощастить іншим разом!"
	return 1
}
}


proc hunt {nick uhost hand chan args} {
global lastcall repeat
  if { [info exist lastcall([service:detcl $nick])]&&[expr [unixtime]-$lastcall([service:detcl $nick])]<$repeat } { 
  set wtime [duration [expr $repeat-([unixtime]-$lastcall([service:detcl $nick]))]]
    putnotc $nick "Почекайте [time:replace $wtime] до початку нового сезону полювання."
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
	putserv "PRIVMSG $chan :\00302Ви затаїлись в $huntplace, ви щось чуєте... Ви стріляєте!!!"
	if [rand 2] {
		putserv "privmsg $chan :\00302Поздоровляємо,\00313 $nick!\00302 Ви щойно поклали в свій мішок $critter вагою в $weightnumber кіло!"
	} else {
			switch [rand 10] {
			0 { 
			      putserv "privmsg $chan :\00302Ви вистрілили і промахнулись... щойно розвіялася курява, здійнята вашим пострілом, ви помітили, що навколо вас стоять три могутніх тигриці, вдягнені в бдсм костюми з чорних шкіряних ременів, прикрашених срібною клепанкою."
			      putserv "privmsg $chan :\00302    Лiворуч - звичайного забарвлення, жовто-чорна, чорні шкіряні ремені губляться на її смугастому хутрі.."
			      putserv "privmsg $chan :\00302    Праворуч - біло-блакитна, крізь її хутро чудово проглядають набубнявілі соски її грудей."
			      putserv "privmsg $chan :\00302    Прямо - могутня, біло-чорна тигриця, у своїх перевитих міцними м'язами лапах вона тримає нашийник з повідком... І дивиться на вас так, що ви чомусь розумієте, що краще не тікати..."
		 	}
			1 {
			      putserv "privmsg $chan :\00302Ви вистрілили... ох не варто було вам цього робити... бо щойно розвіялась курява... "
			      putserv "privmsg $chan :\00302Ви побачили броньованого слона що явно перебуває у шлюбному періоді... Вам залишається лише тікати по дорозі відкладаючи чимало цегли..."
			}
			2 {
			      putserv "privmsg $chan :\00302Ви вистрілили, і зрозуміли, що стріляли в абсолютну пустку... таке теж буває... наступного разу пощастить... можливо..."
			}
			3 {
			      putserv "privmsg $chan :\00302Ви вистрілили і промахнулись! Ох не варто вам було це робити, на вас накинулися щури і почали вам впарювати глушилки від тарганів, та ще якусь нісенітницю..."
			}
			4 {
			      putserv "privmsg $chan :\00302Ви вистрілили і промахнулись! Ох не варто вам було це робити, на вас накинулися щури і почали водити навкруги весняні хороводи, співаючи інтернаціонал..."
			}
			5 {
			      putserv "privmsg $chan :\00302Ви вистрілили і промахнулись! На постріл прибіг натовп хуманів, вони товсті та огидні, показують вам свої голі животи, відрощені у макдаках..."
			}
			6 {
			      putserv "privmsg $chan :\00302Рушниця не вистрілила, а лише зробила неприємний звук та розповсюдила навкруги дуже тяжкий запах..."
			}
			7 {
			      putserv "privmsg $chan :\00302Ви вистрілили і промахнулися... щойно розвіялася курява, здійнята вашим пострілом, ви помітили могутнього Лева в БДСМ вбранні... Втекти ви не встигли... бо ваші лапи несподівано охопили ліани..."
			}
			8 {
			      putserv "privmsg $chan :\00302Ви вистрілили і промахнулися... щойно розвіялася курява, здійнята Вашим пострілом, ви помітили якогось плюгавого хумана в брудному медецинському халаті... Він тремтить і тягне до вас свої руки примовляючи: \"о, нове м'ясо, мені буде тепер кого різати, та кому пришивати відгризені ...\""
			}
			9 {
			      putserv "privmsg $chan :\00302Ви вистрілили і промахнулися... курява повільно розвіялась..."
			      putserv "privmsg $chan :\00302Несподівано з дерева на вас звалилася самиця ягуара, затягла вас на дерево і повідомила, що їй необхідно завагітніти..."
			}
			}
		
		return 1
	}
set f [open "hunttrophy" r]
gets $f huntrecord
close $f
if { $weightnumber > [lindex $huntrecord 1] } {
	putserv "privmsg $chan :\00304УРА!!! Це новий рекорд, так тримати \00313 $nick!\00304 Напиши !трофеї щоб це побачити!"
	#putserv "privmsg $chan :$chan щойно поклали в свій мішок $critter  вагою в $weightnumber кілограм та встановили новий рекорд!"
	set f [open "hunttrophy" w]
	puts $f "$nick $weightnumber $critter"
	close $f
	return 1
} else {
	putserv "privmsg $chan :\00302Фрр! Вибачай\00313 $nick, \00302але на рекорд не тягне."
	return 1
}
}


proc fish {nick uhost hand chan args} {
global lastcall repeat
  if { [info exist lastcall([service:detcl $nick])]&&[expr [unixtime]-$lastcall([service:detcl $nick])]<$repeat } { 
  set wtime [duration [expr $repeat-([unixtime]-$lastcall([service:detcl $nick]))]]
    putnotc $nick "До закінчення нересту (це такий риб'ячий їф) лишилось [time:replace $wtime]. Пізніше можна буде ловити..."
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
	putserv "PRIVMSG $chan :\00302Ви закидаєте свою вудку в $fishplace ви підітнули щось і починаєте його швидко тягнути..."
	if [rand 2] {
		putserv "privmsg $chan :\00302Biтаю,\00313 $nick!\00302 Ви щойно спіймали $fishtocatch! аж на $weightnumber кіло!"
	} else {
		  switch [rand 9] {
			0 { 
			      putserv "privmsg $chan :\00302Фрр, твоя рибка зірвалась,\00313 $nick!\00302 Не біда, пізніше пощастить?"
			}
			1 {
			      putserv "privmsg $chan :\00302Щось несподівано смиконуло і затягло вудку в воду... пізніше пощастить... можливо..."
			}
			2 {
			      putserv "privmsg $chan :\00302Ви витягнули русалку, вона відгамселила вас своїм бюстгалтером, та, одягнувши вам його на голову, стрибонула назад у воду..."
			}
			3 {
			      putserv "privmsg $chan :\00302Ви зламали вудку, тягнучи щось з-під води, через мить на берег виліз КРАБ, озброєний ядерними боєголовками"
			}
			4 {
			      putserv "privmsg $chan :\00302Ви нічого не вловили, оскільки всі підводні жителі сьогодні проводять мітинг \"прокинься, Ктулху\" "
			}
			5 {
			      putserv "privmsg $chan :\00302Ви виловили голозадого шестилапого окуня, він дав вам кілька разів по мордасі, та й стрибнув назад у воду..."
			}
			6 {
			      putserv "privmsg $chan :\00302Ви виловили щось настільки незрозуміле, що система рекордів не може зарахувати вам цю здобич."
			}
			7 {
			      putserv "privmsg $chan :\00302Ви витягнули з води дещо, у вас є 3 секунди що б повернути це назад... якщо не встигнerror1s5w1g3%"
			}
			8 {
			      putserv "privmsg $chan :\00302Ви витягнули з води моржа, він демонструє вам свою моржову кістку та детально розповідає що саме буде зараз з вами нею робити..."
			}
			}
		
		
		
		return 1
	}
set f [open "fishtrophy" r]
gets $f fishrecord
close $f
if { $weightnumber > [lindex $fishrecord 1] } {
	putserv "privmsg $chan :\00304Мур мур мяв!!! Це ж новий рекорд! вітаю,\00313 $nick!\00304 Пиши !трофеї що б це побачити."
	#putserv "privmsg $chan :$nick щойно виловив $fishtocatch на $weightnumber кіло та встановив новий рекорд!"
	set f [open "fishtrophy" w]
	puts $f "$nick $weightnumber $fishtocatch"
	close $f
	return 1
} else {
	putserv "privmsg $chan :\00302Вибачай\00313 $nick,\00302 але це не рекорд! Спроба гарна, в майбутньому обов'язково пощастить!"
	return 1
}

}

proc newmonth {nick uhost hand chan args} {
global hunttargets fish fishplaces huntplaces
set f [open "fishtrophy" w]
puts $f "Nerfbendr 5 Guppie"
close $f
set f [open "digtrophy" w]
puts $f "Rex 5 ППШ"
close $f
set f [open "hunttrophy" w]
puts $f "Nerfbendr 5 Ant"
close $f
putserv "privmsg $chan :\00302Трапилась якась невідома хуйня! Пиши !cast чи !hunt щоб грати!"
return 1
}

proc trophy {nick uhost hand chan args} {
global hunttargets fish fishplaces huntplaces artefakt digplaces

if ![file exists "fishtrophy"] {
set f [open "fishtrophy" w]
puts $f "Nerfbendr 5 гупі"
close $f
}
if ![file exists "digtrophy"] {
set f [open "digtrophy" w]
puts $f "Rex 5 автомат ППШ"
close $f
}
if ![file exists "hunttrophy"] {
set f [open "hunttrophy" w]
puts $f "Nerfbendr 5 Энт"
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
putserv "privmsg $chan :\00304[lindex $fishrecord 0] - цей пухнастик утримує рекорд з рибалки, виловив - [lrange $fishrecord 2 end] на [lindex $fishrecord 1] кіло!"
putserv "privmsg $chan :\00304[lindex $huntrecord 0] - цей пофігіст став рекордсменом-мисливцем, здобувши [lrange $huntrecord 2 end]! Вагою в [lindex $huntrecord 1] кіло!"
putserv "privmsg $chan :\00304[lindex $digrecord 0] - цей растаман найкращий археолог, викопав [lrange $digrecord 2 end]! Bік артефакту -  [lindex $digrecord 1]!"
return 1
}