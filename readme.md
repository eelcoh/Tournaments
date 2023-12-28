# A hobbyist betting app for the world cups and the european championships of 2018, 2020, 2022 and 2024.
Built with [elm](http://elm-lang.org/), using the fantastic [style-elements](http://package.elm-lang.org/packages/mdgriffith/style-elements/latest) library.

To add a tournament: add a Bets.Init.<your-tournament-name>.Tournament module
and have it expose the three functions (bracket, initTeamData, matches) where the contract is as follows:
- `bracket` must have the type `List Bets.Types.Bracket`
- `initTeamData` must have the type `Bets.Types.TeamData` which is an alias for `List Bets.Types.TeamDatum`
- `matches` must have the type `List Bets.Types.Match`

and have it imported - there can only be one imported tournament at the time
see for example in the module `Bets.Init`:
`import Bets.Init.Euro2020.Tournament exposing (bracket, initTeamData, matches)`
`import Bets.Init.WorldCup2022.Tournament exposing (bracket, initTeamData, matches)`
`import Bets.Init.Euro2024.Tournament exposing (bracket, initTeamData, matches)`