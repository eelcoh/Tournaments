module Bets.Init.WorldCup2026.Tournament.Teams exposing (..)

import Bets.Types exposing (Bracket(..), Candidate(..), Group(..), HasQualified(..), Round(..), Team, TeamData, TeamDatum, Winner(..))
import Bets.Types.Team exposing (team)


algeria : TeamDatum
algeria =
    { team = team "ALG" "Algerije"
    , players = []
    , group = J
    }


austria : TeamDatum
austria =
    { team = team "AUT" "Oostenrijk"
    , players = []
    , group = J
    }


cape_verde : TeamDatum
cape_verde =
    { team = team "CPV" "Kaapverdië"
    , players = []
    , group = H
    }


colombia : TeamDatum
colombia =
    { team = team "COL" "Colombia"
    , players = []
    , group = K
    }


curacao : TeamDatum
curacao =
    { team = team "CUW" "Curaçao"
    , players = []
    , group = E
    }


egypt : TeamDatum
egypt =
    { team = team "EGY" "Egypte"
    , players = []
    , group = G
    }


haiti : TeamDatum
haiti =
    { team = team "HAI" "Haïti"
    , players = []
    , group = C
    }


ivory_coast : TeamDatum
ivory_coast =
    { team = team "CIV" "Ivoorkust"
    , players = []
    , group = E
    }


jordan : TeamDatum
jordan =
    { team = team "JOR" "Jordanië"
    , players = []
    , group = J
    }


new_zealand : TeamDatum
new_zealand =
    { team = team "NZL" "Nieuw-Zeeland"
    , players = []
    , group = G
    }


norway : TeamDatum
norway =
    { team = team "NOR" "Noorwegen"
    , players = []
    , group = I
    }


panama : TeamDatum
panama =
    { team = team "PAN" "Panama"
    , players = []
    , group = L
    }


paraguay : TeamDatum
paraguay =
    { team = team "PAR" "Paraguay"
    , players = []
    , group = D
    }


scotland : TeamDatum
scotland =
    { team = team "SCO" "Schotland"
    , players = []
    , group = C
    }


south_africa : TeamDatum
south_africa =
    { team = team "RSA" "Zuid-Afrika"
    , players = []
    , group = A
    }


uzbekistan : TeamDatum
uzbekistan =
    { team = team "UZB" "Oezbekistan"
    , players = []
    , group = K
    }



-- teams
-- regex  \([^)]*\),
-- Group A (Rome/Baku): Turkey, Italy (hosts), Wales, Switzerland


qatar : TeamDatum
qatar =
    { team = { teamID = "QAT", teamName = "Qatar" }
    , players =
        [ "Saad Al Sheeb"
        , "Meshaal Barsham"
        , "Yousef Hassan"
        , "Salah Zakaria"
        , "Abdelkarim Hassan"
        , "Boualem Khoukhi"
        , "Ró-Ró"
        , "Tarek Salman"
        , "Bassam Al-Rawi"
        , "Musab Kheder"
        , "Homam Ahmed"
        , "Mohammed Emad"
        , "Jassem Gaber"
        , "Karim Boudiaf"
        , "Abdulaziz Hatem"
        , "Ali Assadalla"
        , "Mohammed Waad"
        , "Abdelrahman Moustafa"
        , "Osama Al-Tairi"
        , "Ahmed Fadhel"
        , "Mostafa Tarek"
        , "Hassan Al-Haydos"
        , "Akram Afif"
        , "Almoez Ali"
        , "Ismaeel Mohammad"
        , "Mohammed Muntari"
        , "Ahmed Alaaeldin"
        , "Yusuf Abdurisag"
        , "Khalid Muneer"
        , "Naif Al-Hadhrami"
        ]
    , group = A
    }


ecuador : TeamDatum
ecuador =
    { team = { teamID = "ECU", teamName = "Ecuador" }
    , players =
        [ "Alexander Domínguez"
        , "Hernán Galíndez"
        , "Moisés Ramírez"
        , "Gonzalo Valle"
        , "Pervis Estupiñán"
        , "Ángelo Preciado"
        , "Piero Hincapié"
        , "Xavier Arreaga"
        , "Byron Castillo"
        , "Diego Palacios"
        , "Fernando León"
        , "Jackson Porozo"
        , "William Pacho"
        , "Ángel Mena"
        , "Carlos Gruezo"
        , "Jhegson Méndez"
        , "Gonzalo Plata"
        , "Moisés Caicedo"
        , "Romario Ibarra"
        , "Alan Franco"
        , "José Cifuentes"
        , "Jeremy Sarmiento"
        , "Nilson Angulo"
        , "Patrickson Delgado"
        , "Anthony Valencia"
        , "Enner Valencia"
        , "Michael Estrada"
        , "Djorkaeff Reasco"
        ]
    , group = A
    }


senegal : TeamDatum
senegal =
    { team = { teamID = "SEN", teamName = "Senegal" }
    , players =
        [ "Édouard Mendy"
        , "Alioune Badara Faty"
        , "Bingourou Kamara"
        , "Saliou Ciss"
        , "Youssouf Sabaly"
        , "Kalidou Koulibaly "
        , "Pape Abou Cissé"
        , "Abdou Diallo"
        , "Fodé Ballo-Touré"
        , "Abdoulaye Seck"
        , "Bouna Sarr"
        , "Idrissa Gueye"
        , "Nampalys Mendy"
        , "Cheikhou Kouyaté"
        , "Pape Matar Sarr"
        , "Moustapha Name"
        , "Pape Gueye"
        , "Boulaye Dia"
        , "Sadio Mané"
        , "Ismaïla Sarr"
        , "Bamba Dieng"
        , "Keita Baldé"
        , "Famara Diédhiou"
        , "Mame Thiam"
        , "Habib Diallo"
        ]
    , group = A
    }


