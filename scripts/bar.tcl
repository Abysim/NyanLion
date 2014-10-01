#################################################################################
# Описание: 
#	Виртуальный бар, включает в себя достаточно много напитков с рандомными ответами
#	встроенное бар-меню. Задержку перед использованием команды. Запрет на использование
#	функций бара на определенном канале. Бот не будет отвечать на команды типа !пиво всем
#	и т.п., теперь проерка идеть на то, есть ли ник на канале. Возможность запретить 
#	использование команды !пиво <ник_вашего_бота>.
#
# Команды:
#	!бар
#	!пиво
#	!водка
#	!коньяк
#	!коктейл
#	!вино
#	!шампанское
#	!кофе
#	!чай
#	!сок
#	!вода
#
# Поддержка:
# http://www.hackersforce.com
# http://forum.hackersforce.com
# irc.hackersforce.com:6667 - #hackers
#
# Автор:
#	МРАК
#
# Флаги канала:
#	.chanset #chan +nopubbar - отключит любые команды бара на канале #chan
#	.chanset #chan -nopubbar - включит любые команды бара на канале #chan
#	команда подается в partyline (DCC CHAT) у бота.
#
# Версия: 
#	1.0
#################################################################################
# История версий:
#
# версия 1.0
#	+ на каждый вид из меню бара добавлены рандомные ответы
#	+ возможность запрета использования бара на определенном канале
#	+ Время перед повторным использованием команды на канале.
#	+ Проверка на присутствие ника на канале, чтобы не делали например: 
#	"!пиво Васе о голову" м т.п.
#	+ Добавлен help бар-меню, с возможностью выбора его вывода.
#	+ Возможность запретить использовать функции бара со стороны пользователей 
#	в сторону бота. Бот будет отвечать нотисом, и делать смешное действие от имени 
#	пользователя.
#################################################################################
setudef flag nopubbar

# Префикс перед использованием команд
set bar(prefix) "!"

# Время перед повторным использованием команд бара (в секундах).
set bar(time) 0

# Вариан вывода хелпа по команде !бар (1 - многострочный, 0 - двухстрочный)
set bar(helpmode) 1

# Что сделать при попытке использовать функции бара в сторону бота. Пример !пиво <ник бота>
# 0 - разрешить пользователю заказывать что-то в баре для бота
# 1 - запретить пользователю заказывать что-то в баре для бота, Тогда бот будет отвечать натисом
# юзеру, то что ему ненадо ничего. И делать смешное действие от лица пользователя на канале.
set bar(botuse) 1

# откуда вытаскивать
set bar(find) {
 {дістав з бару}
 {витяг з бару}
 {взяв з полиці}
 {взяв зі столу}
 {приніс з магазину}
 {витягнув з шухляди}
 {купив}
}

# метод перидачи напитков
set bar(put) {
 {та передав}
 {та принюхавшись, передав}
 {та муркочучи, передав}
 {та фиркнувши, передав}
 {та киданув}
 {та протягнув}
 {та благоговійно підніс}
 {та раболіпно преподав}
 {та поблажливо вручив}
 {й огидливо жбуранув у}
 {та зробив гримасу відрази передав}
 {та, додавши ложечку ціаніду, передав}
}

# нотис юзеру, перед выполнением действия им. Когда юзер заказывает что-то для бота (если bar(botuse) = 1)
set bar(notceruser) {
 {Фрр!}
 {дякую але я сам}
 {ФРРР! мені і самому не важко!}
 {Фрр! З мене досить!}
 }

# Действия ника (::), при попытке использовать функции бара в сторону бота, от лица бота (если bar(botuse) = 1)
set bar(erruser) {
 {пшшш!}
 {шипить}
 {чеше задньою лапою за вухом}
} 


set bar(version) 1.0
set bar(autors) MPAK
set bar(email) mpak@nordlines.ru



bind pub - $bar(prefix)кофе pub:kofe
bind pub - $bar(prefix)kofe pub:kofe
bind pub - $bar(prefix)кава pub:kofe
bind pub - $bar(prefix)кави pub:kofe
bind pub - $bar(prefix)сок pub:sok
bind pub - $bar(prefix)sok pub:sok
bind pub - $bar(prefix)сік pub:sok
bind pub - $bar(prefix)juice pub:sok
bind pub - $bar(prefix)соку pub:sok
bind pub - $bar(prefix)чай pub:tea
bind pub - $bar(prefix)чаю pub:tea
bind pub - $bar(prefix)tea pub:tea
bind pub - $bar(prefix)воды pub:voda
bind pub - $bar(prefix)води pub:voda
bind pub - $bar(prefix)water pub:voda
bind pub - $bar(prefix)вода pub:voda



