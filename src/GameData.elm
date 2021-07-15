module GameData exposing (..)


type CPtype
    = Local
    | Global

type alias GameData =
    { allCP : List CPdata
    , allCR : List CRdata
    , helpText : List HelpText
    }


type alias CRdata =
    { --view: CRview
      -- The index of the area.
      city : Int
    , effect : List PureCPdata
    , name : String
    , location : (Int,Int)
    }


type alias CPdata =
    { pure : PureCPdata
    , effect : List PureCPdata
    , typeCP : CPtype
    }


type alias PureCPdata =
    { name : String
    , {--
            The data have 2 meaning:
            1. when as effect: increase or decrease of certain CP each time loaded 
            2. when as globalCP/localCP: the value of the certain CP
        --}
      data : Float
    }


type alias HelpText =
    { name : String
    , -- Help text.
      text : String
    }






initHelpText : HelpText
initHelpText =
    { name = "init", text = "init" }


initPureCPdata : PureCPdata
initPureCPdata =
    { name = "init", data = 0 }


initCPdata : CPdata
initCPdata =
    { pure = initPureCPdata
    , effect = [ initPureCPdata ]
    , typeCP = Global
    }


initCRdata : CRdata
initCRdata =
    { city = 1
    , effect = [ initPureCPdata ]
    , name = "init"
    , location = (0,0)
    }

initCRdata_4test : CRdata
initCRdata_4test =
    { city = 2
    , effect = [ initPureCPdata ]
    , name = "init"
    , location = (0,0)
    }


initGameData : GameData
initGameData =
    GameData   ([ initCPdata ] ++ [ initCPdata ]) [ initCRdata ] [ initHelpText ]


update_Gamedata : GameData -> GameData
update_Gamedata oldGmae =
  oldGmae
  |> update_CR_CP
  |> update_Area_CP
  |> update_CP_CP



update_CP_CP : GameData -> GameData
update_CP_CP gameData =
 gameData


update_CR_CP : GameData -> GameData
update_CR_CP gameData =
 gameData


update_Area_CP : GameData -> GameData
update_Area_CP gameData =
 gameData