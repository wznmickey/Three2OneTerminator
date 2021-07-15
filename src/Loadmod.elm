module LoadMod exposing (loadMod)
import GameData exposing(..)
import Json exposing(Decoder)


dCP : Decoder CPdata
dCP = map4 CPdata
    field("name" string)
    field("initValue" float)
    field("type" string)
    field("effect" List (dPureCP))

dPureCP :Decoder PureCPdata
dPureCP = map2 PureCPdata 
    field("name" string)
    field("initValue" float)


dCR : Decoder CRdata
dCR = map3 CRdata
    field("name" string)
    field("location" int)
    field("effect" List (dPureCP))

darea : Decoder Area
darea = map3 Area
    field("name" string)
    field("location" int)
    field("effect" List (dPureCP))
