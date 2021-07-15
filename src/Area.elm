--unit area


module Area exposing (..)

import GameData exposing (CPdata, PureCPdata, initCPdata, initPureCPdata)


type alias Area =
    { --view : Mapview,
    , name: String
      localCP : List CPdata
    , effect : List PureCPdata
    , --The index of the area. Start from **1**.
      no : Int
    , areaColor : String
    }


init_Area : Int -> Area
init_Area areaNumber =
    { localCP = [ initCPdata ]
    , effect = [ initPureCPdata ]
    , no = areaNumber
    , areaColor = "pink"
    }


init_AreaS : Int -> List Area
init_AreaS areaNumber =
    let
        firstArea =
            [ init_Area areaNumber ]
    in
    if areaNumber == 1 then
        firstArea

    else
        firstArea ++ init_AreaS (areaNumber - 1)
