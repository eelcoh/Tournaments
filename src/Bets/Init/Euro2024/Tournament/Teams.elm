module Bets.Init.Euro2024.Tournament.Teams exposing (..)

import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Winner(..))
import Bets.Types.Team exposing (team)



-- teams
-- regex  \([^)]*\),


a1 : TeamDatum
a1 =
    { team = team "GER" "Duitsland"
    , players =
        [ "Oliver Baumann"
        , "Manuel Neuer"
        , "Alexander Nübel"
        , "Marc-Andre ter Stegen"
        , "Jonathan Tah"
        , "Nico Schlotterbeck"
        , "Robin Koch"
        , "Maximilian Mittelstädt"
        , "Antonio Rüdiger"
        , "Waldemar Anton"
        , "Benjamin Hendrichs"
        , "David Raum"
        , "Aleksandar Pavlovic"
        , "Robert Andrich"
        , "Pascal Gross"
        , "Joshua Kimmich"
        , "Thomas Müller"
        , "Ilkay Gündogan"
        , "Jamal Musiala"
        , "Florian Wirtz"
        , "Toni Kroos"
        , "Niclas Füllkrug"
        , "Kai Havertz"
        , "Leroy Sané"
        , "Chris Führich"
        , "Deniz Undav"
        , "Maximilian Beier"
        ]
    , group = A
    }


a2 : TeamDatum
a2 =
    { team = { teamID = "SCO", teamName = "Schotland" }
    , players =
        [ "Zander Clark"
        , "Craig Gordon"
        , "Angus Gunn"
        , "Liam Kelly"
        , "Liam Cooper"
        , "Grant Hanley"
        , "Jack Hendry"
        , "Ross McCrorie"
        , "Scott McKenna"
        , "Ryan Porteous"
        , "Anthony Ralston"
        , "Andy Robertson"
        , "John Souttar"
        , "Greg Taylor"
        , "Kieran Tierney"
        , "Stuart Armstrong"
        , "Ryan Christie"
        , "Billy Gilmour"
        , "Ryan Jack"
        , "Kenny McLean"
        , "John McGinn"
        , "Callum McGregor"
        , "Scott McTominay"
        , "Che Adams"
        , "Ben Doak"
        , "Lyndon Dykes"
        , "James Forrest"
        , "Lawrence Shankland"
        ]
    , group = A
    }


a3 : TeamDatum
a3 =
    { team = { teamID = "HUN", teamName = "Hongarije" }
    , players =
        [ "Dznes Dibusz"
        , "Peter Gulacsi"
        , "Peter Szappanos"
        , "Botond Balogh"
        , "Endre Botka"
        , "Marton Dardai"
        , "Attila Fiola"
        , "Adam Lang"
        , "Willi Orban"
        , "Attila Szalai"
        , "Milos Kerkez"
        , "Bendeguz Bolla"
        , "Mihaly Kata"
        , "Laszlo Kleinheisler"
        , "Adam Nagy"
        , "Zsolt Nagy"
        , "Loic Nego"
        , "Andras Schäfer"
        , "Callum Styles"
        , "Dominik Szoboszlai"
        , "Martin Adam"
        , "Kevin Csoboth"
        , "Daniel Gazdag"
        , "Krisztofer Horvath"
        , "Roland Sallai"
        , "Barnabas Varga"
        ]
    , group = A
    }


a4 : TeamDatum
a4 =
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



-- Group B : Spain, Croatia, Italy, Albania


b1 : TeamDatum
b1 =
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
    , group = B
    }


b2 : TeamDatum
b2 =
    { team = team "CRO" "Kroatië"
    , players =
        [ "Dominik Livakovic"
        , "Ivica Ivusic"
        , "Nediljko Labrovic"
        , "Domagoj Vida"
        , "Josip Juranovic"
        , "Josko Gvardiol"
        , "Josip Stanisic"
        , "Borna Sosa"
        , "Josip Sutalo"
        , "Martin Erlic"
        , "Marin Pongracic"
        , "Luka Modric"
        , "Mateo Kovacic"
        , "Marcelo Brozovic"
        , "Mario Pasalic"
        , "Nikola Vlasic"
        , "Lovro Majer"
        , "Luka Ivanusec"
        , "Luka Susic"
        , "Martin Baturina"
        , "Ivan Perisic"
        , "Andrej Kramaric"
        , "Bruno Petkovic"
        , "Marko Pjaca"
        , "Ante Budimir"
        , "Marco Pasalic"
        ]
    , group = B
    }


