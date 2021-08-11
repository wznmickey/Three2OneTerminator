module Update exposing
    ( switchPause, checkHelp
    , updateData, moveCR
    , keyPress
    )

{-| This module gives the functions for updating data.


# State

@docs switchPause, checkHelp


# Data

@docs updateData, moveCR


# Key

@docs keyPress

-}

import Area
    exposing
        ( Area
        , initArea
        )
import Array exposing (Array)
import CPdata
    exposing
        ( CPdata
        , initCPdata
        )
import CPtype exposing (CPtype(..))
import CRdata
    exposing
        ( CRdata
        , initCRdata
        )
import Dict exposing (Dict)
import For exposing (for)
import GameData
    exposing
        ( GameData
        , getCPdataByName
        , getPureCPdataByName
        )
import GameInfo exposing (GameInfo)
import Msg
    exposing
        ( Element(..)
        , FileStatus(..)
        , KeyInfo(..)
        , Msg(..)
        , State(..)
        )
import PureCPdata
    exposing
        ( PureCPdata
        , initPureCPdata
        )


{-| This function receive `State` as the current state and return `Msg` as `ToState State` to indicate next state. Used when related to pause.
-}
switchPause : State -> Msg
switchPause state =
    if state == Pause then
        ToState
            Running

    else if state == Running then
        ToState
            Pause

    else
        ToState
            state


{-| This function receive `State` as the current state and return `Msg` as `ToState State` to indicate next state. Used when related to help.
-}
checkHelp : State -> Msg
checkHelp state =
    if state == Running then
        ToState
            Pause

    else
        ToState
            state



--change cp according to effect


effectCP : Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata -> ( Dict String PureCPdata, Dict String PureCPdata )
effectCP effect global local =
    ( dictEffectCP
        effect
        global
    , dictEffectCP
        effect
        local
    )


dictEffectCP : Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata
dictEffectCP effect before =
    Dict.map
        (getEffect
            effect
        )
        before


getEffect : Dict String PureCPdata -> String -> PureCPdata -> PureCPdata
getEffect effect key before =
    if before.name == key then
        valueEffectCP
            (getPureCPdataByName
                ( key
                , effect
                )
            )
            before

    else
        before


valueEffectCP : PureCPdata -> PureCPdata -> PureCPdata
valueEffectCP effect before =
    { before
        | data =
            before.data + effect.data
    }



--data update


{-| This function changes CP based on the inputted data.
-}
updateData : GameData -> GameData
updateData data =
    data
        |> updateDataArea
        |> updateDataCR
        |> updateDataCP


updateDataArea : GameData -> GameData
updateDataArea data =
    let
        ( newArea, newGlobal ) =
            areaCPchange
                data.area
                data.globalCP
    in
    { data
        | area =
            newArea
        , globalCP =
            newGlobal
    }


updateDataCR : GameData -> GameData
updateDataCR data =
    let
        ( newArea, newGlobal ) =
            changeCR2CP
                data.allCR
                data.globalCP
                data.area
    in
    { data
        | area =
            newArea
        , globalCP =
            newGlobal
    }


updateDataCP : GameData -> GameData
updateDataCP data =
    let
        ( newArea, newGlobal ) =
            changeCP2CP data.infoCP data.globalCP data.area
    in
    { data
        | area =
            newArea
        , globalCP =
            newGlobal
    }



--change cp according to CP


changeCP2CP : Dict String CPdata -> Dict String PureCPdata -> Dict String Area -> ( Dict String Area, Dict String PureCPdata )
changeCP2CP dict global area =
    let
        afterGlobal =
            changeGlobalCP2CP
                dict
                global
    in
    changeLocalCP2CP
        dict
        area
        afterGlobal


changeGlobalCP2CP : Dict String CPdata -> Dict String PureCPdata -> Dict String PureCPdata
changeGlobalCP2CP dict global =
    eachGlobalChangeCP2CP
        dict
        global
        global


changeLocalCP2CP : Dict String CPdata -> Dict String Area -> Dict String PureCPdata -> ( Dict String Area, Dict String PureCPdata )
changeLocalCP2CP dict area global =
    let
        afterGlobal =
            globalChangeCP2CP
                dict
                area
                global

        afterArea =
            Dict.fromList
                (List.map
                    (\x ->
                        ( x.name
                        , eachGlobalChangeCP2CP
                            dict
                            x.localCP
                            x.localCP
                        )
                    )
                    (Dict.values
                        area
                    )
                )
    in
    ( Dict.map
        ((\after name x ->
            { x
                | localCP =
                    Maybe.withDefault
                        x.localCP
                        (Dict.get
                            name
                            after
                        )
            }
         )
            afterArea
        )
        area
    , afterGlobal
    )


globalChangeCP2CP : Dict String CPdata -> Dict String Area -> Dict String PureCPdata -> Dict String PureCPdata
globalChangeCP2CP dict area global =
    Tuple.first
        (for
            0
            (Dict.size
                area
                - 1
            )
            (getCertainArea
                dict
            )
            ( global
            , Array.fromList
                (Dict.values
                    area
                )
            )
        )


getCertainArea : Dict String CPdata -> Int -> ( Dict String PureCPdata, Array Area ) -> ( Dict String PureCPdata, Array Area )
getCertainArea dict i ( global, area ) =
    ( eachGlobalChangeCP2CP
        dict
        (Maybe.withDefault
            initArea
            (Array.get
                i
                area
            )
        ).localCP
        global
    , area
    )