netherlands : TeamDatum
netherlands =
    { team = { teamID = "NED", teamName = "Nederland" }
    , players =
        [ "Jasper Cillessen"
        , "Justin Bijlow"
        , "Mark Flekken"
        , "Remko Pasveer"
        , "Andries Noppert"
        , "Daley Blind"
        , "Stefan de Vrij"
        , "Virgil van Dijk (captain)"
        , "Matthijs de Ligt"
        , "Denzel Dumfries"
        , "Nathan Aké"
        , "Jurriën Timber"
        , "Tyrell Malacia"
        , "Devyne Rensch"
        , "Mitchel Bakker"
        , "Sven Botman"
        , "Jeremie Frimpong"
        , "Pascal Struijk"
        , "Micky van de Ven"
        , "Frenkie de Jong"
        , "Steven Berghuis"
        , "Davy Klaassen"
        , "Marten de Roon"
        , "Jordy Clasie"
        , "Ryan Gravenberch"
        , "Teun Koopmeiners"
        , "Guus Til"
        , "Kenneth Taylor"
        , "Xavi Simons"
        , "Memphis Depay"
        , "Luuk de Jong"
        , "Steven Bergwijn"
        , "Vincent Janssen"
        , "Donyell Malen"
        , "Wout Weghorst"
        , "Cody Gakpo"
        , "Arnaut Danjuma"
        , "Noa Lang"
        , "Brian Brobbey"
        ]
    , group = A
    }



--


england : TeamDatum
england =
    { team = { teamID = "ENG", teamName = "Engeland" }
    , players =
        [ "Nick Pope"
        , "Aaron Ramsdale"
        , "Dean Henderson"
        , "Reece James"
        , "Luke Shaw"
        , "John Stones"
        , "Eric Dier"
        , "Harry Maguire"
        , "Kieran Trippier"
        , "Kyle Walker"
        , "Conor Coady"
        , "Marc Guéhi"
        , "Ben Chilwell"
        , "Trent Alexander-Arnold"
        , "Fikayo Tomori"
        , "Declan Rice"
        , "Jude Bellingham"
        , "Jordan Henderson"
        , "Mason Mount"
        , "James Ward-Prowse"
        , "Harry Kane"
        , "Raheem Sterling"
        , "Phil Foden"
        , "Bukayo Saka"
        , "Ivan Toney"
        , "Tammy Abraham"
        , "Jarrod Bowen"
        ]
    , group = B
    }


wales : TeamDatum
wales =
    { team = { teamID = "WAL", teamName = "Wales" }
    , players =
        [ "Wayne Hennessey"
        , "Danny Ward"
        , "Tom King"
        , "Chris Gunter"
        , "Connor Roberts"
        , "Joe Rodon"
        , "Neco Williams"
        , "Rhys Norrington-Davies"
        , "Ben Cabango"
        , "Jonny Williams"
        , "Joe Morrell"
        , "Matthew Smith"
        , "Dylan Levitt"
        , "Rubin Colwill"
        , "Sorba Thomas"
        , "Wes Burns"
        , "Jordan James"
        , "Gareth Bale"
        , "Daniel James"
        , "Kieffer Moore"
        , "Tyler Roberts"
        , "Brennan Johnson"
        , "Mark Harris"
        ]
    , group = B
    }


usa : TeamDatum
usa =
    { team = { teamID = "USA", teamName = "Amerika" }
    , players =
        [ "Matt Turner"
        , "Sean Johnson"
        , "Ethan Horvath"
        , "Zack Steffen"
        , "John Pulskamp"
        , "Sergiño Dest"
        , "Mark McKenzie"
        , "Sam Vines"
        , "Erik Palmer-Brown"
        , "Joe Scally"
        , "Reggie Cannon"
        , "Cameron Carter-"
        , "Vickers"
        , "Chris Richards"
        , "Antonee Robinson"
        , "George Bello"
        , "Miles Robinson"
        , "Brooks Lennon"
        , "DeJuan Jones"
        , "Kobi Henry"
        , "Henry Kessler"
        , "Justin Che"
        , "Jonathan Gómez"
        , "Bryan Reynolds"
        , "Kevin Paredes"
        , "Kellyn Acosta"
        , "Weston McKennie"
        , "Tyler Adams"
        , "Luca de la Torre"
        , "Johnny Cardoso"
        , "Malik Tillman"
        , "Yunus Musah"
        , "Djordje Mihailovic"
        , "Gianluca Busio"
        , "James Sands"
        , "Sebastian Lletget"
        , "Jackson Yueill"
        , "Cole Bassett"
        , "Caden Clark"
        , "Christian Pulisic"
        , "Brenden Aaronson"
        , "Josh Sargent"
        , "Giovanni Reyna"
        , "Ricardo Pepi"
        , "Timothy Weah"
        , "Haji Wright"
        , "Jordan Pefok"
        , "Gyasi Zardes"
        , "Taylor Booth"
        , "Cade Cowell"
        ]
    , group = B
    }


iran : TeamDatum
iran =
    { team = { teamID = "IRN", teamName = "Iran" }
    , players =
        [ "Ehsan Hajsafi"
        , "Milad Mohammadi"
        , "Sadegh Moharrami"
        , "Majid Hosseini"
        , "Aref Aghasi"
        , "Mehdi Shiri"
        , "Aref Gholami"
        , "Danial Esmaeilifar"
        , "Farshad Faraji"
        , "Siavash Yazdani"
        , "Alireza Jahanbakhsh"
        , "Saeid Ezatolahi"
        , "Saman Ghoddos"
        , "Ahmad Nourollahi"
        , "Ali Gholizadeh"
        , "Ali Karimi"
        , "Mehdi Hosseini"
        , "Saeid Sadeghi"
        , "Reza Asadi"
        , "Mohammad Karimi"
        , "Yasin Salmani"
        , "Amirhossein Hosseinzadeh"
        , "Soroush Rafiei"
        , "Kamal Kamyabinia"
        , "Zobeir Niknafs"
        , "Karim Ansarifard"
        , "Sardar Azmoun"
        , "Mehdi Taremi"
        , "Mehdi Ghayedi"
        , "Shahriyar Moghanlou"
        , "Allahyar Sayyadmanesh"
        , "Ali Alipour"
        , "Kaveh Rezaei"
        , "Shahab Zahedi"
        ]
    , group = B
    }