b3 : TeamDatum
b3 =
    { team = { teamID = "ITA", teamName = "Italy" }
    , players =
        [ "Gianluigi Donnarumma"
        , "Alex Meret"
        , "Ivan Provedel"
        , "Guglielmo Vicario"
        , "Francesco Acerbi"
        , "Alessandro Bastoni"
        , "Raoul Bellanova"
        , "Alessandro Buongiorno"
        , "Riccardo Calafiori"
        , "Andrea Cambiaso"
        , "Matteo Darmian"
        , "Giovanni Di Lorenzo"
        , "Federico Dimarco"
        , "Gianluca Mancini"
        , "Giorgio Scalvini"
        , "Nicolò Barella"
        , "Bryan Cristante"
        , "Nicolò Fagioli Michael Folorunsho"
        , "Davide Frattesi"
        , "Jorginho"
        , "Lorenzo Pellegrini"
        , "Samuele Ricci"
        , "Federico Chiesa"
        , "Stephan El Shaarawy"
        , "Riccardo Orsolini"
        , "Giacomo Raspadori"
        , "Mateo Retegui"
        , "Gianluca Scamacca"
        , "Mattia Zaccagni"
        ]
    , group = B
    }


b4 : TeamDatum
b4 =
    { team = team "ALB" "Albanië"
    , players = []
    , group = B
    }



-- Group C : Slovenia, Denmark, Serbia, England


c1 : TeamDatum
c1 =
    { team = team "SLO" "Slovenië"
    , players =
        [ "Jan Oblak"
        , "Vid Belec"
        , "Igor Vekic"
        , "Matevz Vidovsek"
        , "Jure Balkovec"
        , "Jaka Bijol"
        , "Miha Blazic"
        , "David Brekalo"
        , "Vanja Drkusic"
        , "Erik Janza"
        , "Zan Karnicnik"
        , "Petar Stojanovic"
        , "Zan Zaletel"
        , "Timi Max Elsnik"
        , "Adam Gnezda Cerin"
        , "Jon Gorenc Stankovic"
        , "Tomi Horvat"
        , "Jasmin Kurtic"
        , "Sandi Lovric"
        , "Benjamin Verbic"
        , "Miha Zajc"
        , "Adrian Zeljkovic"
        , "Nini Zugelj"
        , "Zan Celar"
        , "Josip Ilicic"
        , "Jan Mlakar"
        , "Benjamin Sesko"
        , "Andraz Sporar"
        , "Zan Vipotnik"
        , "Luka Zahovic"
        ]
    , group = C
    }


c2 : TeamDatum
c2 =
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
    , group = C
    }


c3 : TeamDatum
c3 =
    { team = team "SRB" "Servië"
    , players =
        [ "Aleksandar Jovanovic"
        , "Vanja Milinkovic-Savic"
        , "Djordje Petrovic"
        , "Predrag Rajkovic"
        , "Srdjan Babic"
        , "Nikola Milenkovic"
        , "Strahinja Erakovic"
        , "Strahinja Pavlovic"
        , "Jan-Carlo Simic"
        , "Uros Spajic"
        , "Nemanja Stojic"
        , "Milos Veljkovic"
        , "Samed Bazdar"
        , "Veljko Birmancevic"
        , "Aleksandar Cirkovic"
        , "Mijat Gacinovic"
        , "Matija Gluscevic"
        , "Nemanja Gudelj"
        , "Ivan Ilic"
        , "Filip Kostic"
        , "Sasa Lukic"
        , "Nemanja Maksimovic"
        , "Srdjan Mijailovic"
        , "Sergej Milinkovic-Savic"
        , "Filip Mladenovic"
        , "Nemanja Radonjic"
        , "Lazar Samardzic"
        , "Dusan Tadic"
        , "Sasa Zdjelar"
        , "Andrija Zivkovic"
        , "Mihailo Ivanovic"
        , "Luka Jovic"
        , "Aleksandar Mitrovic"
        , "Petar Ratkov"
        , "Dusan Vlahovic"
        ]
    , group = C
    }


c4 : TeamDatum
c4 =
    { team = { teamID = "ENG", teamName = "Engeland" }
    , players =
        [ "Jordan Pickford"
        , "Aaron Ramsdale"
        , "Dean Henderson"
        , "James Trafford"
        , "Kyle Walker"
        , "John Stones"
        , "Harry Maguire"
        , "Kieran Trippier"
        , "Luke Shaw"
        , "Joe Gomez"
        , "Marc Guéhi"
        , "Lewis Dunk"
        , "Ezri Konsa"
        , "Jarrad Branthwaite"
        , "Jarell Quansah"
        , "Declan Rice"
        , "Jude Bellingham"
        , "Trent Alexander-Arnold"
        , "Conor Gallagher"
        , "James Maddison"
        , "Kobbie Mainoo"
        , "Curtis Jones"
        , "Adam Wharton"
        , "Harry Kane"
        , "Jack Grealish"
        , "Phil Foden"
        , "Bukayo Saka"
        , "Ollie Watkins"
        , "Jarrod Bowen"
        , "Ivan Toney"
        , "Eberechi Eze"
        , "Cole Palmer"
        , "Anthony Gordon"
        ]
    , group = C
    }



-- Group D : PlayoffA, Netherlands, Austria, France


d1 : TeamDatum
d1 =
    { team = team "POL" "Polen"
    , players = []
    , group = D
    }


