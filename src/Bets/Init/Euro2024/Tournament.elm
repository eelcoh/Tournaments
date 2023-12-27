module Bets.Init.Euro2024.Tournament exposing
    ( bracket
    , groupMembers
    , initTeamData
    , matches
    , teams
      -- , tournament
    )

import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Tournament6x4, Winner(..))
import Bets.Types.DateTime exposing (date, time)
import Bets.Types.Group as Group
import Bets.Types.Match exposing (match)
import Bets.Types.Team exposing (team)
import Stadium exposing (..)
import Time exposing (Month(..))
import Tuple exposing (pair)


tournament : Tournament6x4
tournament =
    { a1 = slot "A1" germany
    , a2 = slot "A2" scotland
    , a3 = slot "A3" hungary
    , a4 = slot "A4" switzerland
    , b1 = slot "B1" spain
    , b2 = slot "B2" croatia
    , b3 = slot "B3" italy
    , b4 = slot "B4" albania
    , c1 = slot "C1" slovenia
    , c2 = slot "C2" denmark
    , c3 = slot "C3" serbia
    , c4 = slot "C4" england
    , d1 = slot "D1" playoffa
    , d2 = slot "D2" netherlands
    , d3 = slot "D3" austria
    , d4 = slot "D4" france
    , e1 = slot "E1" belgium
    , e2 = slot "E2" slovakia
    , e3 = slot "E3" romania
    , e4 = slot "E4" playoffb
    , f1 = slot "F1" turkey
    , f2 = slot "F2" playoffc
    , f3 = slot "F3" portugal
    , f4 = slot "F4" czechia
    }


slot : String -> TeamDatum -> ( String, Maybe Team )
slot s t =
    pair s (Just t.team)


bracket : Bracket
bracket =
    let
        firstPlace grp =
            let
                code =
                    "W" ++ Group.toString grp
            in
            TeamNode code (FirstPlace grp) Nothing TBD

        secondPlace grp =
            let
                code =
                    "R" ++ Group.toString grp
            in
            TeamNode code (SecondPlace grp) Nothing TBD

        bestThird idx grps =
            let
                code =
                    "T" ++ String.fromInt idx
            in
            TeamNode code (BestThirdFrom grps) Nothing TBD

        tnwa =
            firstPlace A

        tnwb =
            firstPlace B

        tnwc =
            firstPlace C

        tnwd =
            firstPlace D

        tnwe =
            firstPlace E

        tnwf =
            firstPlace F

        tnra =
            secondPlace A

        tnrb =
            secondPlace B

        tnrc =
            secondPlace C

        tnrd =
            secondPlace D

        tnre =
            secondPlace E

        tnrf =
            secondPlace F

        tnt1 =
            bestThird 1 [ A, D, E, F ]

        tnt2 =
            bestThird 2 [ D, E, F ]

        tnt3 =
            bestThird 3 [ A, B, C, D ]

        tnt4 =
            bestThird 4 [ A, B, C ]

        -- Second round matches
        mn37 =
            MatchNode "m37" None tnwa tnrc II TBD

        mn38 =
            MatchNode "m38" None tnra tnrb II TBD

        mn39 =
            MatchNode "m39" None tnwb tnt1 II TBD

        mn40 =
            MatchNode "m40" None tnwc tnt2 II TBD

        mn41 =
            MatchNode "m41" None tnwf tnt4 II TBD

        mn42 =
            MatchNode "m42" None tnrd tnre II TBD

        mn43 =
            MatchNode "m43" None tnwe tnt3 II TBD

        mn44 =
            MatchNode "m44" None tnwd tnrf II TBD

        -- quarter finals
        mn45 =
            MatchNode "m45" None mn39 mn37 III TBD

        mn46 =
            MatchNode "m46" None mn41 mn42 III TBD

        mn47 =
            MatchNode "m47" None mn43 mn44 III TBD

        mn48 =
            MatchNode "m48" None mn40 mn38 III TBD

        -- semi finals
        mn49 =
            MatchNode "m49" None mn45 mn46 IV TBD

        mn50 =
            MatchNode "m50" None mn47 mn48 IV TBD

        -- finals
        mn51 =
            MatchNode "m51" None mn49 mn50 V TBD
    in
    mn51



-- Matches


