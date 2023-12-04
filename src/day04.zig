const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

const Card = struct {
    score: u32,
    copies: u32 = 1,
};

pub fn main() !void {
    @setEvalBranchQuota(100000);

    var timer = std.time.Timer.start() catch unreachable;
    var lines_it = tokenizeSca(u8, data, '\n');

    var card_num: u32 = 0;
    var cards: [std.mem.count(u8, data, "\n")]Card = undefined;

    var sum1: u32 = 0;
    while (lines_it.next()) |line| : (card_num += 1) {
        var split1 = splitSca(u8, line, ':');
        const game = split1.first();
        _ = game;
        const round = split1.next() orelse unreachable;

        var split2 = splitSca(u8, round, '|');
        const winning = split2.first();
        const numbers = split2.next() orelse unreachable;

        var winners: [100]bool = [_]bool{false} ** 100;
        var split3 = tokenizeSca(u8, winning, ' ');
        while (split3.next()) |number| {
            const num = parseInt(u32, number, 10) catch unreachable;
            winners[num] = true;
        }

        var score: u32 = 0;

        var numbers_it = tokenizeSca(u8, numbers, ' ');
        while (numbers_it.next()) |number| {
            const num = parseInt(u32, number, 10) catch unreachable;
            if (winners[num]) {
                score += 1;
            }
        }

        cards[card_num] = .{ .score = score };

        if (score > 0)
            sum1 += std.math.pow(u32, 2, score - 1);
    }

    var sum2: u32 = 0;

    for (&cards, 0..) |*card, i| {
        var j: u32 = 1;
        while (j <= card.score) : (j += 1) {
            cards[i + j].copies += card.copies;
        }

        sum2 += card.copies;
    }

    print("Taken: {}\n", .{ timer.read()});
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