argentina : TeamDatum
argentina =
    { team = { teamID = "ARG", teamName = "Argentina" }
    , players =
        [ "Emiliano Martínez"
        , "Franco Armani"
        , "Agustín Marchesín"
        , "Gerónimo Rulli"
        , "Juan Musso"
        , "Agustín Rossi"
        , "Nicolás Otamendi"
        , "Marcos Acuña"
        , "Nicolás Tagliafico"
        , "Germán Pezzella"
        , "Nahuel Molina"
        , "Gonzalo Montiel"
        , "Juan Foyth"
        , "Cristian Romero"
        , "Lucas Martínez Quarta"
        , "Lisandro Martínez"
        , "Facundo Medina"
        , "Marcos Senesi"
        , "Nehuén Pérez"
        , "Ángel Di María"
        , "Leandro Paredes"
        , "Rodrigo De Paul"
        , "Giovani Lo Celso"
        , "Guido Rodríguez"
        , "Nicolás González"
        , "Exequiel Palacios"
        , "Roberto Pereyra"
        , "Alejandro Gómez"
        , "Nicolás Domínguez"
        , "Maximiliano Meza"
        , "Lucas Ocampos"
        , "Alexis Mac Allister"
        , "Enzo Fernández"
        , "Emiliano Buendía"
        , "Thiago Almada"
        , "Matías Soulé"
        , "Nicolás Paz"
        , "Luka Romero"
        , "Valentín Carboni"
        , "Lionel Messi"
        , "Lautaro Martínez"
        , "Paulo Dybala"
        , "Ángel Correa"
        , "Joaquín Correa"
        , "Julián Álvarez"
        , "Lucas Alario"
        , "Giovanni Simeone"
        , "Alejandro Garnacho"
        ]
    , group = C
    }


saudi_arabia : TeamDatum
saudi_arabia =
    { team = { teamID = "KSA", teamName = "Saoedi Arabië" }
    , players =
        [ "Mohammed Al-Owais"
        , "Fawaz Al-Qarni"
        , "Mohammed Al Rubaie"
        , "Nawaf Al-Aqidi"
        , "Yasser Al-Shahrani"
        , "Mohammed Al-Breik"
        , "Ali Al-Bulaihi"
        , "Sultan Al-Ghanam"
        , "Saud Abdulhamid"
        , "Abdulelah Al-Amri"
        , "Hassan Tambakti"
        , "Abdullah Madu"
        , "Ahmed Bamsaud"
        , "Fahad Al-Muwallad"
        , "Salman Al-Faraj"
        , "Salem Al-Dawsari"
        , "Nawaf Al-Abed"
        , "Abdullah Otayf"
        , "Hattan Bahebri"
        , "Mohamed Kanno"
        , "Abdulellah Al-Malki"
        , "Sami Al-Najei"
        , "Ali Al-Hassan"
        , "Nasser Al-Dawsari"
        , "Ayman Yahya"
        , "Abdulrahman Al-Aboud"
        , "Riyadh Sharahili"
        , "Firas Al-Buraikan"
        , "Abdullah Al-Hamdan"
        , "Saleh Al-Shehri"
        , "Haitham Asiri"
        , "Abdullah Radif"
        ]
    , group = C
    }


mexico : TeamDatum
mexico =
    { team = { teamID = "MEX", teamName = "Mexico" }
    , players =
        [ "Guillermo Ochoa"
        , "Alfredo Talavera"
        , "Rodolfo Cota"
        , "Héctor Moreno"
        , "Jesús Gallardo"
        , "Néstor Araujo"
        , "César Montes"
        , "Jorge Sánchez"
        , "Gerardo Arteaga"
        , "Jesús Angulo"
        , "Kevin Álvarez"
        , "Johan Vásquez"
        , "Andrés Guardado"
        , "Héctor Herrera"
        , "Jesús Corona"
        , "Edson Álvarez"
        , "Orbelín Pineda"
        , "Uriel Antuna"
        , "Érick Gutiérrez"
        , "Carlos Rodríguez"
        , "Roberto Alvarado"
        , "Luis Romo"
        , "Diego Lainez"
        , "Alexis Vega"
        , "Érick Sánchez"
        , "Luis Chávez"
        , "Raúl Jiménez"
        , "Hirving Lozano"
        , "Henry Martín"
        , "Rogelio Funes Mori"
        , "Santiago Giménez"
        ]
    , group = C
    }


poland : TeamDatum
poland =
    { team = team "POL" "Polen"
    , players =
        [ "Wojciech Szczęsny"
        , "Łukasz Skorupski"
        , "Bartłomiej Drągowski"
        , "Kamil Grabara"
        , "Radosław Majecki"
        , "Kamil Glik"
        , "Bartosz Bereszyński"
        , "Jan Bednarek"
        , "Artur Jędrzejczyk"
        , "Tomasz Kędziora"
        , "Arkadiusz Reca"
        , "Tymoteusz Puchacz"
        , "Paweł Dawidowicz"
        , "Matty Cash"
        , "Michał Helik"
        , "Nicola Zalewski"
        , "Robert Gumny"
        , "Jakub Kiwior"
        , "Michał Karbownik"
        , "Paweł Bochniewicz"
        , "Mateusz Wieteska"
        , "Patryk Kun"
        , "Maik Nawrocki"
        , "Grzegorz Krychowiak"
        , "Kamil Grosicki"
        , "Piotr Zieliński"
        , "Karol Linetty"
        , "Mateusz Klich"
        , "Przemysław Frankowski"
        , "Kamil Jóźwiak"
        , "Jacek Góralski"
        , "Sebastian Szymański"
        , "Damian Szymański"
        , "Kacper Kozłowski"
        , "Szymon Żurkowski"
        , "Krystian Bielik"
        , "Jakub Kamiński"
        , "Mateusz Łęgowski"
        , "Michał Skóraś"
        , "Patryk Dziczek"
        , "Jakub Piotrowski"
        , "Robert Lewandowski"
        , "Arkadiusz Milik"
        , "Krzysztof Piątek"
        , "Karol Świderski"
        , "Adam Buksa"
        , "Dawid Kownacki"
        ]
    , group = C
    }