matches =
    let
        t =
            tournament
    in
    { -- Group A
      m01 = match "m01" t.a1 t.a2 (date 2024 Jun 14) (time 21 0) munich
    , m02 = match "m02" t.a3 t.a4 (date 2024 Jun 15) (time 15 0) cologne
    , m14 = match "m14" t.a1 t.a3 (date 2024 Jun 19) (time 18 0) stuttgart
    , m13 = match "m13" t.a2 t.a4 (date 2024 Jun 19) (time 21 0) cologne
    , m25 = match "m25" t.a4 t.a1 (date 2024 Jun 23) (time 21 0) frankfurt
    , m26 = match "m26" t.a2 t.a3 (date 2024 Jun 23) (time 21 0) stuttgart

    -- Group B
    , m03 = match "m03" t.b1 t.b2 (date 2024 Jun 15) (time 18 0) berlin
    , m04 = match "m04" t.b3 t.b4 (date 2024 Jun 15) (time 21 0) dortmund
    , m15 = match "m15" t.b2 t.b4 (date 2024 Jun 19) (time 15 0) hamburg
    , m16 = match "m16" t.b1 t.b3 (date 2024 Jun 20) (time 21 0) gelsenkirchen
    , m27 = match "m27" t.b4 t.b1 (date 2024 Jun 24) (time 21 0) dusseldorf
    , m28 = match "m28" t.b2 t.b3 (date 2024 Jun 24) (time 21 0) leipzig

    -- Group C
    , m05 = match "m05" t.c1 t.c2 (date 2024 Jun 16) (time 18 0) stuttgart
    , m06 = match "m06" t.c3 t.c4 (date 2024 Jun 16) (time 21 0) gelsenkirchen
    , m18 = match "m18" t.c1 t.c3 (date 2024 Jun 20) (time 15 0) munich
    , m17 = match "m17" t.c2 t.c4 (date 2024 Jun 20) (time 18 0) frankfurt
    , m29 = match "m29" t.c4 t.c1 (date 2024 Jun 25) (time 21 0) cologne
    , m30 = match "m30" t.c2 t.c3 (date 2024 Jun 25) (time 21 0) munich

    -- Group D
    , m07 = match "m07" t.d1 t.d2 (date 2024 Jun 16) (time 15 0) hamburg
    , m08 = match "m08" t.d3 t.d4 (date 2024 Jun 17) (time 21 0) dusseldorf
    , m19 = match "m19" t.d1 t.d3 (date 2024 Jun 21) (time 18 0) berlin
    , m20 = match "m20" t.d2 t.d4 (date 2024 Jun 21) (time 21 0) leipzig
    , m31 = match "m31" t.d2 t.d3 (date 2024 Jun 25) (time 18 0) berlin
    , m32 = match "m32" t.d4 t.d1 (date 2024 Jun 25) (time 18 0) dortmund

    -- Group E: Belgium, Slovakia, Romania, PlayoffB
    , m10 = match "m10" t.e3 t.e4 (date 2024 Jun 17) (time 15 0) munich
    , m09 = match "m09" t.e1 t.e2 (date 2024 Jun 17) (time 18 0) frankfurt
    , m21 = match "m21" t.e2 t.e4 (date 2024 Jun 21) (time 15 0) dusseldorf
    , m22 = match "m22" t.e1 t.e3 (date 2024 Jun 22) (time 21 0) cologne
    , m33 = match "m33" t.e2 t.e3 (date 2024 Jun 26) (time 18 0) frankfurt
    , m34 = match "m34" t.e4 t.e1 (date 2024 Jun 26) (time 18 0) stuttgart

    -- Group F: Turkey, PlayoffC, Portugal, Czechia
    , m11 = match "m11" t.f1 t.f2 (date 2024 Jun 18) (time 18 0) dortmund
    , m12 = match "m12" t.f3 t.f4 (date 2024 Jun 18) (time 21 0) leipzig
    , m24 = match "m24" t.f2 t.f4 (date 2024 Jun 22) (time 15 0) hamburg
    , m23 = match "m23" t.f1 t.f3 (date 2024 Jun 22) (time 18 0) dortmund
    , m35 = match "m35" t.f2 t.f3 (date 2024 Jun 26) (time 21 0) gelsenkirchen
    , m36 = match "m36" t.f4 t.f1 (date 2024 Jun 26) (time 21 0) hamburg
    }


initTeamData : TeamData
initTeamData =
    [ germany
    , scotland
    , hungary
    , switzerland

    --
    , spain
    , croatia
    , italy
    , albania

    --
    , slovenia
    , denmark
    , serbia
    , england

    --
    , playoffa
    , netherlands
    , austria
    , france

    -- Group E: Belgium, Slovakia, Romania, PlayoffB
    , belgium
    , slovakia
    , romania
    , playoffb

    -- Group F: Turkey, PlayoffC, Portugal, Czechia
    , turkey
    , playoffc
    , portugal
    , czechia
    ]


teams : List Team
teams =
    List.map .team initTeamData


groupMembers : Group -> List Team
groupMembers grp =
    let
        inGroup td =
            td.group == grp
    in
    List.filter inGroup initTeamData
        |> List.map .team



-- teams
-- regex  \([^)]*\),
-- Group A: Germany, Scotland, Hungary, Switzerland


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
    , group = A
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
    , group = A
    }


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



-- Group B : Spain, Croatia, Italy, Albania


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
    , group = B
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
    , group = B
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
    , group = B
    }


albania : TeamDatum
albania =
    { team = team "ALB" "Albanië"
    , players = []
    , group = B
    }



-- Group C : Slovenia, Denmark, Serbia, England


slovenia : TeamDatum
slovenia =
    { team = team "SLO" "Slovenië"
    , players = []
    , group = C
    }


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
    , group = C
    }


serbia : TeamDatum
serbia =
    { team = team "SRB" "Servië"
    , players = []
    , group = C
    }


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
    , group = C
    }



-- Group D : PlayoffA, Netherlands, Austria, France


playoffa : TeamDatum
playoffa =
    { team = team "?A?" "Playoff Winner A"
    , players = []
    , group = D
    }


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
    , group = D
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
    , group = D
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
    , group = D
    }



-- Group E : Belgium, Slovakia, Romania, PlayoffB


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


romania : TeamDatum
romania =
    { team = team "ROM" "Roemenië"
    , players = []
    , group = E
    }


playoffb : TeamDatum
playoffb =
    { team = team "?B?" "Playoff Winner B"
    , players = []
    , group = E
    }



-- Group F: Turkey, PlayoffC, Portugal, Czechia


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
    , group = F
    }


playoffc : TeamDatum
playoffc =
    { team = team "?C?" "Playoff Winner C"
    , players = []
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
    , group = F
    }
