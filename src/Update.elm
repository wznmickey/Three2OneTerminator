module Update exposing (..)
import Dict exposing (Dict)
import PureCPdata exposing (PureCPdata)
import GameData exposing (getPureCPdataByName)
import GameData exposing (GameData)
import Area exposing (Area)
import For exposing (for_outer)
import Array exposing (Array)
import Area exposing (initArea)
import CRdata exposing (CRdata)


effectCP : Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata -> ( Dict String PureCPdata, Dict String PureCPdata )
effectCP effect global local =
    ( dictEffectCP effect global, dictEffectCP effect local )


dictEffectCP : Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata
dictEffectCP effect before =
    Dict.map (getEffect effect) before


getEffect : Dict String PureCPdata -> String -> PureCPdata -> PureCPdata
getEffect effect key before =
    if before.name == key then
        valueEffectCP (getPureCPdataByName ( key, effect )) before

    else
        before


valueEffectCP : PureCPdata -> PureCPdata -> PureCPdata
valueEffectCP effect before =
    { before | data = before.data + effect.data }


updateData : GameData -> GameData
updateData data =
    let
        ( newArea, newGlobal ) =
            areaCPchange data.area data.globalCP
    in
    { data | area = newArea, globalCP = newGlobal }


areaCPchange : Dict String Area -> Dict String PureCPdata -> ( Dict String Area, Dict String PureCPdata )
areaCPchange area global =
    let
        pureArea =
            Array.map (\( x, y ) -> y) (Array.fromList (Dict.toList area))

        ( afterAreaArray, afterGlobal ) =
            for_outer 0 (Dict.size area) eachAreaCPchange ( pureArea, global )
    in
    ( Dict.fromList (List.map (\x -> ( x.name, x )) (Array.toList afterAreaArray)), afterGlobal )


eachAreaCPchange : Dict String PureCPdata -> Int -> Array Area -> ( Array Area, Dict String PureCPdata )
eachAreaCPchange global i a =
    let
        newArea =
            Maybe.withDefault initArea (Array.get i a)
        ( newGlobal, local ) =
            effectCP newArea.effect global newArea.localCP
    in
    ( Array.map ((\y x -> { x | localCP = y }) local) a, newGlobal )




moveCR : Dict String CRdata -> String -> String -> Dict String CRdata
moveCR before from to =
    Dict.update from (setCRlocation to) before


setCRlocation : String -> Maybe CRdata -> Maybe CRdata
setCRlocation to from =
    case from of
        Just fromArea ->
            Maybe.Just { fromArea | location = to }

        _ ->
            from
