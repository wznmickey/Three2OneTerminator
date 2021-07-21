module Update exposing (..)

import Area exposing (Area, initArea)
import Array exposing (Array)
import CPdata exposing (CPdata)
import CPtype exposing (CPtype(..))
import CRdata exposing (CRdata, initCRdata)
import Dict exposing (Dict)
import For exposing (for_outer)
import GameData exposing (GameData, getCPdataByName, getPureCPdataByName)
import Html exposing (ol)
import PureCPdata exposing (PureCPdata)



--change cp according to effect


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
    --For debug { before | data = (Debug.log "before" before.data) + (Debug.log "add" effect.data) }
    { before | data =  before.data+ effect.data }



--data update


updateData : GameData -> GameData
updateData data =
    let
        ( newArea, newGlobal ) =
            areaCPchange data.area data.globalCP
    in
    { data | area = newArea, globalCP = newGlobal }



--change cp according to CR


changeCR2CP : Dict String CRdata -> Dict String PureCPdata -> Dict String Area -> ( Dict String Area, Dict String PureCPdata )
changeCR2CP cr global area =
    let
        arrayCR =
            Array.map (\( x, y ) -> y) (Array.fromList (Dict.toList cr))

        ( dontcare, ( updatedArea, updatedGlobal ) ) =
            for_outer 0 (Dict.size cr) eachChangeCR2CP ( arrayCR, ( global, area ) )
    in
    (  updatedGlobal,updatedArea)


eachChangeCR2CP : ( Dict String PureCPdata, Dict String Area ) -> Int -> Array CRdata -> ( Array CRdata, ( Dict String PureCPdata, Dict String Area ) )
eachChangeCR2CP ( global, area ) i cr =
    let
        certainCR =
            Maybe.withDefault initCRdata (Array.get i cr)

        certainArea =
            Maybe.withDefault initArea (Dict.get certainCR.name area)

        ( updatedArea, updatedGlobal ) =
            certainChangeCR2CP global certainArea certainCR
        updatedAllArea =
            Dict.update certainCR.name ((\x y->x) (Just updatedArea)) area
    in
    ( cr, ( updatedGlobal, updatedAllArea ) )


certainChangeCR2CP : Dict String PureCPdata -> Area -> CRdata -> ( Area, Dict String PureCPdata )
certainChangeCR2CP global area certainCR =
    let
        localCP =
            area.localCP

        effect =
            certainCR.effect

        ( newGlobal, newLocal ) =
            effectCP effect global localCP
    in
    ( { area | localCP = newLocal }, newGlobal )



--change cp according to area


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
    ( Array.set i (((\y x -> { x | localCP =  y }) local) newArea) a, newGlobal )



-- change all cp according to cp
-- changeCP_byCP : GameData -> GameData
-- changeCP_byCP oldData =
--     { oldData | globalCP = change_GlobalCP_byCP oldData.globalCP oldData.infoCP}
-- -- change global cp by global cp
-- change_GlobalCP_byCP :  Dict String PureCPdata -> Dict String CPdata -> Dict String PureCPdata
-- change_GlobalCP_byCP oldGlobalCP cpInfo =
--      Dict.fromList  ( updateCp_byoneCP (Dict.toList oldGlobalCP) Dict.toList cpInfo )
-- updateCp_byoneCP : String -> Float -> Dict String CPdata -> (String,Float)
-- updateCp_byoneCP name value =
--  Dict.values
-- change an area cp by
-- change all cp according to cr
--cr operation


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
