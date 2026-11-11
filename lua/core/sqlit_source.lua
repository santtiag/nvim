-- Fuente de blink.cmp con el esquema que sqlit exporta al abrir una query
-- con <space>o: tablas, vistas, procedimientos y columnas. sqlit deja la ruta
-- del JSON en $SQLIT_SCHEMA_FILE; fuera de sqlit la fuente queda desactivada.
local source = {}

function source.new()
    return setmetatable({}, { __index = source })
end

function source:enabled()
    return vim.env.SQLIT_SCHEMA_FILE ~= nil
end

local function load_items()
    local ok, schema = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(vim.env.SQLIT_SCHEMA_FILE), '\n'))
    end)
    if not ok or type(schema) ~= 'table' then
        return {}
    end

    local kinds = require('blink.cmp.types').CompletionItemKind
    local items, seen = {}, {}
    local function add(label, kind, detail)
        -- sqlit guarda las columnas bajo el nombre de tabla en dos variantes
        -- de mayúsculas; se deduplica sin distinguirlas.
        local key = label .. '\0' .. detail:lower()
        if not seen[key] then
            seen[key] = true
            items[#items + 1] = { label = label, kind = kind, labelDetails = { description = detail } }
        end
    end

    for _, name in ipairs(schema.tables or {}) do add(name, kinds.Class, 'table') end
    for _, name in ipairs(schema.views or {}) do add(name, kinds.Interface, 'view') end
    for _, name in ipairs(schema.procedures or {}) do add(name, kinds.Function, 'procedure') end
    for tbl, columns in pairs(schema.columns or {}) do
        for _, column in ipairs(columns) do add(column, kinds.Field, tbl) end
    end
    return items
end

function source:get_completions(_, callback)
    self.items = self.items or load_items()
    callback({ items = self.items, is_incomplete_forward = false, is_incomplete_backward = false })
end

return source
