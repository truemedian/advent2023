const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

const map = .{
    .{ "one", 1 },
    .{ "two", 2 },
    .{ "three", 3 },
    .{ "four", 4 },
    .{ "five", 5 },
    .{ "six", 6 },
    .{ "seven", 7 },
    .{ "eight", 8 },
    .{ "nine", 9 },
};

fn findForward1(line: []const u8) u8 {
    var i: u16 = 0;
    while (i < line.len) {
        if (line[i] >= '0' and line[i] <= '9') {
            return line[i] - '0';
        }

        i += 1;
    }

    unreachable;
}

fn findReverse1(line: []const u8) u8 {
    var i: u16 = @as(u16, @intCast(line.len)) - 1;
    while (i >= 0) {
        if (line[i] >= '0' and line[i] <= '9') {
            return line[i] - '0';
        }

        i -= 1;
    }

    unreachable;
}

fn findForward2(line: []const u8) u8 {
    var first_digit_index: u16 = 0;
    while (first_digit_index < line.len) {
        if (line[first_digit_index] >= '0' and line[first_digit_index] <= '9') {
            break;
        }

        first_digit_index += 1;
    }

    var i: u16 = 0;
    while (i < first_digit_index) {
        inline for (map) |dat| {
            const key, const value = dat;

            if (std.mem.startsWith(u8, line[i..], key)) {
                return value;
            }
        }

        i += 1;
    }

    return line[first_digit_index] - '0';
}

fn findReverse2(line: []const u8) u8 {
    var last_digit_index: u16 = @as(u16, @intCast(line.len)) - 1;
    while (last_digit_index >= 0) {
        if (line[last_digit_index] >= '0' and line[last_digit_index] <= '9') {
            break;
        }

        last_digit_index -= 1;
    }

    if (line.len < 3) {
        return line[last_digit_index] - '0';
    }

    var i: u16 = @as(u16, @intCast(line.len)) - 3;
    while (i > last_digit_index) {
        inline for (map) |dat| {
            const key, const value = dat;

            if (std.mem.startsWith(u8, line[i..], key)) {
                return value;
            }
        }

        i -= 1;
    }

    return line[last_digit_index] - '0';
}

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var line_it = tokenizeSca(u8, data, '\n');

    var sum1: u64 = 0;
    var sum2: u64 = 0;

    while (line_it.next()) |line| {
        sum1 += findForward1(line) * 10 + findReverse1(line);
        sum2 += findForward2(line) * 10 + findReverse2(line);
    }

    print("Taken: {}\n", .{timer.read()});
    print("Part 1: {}\n", .{sum1});
    print("Part 2: {}\n", .{sum2});
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
const eql = std.mem.eql;

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
