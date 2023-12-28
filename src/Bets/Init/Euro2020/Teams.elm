module Bets.Init.Euro2020.Teams exposing (..)

import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Winner(..))
import Bets.Types.Team exposing (team)



-- teams
-- regex  \([^)]*\),


turkey : TeamDatum
turkey =
    { team = { teamID = "TUR", teamName = "Turkey" }
    , players =
        [ "Gökhan Akkan"
        , "Altay Bayindir"
        , "Ugurcan Çakir"
        , "Mert Günok"
        , "Kaan Ayhan"
        , "Zeki Çelik"
        , "Merih Demiral"
        , "Ozan Kabak"
        , "Umut Meras"
        , "Mert Müldür"
        , "Çaglar Söyüncü"
        , "Ridvan Yilmaz"
        , "Taylan Antalyali"
        , "Hakan Çalhanoglu"
        , "Irfan Can Kahveci"
        , "Orkun Kökçü"
        , "Mahmut Tekdemir"
        , "Dorukhan Toköz"
        , "Ozan Tufan"
        , "Yusuf Yazici"
        , "Okay Yokuslu"
        , "Halil Akbunar"
        , "Kerem Aktürkoglu"
        , "Halil Dervisoglu"
        , "Efecan Karaca"
        , "Kenan Karaman"
        , "Abdülkadir Ömür"
        , "Enes Ünal"
        , "Cengiz Ünder"
        , "Burak Yilmaz"
        ]
    , group = A
    }


wales : TeamDatum
wales =
    { team = { teamID = "WAL", teamName = "Wales" }
    , players =
        [ "Wayne Hennessey", "Danny Ward", "Adam Davies", "Chris Gunter", "Ben Davies", "Connor Roberts", "Ethan Ampadu", "Chris Mepham", "Joe Rodon", "James Lawrence", "Neco Williams", "Rhys Norrington-Davies", "Ben Cabango", "Aaron Ramsey", "Joe Allen", "Jonny Williams (Cardiff City, Harry Wilson", "Daniel James", "David Brooks", "Joe Morrell", "Matt Smith", "Dylan Levitt", "Rubin Colwill", "Gareth Bale", "Kieffer Moore", "Tyler Roberts" ]
    , group = A
    }


italy : TeamDatum
italy =
    { team = { teamID = "ITA", teamName = "Italy" }
    , players =
        [ "Alessio Cragno"
        , "Gianluigi Donnarumma"
        , "Alex Meret"
        , "Salvatore Sirigu"
        , "Francesco Acerbi"
        , "Alessandro Bastoni"
        , "Cristiano Biraghi"
        , "Leonardo Bonucci"
        , "Giorgio Chiellini"
        , "Giovanni Di Lorenzo"
        , "Alessandro Florenzi"
        , "Manuel Lazzari"
        , "Gianluca Mancini"
        , "Leonardo Spinazzola"
        , "Rafael Tolói"
        , "Nicolò Barella"
        , "Gaetano Castrovilli"
        , "Bryan Cristante"
        , "Manuel Locatelli"
        , "Lorenzo Pellegrini"
        , "Matteo Pessina"
        , "Stefano Sensi"
        , "Marco Verratti"
        , "Andrea Belotti"
        , "Domenico Berardi"
        , "Federico Bernardeschi"
        , "Federico Chiesa"
        , "Vincenzo Grifo"
        , "Ciro Immobile"
        , "Lorenzo Insigne"
        , "Moise Kean"
        , "Matteo Politano"
        , "Giacomo Raspadori"
        ]
    , group = A
    }


switzerland : TeamDatum
switzerland =
    { team = { teamID = "SUI", teamName = "Switzerland" }
    , players =
        [ "Yann Sommer"
        , "Yvon Mvogo"
        , "Jonas Omlin"
        , "Gregor Kobel"
        , "Manuel Akanji"
        , "Loris Benito"
        , "Nico Elvedi"
        , "Kevin Mbabu"
        , "Becir Omeragic"
        , "Ricardo Rodríguez"
        , "Silvan Widmer"
        , "Fabian Schär"
        , "Jordan Lotomba"
        , "Eray Cömert"
        , "Granit Xhaka"
        , "Denis Zakaria"
        , "Remo Freuler"
        , "Djibril Sow"
        , "Admir Mehmedi"
        , "Xherdan Shaqiri"
        , "Ruben Vargas"
        , "Steven Zuber"
        , "Edimilson Fernandes"
        , "Christian Fassnacht"
        , "Dan Ndoye"
        , "Andi Zeqiri"
        , "Breel Embolo"
        , "Mario Gavranović"
        , "Haris Seferović"
        ]
    , group = A
    }



