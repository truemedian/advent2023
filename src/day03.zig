const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

fn isSymbol(c: u8) bool {
    return !std.ascii.isDigit(c) and c != '.';
}

const Number = struct {
    value: usize,

    row: usize,
    col: usize,
    length: u8,
};

const Symbol = struct {
    row: usize,
    col: usize,
    char: u8,

    pub fn isInRectangle(self: Symbol, x: usize, y: usize, width: usize) bool {
        const left = if (x == 0) x else x - 1;
        const right = x + width;

        const top = if (y == 0) y else y - 1;
        const bottom = y + 1;

        return self.col >= left and self.col <= right and self.row >= top and self.row <= bottom;
    }
};

pub fn main() !void {
    @setEvalBranchQuota(100000);

    var timer = std.time.Timer.start() catch unreachable;

    var numbers = try std.ArrayList(Number).initCapacity(gpa, 1000);
    var symbols = try std.ArrayList(Symbol).initCapacity(gpa, 1000);

    var lines_it = tokenizeSca(u8, data, '\n');
    var row: usize = 0;
    while (lines_it.next()) |line| : (row += 1) {
        var num: usize = 0;
        var length: u8 = 0;

        for (line, 0..) |c, col| {
            if (std.ascii.isDigit(c)) {
                num *= 10;
                num += c - '0';
                length += 1;
            } else if (num != 0) {
                try numbers.append(Number{ .value = num, .row = row, .col = col - length, .length = length });
                num = 0;
                length = 0;
            }

            if (isSymbol(c)) {
                try symbols.append(Symbol{ .row = row, .col = col, .char = c });
            }
        }

        if (num != 0) {
            try numbers.append(Number{ .value = num, .row = row, .col = line.len - length, .length = length });
        }
    }

    var sum1: usize = 0;
    var sum2: usize = 0;

    var arena = std.heap.ArenaAllocator.init(gpa);
    defer arena.deinit();

    for (symbols.items) |s| {
        if (s.char == '*') {
            var candidates = std.ArrayList(Number).init(arena.allocator());
            defer _ = arena.reset(.retain_capacity);

            for (numbers.items) |n| {
                if (s.isInRectangle(n.col, n.row, n.length)) {
                    try candidates.append(n);
                    sum1 += n.value;
                }
            }

            if (candidates.items.len == 2) {
                sum2 += candidates.items[0].value * candidates.items[1].value;
            }
        } else {
            for (numbers.items) |n| {
                if (s.isInRectangle(n.col, n.row, n.length)) {
                    sum1 += n.value;
                }
            }
        }
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