proc pub:pivo {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {бутылочку пива 'Славутич'}
 {бутылку пива 'Славутич'}
 {банку пива 'Славутич'}
 {бутылочку пива 'LowenBrau'}
 {бутылку пива 'LowenBrau'}
 {банку пива 'LowenBrau'}
 {бутылочку пива 'Черниговское'}
 {бутылку пива 'Черниговское'}
 {банку пива 'Черниговское'}
 {бутылочку пива 'Оболонь Премиум'}
 {бутылку пива 'Оболонь Премиум'}
 {банку пива 'Оболонь Премиум'}
 {бутылочку пива 'Галицкая Корона'}
 {бутылку пива 'Галицкая Корона'}
 {банку пива 'Галицкая Корона'}
 {бутылочку пива 'Львовское 1715'}
 {бутылку пива 'Львовское 1715'}
 {банку пива 'Львовское 1715'}
 {втихаря пихнула кружку себе меж ног}
 {думая что никто не видит, пихнула пивную кружку себе меж ног}
 {бутылочку пива 'Сармат'}
 {бутылку пива 'Сармат'}
 {банку пива 'Сармат'}
 {бутылочку пива 'Черниговское Белое'}
 {бутылку пива 'Черниговское Белое'}
 {банку пива 'Черниговское Белое'}
 {бутылочку пива 'Warsteiner'}
 {бутылку пива 'Warsteiner'}
 {банку пива 'Warsteiner'}
 {бутылочку пива 'ZIP'}
 {бутылку пива 'ZIP'}
 {банку пива 'ZIP'}
 {бутылочку пива 'Бердичевское'}
 {бутылку пива 'Бердичевское'}
 {банку пива 'Бердичевское'}
 {бутылочку пива 'Staropramen'}
 {бутылку пива 'Staropramen'}
 {банку пива 'Staropramen'}
 {бутылочку пива 'Радомышль'}
 {бутылочку пива 'Kozel'}
 {бутылку пива 'Holsten'}
 {банку пива 'Gold Pfeasant'}
 {банку пива 'Хундертауэр'}
 {банку пива 'Гоблэнд N1'}
 {банку пива 'Гоблэнд N2'}
 {банку пива 'Гоблэнд N3'}
 {банку пива 'Гоблэнд N4'}
 {банку пива 'Гоблэнд N5'}
 {банку пива 'Гоблэнд N6'}
 {банку пива 'Гоблэнд N7'}
 {банку пива 'Гоблэнд N8'}
 {банку пива 'Гоблэнд N9'}
 {банку пива 'Гоблэнд N10'}
 {банку пива 'Гоблэнд N11'}
 {банку пива 'Гоблэнд N12'}
 {банку пива 'Заклинание старого друида'}
 {бутылку пива 'Хундертауэр'}
 {бутылку пива 'Гоблэнд N1'}
 {бутылку пива 'Гоблэнд N2'}
 {бутылку пива 'Гоблэнд N3'}
 {бутылку пива 'Гоблэнд N4'}
 {бутылку пива 'Гоблэнд N5'}
 {бутылку пива 'Гоблэнд N6'}
 {бутылку пива 'Гоблэнд N7'}
 {бутылку пива 'Гоблэнд N8'}
 {бутылку пива 'Гоблэнд N9'}
 {бутылку пива 'Гоблэнд N10'}
 {бутылку пива 'Гоблэнд N11'}
 {бутылку пива 'Гоблэнд N12'}
 {бутылку пива 'Заклинание старого друида'}
 {кружку пива 'Хундертауэр'}
 {кружку пива 'Гоблэнд N1'}
 {кружку пива 'Гоблэнд N2'}
 {кружку пива 'Гоблэнд N3'}
 {кружку пива 'Гоблэнд N4'}
 {кружку пива 'Гоблэнд N5'}
 {кружку пива 'Гоблэнд N6'}
 {кружку пива 'Гоблэнд N7'}
 {кружку пива 'Гоблэнд N8'}
 {кружку пива 'Гоблэнд N9'}
 {кружку пива 'Гоблэнд N10'}
 {кружку пива 'Гоблэнд N11'}
 {кружку пива 'Гоблэнд N12'}
 {кружку пива 'Заклинание старого друида'}
 {бутылочку пива 'Zipfer'}
 {бутылку пива 'Zipfer'}
 {банку пива 'Zipfer'}
 {бутылочку пива 'Рогань'}
 {бутылку пива 'Рогань'}
 {банку пива 'Рогань'}
 {бутылочку пива 'Tuborg'}
 {бутылку пива 'Tuborg'}
 {банку пива 'Tuborg'}
 {бутылочку пива 'Carlsberg'}
 {бутылку пива 'Carlsberg'}
 {банку пива 'Carlsberg'}
 {Кувшин молока}
 {Кувшин Кумыса}
 {Горшочек с молозывом}
 {банку пива 'Хундертауэр'}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017"
 }
}

