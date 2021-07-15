--unit area
module Area exposing (..)
import GameData exposing (CPdata,PureCPdata,initCPdata,initPureCPdata)
import GameData exposing (CRdata)
import GameData exposing (initCRdata)
type alias Area =
    { --view : Mapview,
      localCP : List CPdata
    , effect : List PureCPdata
    , --The index of the area. Start from **1**.
      no : Int
    , areaColor : String
    , areaPos : (Int,Int)
    
    }

init_Area : Int -> (Int,Int)-> Area
init_Area areaNumber areaPos= 
 
    { localCP = [ initCPdata ]
    , effect = [ initPureCPdata ]
    , no = areaNumber
    , areaColor = "pink"
    , areaPos = areaPos
    }

 
init_AreaPos: Int -> (Int,Int)
init_AreaPos areaNumber =
  if areaNumber == 1 then
  (200,250)
  else if areaNumber == 2 then
  (280,200)
  else if areaNumber == 3 then
  (350,300)
  else (50,100)


init_AreaS : Int -> List Area 
init_AreaS areaNumber =
   let 
      firstArea = [(init_Area areaNumber (init_AreaPos areaNumber))]
    in
    if areaNumber == 1 then
      firstArea
    else firstArea ++ init_AreaS (areaNumber - 1) 
    
        