eachGlobalChangeCP2CP : Dict String CPdata -> Dict String PureCPdata -> Dict String PureCPdata -> Dict String PureCPdata
eachGlobalChangeCP2CP dict local global =
    let
        effect =
            Array.fromList
                (Dict.values
                    (Dict.map
                        (\name x ->
                            eachGlobalCertainCPchangeCP2CP
                                dict
                                local
                                name
                        )
                        local
                    )
                )
    in
    Tuple.first
        (for 0
            (Array.length
                effect
                - 1
            )
            eachEffectCP
            ( global
            , effect
            )
        )


eachEffectCP : Int -> ( Dict String PureCPdata, Array (Dict String PureCPdata) ) -> ( Dict String PureCPdata, Array (Dict String PureCPdata) )
eachEffectCP i ( global, effect ) =
    ( dictEffectCP
        (Maybe.withDefault
            Dict.empty
            (Array.get
                i
                effect
            )
        )
        global
    , effect
    )


eachGlobalCertainCPchangeCP2CP : Dict String CPdata -> Dict String PureCPdata -> String -> Dict String PureCPdata
eachGlobalCertainCPchangeCP2CP dict local nameCP =
    Dict.fromList
        (List.map (\x -> ( x.name, x ))
            (timesCPdata
                (Dict.values
                    (Maybe.withDefault
                        initCPdata
                        (Dict.get
                            nameCP
                            dict
                        )
                    ).effect
                )
                (Maybe.withDefault
                    initPureCPdata
                    (Dict.get
                        nameCP
                        local
                    )
                )
            )
        )


timesCPdata : List PureCPdata -> PureCPdata -> List PureCPdata
timesCPdata a b =
    List.map
        (\x ->
            { x
                | data =
                    x.data
                        * b.data
            }
        )
        a



--change cp according to CR


changeCR2CP : Dict String CRdata -> Dict String PureCPdata -> Dict String Area -> ( Dict String Area, Dict String PureCPdata )
changeCR2CP cr global area =
    let
        arrayCR =
            Array.map
                (\( x, y ) ->
                    y
                )
                (Array.fromList
                    (Dict.toList
                        cr
                    )
                )

        ( dontcare, ( updatedArea, updatedGlobal ) ) =
            for
                0
                (Dict.size
                    cr
                    - 1
                )
                eachChangeCR2CP
                ( arrayCR
                , ( global
                  , area
                  )
                )
    in
    ( updatedGlobal
    , updatedArea
    )


eachChangeCR2CP : Int -> ( Array CRdata, ( Dict String PureCPdata, Dict String Area ) ) -> ( Array CRdata, ( Dict String PureCPdata, Dict String Area ) )
eachChangeCR2CP i ( cr, ( global, area ) ) =
    let
        certainCR =
            Maybe.withDefault
                initCRdata
                (Array.get
                    i
                    cr
                )

        certainArea =
            Maybe.withDefault
                initArea
                (Dict.get (Debug.log "1" certainCR.location) area)

        ( updatedArea, updatedGlobal ) =
            certainChangeCR2CP
                global
                certainArea
                certainCR

        updatedAllArea =
            Dict.update
                certainCR.location
                ((\x y ->
                    x
                 )
                    (Just
                        updatedArea
                    )
                )
                area
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
            effectCP effect
                global
                localCP
    in
    ( { area
        | localCP =
            newLocal
      }
    , newGlobal
    )



--change cp according to area


areaCPchange : Dict String Area -> Dict String PureCPdata -> ( Dict String Area, Dict String PureCPdata )
areaCPchange area global =
    let
        pureArea =
            Array.map
                (\( x, y ) ->
                    y
                )
                (Array.fromList
                    (Dict.toList
                        area
                    )
                )

        ( afterAreaArray, afterGlobal ) =
            for
                0
                (Dict.size area - 1)
                eachAreaCPchange
                ( pureArea
                , global
                )
    in
    ( Dict.fromList
        (List.map
            (\x ->
                ( x.name
                , x
                )
            )
            (Array.toList
                afterAreaArray
            )
        )
    , afterGlobal
    )


eachAreaCPchange : Int -> ( Array Area, Dict String PureCPdata ) -> ( Array Area, Dict String PureCPdata )
eachAreaCPchange i ( a, global ) =
    let
        newArea =
            Maybe.withDefault
                initArea
                (Array.get
                    i
                    a
                )

        ( newGlobal, local ) =
            effectCP
                newArea.effect
                global
                newArea.localCP
    in
    ( Array.set
        i
        ((\y x ->
            { x
                | localCP =
                    y
            }
         )
            local
            newArea
        )
        a
    , newGlobal
    )


{-| This function use `Dict String CRdata` as the CR data and 2 `String` (1st as from, 2st as to) to move CR and return the whole CR data.
-}
moveCR : Dict String CRdata -> String -> String -> Dict String CRdata
moveCR before from to =
    Dict.update
        from
        (setCRlocation
            to
        )
        before


setCRlocation : String -> Maybe CRdata -> Maybe CRdata
setCRlocation to from =
    case from of
        Just fromArea ->
            Maybe.Just
                { fromArea
                    | location =
                        to
                }

        _ ->
            from


{-| This function transfer `Int` as keycode to meaningful `Msg` of which key is pressed.
-}
keyPress : Int -> Msg
keyPress input =
    let
        i =
            Debug.log "Receive Key"
                input
    in
    case i of
        32 ->
            KeyPress
                Space

        82 ->
            KeyPress
                R

        72 ->
            KeyPress
                H

        _ ->
            KeyPress
                NotCare
