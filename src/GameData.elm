module GameData exposing (..)


type CPtype
    = Local
    | Global


type alias CRdata =
    { --view: CRview
      -- The index of the area.
      name : String
    , location : Int
    , effect : List PureCPdata
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


type alias GameData =
    { globalCP : List CPdata
    , allCR : List CRdata
    , helpText : List HelpText
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
    , typeCP = Local
    }


initCRdata : CRdata
initCRdata =
    { name = "CR"
    , location = 0
    , effect = [ initPureCPdata ]
    }


initGameData : GameData
initGameData =
    GameData [ initCPdata ] [ initCRdata ] [ initHelpText ]

{-- This part of code can not be compiled. The name and the coding seems not fit. Reserve it for further developing.
changeCP2CR : Int -> Int
changeCP2CR =
    { 
    if CPdata < 10 then
        CPdata = CRdata+1
        CRdata = CRdata-1
    else if CPdata >= 10 then
        CPdata = CRdata+2
        CRdata = CRdata-2
    }
--}
