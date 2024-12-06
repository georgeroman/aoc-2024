const std = @import("std");

fn getBaseKey(i: isize, j: isize) isize {
    // Should make `j * multiplier` never reaches `i * multiplier`
    return i * 100000000 + j * 10000;
}

fn getNextDirection(iDir: isize, jDir: isize) [2]isize {
    if (iDir == 0 and jDir == -1) {
        return .{-1, 0};
    } else if (iDir == 0 and jDir == 1) {
        return .{1, 0};
    } else if (jDir == 0 and iDir == -1) {
        return .{0, 1};
    } else {
        return .{0, -1};
    }
}

pub fn day6() !void {
    var map = std.ArrayList([]u8).init(std.heap.page_allocator);

    const file = try std.fs.cwd().openFile("./src/day6/input.txt", .{});
    defer file.close();

    var i: isize = undefined;
    var j: isize = undefined;
    var iDir: isize = -1;
    var jDir: isize = 0;
    while(try file.reader().readUntilDelimiterOrEofAlloc(std.heap.page_allocator, '\n', std.math.maxInt(usize))) |line| {
        try map.append(line);

        const caretIndex = std.mem.indexOfScalar(u8, line, '^');
        if (caretIndex != null) {
            i = @intCast(map.items.len - 1);
            j = @intCast(caretIndex.?);
        }
    }


    var visited = std.AutoHashMap(isize, bool).init(std.heap.page_allocator);
    try visited.put(getBaseKey(i, j), true);

    while (true) {
        const nextI = i + iDir;
        const nextJ = j + jDir;

        if (nextI < 0) {
            break;
        }
        if (nextI >= map.items.len) {
            break;
        }
        if (nextJ < 0) {
            break;
        }
        if (nextJ >= map.items[@intCast(nextI)].len) {
            break;
        }

        if (map.items[@intCast(nextI)][@intCast(nextJ)] == '#') {
            const nextDir = getNextDirection(iDir, jDir);
            iDir = nextDir[0];
            jDir = nextDir[1];

            continue;
        }

        try visited.put(getBaseKey(nextI, nextJ), true);

        i = nextI;
        j = nextJ;
    }

    std.debug.print("{d}\n", .{visited.count()});
}