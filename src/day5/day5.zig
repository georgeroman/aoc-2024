const std = @import("std");

pub fn day5() !void {
    var valuesAfter = std.AutoHashMap(u32, []u32).init(std.heap.page_allocator);

    const file = try std.fs.cwd().openFile("./src/day5/input.txt", .{});
    defer file.close();

    var result1: u32 = 0;
    var result2: u32 = 0;

    while(try file.reader().readUntilDelimiterOrEofAlloc(std.heap.page_allocator, '\n', std.math.maxInt(usize))) |line| {
        defer std.heap.page_allocator.free(line);

        if (line.len == 0) {
            continue;
        }

        if (std.mem.indexOfScalar(u8, line, '|') != null) {
            var split = std.mem.splitScalar(u8, line, '|');

            const before = try std.fmt.parseUnsigned(u32, split.next().?, 10);
            const after = try std.fmt.parseUnsigned(u32, split.next().?, 10);

            if (valuesAfter.get(before) == null) {
                var list = std.ArrayList(u32).init(std.heap.page_allocator);
                try valuesAfter.put(before, try list.toOwnedSlice());
            }

            var list = std.ArrayList(u32).fromOwnedSlice(std.heap.page_allocator,valuesAfter.get(before).?);
            try list.append(after);

            try valuesAfter.put(before, try list.toOwnedSlice());
        }

        if (std.mem.indexOfScalar(u8, line, ',') != null) {
            var values = std.ArrayList(u32).init(std.heap.page_allocator);

            var split = std.mem.splitScalar(u8, line, ',');
            while (split.peek() != null) {
                const value = try std.fmt.parseUnsigned(u32, split.next().?, 10);
                try values.append(value);
            }

            var isOrdered1 = true;
            var isOrdered2 = false;

            var i: usize = 0;
            while (i < values.items.len) {
                var j =  i + 1;
                while (j < values.items.len) {
                    const valuesAfterEntry = valuesAfter.get(values.items[j]);
                    if (valuesAfterEntry != null and std.mem.indexOfScalar(u32, valuesAfterEntry.?, values.items[i]) != null) {
                        isOrdered1 = false;

                        std.mem.swap(u32, &values.items[i], &values.items[j]);
                        isOrdered2 = true;
                    }

                    j += 1;
                }

                i += 1;
            }

            if (isOrdered1) {
                result1 += values.items[@divFloor(values.items.len, 2)];
            }
            if (isOrdered2) {
                result2 += values.items[@divFloor(values.items.len, 2)];
            }
        }
    }

    std.debug.print("{d}\n{d}\n", .{result1, result2});
}