local dlg = Dialog()
    :entry { id = "separator", label = "Separator", text = "_" }
    :check { id = "include_filename", label = "Include Filename", selected = true }
    :button { id = "confirm", text = "Confirm", focus = true }
    :button { id = "cancel", text = "Cancel" }
    :show()
    .data

if dlg.confirm then
    local spr = app.sprite
    if not spr then return print('No active sprite') end

    local path, title = spr.filename:match("^(.+[/\\])(.-).([^.]*)$")
    local msg = { "Do you want to export/overwrite the following files?" }

    for i, tag in ipairs(spr.tags) do
        local fn = path
        if dlg.include_filename then
            fn = fn .. title .. dlg.separator
        end
        fn = fn .. tag.name
        table.insert(msg, '-' .. fn .. '.png')
    end

    if app.alert { title = "Export Sprite Sheets", text = msg,
            buttons = { "&Yes", "&No" } } ~= 1 then
        return
    end

    for i, tag in ipairs(spr.tags) do
        local fn = path .. '/'
        if dlg.include_filename then
            fn = fn .. title .. dlg.separator
        end
        fn = fn .. tag.name
        app.command.ExportSpriteSheet {
            ui = false,
            type = SpriteSheetType.HORIZONTAL,
            textureFilename = fn .. '.png',
            dataFormat = SpriteSheetDataFormat.JSON_ARRAY,
            tag = tag.name,
            listLayers = false,
            listTags = false,
            listSlices = false,
        }
    end
end
