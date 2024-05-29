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
        [ "Marvin Keller"
        , "Gregor Kobel"
        , "Pascal Loretz"
        , "Yvon Mvogo"
        , "Yann Sommer,Manuel Akanji"
        , "Aurèle Amenda"
        , "Nico Elvedi"
        , "Ulisses Garcia"
        , "Albian Hajdari"
        , "Kevin Mbabu"
        , "Bryan Okoh"
        , "Becir Omeragic"
        , "Ricardo Rodriguez"
        , "Fabian Schär"
        , "Leonidas Stergiou"
        , "Silvan Widmer (1. FSV Mainz 05)"
        , "Cédric Zesiger"
        , "Michel Aebischer"
        , "Uran Bislimi"
        , "Remo Freuler"
        , "Ardon Jashari"
        , "Fabian Rieder"
        , "Vincent Sierro"
        , "Xherdan Shaqiri"
        , "Filip Ugrinic"
        , "Granit Xhaka"
        , "Denis ZakariaZeki Amdouni"
        , "Breel Embolo"
        , "Kwadwo Duah"
        , "Joël Monteiro"
        , "Dan Ndoye"
        , "Noah Okafor"
        , "Renato Steffen"
        , "Ruben Vargas"
        , "Andi Zeqiri"
        , "Steven Zuber"
        ]
    , group = A
    }



-- Group B : Spain, Croatia, Italy, Albania


