const std = @import("std");

const WORD = "XMAS";
fn search1(nextIndexToFind: usize, direction: [2]isize, iConst: isize, jConst: isize, map: [][]u8) !u32 {
    var result: u32 = 0;

    if (map[@intCast(iConst)][@intCast(jConst)] == WORD[nextIndexToFind]) {
        if (WORD[nextIndexToFind] == 'S') {
            return 1;
        }

        const i = iConst + direction[0];
        const j = jConst + direction[1];
        if (i >= 0 and i < map.len and j >= 0 and j < map[@intCast(i)].len) {
            result += try search1(nextIndexToFind + 1, direction, i, j, map);
        }
    }

    return result;
}

pub fn day4() !void {
    var map = std.ArrayList([]u8).init(std.heap.page_allocator);

    const file = try std.fs.cwd().openFile("./src/day4/input.txt", .{});
    defer file.close();

    while(try file.reader().readUntilDelimiterOrEofAlloc(std.heap.page_allocator, '\n', std.math.maxInt(usize))) |line| {
        try map.append(line);
    }

    var result1: u32 = 0;
    var result2: u32 = 0;

    const directions: [8][2]isize = .{.{0,1},.{1,1},.{1,0},.{1,-1},.{0,-1},.{-1,-1},.{-1,0},.{-1,1}};

    var i: isize = 0;
    while (i < map.items.len) {
        var j: isize = 0;
        while (j < map.items[@intCast(i)].len) {
            for (directions) |direction| {
                result1 += try search1(0, direction, i, j, map.items);
            }

            if (i > 0 and i < map.items.len - 1 and j > 0 and j < map.items[@intCast(i)].len - 1) {
                const diagonal1: [3]u8 = .{
                    map.items[@intCast(i - 1)][@intCast(j - 1)],
                    map.items[@intCast(i)][@intCast(j)],
                    map.items[@intCast(i + 1)][@intCast(j + 1)]
                };
                const diagonal2: [3]u8 = .{
                    map.items[@intCast(i - 1)][@intCast(j + 1)],
                    map.items[@intCast(i)][@intCast(j)],
                    map.items[@intCast(i + 1)][@intCast(j - 1)]
                };
            
                if (
                    (std.mem.eql(u8, &diagonal1, "MAS") or std.mem.eql(u8, &diagonal1, "SAM")) and
                    (std.mem.eql(u8, &diagonal2, "MAS") or std.mem.eql(u8, &diagonal2, "SAM"))
                ) {
                    result2 += 1;
                }
            }

            j += 1;
        }

        i += 1;
    }

    std.debug.print("{d}\n{d}\n", .{result1, result2});
}