proc pub:vodka {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {бутылку водки 'Украинка', налила рюмаху}
 {бутылку водки '5 капель', плеснула рюмаху}
 {бутылку водки 'Хортица', налила в рюмочку}
 {бутылку водки 'Цельсий', налила в рюмку}
 {бутылку водки 'Билэнька', налила в граненый стакан}
 {бутылку водки 'Первак', налила в рюмаху}
 {бутылку водки 'Юрий Долгорукий', плеснула в рюмаху}
 {бутылку водки 'Гетьман', аккуратненько налила в рюмочку,}
 {бутылку водки 'Немирофф', налила в рюмку}
 {бутылку водки 'Хлебный Дар', плеснула в рюмку}
 {пузырь водяры, плеснула в рюмку}
 {банку самогона, ливанула в рюмку}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:voda {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {пляшечку води 'Аква Мінерале', налив в склянку}
 {пів літрову пляшечку води 'Бон Аква'}
 {воду 'Драгівська'}
 {глечик з водою 'Нарзан', налив в келих}
 {пляшку води 'Поляна'}
 {літрову пляшку води 'Оболонь', налив в склянку}
 {воду 'Лужанська-7', налив в кухоль}
 {пляшку води 'Аляска', налив в кухоль}
 {пляшечку водички 'Лужанська-3', акуратненько налив в келих}
 {воду 'Миргородська', хлюпнув в склянку}
 {баночку води 'Pepsi'}
 {пляшечку води 'Coca-Cola'}
 {пляшечку води 'Pepsi', налив в склянку}
 {пляшечку води 'Coca-Cola', акуратно налив в склянку}
 {баночку 'Sprite'}
 {літрову пляшку води '7 UP', налив в склянку}
 {води 'Fanta', налив в келих}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:kokteil {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {коктейль 'Казанова Дыня'}
 {баночку коктейля'Казанова'}
 {банку коктейля 'Трофи Фейхоа'}
 {коктейль 'Трофи Дыня'}
 {баночку коктейля 'Трофи'}
 {коктейль 'МАГДАЛИНА'}
 {коктейль 'отвертка'}
 {банку коктейля 'отвертка'}
 {коктейль 'Bravo'}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:vino {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(find) {
 {достала из бара}
 {вытащила из бара}
 {взяла с полки}
 {взяла со стола}
 {достала из погреба}
 {достала из погребка}
 {принесла из магазина}
 {вытащила из тумбочки}
 {купила}
}

set bar(drink) {
 {бутылку вина 'Мерло', налила бокал}
 {бутылку вина 'Изабелла', осторожно налила бокал}
 {вино 'Кагор', аккуратно налила бокал}
 {бутылку вина 'Кровь Драконa', налила бакал}
 {вино 'Каберне Чизай', налила бокал}
 {бутылку вина 'Берегвайн Токай', аккуратно налила бокал}
 {вино 'Тамянка Чизай', налила бокал}
 {бутылку вина 'Бовийон Бордо', осторожно налила бокальчик}
 {вино 'Кюве Дю Пап', налила бокал}
 {бутылку вина 'Листель Мерло', осторожно открыл, налила бокал}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:kofe {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {банку 'Nescafe', зкипятив чайник, приготував чашечку ( http://fun-gallery.com/wp-content/uploads/2011/06/Cat-Coffee-Art.jpg )}
 {банку 'Nescafe', приготував чашечку ароматної кави ( http://fun-gallery.com/wp-content/uploads/2011/06/Bunny-Coffee-Art.jpg )}
 {банку кофе 'Jacobs', проготував чашечку ( http://fun-gallery.com/wp-content/uploads/2011/06/Panda-Coffee-Art.jpg )}
 {каву 'Chibo', приготував ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-8.jpg )}
 {'Маккофе', заварив чашечку ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-7.jpg )}
 {пакет зернової кави, намолов, приготував чашечку ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-6.jpg )}
 {пакет зернової кави, намолов, приготував чашечку ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-5.jpg )}
 {молоту каву, приготував чашечку ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-4.jpg )}
 {каву, зник незрозуміло куди, приніс чашечку ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-2.jpg )}
 {чашечку кави, намалювавши в піні лапки ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-3.jpg )}
 {чашечку кави, щось робив над нею... ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-1.jpg )}
 {термос з кавою, налив з нього в чашечку ( http://www.kittenspet.com/wp-content/uploads/2011/12/coffee-cat-.jpg )}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:sok {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар тимчасово не працює.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {пачку соку 'Jaffa', налив в склянку}
 {сік 'Садочок', обережно налив в склянку}
 {Апельсиновий сік}
 {пачку Апельсинового соку, налив в склянку}
 {пачку соку 'Добрий', обережно налив в келих}
 {пачку соку 'Santal', налив в склянку}
 {сік 'Біола'}
 {Ананасовий сік, налив в скляночку}
 {сік 'Улюблений Сад', налив в склянку}
 {сік 'Rich', налив в стакан}
 {сік 'Rich', обережно налив в склянку}
 {Сок 'Тигрині секрети', посміхаючись націдив в склянку}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:koniak {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар тимчасово не працює.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033будь яка команда бару буде доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {коньяк 'Гринвич', плеснула рюмку}
 {бутылку коньяка 'Тиса', аккуратно налила рюмку}
 {коньяк 'Закарпатский', налила рюмаху}
 {коньяк 'Ужгород', осторожно налила рюмаху}
 {бутылку коньяка 'Арарат', налила рюмку}
 {бутылку коньяка 'Карпаты', неспеша налила рюмку }
 {коньяк 'Квинт', налила рюмочку}
 {бутылку коньяка 'Реми-Мартен', аккуратно налила рюмку}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:shampanskoe {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {шампанское 'Крымское', налила фужер}
 {'Советское' шампанское, аккуратно налила фужер}
 {бутылку шампанского 'Корнет', налила фужер}
 {шампанское 'Одесса', осторожно налила фужер}
 {бутылку 'Асти Мондоро', неспеша налила фужер}
 {шампанское 'Вдова Клико', налила фужер}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:tea {nick uhost hand chan args} {
 global botnick bar
 set args [lindex $args 0]

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return
 }

set barline [utimers]
foreach line $barline {
 if {"bar:reset $uhost" == [lindex $line 1]} { set bartime [lindex $line 0] }
 }
 if { [info exists bar(host,$uhost)] } { 
	set temp [duration $bartime] 
        	regsub -all -- {hours} $temp {час(ов)} temp 
	        regsub -all -- {hour} $temp {час} temp 
		regsub -all -- {minutes} $temp {минут(ы)} temp
        	regsub -all -- {minute} $temp {минуту} temp
		regsub -all -- {seconds} $temp {секунд(ы)} temp
		regsub -all -- {second} $temp {секунду} temp
 if {$bar(time) > 0} { putserv "NOTICE $nick :\0033Любая команда бара будет доступна через \0037\002$temp\002\017" }
 return
 }

set bar(host,$uhost) 1
set bar(timer,$uhost) [utimer $bar(time) [list bar:reset $uhost ] ]

set bar(drink) {
 {чай 'Lipton', заварив кружку}
 {чай 'Бесіда', заварив кружку}
 {чай 'Ахмад', заварив в кружці}
 {чай 'Мілфорд', заварив кружку}
 {'Травневий' чай, заварив}
 {Зелений чай, котрий Ахмед, збирач чаю, збирав з любов'ю та ніжністю}
 {Традиційний Ерл Грей привезений на англійских галерах із делекої Індії}
 {відвар листя Сенни}
 {відвар Звіробою}
 {відвар із курячих лапок з ромашкою}
 {Сому із вівтарів храму Великого Панехта}
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
  putserv "NOTICE $nick :\0037\002$args\002\00310 відсутній на каналі \0037\002$chan\017" 
 }
}

proc pub:barhelp {nick uhost hand chan args} {
 global botnick bar

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return 
 }

 if {$bar(helpmode) == 1} {
  putserv "PRIVMSG $nick :Меню бара у \002$botnick\002"
  putserv "PRIVMSG $nick :\002$bar(prefix)бар\002 - меню бара у $botnick"
  putserv "PRIVMSG $nick :\002$bar(prefix)пиво\002 - бот нальет вам виртуального пива"
  putserv "PRIVMSG $nick :\002$bar(prefix)водка\002 - бот нальет вам виртуальной водки"
  putserv "PRIVMSG $nick :\002$bar(prefix)коньяк\002 - бот нальет вам коньяк"
  putserv "PRIVMSG $nick :\002$bar(prefix)коктейл\002 - бот достанет и передаст или нальет вам коктейль"
  putserv "PRIVMSG $nick :\002$bar(prefix)вино\002 - бот достанет и нальет вино специально для вас"
  putserv "PRIVMSG $nick :\002$bar(prefix)шампанское\002 - бот нальет вам шампанского"
  putserv "PRIVMSG $nick :\002$bar(prefix)кофе\002 - бот приготовит ароматный вам кофе"
  putserv "PRIVMSG $nick :\002$bar(prefix)чай\002 - бот приготовит вам чай"
  putserv "PRIVMSG $nick :\002$bar(prefix)сок\002 - бот принесет или нальет вам сок"
  putserv "PRIVMSG $nick :\002$bar(prefix)вода\002 - бот достанет и передаст вам или нальет воды"
  putserv "PRIVMSG $nick :Использование: \002$bar(prefix)пиво\002 - $botnick нальет вам пиво, \002$bar(prefix)пиво <ник>\002 - $botnick нальет пиво \002<ник>\002"
 return
 } else {
  putserv "NOTICE $nick :\00310Команды бара у \002$botnick\002: \0037$bar(prefix)пиво, $bar(prefix)водка, $bar(prefix)коньяк, $bar(prefix)коктейл, $bar(prefix)вино, $bar(prefix)шампанское, $bar(prefix)кофе, $bar(prefix)чай, $bar(prefix)сок, $bar(prefix)вода\017"
  putserv "NOTICE $nick :\00310Возможно использование:\0037 $bar(prefix)пиво\00310 - $botnick нальет вам пиво,\0037 $bar(prefix)пиво <ник>\00310 - $botnick нальет пиво <ник>\017"
 }
}

proc msg:barhelp {nick uhost hand args} {
 global botnick bar

 if {$bar(helpmode) == 1} {
  putserv "PRIVMSG $nick :Меню бара у \002$botnick\002"
  putserv "PRIVMSG $nick :\002$bar(prefix)бар\002 - меню бара у $botnick"
  putserv "PRIVMSG $nick :\002$bar(prefix)пиво\002 - бот нальет вам виртуального пива"
  putserv "PRIVMSG $nick :\002$bar(prefix)водка\002 - бот нальет вам виртуальной водки"
  putserv "PRIVMSG $nick :\002$bar(prefix)коньяк\002 - бот нальет вам коньяк"
  putserv "PRIVMSG $nick :\002$bar(prefix)коктейль\002 - бот достанет и передаст или нальет вам коктейль"
  putserv "PRIVMSG $nick :\002$bar(prefix)вино\002 - бот достанет и нальет вино специально для вас"
  putserv "PRIVMSG $nick :\002$bar(prefix)шампанское\002 - бот нальет вам шампанского"
  putserv "PRIVMSG $nick :\002$bar(prefix)кофе\002 - бот приготовит ароматный вам кофе"
  putserv "PRIVMSG $nick :\002$bar(prefix)чай\002 - бот приготовит вам чай"
  putserv "PRIVMSG $nick :\002$bar(prefix)сок\002 - бот принесет или нальет вам сок"
  putserv "PRIVMSG $nick :\002$bar(prefix)вода\002 - бот достанет и передаст вам или нальет воды"
  putserv "PRIVMSG $nick :Использование: \002$bar(prefix)пиво\002 - $botnick нальет вам пиво, \002$bar(prefix)пиво <ник>\002 - $botnick нальет пиво \002<ник>\002"
 return
 } else {
  putserv "NOTICE $nick :\00310Команды бара у \002$botnick\002: \0037$bar(prefix)пиво, $bar(prefix)водка, $bar(prefix)коньяк, $bar(prefix)коктейль, $bar(prefix)вино, $bar(prefix)шампанское, $bar(prefix)кофе, $bar(prefix)чай, $bar(prefix)сок, $bar(prefix)вода\017"
  putserv "NOTICE $nick :\00310Возможно использование:\0037 $bar(prefix)пиво\00310 - $botnick нальет вам пиво,\0037 $bar(prefix)пиво <ник>\00310 - $botnick нальет пиво <ник>\017"
 }
}

proc pub:barnone {nick uhost hand chan args} {
 global botnick bar

 if {[channel get $chan nopubbar]} {
  putserv "NOTICE $nick :\00310На канале \0037\002$chan\002\00310 бар временно не работает.\017\017"
 return 
 }
  putserv "NOTICE $nick :\0033Такой команды в меню бара нет. Используйте \0037\002$bar(prefix)бар\002\0033 для ознакомления с \0037'Меню бара у $botnick'\017"
}

proc bar:reset { uhost } {
 global bar
 catch {killutimer $bar(timer,$uhost)}
 catch {unset bar(timer,$uhost)}
 catch {unset bar(host,$uhost)}
}


putlog "bar.tcl v$bar(version) by $bar(autors) loaded - $bar(email)"