b1 : TeamDatum
b1 =
    { team = team "ESP" "Spanje"
    , players =
        [ "Unai Simon"
        , "Alex Remiro"
        , "David Raya"
        , "Dani Carvajal"
        , "Jesús Navas"
        , "Aymeric Laporte"
        , "Nacho Fernandez"
        , "Robin Le Normand"
        , "Pau Cubarsi"
        , "Dani Vivian"
        , "Alejandro Grimaldo"
        , "Marc Cucurella"
        , "Rodri"
        , "Martin Zubimendi"
        , "Fabian Ruiz"
        , "Mikel Merino"
        , "Pedri"
        , "Marcos Llorente"
        , "Aleix Garcia"
        , "Alex Baena"
        , "Fermín López"
        , "Álvaro Morata"
        , "Joselu"
        , "Dani Olmo"
        , "Nico Williams"
        , "Mikel Oyarzabal"
        , "Ayoze Pérez"
        , "Ferran Torres"
        , "Lamine Yamal"
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
    , players =
        [ "Etrit Berisha"
        , "Thomas Strakosha"
        , "Elhan Kastrati"
        , "Simon Simoni"
        , "Berat Djimsiti"
        , "Elseid Hysaj"
        , "Iván Balliu"
        , "Ardian Ismajli"
        , "Arlind Ajeti"
        , "Naser Aliji"
        , "Mario Mitaj"
        , "Enea Mihaj"
        , "Marash Kumbulla"
        , "Amir Abrashi"
        , "Kristjan Asllani"
        , "Nedim Bajrami"
        , "Medon Berisha"
        , "Klaus Gjasula"
        , "Qazim Laçi"
        , "Ernest Muçi"
        , "Ylber Ramadani"
        , "Jasir Asani"
        , "Armando Broja"
        , "Mirlind Daku"
        , "Arbër Hoxha"
        , "Rey Manaj"
        , "Taulant Seferi"
        ]
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
    { team = { teamID = "DEN", teamName = "Denemarken" }
    , players =
        [ "Mads Hermansen"
        , "Frederik Rönnow"
        , "Kasper Schmeichel"
        , "Verdedigers:Andreas Christensen"
        , "Joachim Andersen"
        , "Victor Nelsson"
        , "Jannik Vestergaard"
        , "Victor Kristiansen"
        , "Joakim Maehle"
        , "Rasmus Kristensen"
        , "Jens Stryger Larsen"
        , "Middenvelders:Pierre-Emile Højbjerg"
        , "Morten Hjulmand"
        , "Mathias Jensen"
        , "Christian Eriksen"
        , "Matt O’Riley"
        , "Thomas Delaney"
        , "Jesper Lindstrøm"
        , "Aanvallers:Mohamed Daramy"
        , "Anders Dreyer"
        , "Jonas Wind"
        , "Kasper Dolberg"
        , "Yussuf Poulsen"
        , "Rasmus Højlund"
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
    , players =
        [ "Wojciech Szczesny"
        , "Marcin Bulka"
        , "Lukasz Skorupski"
        , "Oliwier Zych"
        , "Jan Bednarek"
        , "Bartosz Bereszynski"
        , "Pawel Bochniewicz"
        , "Pawel Dawidowicz"
        , "Jakub Kiwior"
        , "Timoteusz Puchacz"
        , "Bartosz Salamon"
        , "Sebastian Walukiewicz"
        , "Przemyslaw Frankowski"
        , "Kamil Grosicki"
        , "Jakub Moder"
        , "Jakub Piotrowski"
        , "Taras Romanczuk"
        , "Bartosz Slisz"
        , "Damian Szymanski"
        , "Sebastian Szymanski"
        , "Michal Skoras"
        , "Kacper Urbanski"
        , "Nicola Zalewski"
        , "Piotr Zielinski,Adam Buksa"
        , "Robert Lewandowski"
        , "Arkadiusz Milik"
        , "Krzysztof Piatek"
        , "Karol Swiderski"
        ]
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
        [ "Koen Casteels"
        , "Matz Sels"
        , "Thomas Kaminski"
        , "Timothy Castagne"
        , "Zeno Debast"
        , "Maxim De Cuyper"
        , "Wout Faes"
        , "Thomas Meunier"
        , "Arthur Theate"
        , "Jan Vertonghen"
        , "Axel Witsel"
        , "Kevin De Bruyne"
        , "Orel Mangala"
        , "Amadou Onana"
        , "Youri Tielemans"
        , "Arthur Vermeeren"
        , "Aster Vranckx"
        , "Johan Bakayoko"
        , "Yannick Carrasco"
        , "Charles De Ketelaere"
        , "Jérémy Doku"
        , "Romelu Lukaku"
        , "Dodi Lukebakio"
        , "Loïs Openda"
        , "Leandro Trossard"
        ]
    , group = E
    }


e2 : TeamDatum
e2 =
    { team = { teamID = "SVK", teamName = "Slowakije" }
    , players =
        [ "Martin Dúbravka"
        , "Marek Rodák"
        , "Henrich Ravas"
        , "Dominik Takáč"
        , "Peter Pekarik"
        , "Milan Škriniar"
        , "Norbert Gyömbér"
        , "Dávid Hancko"
        , "Denis Vavro"
        , "Vernon De Marco"
        , "Michal Tomič"
        , "Matúš Kmet"
        , "Adam Obert"
        , "Sebastian Kóša"
        , "Juraj Kucka"
        , "Ondrej Duda"
        , "Patrik Hrošovský"
        , "Stanislav Lobotka"
        , "Matúš Bero"
        , "László Bénes"
        , "Jakub Kadák"
        , "Dominik Hollý"
        , "Róbert Bozeník"
        , "Lukáš Haraslín"
        , "Tomas Suslov"
        , "Ivan Schranz"
        , "David Strelec"
        , "David Duris"
        , "Róbert Polievka"
        , "Ľubomír Tupta"
        , "Leo Sauer"
        ]
    , group = E
    }


e3 : TeamDatum
e3 =
    { team = team "ROM" "Roemenië"
    , players =
        [ "Florin Nita"
        , "Horatiu Moldovan"
        , "Stefan Tarnovanu"
        , "Razvan Sava"
        , "Nicusor Bancu"
        , "Andrei Burca"
        , "Ionut Nedelcearu"
        , "Adrian Rus"
        , "Andrei Ratiu"
        , "Radu Dragusin"
        , "Vasile Mogos"
        , "Bogdan Racovitan"
        , "Nicolae Stanciu"
        , "Razvan Marin"
        , "Alexandru Cicaldau"
        , "Ianis Hagi"
        , "Dennis Man"
        , "Valentin Mihaila"
        , "Marius Marin"
        , "Darius Olaru"
        , "Deian Sorescu"
        , "Florinel Coman"
        , "Adrian Sut"
        , "Constantin Grameni"
        , "George Puscas"
        , "Denis Alibec"
        , "Denis Dragus"
        , "Daniel Birligea"
        ]
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
        [ "Altay Bayindir"
        , "Doğan Alemdar"
        , "Mert Günok"
        , "Uğurcan Cakır"
        , "Mert Müldür"
        , "Cağlar Soyuncu"
        , "Ferdi Kadioğlu"
        , "Zeki Celik"
        , "Abdülkerim Bardakci"
        , "Ahmetcan Kaplan"
        , "Merih Demiral"
        , "Ozan Kabak"
        , "Samet Akaydın"
        , "Cenk Özkacar"
        , "Berat Ozdemir"
        , "Can Uzun"
        , "Hakan Calhanoglu"
        , "İsmail Yuksek"
        , "Kaan Ayhan"
        , "Okay Yokuslu"
        , "Orkun Kokcu"
        , "Salih Ozcan"
        , "Abdulkadir Omur"
        , "İrfan Can Kahveci"
        , "Yunus Akgün"
        , "Kenan Yildiz"
        , "Kerem Akturkoglu"
        , "Barıs Alper Yilmaz"
        , "Oguz Aydin"
        , "Arda Guler"
        , "Bertug Yildirim"
        , "Cenk Tosun"
        , "Semih Kılıcsoy"
        , "Enes Unal"
        , "Yusuf Yazici"
        ]
    , group = F
    }


f2 : TeamDatum
f2 =
    { team = team "GEO" "Georgië"
    , players =
        [ "Giorgi Mamardashvili"
        , "Giorgi Loria"
        , "Luka Gugeshashvili"
        , "Solomon Kvirkvelia"
        , "Giorgi Gvelesiani"
        , "Guram Kashia"
        , "Jemal Tabidze"
        , "Lasha Dvali"
        , "Luka Lochoshvili"
        , "Otar Kakabadze"
        , "Giorgi Gocholeishvili"
        , "Giorgi Chakvetadze"
        , "Anri Mekvabishvili"
        , "Jaba Kankava"
        , "Otar Kiteishvili"
        , "Nika Kvekveskiri"
        , "Giorgi Kochorashvili"
        , "Sandro Altunashvili"
        , "Levan Shengelia"
        , "Giorgi Tsitaishvili"
        , "Saba Lobjanidze"
        , "Zuriko Davitashvili"
        ]
    , group = F
    }


f3 : TeamDatum
f3 =
    { team = team "POR" "Portugal"
    , players =
        [ "Diogo Costa"
        , "José Sá"
        , "Rui Patrício"
        , "António Silva"
        , "Danilo Pereira"
        , "Diogo Dalot"
        , "Gonçalo Inácio"
        , "João Cancelo"
        , "Nélson Semedo"
        , "Nuno Mendes"
        , "Pepe en Rúben Dias"
        , "Bruno Fernandes"
        , "João Neves"
        , "João Palhinha"
        , "Otávio Monteiro"
        , "Rúben Neves en Vitinha"
        , "Bernardo Silva"
        , "Cristiano Ronaldo"
        , "Diogo Jota"
        , "Francisco Conceição"
        , "Gonçalo Ramos"
        , "João Félix"
        , "Pedro Neto"
        , "Rafael Leão"
        ]
    , group = F
    }


f4 : TeamDatum
f4 =
    { team = { teamID = "CZE", teamName = "Tsjechië" }
    , players =
        [ "Vitezslav Jaros"
        , "Matej Kovar"
        , "Jindrich Stanek"
        , "Vladimir Coufal"
        , "David Doudera"
        , "Tomas Holes"
        , "Robin Hranac"
        , "David Jurásek"
        , "Ladislav Krejci"
        , "Martin Vitik"
        , "Tomas Vlcek"
        , "David Zima"
        , "Antonin Barak"
        , "Vaclav Cerny"
        , "Ondrej Lingr"
        , "Tomas Soucek"
        , "Lukas Provod"
        , "Pavel Sulc"
        , "Adam Hlozek"
        , "Tomas Chory"
        , "Mojmir Chytil"
        , "Jan Kuchta"
        , "Patrik Schick"
        ]
    , group = F
    }