-- Group B (Copenhagen/St Petersburg): Denmark (hosts), Finland, Belgium, Russia (hosts)


denmark : TeamDatum
denmark =
    { team = { teamID = "DEN", teamName = "Denmark" }
    , players =
        [ "Jonas Lössl"
        , "Frederik Rønnow"
        , "Kasper Schmeichel"
        , "Joachim Andersen"
        , "Nicolai Boilesen"
        , "Andreas Christensen"
        , "Mathias Jørgensen"
        , "Simon Kjaer"
        , "Joakim Maehle"
        , "Jens Stryger Larsen"
        , "Jannik Vestergaard"
        , "Daniel Wass"
        , "Anders Christiansen"
        , "Mikkel Damsgaard"
        , "Thomas Delaney"
        , "Christian Eriksen"
        , "Pierre-Emile Højbjerg"
        , "Mathias Jensen"
        , "Christian Nørgaard"
        , "Robert Skov"
        , "Martin Braithwaite"
        , "Andreas Cornelius"
        , "Kasper Dolberg"
        , "Andreas Skov Olsen"
        , "Yussuf Poulsen"
        , "Jonas Wind"
        ]
    , group = B
    }


finland : TeamDatum
finland =
    { team = { teamID = "FIN", teamName = "Finland" }
    , players =
        [ "Lukáš Hrádecký"
        , "Jesse Joronen"
        , "Anssi Jaakkola"
        , "Nikolai Alho"
        , "Paulus Arajuuri"
        , "Albin Granlund"
        , "Nicholas Hamalainen"
        , "Robert Ivanov"
        , "Daniel O’Shaughnessy"
        , "Juhani Ojala"
        , "Jere Uronen"
        , "Leo Väisänen"
        , "Sauli Väisänen"
        , "Frederik Jensen"
        , "Glen Kamara"
        , "Joni Kauko"
        , "Thomas Lam"
        , "Rasmus Schüller"
        , "Pyry Soiri"
        , "Tim Sparv"
        , "Onni Valakari"
        , "Jasin-Amin Assehnoun"
        , "Marcus Forss"
        , "Lassi Lappalainen"
        , "Joel Pohjanpalo"
        , "Teemu Pukki"
        ]
    , group = B
    }


russia : TeamDatum
russia =
    { team = team "RUS" "Rusland"
    , players =
        [ "Yuri Dyupin"
        , "Andrey Lunev"
        , "Matvey Safonov"
        , "Anton Shunin"
        , "Igor Diveyev"
        , "Georgi Dzhikiya"
        , "Mário Fernandes"
        , "Vyacheslav Karavaev"
        , "Fedor Kudryashov"
        , "Ilya Samoshnikov"
        , "Andrey Semenov"
        , "Roman Yevgenyev"
        , "Yuri Zhirkov"
        , "Dmitri Barinov"
        , "Daniil Fomin"
        , "Aleksandr Golovin"
        , "Daler Kuzyaev"
        , "Denis Makarov"
        , "Aleksey Miranchuk"
        , "Maksim Mukhin"
        , "Magomed Ozdoev"
        , "Arsen Zakharyan"
        , "Roman Zobnin"
        , "Denis Cheryshev"
        , "Artem Dzyuba"
        , "Alexey Ionov"
        , "Andrey Mostovoy"
        , "Aleksandr Sobolev"
        , "Anton Zabolotny"
        , "Rifat Zhemaletdinov"
        ]
    , group = B
    }


belgium : TeamDatum
belgium =
    { team = team "BEL" "België"
    , players =
        [ "Thibaut Courtois"
        , "Simon Mignolet"
        , "Mats Selz"
        , "Toby Alderweireld"
        , "Dedryck Boyata"
        , "Jason Denayer"
        , "Thomas Vermaelen"
        , "Jan Vertonghen"
        , "Timothy Castagne"
        , "Nacer Chadli"
        , "Yannick Carrasco"
        , "Kevin De Bruyne"
        , "Leander Dendoncker"
        , "Thorgan Hazard"
        , "Thomas Meunier"
        , "Dennis Praet"
        , "Youri Tielemans"
        , "Hans Vanaken"
        , "Axel Witsel"
        , "Michy Batshuayi"
        , "Christian Benteke"
        , "Jérémy Doku"
        , "Eden Hazard"
        , "Romelu Lukaku"
        , "Dries Mertens"
        , "Leandro Trossard"
        ]
    , group = B
    }



