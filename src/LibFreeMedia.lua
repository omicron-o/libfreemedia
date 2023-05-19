local lib = LibStub:NewLibrary("LibFreeMedia", 100)
if not lib then
    return
end

local DEFAULT_MEDIA_TABLE = {
    background = {
        ["Blizzard Dialog Background"]          = "Interfacee\\DialogFrame\\UI-DialogBox-Background",
        ["Blizzard Dialog Background Dark"]     = "Interfacee\\DialogFrame\\UI-DialogBox-Background-Dark",
        ["Blizzard Dialog Background Gold"]     = "Interfacee\\DialogFrame\\UI-DialogBox-Gold-Background",
        ["Blizzard Low Health"]                 = "Interfacee\\FullScreenTextures\\LowHealth",
        ["Blizzard Marble"]                     = "Interfacee\\FrameGeneral\\UI-Background-Marble",
        ["Blizzard Out of Control"]             = "Interfacee\\FullScreenTextures\\OutOfControl",
        ["Blizzard Parchment"]                  = "Interfacee\\AchievementFrame\\UI-Achievement-Parchment-Horizontal",
        ["Blizzard Parchment 2"]                = "Interfacee\\AchievementFrame\\UI-GuildAchievement-Parchment-Horizontal",
        ["Blizzard Rock"]                       = "Interfacee\\FrameGeneral\\UI-Background-Rock",
        ["Blizzard Tabard Background"]          = "Interfacee\\TabardFrame\\TabardFrameBackground",
        ["Blizzard Tooltip"]                    = "Interfacee\\Tooltips\\UI-Tooltip-Background",
        ["Solid"]                               = "Interfacee\\Buttons\\WHITE8X8",
    },
    font = {
        ["Arial Narrow"]                        = "Fonts\\ARIALN.TTF",
        ["Friz Quadrata TT"]                    = "Fonts\\FRIZQT__.TTF",
        ["Morpheus"]                            = "Fonts\\MORPHEUS.TTF",
        ["Skurri"]                              = "Fonts\\SKURRI.TTF",
    },
    border = {
        ["None"]                                = "Interface\\None",
        ["Achievement Wood"]                    = "Interface\\AchievementFrame\\UI-Achievement-WoodBorder",
        ["Chat Bubble"]                         = "Interface\\Tooltips\\ChatBubble-Backdrop",
        ["Blizzard Dialog"]                     = "Interface\\DialogFrame\\UI-DialogBox-Border",
        ["Blizzard Dialog Gold"]                = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        ["Blizzard Party"]                      = "Interface\\CHARACTERFRAME\\UI-Party-Border",
        ["Blizzard Tooltip"]                    = "Interface\\Tooltips\\UI-Tooltip-Border",
    },
    statusbar = {
        ["Blizzard"]                            = "Interface\\TargetingFrame\\UI-StatusBar",
        ["Blizzard Character Skills Bar"]       = "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar",
    },
    sound = {
        ["None"]                                = "Interface\\Quiet.ogg",
    }
}

local function MakeDefaultList()
    local lists = {}
    for kind, media in pairs(DEFAULT_MEDIA_TABLE) do
        local list = {}
        lists[kind] = list
        for identifier, _ in pairs(media) do
            table.insert(list, identifier)
        end
        table.sort(list)
    end
    return lists
end

local DEFAULT_MEDIA_LIST = MakeDefaultList()


-- Interopability with a proprietary alternative is contained in this block
do
    local libsm = LibStub:GetLibrary("LibSharedMedia-3.0", true)
    if not libsm then
        -- Register an empty library with just the data tables
        libsm = LibStub:NewLibrary("LibSharedMedia-3.0", 0)
        libsm.MediaTable = DEFAULT_MEDIA_TABLE
        libsm.MediaList = DEFAULT_MEDIA_LIST
    end

    ---@type table<string, table<string, any>> 
    lib.media = libsm.MediaTable
    ---@type table<string, string[]> 
    lib.mediaList = libsm.MediaList
end


---@param kind string The kind of media you are registering. E.g. "font" or "background"
---@param identifier string Named identifier for the media
---@param data any
---@return boolean
-- Does not sort the media list after it added a file
local function RegisterOne(kind, identifier, data)
    local media = lib.media[kind]
    local mediaList = lib.mediaList[kind]
    if not media then
        media = {}
        mediaList = {}
        lib.media[kind] = media
        lib.mediaList[kind] = mediaList
    end
    if media[identifier] then
        return false
    end

    media[identifier] = data
    table.insert(lib.mediaList[kind], identifier)
    return true
end


---@param kind string The kind of media you are registering. E.g. "font" or "background"
---@param identifier string Named identifier for the media
---@param data any
---@return boolean
function lib:Register(kind, identifier, data)
    local retval = RegisterOne(kind, identifier, data)
    if retval then
        table.sort(self.mediaList[kind])
    end
    return retval
end


---Return the media that matches the given kind and identifier. May return nil if the media does not exist.
---@param kind string The kind of media you are requesting. E.g. "font" or "background"
---@param identifier string Named identifier for the media
---@return any | nil
function lib:Get(kind, identifier)
    local media = self.media[kind]
    if media then
        return media[identifier]
    end
end


---Return a sorted list of identifiers. May return nil if there is no media of that kind.
---@param kind string The kind of media you are requesting. E.g. "font" or "background"
---@return string[] | nil
function lib:GetList(kind)
    return self.mediaList[kind]
end


---Return a table with identifier keys and media data values
---@param kind string The kind of media you are requesting. E.g. "font" or "background"
---@return table<string,any> | nil
function lib:GetTable(kind)
    return self.media[kind]
end
