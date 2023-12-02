const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var lines_it = tokenizeSca(u8, data, '\n');

    var sum1: u32 = 0;
    var sum2: u32 = 0;

    while (lines_it.next()) |line| {
        var id_split = splitSca(u8, line, ':');
        const game_id_str = id_split.first()[5..];
        const game_id = parseInt(u32, game_id_str, 10) catch unreachable;

        const game_data = id_split.next() orelse unreachable;

        var valid1 = true;
        var red: u32 = 0;
        var green: u32 = 0;
        var blue: u32 = 0;

        var game_data_split = splitSca(u8, game_data, ';');
        while (game_data_split.next()) |row| {
            var row_split = splitSca(u8, row, ',');
            while (row_split.next()) |col| {
                var col_split = tokenizeSca(u8, col, ' ');
                const num = parseInt(u32, col_split.next() orelse unreachable, 10) catch unreachable;
                const name = col_split.next() orelse unreachable;

                if (std.mem.eql(u8, name, "red")) {
                    if (num > 12) valid1 = false;

                    red = @max(red, num);
                } else if (std.mem.eql(u8, name, "green")) {
                    if (num > 13) valid1 = false;

                    green = @max(green, num);
                } else if (std.mem.eql(u8, name, "blue")) {
                    if (num > 14) valid1 = false;

                    blue = @max(blue, num);
                }
            }
        }
        
        if (valid1) {
            sum1 += game_id;
        }

        sum2 += red * green * blue;
    }

    print("Taken: {d}\n", .{timer.read()});
    print("Part 1: {d}\n", .{sum1});
    print("Part 2: {d}\n", .{sum2});
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