-- Group C (Amsterdam/Bucharest): Netherlands (hosts), Ukraine, Austria, Play-off winner D or A


netherlands : TeamDatum
netherlands =
    { team = { teamID = "NED", teamName = "Nederland" }
    , players =
        [ "Marco Bizot"
        , "Tim Krul"
        , "Maarten Stekelenburg"
        , "Patrick van Aanholt"
        , "Nathan Aké"
        , "Daley Blind"
        , "Denzel Dumfries"
        , "Matthijs de Ligt"
        , "Jurriën Timber"
        , "Joël Veltman"
        , "Stefan de Vrij"
        , "Owen Wijndal"
        , "Donny van de Beek"
        , "Ryan Gravenberch"
        , "Frenkie de Jong"
        , "Davy Klaassen"
        , "Teun Koopmeiners"
        , "Marten de Roon"
        , "Georginio Wijnaldum"
        , "Steven Berghuis"
        , "Memphis Depay"
        , "Cody Gakpo"
        , "Luuk de Jong"
        , "Donyell Malen"
        , "Quincy Promes"
        , "Wout Weghorst"
        ]
    , group = C
    }


ukraine : TeamDatum
ukraine =
    { team = { teamID = "UKR", teamName = "Oekraïne" }
    , players =
        [ "Georgiy Bushchan"
        , "Andriy Lunin"
        , "Andriy Pyatov"
        , "Anatolii Trubin"
        , "Oleksandr Karavaev"
        , "Viktor Korniienko"
        , "Serhiy Kryvtsov"
        , "Mykola Matviyenko"
        , "Bogdan Mykhaylichenko"
        , "Vitaliy Mykolenko"
        , "Denys Popov"
        , "Eduard Sobol"
        , "Oleksandr Syrota"
        , "Oleksandr Tymchyk"
        , "Illia Zabarnyi"
        , "Oleksandr Zinchenko"
        , "Oleksandr Andriyevskiy"
        , "Artem Bondarenko"
        , "Vitaliy Buyalskiy"
        , "Viktor Kovalenko"
        , "Bogdan Lednev"
        , "Yevhen Makarenko"
        , "Ruslan Malinovskyi"
        , "Marlos"
        , "Mykola Shaparenko"
        , "Volodymyr Shepelev"
        , "Taras Stepanenko"
        , "Heorhiy Sudakov"
        , "Serhiy Sydorchuk"
        , "Artem Besedin"
        , "Artem Dovbyk"
        , "Yevhen Konoplyanka"
        , "Viktor Tsygankov"
        , "Roman Yaremchuk"
        , "Andriy Yarmolenko"
        , "Oleksandr Zubkov"
        ]
    , group = C
    }


austria : TeamDatum
austria =
    { team = { teamID = "AUT", teamName = "Oostenrijk" }
    , players =
        [ "Daniel Bachmann"
        , "Pavao Pervan"
        , "Alexander Schlager"
        , "David Alaba"
        , "Aleksandar Dragovic"
        , "Marco Friedl"
        , "Martin Hinteregger"
        , "Stefan Lainer"
        , "Philipp Lienhart"
        , "Stefan Posch"
        , "Christopher Trimmel"
        , "Andreas Ulmer"
        , "Julian Baumgartlinger"
        , "Christoph Baumgartner"
        , "Florian Grillitsch"
        , "Stefan Ilsanker"
        , "Konrad Laimer"
        , "Valentino Lazaro"
        , "Marcel Sabitzer"
        , "Louis Schaub"
        , "Xaver Schlager"
        , "Alessandro Schöpf"
        , "Marko Arnautovic"
        , "Michael Gregoritsch"
        , "Sasa Kalajdzic"
        , "Karim Onisiwo"
        ]
    , group = C
    }


