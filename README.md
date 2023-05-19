# LibFreeMedia

LibFreeMedia is a small library to facilitate the sharing of media resources
between different World of Warcraft addons. It was developed to provide a free
software alternative to the proprietary LibSharedMedia. 

Sharing media works best for both users as well as addon developers if everyone
can access the shared media pool equally, and this includes authors that want
to release their addons as free software. Therefore this library interoperates
with LibShareMedia. Media registered using one library can be retrieved with
the other and vice versa. See [Interopability](#interopability) for the
limitations of this interopability.

# API

LibFreeMedia registers as a library using LibStub. Use LibStub to acquire a
handle to the libary:
```lua
local lib = LibStub:GetLibrary("LibFreeMedia")
```

## Registering Media

```lua
lib:Register(kind, identifier, data)
```

### Arguments

 * *kind* (string): the kind of media you are registering. Some examples are
   "font", "background" or "statusbar"
 * *identifier* (string): The (unique among its kind) name to identify the
   media. Users will often see this name, so use a descriptive name.
 * *data* (any): The data that represents the media. After it is registered
    the library takes ownership of the data and it _must not_ be changed.

### Return value

The return value is a boolean indicating whether the media was registered
successfully. Failure may happen for a number of reasons, including registering
invalid data or the identifier already has registered media for that kind.

### Example

```lua
local libfm = LibStub:GetLibrary("LibFreeMedia")
libfm:Register("font", "Roboto Regular", "Interface\\AddOn\\MyAddon\\Fonts\\Roboto Regular.ttf")
libfm:Register("font", "Roboto Bold", "Interface\\AddOn\\MyAddon\\Fonts\\Roboto Bold.ttf")

if not libfm:Register("font", "Roboto Bold", "Interface\\AddOn\\MyAddon\\Fonts\\Roboto Bold.ttf") then
    error("The media registration failed")
end
```

## Getting individual media

```lua
lib:Get(kind, identifier)
```

### Arguments

 * *kind* (string): the kind of media you want to retrieve. Some examples are
   "font", "background" or "statusbar".
 * *identifier* (string): The name of the media you want to retrieve.

### Return value

If the media exists, its data is returned. The type of this data depends on the
kind of media. LibFreeMedia retains ownership of this data and you _must not_
alter it in place.

If the media does not exist the function will return `nil`.

### Examples

```lua
local libfm = LibStub:GetLibrary("LibFreeMedia")

local robotoRegular = libfm:Get("font", "Roboto Regular")
if robotoRegular then
    print("Successfully got the font location:", robotoRegular)
else
    print("The 'Roboto Regular' font could not be retrieved")
end
```

## Getting a list of media identifiers

```lua
lib:GetList(kind)
```

### Arguments

 * *kind* (string): the kind of media you want to get a list of. Some examples
   are "font", "background" or "statusbar".

### Return value

If there is media registered for the requested kind it will be returned as a
sorted sequence table of media identifiers for the requested kind. If there is
no media of the requested kind then this function will return either `nil` or
an empty table.

LibSharedMedia retains ownership of the returned tables and they should not be
altered in place. These tables may be reused by LibSharedMedia and and media
that is registered in the future could be added to these tables but this behavior
_should not_ be relied on. If you require an up to date list, call the
library to receive one. If you require a snapshot to remain static, make a deep
copy.

### Examples

```lua
local libfm = LibStub:GetLibrary("LibFreeMedia")

local fonts = libfm:GetList("font")
if fonts == nil or #fonts == 0 then
    print("No registered fonts found")
else
    print("Registered fonts", table.concat(fonts, ", "))
end
```

## Getting a table of media data

```lua
lib:GetTable(kind)
```

### Arguments

 * *kind* (string): the kind of media you want to get a list of. Some examples
   are "font", "background" or "statusbar".

### Return value

If there is media registered for the requested kind it will be returned as a
table with identifier:data pairs. If there is no media of the requested kind
then this function will return either `nil` or an empty table.

LibSharedMedia retains ownership of the returned tables and they should not be
altered in place. These tables may be reused by LibSharedMedia and and media
that is registered in the future could be added to these tables but this behavior
_should not_ be relied on. If you require an up to date list, call the
library to receive one. If you require a snapshot to remain static, make a deep
copy.

### Examples

```lua
local libfm = LibStub:GetLibrary("LibFreeMedia")

local fonts = libfm:GetTable("font") or {}

for identifier, data in pairs(fonts) do
    print(identifier, data)
end
```

# Embedding LibFreeMedia 

The recommended way to include LibFreeMedia in your addon is embedding it and
getting a handle using LibStub. To do this you To do this simply grab one of
the embed archives from the
[releases](https://gitlab.com/omicron-oss/wow/libfreemedia/-/releases) and
extract these files in your addon. Do the same with
[LibStub](https://www.wowace.com/projects/libstub). This will get you a
directory tree similar to the following:

```
YourAddon/libs/LibFreeMedia/LibFreeMedia.lua
YourAddon/libs/LibStub/LibStub.lua
YourAddon/YourAddon.toc
...
```

Simply add `LibStub.lua` and `LibFreeMedia.lua` as the first few files in your
`YourAddon.toc` as follows:

```
## Interface: 100100
## Title: YourAddon
## Version: 4.20.69

# List LibStub and then LibFreeMedia
libs/LibStub/LibStub.lua
libs/LibStub/LibFreeMedia.lua

# List all your addon files as desired
```

# Interopability

Since it is in the interested of both users and developers to not create
additional pools for shared media, LibFreeMedia attempts to interoperate
seamlessly with LibSharedMedia. However, there is no 100% parity between
LibFreeMedia and LibSharedMedia. This section will list all the areas where
LibFreeMedia differs from LibSharedMedia.

LibFreeMedia does not support making callbacks on media registration. Any addon
that relies on these callbacks in LibSharedMedia will currently not receive
notifications when media is registered using LibFreeMedia. This is likely
temporary, see issue #1.

LibFreeMedia does not support default return values for missing media, nor does
it allow you to register a particular piece of media as the default for a
specific kind.

LibFreeMedia does not support language masks for font registration. This is not
likely to change.

LibFreeMedia does not attempt to be a drop-in replacement for LibSharedMedia.
The API behaves slightly different. If there is demand for a drop-in
replacement then this could change.
