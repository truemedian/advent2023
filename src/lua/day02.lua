local lpeg = require 'lpeg'

local P, R, S, V = lpeg.P, lpeg.R, lpeg.S, lpeg.V
local C, Cc, Cf, Cg, Ct = lpeg.C, lpeg.Cc, lpeg.Cf, lpeg.Cg, lpeg.Ct

local red = P 'red'
local green = P 'green'
local blue = P 'blue'

local function teswar(t, v) return rawset(t, v[2], v[1]) end

local function validate1(t)
    if t.red and t.red > 12 then
        t.valid = false
    elseif t.green and t.green > 13 then
        t.valid = false
    elseif t.blue and t.blue > 14 then
        t.valid = false
    else
        t.valid = true
    end

    return t
end

local function validate2(t)
    t.valid = true
    for i = 1, #t do
        if not t[i].valid then t.valid = false end

        t.red = math.max(t.red or 0, t[i].red or 0)
        t.green = math.max(t.green or 0, t[i].green or 0)
        t.blue = math.max(t.blue or 0, t[i].blue or 0)
    end

    return t
end

local number = R '09' ^ 1 / tonumber
local cube = Ct(number * P ' ' * C(red + green + blue))
local round = Cf(Ct '' * cube * (P ', ' * cube) ^ 0, teswar) / validate1
local game = Ct(round * (P '; ' * round) ^ 0) / validate2
local solution = Ct(Ct(P 'Game ' * Cg(number, 'id') * P ': ' * game * P '\n') ^ 1)

local function day1(t)
    local sum = 0
    for i = 1, #t do
        if t[i][1].valid then sum = sum + t[i].id end
    end

    return sum
end

local function day2(t)
    local sum = 0

    for i = 1, #t do
        sum = sum + t[i][1].red * t[i][1].green * t[i][1].blue
    end

    return sum
end

local input = [[]]

print('Part 1:', (solution / day1):match(input))
print('Part 2:', (solution / day2):match(input))