--
--
--


france : TeamDatum
france =
    { team = { teamID = "FRA", teamName = "Frankrijk" }
    , players =
        [ "Alban Lafont"
        , "Steve Mandanda"
        , "Alphonse Areola"
        , "Benjamin Pavard"
        , "William Saliba"
        , "Raphaël Varane"
        , "Jules Koundé"
        , "Dayot Upamecano"
        , "Jonathan Clauss"
        , "Benoît Badiashile"
        , "Ferland Mendy"
        , "Adrien Truffert"
        , "Eduardo"
        , "Camavinga"
        , "Aurélien"
        , "Tchouaméni"
        , "Matteo Guendouzi"
        , "Jordan Veretout"
        , "Youssouf Fofana"
        , "Antoine"
        , "Griezmann"
        , "Olivier Giroud"
        , "Kylian Mbappé"
        , "Christopher"
        , "Nkunku"
        , "Randal Kolo Muani"
        , "Ousmane Dembélé"
        ]
    , group = D
    }


australia : TeamDatum
australia =
    { team = { teamID = "AUS", teamName = "Australia" }
    , players =
        [ "Mathew"
        , "Ryan"
        , "Danny Vukovic"
        , "Andrew"
        , "Redmayne"
        , "Aziz Behich"
        , "Miloš Degenek"
        , "Bailey Wright"
        , "Fran Karačić"
        , "Harry Souttar"
        , "Nathaniel"
        , "Atkinson"
        , "Joel King"
        , "Kye Rowles"
        , "Thomas Deng"
        , "Aaron Mooy"
        , "Jackson Irvine"
        , "Ajdin Hrustic"
        , "Riley McGree"
        , "Keanu Baccus"
        , "Cameron Devlin"
        , "Mathew Leckie"
        , "Awer Mabil"
        , "Jamie Maclaren"
        , "Mitchell Duke"
        , "Martin Boyle"
        , "Craig Goodwin"
        , "Jason Cummings"
        , "Garang Kuol"
        ]
    , group = D
    }


tunisia : TeamDatum
tunisia =
    { team = { teamID = "TUN", teamName = "Tunisië" }
    , players =
        [ "Mohamed Sedki Debchi"
        , "Aymen Dahmen"
        , "Bechir Ben Saïd"
        , "Bilel Ifa"
        , "Montassar Talbi"
        , "Ali Abdi"
        , "Nader Ghandri"
        , "Dylan Bronn"
        , "Mortadha Ben Ouanes"
        , "Ali Maâloul"
        , "Omar Rekik"
        , "Mohamed Dräger"
        , "Hamza Mathlouthi"
        , "Rami Kaib"
        , "Yan Valery"
        , "Saîf-Eddine Khaoui"
        , "Ferjani Sassi"
        , "Hannibal Mejbri"
        , "Ellyes Skhiri"
        , "Ghailene Chaalali"
        , "Anis Ben Slimane"
        , "Chaïm El Djebali"
        , "Aïssa Laïdouni"
        , "Youssef"
        , "Msakni"
        , "Wahbi Khazri"
        , "Taha Yassine Khenissi"
        , "Seifeddine Jaziri"
        , "Naïm Sliti"
        , "Issam Jebali"
        , "Sayfallah Ltaief"
        ]
    , group = D
    }


denmark : TeamDatum
denmark =
    { team = { teamID = "DEN", teamName = "Denmark" }
    , players =
        [ "Kasper Schmeichel"
        , "Oliver Christensen"
        , "Simon Kjær"
        , "Andreas Christensen"
        , "Jens Stryger Larsen"
        , "Daniel Wass"
        , "Joakim Mæhle"
        , "Joachim Andersen"
        , "Rasmus Kristensen"
        , "Victor Nelsson"
        , "Christian Eriksen"
        , "Thomas Delaney"
        , "Pierre-Emile Højbjerg"
        , "Mathias Jensen"
        , "Martin Braithwaite"
        , "Andreas Cornelius"
        , "Kasper Dolberg"
        , "Andreas Skov Olsen"
        , "Mikkel Damsgaard"
        , "Jonas Wind"
        , "Jesper Lindstrøm"
        ]
    , group = D
    }



-----


spain : TeamDatum
spain =
    { team = team "ESP" "Spanje"
    , players =
        [ "Unai Simón"
        , "Kepa Arrizabalaga"
        , "Robert Sánchez"
        , "David Raya"
        , "David Soria"
        , "Sergio Ramos"
        , "Jordi Alba"
        , "César Azpilicueta"
        , "Dani Carvajal"
        , "Pau Torres"
        , "Iñigo Martínez"
        , "José Gayà"
        , "Eric García"
        , "Aymeric Laporte"
        , "Diego Llorente"
        , "Marcos Alonso"
        , "Hugo Guillamón"
        , "Alejandro Balde"
        , "Arnau Martínez"
        , "Sergio Busquets"
        , "Koke"
        , "Thiago"
        , "Rodri"
        , "Marcos Llorente"
        , "Pedri"
        , "Gavi"
        , "Carlos Soler"
        , "Mikel Merino"
        , "Sergi Roberto"
        , "Sergio Canales"
        , "Brais Méndez"
        , "Oihan Sancet"
        , "Alvaro Morata"
        , "Ferran Torres"
        , "Marco Asensio"
        , "Rodrigo"
        , "Pablo Sarabia"
        , "Dani Olmo"
        , "Mikel Oyarzabal"
        , "Iago Aspas"
        , "Gerard Moreno"
        , "Yeremy Pino"
        , "Ansu Fati"
        , "Nico Williams"
        , "Borja Iglesias"
        ]
    , group = E
    }


