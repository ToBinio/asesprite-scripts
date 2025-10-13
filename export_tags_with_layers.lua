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

    for i, layer in ipairs(spr.layers) do
        if layer.name:sub(1, 1) ~= '_' then
            goto continue
        end

        for i, tag in ipairs(spr.tags) do
            local fn = path
            if dlg.include_filename then
                fn = fn .. title .. dlg.separator
            end
            fn = fn .. tag.name .. dlg.separator .. layer.name:sub(2)

            table.insert(msg, fn .. '.png')
        end
        ::continue::
    end

    if app.alert { title = "Export Sprite Sheets", text = msg,
            buttons = { "&Yes", "&No" } } ~= 1 then
        return
    end

    for i, layer in ipairs(spr.layers) do
        if layer.name:sub(1, 1) ~= '_' then
            goto continue
        end

        for i, layer in ipairs(spr.layers) do
            if layer.name:sub(1, 1) == '_' then
                layer.isVisible = false
            end
        end

        layer.isVisible = true

        for i, tag in ipairs(spr.tags) do
            local fn = path .. '/'
            if dlg.include_filename then
                fn = fn .. title .. dlg.separator
            end
            fn = fn .. tag.name .. dlg.separator .. layer.name:sub(2)

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
        ::continue::
    end
end