north_macedonia : TeamDatum
north_macedonia =
    { team = { teamID = "MAC", teamName = "Macedonië" }
    , players =
        [ "Stole Dimitrievski"
        , "Riste Jankov"
        , "Damjan Shishkovski"
        , "Ezgjan Alioski"
        , "Egzon Bejtulai"
        , "Visar Musliu"
        , "Kire Ristevski"
        , "Stefan Ristovski"
        , "Darko Velkovski"
        , "Gjoko Zajkov"
        , "Arijan Ademi"
        , "Daniel Avramovski"
        , "Enis Bardhi"
        , "Darko Churlinov"
        , "Eljif Elmaz"
        , "Ferhan Hasani"
        , "Tihomir Kostadinov"
        , "Boban Nikolov"
        , "Marjan Radeski"
        , "Stefan Spirovski"
        , "Goran Pandev"
        , "Milan Ristovski"
        , "Vlatko Stojanovski"
        , "Aleksandar Trajkovski"
        , "Ivan Trichkovski"
        , "Krste Velkovski"
        ]
    , group = C
    }



-- Group D (London/Glasgow): England (hosts), Croatia, Play-off winner C, Czech Republic


england : TeamDatum
england =
    { team = { teamID = "ENG", teamName = "Engeland" }
    , players =
        [ "Dean Henderson"
        , "Sam Johnstone"
        , "Jordan Pickford"
        , "Aaron Ramsdale"
        , "Trent Alexander-Arnold"
        , "Ben Chilwell"
        , "Conor Coady"
        , "Ben Godfrey"
        , "Reece James"
        , "Harry Maguire"
        , "Tyrone Mings"
        , "Luke Shaw"
        , "John Stones"
        , "Kieran Trippier"
        , "Kyle Walker"
        , "Ben White"
        , "Jude Bellingham"
        , "Phil Foden"
        , "Jack Grealish"
        , "Jordan Henderson"
        , "Jesse Lingard"
        , "Mason Mount"
        , "Kalvin Phillips"
        , "Declan Rice"
        , "Bukayo Saka"
        , "Jadon Sancho"
        , "James Ward-Prowse"
        , "Dominic Calvert-Lewin"
        , "Mason Greenwood"
        , "Harry Kane"
        , "Marcus Rashford"
        , "Raheem Sterling"
        , "Ollie Watkins"
        ]
    , group = D
    }


croatia : TeamDatum
croatia =
    { team = team "CRO" "Kroatië"
    , players =
        [ "Lovre Kalinic"
        , "Dominik Livakovic"
        , "Simon Sluga"
        , "Borna Barisic"
        , "Domagoj Bradaric"
        , "Duje Caleta-Car"
        , "Josko Gvardiol"
        , "Josip Juranovic"
        , "Dejan Lovren"
        , "Mile Skoric"
        , "Domagoj Vida"
        , "Sime Vrsaljko"
        , "Milan Badelj"
        , "Marcelo Brozovic"
        , "Luka Ivanusec"
        , "Mateo Kovacic"
        , "Luka Modric"
        , "Mario Pasalic"
        , "Ivan Perisic"
        , "Nikola Vlasic"
        , "Josip Brekalo"
        , "Ante Budimir"
        , "Andrej Kramaric"
        , "Mislav Orsic"
        , "Bruno Petkovic"
        , "Ante Rebic"
        ]
    , group = D
    }


scotland : TeamDatum
scotland =
    { team = { teamID = "SCO", teamName = "Schotland" }
    , players =
        [ "Craig Gordon"
        , "David Marshall"
        , "Jon McLaughlin"
        , "Liam Cooper"
        , "Declan Gallagher"
        , "Grant Hanley"
        , "Jack Hendry"
        , "Scott McKenna"
        , "Stephen O'Donnell"
        , "Nathan Patterson"
        , "Andy Robertson"
        , "Greg Taylor"
        , "Kieran Tierney"
        , "Stuart Armstrong"
        , "Ryan Christie"
        , "John Fleck"
        , "Billy Gilmour"
        , "John McGinn"
        , "Callum McGregor"
        , "Scott McTominay"
        , "David Turnbull"
        , "Ché Adams"
        , "Lyndon Dykes"
        , "James Forrest"
        , "Ryan Fraser"
        , "Kevin Nisbet"
        ]
    , group = D
    }