germany : TeamDatum
germany =
    { team = team "GER" "Duitsland"
    , players =
        [ "Oliver Baumann"
        , "Kevin Trapp"
        , "Marc-André ter Stegen"
        , "David Raum"
        , "Matthias Ginter"
        , "Thilo Kehrer"
        , "Niklas Süle"
        , "Benjamin Henrichs"
        , "Armel Bella-Kotchap"
        , "Robin Gosens"
        , "Nico Schlotterbeck"
        , "Joshua Kimmich"
        , "Kai Havertz"
        , "Maximilian Arnold"
        , "Jamal Musiala"
        , "Jonas Hofmann"
        , "İlkay Gündoğan"
        , "Timo Werner"
        , "Serge Gnabry"
        , "Thomas"
        , "Müller"
        , "Leroy Sané"
        ]
    , group = E
    }


costa_rica : TeamDatum
costa_rica =
    { team = { teamID = "CRC", teamName = "Costa Rica" }
    , players =
        [ "Keylor Navas"
        , "Esteban Alvarado"
        , "Patrick Sequeira"
        , "Francisco Calvo"
        , "Bryan Oviedo"
        , "Óscar Duarte"
        , "Kendall Waston"
        , "Rónald Matarrita"
        , "Keysher Fuller"
        , "Juan Pablo Vargas"
        , "Carlos Martínez"
        , "Celso Borges"
        , "Bryan Ruiz"
        , "Yeltsin Tejeda"
        , "Gerson Torres"
        , "Jewison Bennette"
        , "Daniel Chacón"
        , "Youstin Salas"
        , "Roan Wilson"
        , "Brandon Aguilera"
        , "Douglas López"
        , "Anthony Hernández"
        , "Álvaro Zamora"
        , "Joel Campbell"
        , "Johan Venegas"
        , "Anthony Contreras"
        ]
    , group = E
    }


japan : TeamDatum
japan =
    { team = { teamID = "JPN", teamName = "Japan" }
    , players =
        [ "Eiji Kawashima"
        , "Shūichi Gonda"
        , "Daniel Schmidt"
        , "Miki Yamane"
        , "Shogo Taniguchi"
        , "Ko Itakura"
        , "Yuto Nagatomo"
        , "Takehiro Tomiyasu"
        , "Hiroki Sakai"
        , "Maya Yoshida"
        , "Hiroki Ito"
        , "Wataru Endo"
        , "Gaku Shibasaki"
        , "Ritsu Dōan"
        , "Kaoru Mitoma"
        , "Takumi Minamino"
        , "Takefusa Kubo"
        , "Hidemasa Morita"
        , "Junya Ito"
        , "Daichi Kamada"
        , "Ao Tanaka"
        , "Yuki Soma"
        , "Takuma Asano"
        , "Ayase Ueda"
        , "Daizen Maeda"
        ]
    , group = E
    }



-----


belgium : TeamDatum
belgium =
    { team = team "BEL" "België"
    , players =
        [ "Thibaut Courtois"
        , "Simon Mignolet"
        , "Koen Casteels"
        , "Matz Sels"
        , "Toby Alderweireld"
        , "Arthur Theate"
        , "Zeno Debast"
        , "Jan Vertonghen"
        , "Thomas Meunier"
        , "Brandon Mechele"
        , "Dedryck Boyata"
        , "Jason Denayer"
        , "Wout Faes"
        , "Axel Witsel"
        , "Kevin De Bruyne (third"
        , "captain)"
        , "Youri Tielemans"
        , "Yannick Carrasco"
        , "Charles De Ketelaere"
        , "Leandro Trossard"
        , "Amadou Onana"
        , "Leander Dendoncker"
        , "Hans Vanaken"
        , "Timothy Castagne"
        , "Alexis Saelemaekers"
        , "Loïs Openda"
        , "Eden Hazard"
        , "Dries Mertens"
        , "Michy Batshuayi"
        , "Thorgan Hazard"
        , "Dodi Lukebakio"
        ]
    , group = F
    }


croatia : TeamDatum
croatia =
    { team = team "CRO" "Kroatië"
    , players =
        [ "Dominik Livaković"
        , "Ivica Ivušić"
        , "Ivo Grbić"
        , "Dominik Kotarski"
        , "Nediljko Labrović"
        , "Domagoj Vida"
        , "Dejan Lovren"
        , "Borna Barišić"
        , "Duje Ćaleta-Car"
        , "Josip Juranović"
        , "Joško Gvardiol"
        , "Borna Sosa"
        , "Josip Stanišić"
        , "Marin Pongračić"
        , "Martin Erlić"
        , "Josip Šutalo"
        , "Luka Modrić"
        , "Mateo Kovačić"
        , "Marcelo Brozović"
        , "Mario Pašalić"
        , "Nikola Vlašić"
        , "Luka Ivanušec"
        , "Lovro Majer"
        , "Kristijan Jakić"
        , "Luka Sučić"
        , "Josip Mišić"
        , "Ivan Perišić"
        , "Andrej Kramarić"
        , "Josip Brekalo"
        , "Bruno Petković"
        , "Mislav Oršić"
        , "Ante Budimir"
        , "Marko Livaja"
        , "Antonio-Mirko Čolak"
        ]
    , group = F
    }


