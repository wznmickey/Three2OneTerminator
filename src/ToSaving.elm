module ToSaving exposing (..)

import File.Download as Download
import GameData exposing (..)
import Json.Encode exposing (..)


saveString : GameData -> String
saveString data =
    Json.Encode.encode 4 (encodeGameData data)


save : GameData -> Cmd msg
save data =
    Download.string "download.json" "text/json" (saveString data)
