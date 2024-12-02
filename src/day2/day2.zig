const std = @import("std");

fn isSafeReport(items: []const i32) bool {
    var sign: i8 = 0;

    var i: usize = 0;
    while (i < items.len - 1) {
        const currentDiff = items[i] - items[i + 1];
        const currentSign: i8 = if (currentDiff < 0) -1 else 1;
        if (sign == 0) {
            sign = currentSign;
        }

        if (sign != currentSign) {
            return false;
        }
        if (@abs(currentDiff) < 1 or @abs(currentDiff) > 3) {
            return false;
        }

        i += 1;
    }

    return true;
}

pub fn day2() !void {
    var reports = std.ArrayList([]const i32).init(std.heap.page_allocator);

    const file = try std.fs.cwd().openFile("./src/day2/input.txt", .{});
    defer file.close();

    while(try file.reader().readUntilDelimiterOrEofAlloc(std.heap.page_allocator, '\n', std.math.maxInt(usize))) |line| {
        defer std.heap.page_allocator.free(line);

        var level = std.ArrayList(i32).init(std.heap.page_allocator);

        var it = std.mem.splitScalar(u8, line, ' ');

        while (true) {
            const value = it.next();
            if (value == null) {
                break;
            }

            const formattedValue = try std.fmt.parseInt(i32, value.?, 10);
            try level.append(formattedValue);
        }

        try reports.append(level.items);
    }

    var numSafeLevels1: u32 = 0;
    var numSafeLevels2: u32 = 0;
    for (reports.items) |report| {
        const isSafe = isSafeReport(report);
        numSafeLevels1 += if (isSafe) 1 else 0;
        numSafeLevels2 += if (isSafe) 1 else 0;

        if (!isSafe) {
            var indexToRemove: usize = 0;
            while (indexToRemove < report.len) {
                var newReport = std.ArrayList(i32).init(std.heap.page_allocator);
                for (0.., report) |i, level| {
                    if (i != indexToRemove) {
                        try newReport.append(level);
                    }
                }

                if (isSafeReport(newReport.items)) {
                    numSafeLevels2 += 1;
                    break;
                }

                indexToRemove += 1;
            }
        }
    }

    std.debug.print("{d}\n{d}\n", .{numSafeLevels1, numSafeLevels2});
}