canada : TeamDatum
canada =
    { team = { teamID = "CAN", teamName = "Canada" }
    , players =
        [ "Dayne St. Clair"
        , "James Pantemis"
        , "Thomas Hasal"
        , "Doneil Henry"
        , "Richie Laryea"
        , "Alistair Johnston"
        , "Kamal Miller"
        , "Zachary Brault-Guillard"
        , "Raheem Edwards"
        , "Lukas MacNaughton"
        , "Joel Waterman"
        , "Samuel Piette"
        , "Jonathan Osorio"
        , "Mark-Anthony Kaye"
        , "Liam Fraser"
        , "Ismaël Koné"
        , "Mathieu Choinière"
        , "Lucas Cavallini"
        , "Jayden Nelson"
        , "Jacob Shaffelburg"
        , "Ayo Akinola"
        ]
    , group = F
    }


morocco : TeamDatum
morocco =
    { team = { teamID = "MAR", teamName = "Marokko" }
    , players =
        [ "Yassine"
        , "Bounou"
        , "Munir Mohamedi"
        , "Ahmed Reda"
        , "Tagnaouti"
        , "Anas Zniti"
        , "Achraf Hakimi"
        , "Noussair Mazraoui"
        , "Jawad El Yamiq"
        , "Romain"
        , "Saïss"
        , "Achraf Dari"
        , "Samy Mmaee"
        , "Yahia Attiyat Allah"
        , "Badr Benoun"
        , "Fahd Moufi[67]"
        , "Sofyan Amrabat"
        , "Azzedine Ounahi"
        , "Younès Belhanda"
        , "Abdelhamid Sabiri"
        , "Ilias Chair"
        , "Selim Amallah"
        , "Amine Harit"
        , "Yahya Jabrane"
        , "Hakim Ziyech"
        , "Munir El Haddadi"
        , "Zakaria Aboukhlal"
        , "Abde Ezzalzouli"
        , "Sofiane Boufal"
        , "Youssef En-Nesyri"
        , "Walid Cheddira"
        , "Ryan Mmaee"
        , "Ayoub El Kaabi"
        , "Soufiane Rahimi"
        ]
    , group = F
    }



-----


switzerland : TeamDatum
switzerland =
    { team = { teamID = "SUI", teamName = "Switzerland" }
    , players =
        [ "Yann Sommer"
        , "Yvon Mvogo"
        , "David von Ballmoos"
        , "Ricardo Rodriguez"
        , "Fabian Schär"
        , "Manuel Akanji"
        , "Nico Elvedi"
        , "Silvan Widmer"
        , "Kevin Mbabu"
        , "Eray Cömert"
        , "Xherdan Shaqiri"
        , "Granit Xhaka"
        , "Remo Freuler"
        , "Denis Zakaria"
        , "Djibril Sow"
        , "Renato Steffen"
        , "Fabian Frei"
        , "Michel Aebischer"
        , "Ardon Jashari"
        , "Haris Seferovic"
        , "Breel Embolo"
        , "Ruben Vargas"
        , "Cedric Itten"
        , "Dan Ndoye"
        , "Zeki Amdouni"
        ]
    , group = G
    }


brazil : TeamDatum
brazil =
    { team = { teamID = "BRA", teamName = "Brazil" }
    , players =
        [ "Alisson"
        , "Ederson"
        , "Weverton"
        , "Dani Alves"
        , "Marquinhos"
        , "Thiago Silva"
        , "Eder Militão"
        , "Danilo"
        , "Alex Sandro"
        , "Alex Telles"
        , "Bremer, Casemiro"
        , "Fred"
        , "Fabinho"
        , "Bruno Guimarães"
        , "Lucas Paquetá"
        , "Everton Ribeiro"
        , "Neymar"
        , "Vinicius Jr."
        , "Richarlison"
        , "Raphinha"
        , "Antony"
        , "Gabriel Jesus"
        , "Gabriel Martinelli"
        , "Pedro"
        , "Rodrygo"
        ]
    , group = G
    }


serbia : TeamDatum
serbia =
    { team = { teamID = "SRB", teamName = "Servië" }
    , players =
        [ "Marko Dmitrović"
        , "Vanja Milinković-Savić"
        , "Marko Ilić"
        , "Stefan Mitrović"
        , "Strahinja Pavlović"
        , "Miloš Veljković"
        , "Filip Mladenović"
        , "Aleksa Terzić"
        , "Srđan Babić"
        , "Erhan Mašović"
        , "Strahinja Eraković"
        , "Dušan Tadić"
        , "Filip Kostić"
        , "Nemanja Maksimović"
        , "Nemanja Radonjić"
        , "Filip Đuričić"
        , "Saša Lukić"
        , "Andrija Živković"
        , "Darko Lazović"
        , "Ivan Ilić"
        , "Stefan Mitrović"
        , "Aleksandar Mitrović"
        , "Luka Jović"
        , "Dušan Vlahović"
        ]
    , group = G
    }


