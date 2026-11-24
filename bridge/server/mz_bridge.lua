local bridge = {}

function bridge.citizen(cid)
    local character = exports.mz_sd_bridge:GetCharacter(cid)
    if not character then return nil end
    local info = type(character.charinfo) == 'table' and character.charinfo or {}
    local first, last = tostring(info.firstname or ''), tostring(info.lastname or '')
    local name = (first .. ' ' .. last):gsub('^%s+', ''):gsub('%s+$', '')
    return {
        citizenid = cid, name = name ~= '' and name or cid, firstname = first, lastname = last,
        dob = tostring(info.birthdate or ''), sex = tostring(info.gender or ''),
        phone = tostring(info.phone or ''), nationality = tostring(info.nationality or ''),
        job = '', jobGrade = 0, licences = {}, fingerprint = '', bloodtype = '', callsign = ''
    }
end

local function percent(value, scale)
    local number = tonumber(value)
    if not number then return 100 end
    return math.max(0, math.min(100, number / scale))
end

function bridge.vehicles(source)
    local rows = exports.mz_sd_bridge:GetOwnedVehicles(source)
    if type(rows) ~= 'table' then return {} end
    local out = {}
    for _, row in ipairs(rows) do
        local state = tostring(row.state or ''):lower()
        local status = state == 'stored' and 'stored' or (state == 'out' and 'out' or 'impound')
        local garage = tostring(row.garage or '')
        if garage == '' then garage = 'Garage' end
        out[#out + 1] = {
            id = tostring(row.id or row.plate or ''), model = tostring(row.model or ''),
            plate = tostring(row.plate or ''), garage = garage, status = status, locked = status ~= 'out',
            location = status == 'impound' and 'Impound' or (status == 'stored' and garage or 'Out on the street'),
            fuel = percent(row.fuel, 1), engine = percent(row.engine, 10), body = percent(row.body, 10)
        }
    end
    return out
end

return bridge