czechia : TeamDatum
czechia =
    { team = { teamID = "CZE", teamName = "Tsjechië" }
    , players =
        [ "Ales Mandous"
        , "Jiri Pavlenka"
        , "Tomás Vaclík"
        , "Jan Boril"
        , "Jakub Brabec"
        , "Ondrej Celustka"
        , "Vladimír Coufal"
        , "Pavel Kaderábek"
        , "Tomás Kalas"
        , "Ales Mateju"
        , "David Zima"
        , "Antonín Barák"
        , "Vladimír Darida"
        , "Adam Hlozek"
        , "Tomás Holes"
        , "Jakub Jankto"
        , "Alex Král"
        , "Lukás Masopust"
        , "Jakub Pesek"
        , "Petr Sevcík"
        , "Tomás Soucek"
        , "Michael Krmenčík"
        , "Tomás Pekhart"
        , "Patrik Schick"
        , "Matej Vydra"
        ]
    , group = D
    }



-- Group E (Bilbao/Dublin): Spain (hosts), Sweden, Poland, Play-off winner B


spain : TeamDatum
spain =
    { team = team "ESP" "Spanje"
    , players =
        [ "David de Gea"
        , "Unai Simón"
        , "Robert Sánchez"
        , "José Gayà"
        , "Jordi Alba"
        , "Pau Torres"
        , "Aymeric Laporte"
        , "Eric García"
        , "Diego Llorente"
        , "César Azpilicueta"
        , "Marcos Llorente"
        , "Sergio Busquets"
        , "Rodri Hernández"
        , "Pedri"
        , "Thiago Alcántara"
        , "Koke"
        , "Fabián Ruiz"
        , "Dani Olmo"
        , "Mikel Oyarzabal"
        , "Gerard Moreno"
        , "Álvaro Morata"
        , "Ferran Torres"
        , "Adama Traoré"
        , "Pablo Sarabia"
        ]
    , group = E
    }


sweden : TeamDatum
sweden =
    { team = team "SWE" "Zweden"
    , players =
        [ "Karl-Johan Johnsson"
        , "Kristoffer Nordfeldt"
        , "Robin Olsen"
        , "Ludwig Augustinsson"
        , "Marcus Danielson"
        , "Andreas Granqvist"
        , "Filip Helander"
        , "Pontus Jansson"
        , "Emil Krafth"
        , "Victor Lindelöf"
        , "Mikael Lustig"
        , "Martin Olsson"
        , "Jens-Lys Cajuste"
        , "Viktor Claesson"
        , "Albin Ekdal"
        , "Emil Forsberg"
        , "Sebastian Larsson"
        , "Kristoffer Olsson"
        , "Ken Sema"
        , "Mattias Svanberg"
        , "Gustav Svensson"
        , "Marcus Berg"
        , "Alexander Isak"
        , "Dejan Kulusevski"
        , "Jordan Larsson"
        , "Robin Quaison"
        ]
    , group = E
    }


poland : TeamDatum
poland =
    { team = team "POL" "Polen"
    , players =
        [ "Lukasz Fabianski"
        , "Lukasz Skorupski"
        , "Wojciech Szczesny"
        , "Jan Bednarek"
        , "Bartosz Bereszynski"
        , "Pawel Dawidowicz"
        , "Kamil Glik"
        , "Michal Helik"
        , "Tomasz Kedziora"
        , "Kamil Piatkowski"
        , "Tymoteusz Puchacz"
        , "Maciej Rybus"
        , "Przemyslaw Frankowski"
        , "Kamil Józwiak"
        , "Mateusz Klich"
        , "Kacper Kozlowski"
        , "Grzegorz Krychowiak"
        , "Karol Linetty"
        , "Jakub Moder"
        , "Przemyslaw Placheta"
        , "Piotr Zielinski"
        , "Rafal Augustyniak"
        , "Kamil Grosicki"
        , "Robert Gumny"
        , "Radoslaw Majecki"
        , "Sebastian Szymanski"
        ]
    , group = E
    }


slovakia : TeamDatum
slovakia =
    { team = { teamID = "SVK", teamName = "Slowakije" }
    , players =
        [ "Martin Dúbravka"
        , "Dusan Kuciak"
        , "Marek Rodák"
        , "Jakub Holúbek"
        , "Tomás Hubocan"
        , "Peter Pekarík"
        , "Lubomír Satka"
        , "Milan Skriniar"
        , "Denis Vavro"
        , "László Bénes"
        , "Matús Bero"
        , "Ondrej Duda"
        , "Marek Hamsík"
        , "Patrik Hrosovsky"
        , "Juraj Kucka"
        , "Stanislav Lobotka"
        , "Tomás Suslov"
        , "Vladimír Weiss"
        , "Róbert Bozeník"
        , "Michal Duris"
        , "Lukás Haraslín"
        , "Erik Jirka"
        , "Róbert Mak"
        , "David Strelec"
        ]
    , group = E
    }