cameroon : TeamDatum
cameroon =
    { team = { teamID = "CAM", teamName = "Kameroen" }
    , players =
        [ "Simon Ngapandouetnbu"
        , "Devis Epassy"
        , "André Onana"
        , "James Bievenue Djaoyang"
        , "Simon Omossola"
        , "Jean Efala"
        , "Narcisse Nlend"
        , "Darlin Yongwa"
        , "Nicolas Nkoulou"
        , "Christopher Wooh"
        , "Oumar Gonzalez"
        , "Nouhou Tolo"
        , "Olivier Mbaizo"
        , "Collins Fai"
        , "Jean-Charles Castelletto"
        , "Enzo Ebosse"
        , "Michael Ngadeu-Ngadjui"
        , "Enzo Tchato"
        , "Ambroise Oyongo"
        , "Duplexe Tchamba"
        , "Harold Moukoudi"
        , "Jérôme Onguéné"
        , "Joyskim Dawa"
        , "Jean-Claude Billong"
        , "Sacha Boey"
        , "Samuel Kotto"
        , "Olivier Ntcham"
        , "Georges Mandjeck"
        , "Pierre Kunde"
        , "Martin Hongla"
        , "Samuel Gouet"
        , "Gaël Ondoua"
        , "Jean Onana"
        , "Brice Ambina"
        , "André-Frank Zambo"
        , "Anguissa"
        , "Jeando Fuchs"
        , "Arnaud Djoum"
        , "James Léa Siliki"
        , "Yvan Neyou"
        , "Moumi Ngamaleu"
        , "Léandre Tawamba"
        , "Vincent"
        , "Aboubakar"
        , "Jean-Pierre Nsame"
        , "Bryan Mbeumo"
        , "Georges-Kévin Nkoudou"
        , "Karl Toko Ekambi"
        , "Eric Maxim Choupo-Moting"
        , "Christian Bassogog"
        , "Stéphane Bahoken"
        , "Ignatius Ganago"
        , "Danny Loader"
        , "Didier Lamkel Zé"
        , "Kévin Soni"
        , "Clinton N'Jie"
        , "Paul-Georges Ntep"
        , "John Mary"
        , "Jeremy Ebobisse"
        ]
    , group = G
    }



-- Group B (Copenhagen/St Petersburg): Denmark (hosts), Finland, Belgium, Russia (hosts)


portugal : TeamDatum
portugal =
    { team = team "POR" "Portugal"
    , players =
        [ "Rui Patrício"
        , "Anthony Lopes"
        , "Diogo Costa"
        , "Rui Silva"
        , "José Sá"
        , "Pepe"
        , "Danilo Pereira"
        , "Raphaël Guerreiro"
        , "José Fonte"
        , "Rúben Dias"
        , "João Cancelo"
        , "Cédric Soares"
        , "Nélson Semedo"
        , "Nuno Mendes"
        , "Mário Rui"
        , "Diogo Dalot"
        , "Domingos Duarte"
        , "Fábio Cardoso"
        , "David Carmo"
        , "Thierry Correia"
        , "Tiago Djaló"
        , "Gonçalo Inácio"
        , "Diogo Leite"
        , "Nuno Santos"
        , "António Silva"
        , "Nuno Tavares"
        , "João Moutinho"
        , "William Carvalho"
        , "Bernardo Silva"
        , "João Mário"
        , "Bruno Fernandes"
        , "Renato Sanches"
        , "Rúben Neves"
        , "João Palhinha"
        , "Sérgio Oliveira"
        , "Matheus Nunes"
        , "Otávio"
        , "Vitinha"
        , "Fábio Carvalho"
        , "Florentino Luís"
        , "Fábio Vieira"
        , "Cristiano Ronaldo"
        , "André Silva"
        , "Gonçalo Guedes"
        , "João Félix"
        , "Rafael Leão"
        , "Francisco Trincão"
        , "Ricardo Horta"
        , "Paulinho"
        , "Pedro Gonçalves"
        , "Daniel Podence"
        , "Beto"
        , "Jota"
        , "Gonçalo Ramos"
        , "Vitinha"
        ]
    , group = H
    }


ghana : TeamDatum
ghana =
    { team = { teamID = "GHA", teamName = "Ghana" }
    , players =
        [ "Richard Ofori"
        , "Joe Wollacott"
        , "Lawrence Ati-Zigi"
        , "Abdul Manaf Nurudeen"
        , "Ibrahim Danlad"
        , "Jonathan Mensah"
        , "Abdul Rahman Baba"
        , "Daniel Amartey"
        , "Andy Yiadom"
        , "Alexander Djiku"
        , "Kasim Nuhu"
        , "Joseph Aidoo"
        , "Gideon Mensah"
        , "Denis Odoi"
        , "Alidu Seidu"
        , "Mohammed Salisu"
        , "Tariq Lamptey"
        , "Dennis Nkrumah-Korsah"
        , "Patrick Kpozo"
        , "Abdul Mumin"
        , "Stephan Ambrosius"
        , "Ibrahim Imoro"
        , "André Ayew"
        , "Mubarak Wakaso"
        , "Thomas Partey"
        , "Jeffrey Schlupp"
        , "Iddrisu Baba"
        , "Mohammed Kudus"
        , "Daniel-Kofi Kyereh"
        , "Edmund Addo"
        , "Joseph Paintsil"
        , "Majeed Ashimeru"
        , "Elisha Owusu"
        , "Daniel Afriyie"
        , "Salifu Mudasiru"
        , "Salis Abdul Samed"
        , "Jordan Ayew"
        , "Richmond Boakye"
        , "Samuel Owusu"
        , "Caleb Ekuban"
        , "Kamaldeen Sulemana"
        , "Abdul Fatawu Issahaku"
        , "Joel Fameyeh"
        , "Felix Afena-Gyan"
        , "Kwasi Okyere Wriedt"
        , "Osman Bukari"
        , "Yaw Yeboah"
        , "Emmanuel Gyasi"
        , "Christopher Antwi-Adjei"
        , "Iñaki Williams"
        , "Antoine Semenyo"
        , "Mohammed Dauda"
        , "Kamal Sowah"
        , "Ransford-Yeboah Königsdörffer"
        , "Ernest Nuamah"
        ]
    , group = H
    }


