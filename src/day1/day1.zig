const std = @import("std");

pub fn day1() !void {
    var leftIds = std.ArrayList(i32).init(std.heap.page_allocator);
    var rightIds = std.ArrayList(i32).init(std.heap.page_allocator);

    const file = try std.fs.cwd().openFile("./src/day1/input.txt", .{});
    defer file.close();

    while(try file.reader().readUntilDelimiterOrEofAlloc(std.heap.page_allocator, '\n', std.math.maxInt(usize))) |line| {
        defer std.heap.page_allocator.free(line);

        var it = std.mem.splitScalar(u8, line, ' ');

        const leftId = try std.fmt.parseInt(i32, it.next().?, 10);
        try leftIds.append(leftId);

        _ = it.next().?;
        _ = it.next().?;

        const rightId = try std.fmt.parseInt(i32, it.next().?, 10);
        try rightIds.append(rightId);
    }

    std.sort.heap(i32, leftIds.items,{}, comptime std.sort.asc(i32));
    std.sort.heap(i32, rightIds.items, {}, comptime std.sort.asc(i32));

    var totalDistance: u32 = 0;
    var similarityScore: i32 = 0;

    var i: usize = 0;
    while (i < leftIds.items.len) {
        totalDistance += @abs(leftIds.items[i] - rightIds.items[i]);

        var j: usize = 0;
        while (j < rightIds.items.len) {
            if (leftIds.items[i] == rightIds.items[j]) {
                similarityScore += leftIds.items[i];
            }

            j += 1;
        }

        i += 1;
    }

    std.debug.print("{d}\n{d}\n", .{totalDistance, similarityScore});
}