d2 : TeamDatum
d2 =
    { team = { teamID = "NED", teamName = "Nederland" }
    , players =
        [ "Justin Bijlow"
        , "Mark Flekken"
        , "Nick Olij"
        , "Bart Verbruggen"
        , "Nathan Aké"
        , "Daley Blind"
        , "Virgil van Dijk"
        , "Denzel Dumfries"
        , "Jeremie Frimpong"
        , "Lutsharel Geertruida"
        , "Matthijs de Ligt"
        , "Ian Maatsen"
        , "Micky van de Ven"
        , "Stefan de Vrij"
        , "Ryan Gravenberch"
        , "Frenkie de Jong"
        , "Teun Koopmeiners"
        , "Tijjani Reijnders"
        , "Marten de Roon"
        , "Jerdy Schouten"
        , "Quinten Timber"
        , "Joey Veerman"
        , "Georginio Wijnaldum"
        , "Steven Bergwijn"
        , "Brian Brobbey"
        , "Memphis Depay"
        , "Cody Gakpo"
        , "Donyell Malen"
        , "Xavi Simons"
        , "Wout Weghorst"
        ]
    , group = D
    }


d3 : TeamDatum
d3 =
    { team = { teamID = "AUT", teamName = "Oostenrijk" }
    , players =
        [ "Niklas Hedl"
        , "Tobias Lawal"
        , "Heinz Lindner"
        , "Patrick Pentz"
        , "Flavius Daniliuc"
        , "Kevin Danso"
        , "Stefan Lainer"
        , "Philipp Lienhart"
        , "Phillipp Mwene"
        , "Stefan Posch"
        , "Leopold Querfeld"
        , "Gernot Trauner"
        , "Maximilian Wöber"
        , "Thierno Ballo"
        , "Christoph Baumgartner"
        , "Florian Grillitsch"
        , "Marco Grüll"
        , "Florian Kainz"
        , "Konrad Laimer"
        , "Alexander Prass"
        , "Marcel Sabitzer"
        , "Romano Schmid"
        , "Matthias Seidl"
        , "Nicolas Seiwald"
        , "Patrick Wimmer"
        , "Marko Arnautovic"
        , "Maximilian Entrup"
        , "Michael Gregoritsch"
        , "Andreas Weimann"
        ]
    , group = D
    }


d4 : TeamDatum
d4 =
    { team = { teamID = "FRA", teamName = "Frankrijk" }
    , players =
        [ "Alphonse Areola"
        , "Mike Maignan"
        , "Brice Samba"
        , "Jonathan Clauss"
        , "Theo Hernández"
        , "Ibrahima Konaté"
        , "Jules Koundé"
        , "Ferland Mendy"
        , "Benjamin Pavard"
        , "William Saliba"
        , "Dayot Upamecano"
        , "Eduardo Camavinga"
        , "Youssouf Fofana"
        , "Antoine Griezmann"
        , "N’Golo Kanté"
        , "Adrien Rabiot"
        , "Aurélien Tchouaméni"
        , "Warren Zaïre-Emery"
        , "Bradley Barcola"
        , "Kingsley Coman"
        , "Ousmane Dembélé"
        , "Olivier Giroud"
        , "Randal Kolo Muani"
        , "Kylian Mbappé"
        , "Marcus Thuram"
        ]
    , group = D
    }



-- Group E : Belgium, Slovakia, Romania, PlayoffB


e1 : TeamDatum
e1 =
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
    , group = E
    }


e2 : TeamDatum
e2 =
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


e3 : TeamDatum
e3 =
    { team = team "ROM" "Roemenië"
    , players = []
    , group = E
    }


e4 : TeamDatum
e4 =
    { team = team "UKR" "Oekraïne"
    , players =
        [ "Georgiy Bushchan"
        , "Andriy Lunin"
        , "Anatoliy Trubin"
        , "Valeriy Bondar"
        , "Yukhym Konoplya"
        , "Mykola Matviyenko"
        , "Bogdan Mykhaylichenko"
        , "Vitaliy Mykolenko"
        , "Oleksandr Svatok"
        , "Maksym Talovyerov"
        , "Oleksandr Tymchyk"
        , "Ilya Zabarnyi"
        , "Volodymyr Brazhko"
        , "Ruslan Malinovskyi"
        , "Mykhailo Mudryk"
        , "Mykola Shaparenko"
        , "Taras Stepanenko"
        , "Georgiy Sudakov"
        , "Serhiy Sydorchuk"
        , "Viktor Tsygankov"
        , "Oleksandr Zinchenko"
        , "Oleksandr Zubko"
        , "Artem Dovbyk"
        , "Vladyslav Vanat"
        , "Roman Yaremchuk"
        , "Andriy Yarmolenko"
        ]
    , group = E
    }



-- Group F: Turkey, PlayoffC, Portugal, Czechia


f1 : TeamDatum
f1 =
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
    , group = F
    }


f2 : TeamDatum
f2 =
    { team = team "GEO" "Georgië"
    , players = []
    , group = F
    }


f3 : TeamDatum
f3 =
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


f4 : TeamDatum
f4 =
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
    , group = F
    }