uruguay : TeamDatum
uruguay =
    { team = { teamID = "URU", teamName = "Uruguay" }
    , players =
        [ "Fernando Muslera"
        , "Sergio Rochet"
        , "Sebastián Sosa"
        , "Guillermo de Amores"
        , "Santiago Mele"
        , "Gastón Olveira"
        , "Diego Godín"
        , "Martín Cáceres"
        , "José Giménez"
        , "Sebastián Coates"
        , "Matías Viña"
        , "Giovanni González"
        , "Ronald Araújo"
        , "Guillermo Varela"
        , "Mathías Olivera"
        , "Joaquín Piquerez"
        , "Damián Suárez"
        , "Sebastián Cáceres"
        , "Bruno Méndez"
        , "Agustín Rogel"
        , "Gastón Álvarez"
        , "Santiago Bueno"
        , "Leandro Cabrera"
        , "Alfonso Espino"
        , "Lucas Olaza"
        , "Federico Pereira"
        , "José Luis Rodríguez"
        , "Matías Vecino"
        , "Rodrigo Bentancur"
        , "Federico Valverde"
        , "Giorgian de Arrascaeta"
        , "Lucas Torreira"
        , "Nicolás de la Cruz"
        , "Mauro Arambarri"
        , "Fernando Gorriarán"
        , "Manuel Ugarte"
        , "César Araújo"
        , "Maximiliano Araújo"
        , "Felipe Carballo"
        , "Fabricio Díaz"
        , "Luis Suárez"
        , "Edinson Cavani"
        , "Jonathan Rodríguez"
        , "Maxi Gómez"
        , "Darwin Núñez"
        , "Facundo Torres"
        , "Facundo Pellistri"
        , "Agustín Álvarez Martínez"
        , "Diego Rossi"
        , "Agustín Canobbio"
        , "David Terans"
        , "Brian Ocampo"
        , "Martín Satriano"
        , "Thiago Borbas"
        , "Nicolás López"
        ]
    , group = H
    }


south_korea : TeamDatum
south_korea =
    { team = { teamID = "KOR", teamName = "Zuid Korea" }
    , players =
        [ "Kim Dong-jun"
        , "Kim Min-jae"
        , "Kim Ju-sung"
        , "Lee Jae-ik"
        , "Lee Yong"
        , "Jung Seung-hyun"
        , "Kang Sang-woo"
        , "Choi Ji-mook"
        , "Son Heung-min "
        , "Lee Jae-sung"
        , "Hwang Hee-chan"
        , "Hwang In-beom"
        , "Jeong Woo-yeong"
        , "Lee Kang-in"
        , "Lee Yeong-jae"
        , "Kim Dong-hyun"
        , "Kang Seong-jin"
        , "Goh Young-joon"
        , "Lee Ki-hyuk"
        , "Nam Tae-hee"
        , "Lee Dong-jun"
        , "Won Du-jae"
        , "Lee Dong-gyeong"
        , "Eom Ji-sung"
        , "Kim Dae-won"
        , "Hwang Ui-jo"
        , "Cho Young-wook"
        , "Kim Gun-hee"
        ]
    , group = H
    }

team_a4 : TeamDatum
team_a4 =
    { team = { teamID = "A4", teamName = "Winnaar UEFA play-offs D" }
    , players = []
    , group = A
    }
team_b2 : TeamDatum
team_b2 =
    { team = { teamID = "B2", teamName = "Winnaar UEFA play-offs A" }
    , players = []
    , group = B
    }
team_d4 : TeamDatum
team_d4 =
    { team = { teamID = "D4", teamName = "Winnaar UEFA play-offs C" }
    , players = []
    , group = D
    }
team_f3 : TeamDatum
team_f3 =
    { team = { teamID = "F3", teamName = "Winnaar UEFA play-offs B" }
    , players = []
    , group = F
    }

team_i1 : TeamDatum
team_i1 =
    { team = { teamID = "I1", teamName = "Team I1" }
    , players = []
    , group = I
    }

team_i2 : TeamDatum
team_i2 =
    { team = { teamID = "I2", teamName = "Team I2" }
    , players = []
    , group = I
    }

team_i3 : TeamDatum
team_i3 =
    { team = { teamID = "I3", teamName = "Team I3" }
    , players = []
    , group = I
    }

team_i4 : TeamDatum
team_i4 =
    { team = { teamID = "I4", teamName = "Team I4" }
    , players = []
    , group = I
    }

team_j1 : TeamDatum
team_j1 =
    { team = { teamID = "J1", teamName = "Team J1" }
    , players = []
    , group = J
    }

team_j2 : TeamDatum
team_j2 =
    { team = { teamID = "J2", teamName = "Team J2" }
    , players = []
    , group = J
    }

team_j3 : TeamDatum
team_j3 =
    { team = { teamID = "J3", teamName = "Team J3" }
    , players = []
    , group = J
    }

team_j4 : TeamDatum
team_j4 =
    { team = { teamID = "J4", teamName = "Team J4" }
    , players = []
    , group = J
    }

team_k1 : TeamDatum
team_k1 =
    { team = { teamID = "K1", teamName = "Team K1" }
    , players = []
    , group = K
    }

team_k2 : TeamDatum
team_k2 =
    { team = { teamID = "K2", teamName = "Team K2" }
    , players = []
    , group = K
    }

team_k3 : TeamDatum
team_k3 =
    { team = { teamID = "K3", teamName = "Team K3" }
    , players = []
    , group = K
    }

team_k4 : TeamDatum
team_k4 =
    { team = { teamID = "K4", teamName = "Team K4" }
    , players = []
    , group = K
    }

team_l1 : TeamDatum
team_l1 =
    { team = { teamID = "L1", teamName = "Team L1" }
    , players = []
    , group = L
    }

team_l2 : TeamDatum
team_l2 =
    { team = { teamID = "L2", teamName = "Team L2" }
    , players = []
    , group = L
    }

team_l3 : TeamDatum
team_l3 =
    { team = { teamID = "L3", teamName = "Team L3" }
    , players = []
    , group = L
    }

team_l4 : TeamDatum
team_l4 =
    { team = { teamID = "L4", teamName = "Team L4" }
    , players = []
    , group = L
    }