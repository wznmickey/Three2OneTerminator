module ToSaving exposing (save)

{-| This module gives function to transfer from `GameData` to file to download.

# Save

@docs save
-}

import File.Download as Download exposing (string)
import GameData exposing (GameData, encodeGameData)
import Json.Encode exposing (encode)


{-| This function can transfer `GameData` into `String` in Json.
-}
saveString : GameData -> String
saveString data =
    Json.Encode.encode
        4
        (encodeGameData data)


{-| This function can transfer `GameData` into `Cmd msg` request to download the saving.
-}
save : GameData -> Cmd msg
save data =
    Download.string
        "download.json"
        "text/json"
        (saveString data)