-- Group F (Munich/Budapest): Play-off winner A or D, Portugal (holders), France, Germany (hosts)


hungary : TeamDatum
hungary =
    { team = { teamID = "HUN", teamName = "Hongarije" }
    , players =
        [ "Ádám Bogdán"
        , "Dénes Dibusz"
        , "Péter Gulácsi"
        , "Balázs Tóth"
        , "Bendegúz Bolla"
        , "Endre Botka"
        , "Attila Fiola"
        , "Szilveszter Hangya"
        , "Ákos Kecskés"
        , "Ádám Lang"
        , "Gergö Lovrencsics"
        , "Willi Orbán"
        , "Csaba Spandler"
        , "Attila Szalai"
        , "Tamás Cseri"
        , "Dániel Gazdag"
        , "Filip Holender"
        , "László Kleinheisler"
        , "Ádám Nagy"
        , "Loïc Négo"
        , "András Schäfer"
        , "Dávid Sigér"
        , "Dominik Szoboszlai"
        , "János Hahn"
        , "Nemanja Nikolic"
        , "Roland Sallai"
        , "Szabolcs Schön"
        , "Ádám Szalai"
        , "Kevin Varga"
        , "Roland Varga"
        ]
    , group = F
    }


portugal : TeamDatum
portugal =
    { team = team "POR" "Portugal"
    , players =
        [ "Anthony Lopes"
        , "Rui Patrício"
        , "Rui Silva"
        , "João Cancelo"
        , "Rúben Dias"
        , "José Fonte"
        , "Raphael Guerreiro"
        , "Nuno Mendes"
        , "Pepe"
        , "Nélson Semedo"
        , "William Carvalho"
        , "Bruno Fernandes"
        , "João Moutinho"
        , "Rúben Neves"
        , "Sérgio Oliveira"
        , "João Palhinha"
        , "Danilo Pereira"
        , "Renato Sanches"
        , "João Félix"
        , "Pedro Gonçalves"
        , "Gonçalo Guedes"
        , "Diogo Jota"
        , "Cristiano Ronaldo"
        , "André Silva"
        , "Bernardo Silva"
        , "Rafa Silva"
        ]
    , group = F
    }


france : TeamDatum
france =
    { team = { teamID = "FRA", teamName = "Frankrijk" }
    , players =
        [ "Hugo Lloris"
        , "Steve Mandanda"
        , "Mike Meignan"
        , "Lucas Digne"
        , "Léo Dubois"
        , "Lucas Hernández"
        , "Presnel Kimpembe"
        , "Jules Koundé"
        , "Clément Lenglet"
        , "Benjamin Pavard"
        , "Raphaël Varane"
        , "Kurt Zouma"
        , "N'Golo Kanté"
        , "Thomas Lemar"
        , "Paul Pogba"
        , "Adrien Rabiot"
        , "Moussa Sissoko"
        , "Corentin Tolisso"
        , "Wissam Ben Yedder"
        , "Karim Benzema"
        , "Kingsley Coman"
        , "Ousmane Dembélé"
        , "Olivier Giroud"
        , "Antoine Griezmann"
        , "Kylian Mbappé"
        , "Marcus Thuram"
        ]
    , group = F
    }


germany : TeamDatum
germany =
    { team = team "GER" "Duitsland"
    , players =
        [ "Bernd Leno"
        , "Manuel Neuer"
        , "Kevin Trapp"
        , "Matthias Ginter"
        , "Robin Gosens"
        , "Christian Günter"
        , "Marcel Halstenberg"
        , "Mats Hummels"
        , "Lukas Klostermann"
        , "Robin Koch"
        , "Antonio Rüdiger"
        , "Niklas Süle"
        , "Emre Can"
        , "Leon Goretzka"
        , "Ilkay Gündogan"
        , "Kai Havertz"
        , "Joshua Kimmich"
        , "Toni Kroos"
        , "Jamal Musiala"
        , "Florian Neuhaus"
        , "Serge Gnabry"
        , "Jonas Hofmann"
        , "Thomas Müller"
        , "Leroy Sané"
        , "Kevin Volland"
        , "Timo Werner"
        ]
    , group = F
    }
