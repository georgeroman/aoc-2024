const std = @import("std");

fn isNumber(c: u8) bool {
    if (c >= '0' and c <= '9') {
        return true;
    }

    return false;
}

pub fn day3() !void {
    const file = try std.fs.cwd().openFile("./src/day3/input.txt", .{});
    defer file.close();

    const memory = (try file.reader().readUntilDelimiterOrEofAlloc(std.heap.page_allocator, '\n', std.math.maxInt(usize))).?;

    var result1: u32 = 0;
    var result2: u32 = 0;

    var enabled = true;

    var i: usize = 0;
    while (i < memory.len) {
        const currentIndex = i;
        i += 1;

        if (currentIndex + 4 < memory.len and std.mem.eql(u8, "do()", memory[currentIndex..currentIndex+4])) {
            enabled = true;
        }

        if (currentIndex + 7 < memory.len and std.mem.eql(u8, "don't()", memory[currentIndex..currentIndex+7])) {
            enabled = false;
        }

        if (currentIndex + 4 < memory.len and std.mem.eql(u8, "mul(", memory[currentIndex..currentIndex+4])) {
            // We start parsing after "mul("
            var j = currentIndex + 4;

            var number1: ?u32 = null;
            var numbersCount1: u32 = 0;
            const numberStart1 = j;
            while (j < memory.len and isNumber(memory[j])) {
                numbersCount1 += 1;
                j += 1;
            }
            if (numbersCount1 < 1 or numbersCount1 > 3) {
                continue;
            }
            number1 = try std.fmt.parseInt(u32, memory[numberStart1..numberStart1+numbersCount1], 10);

            if (j >= memory.len or memory[j] != ',') {
                continue;
            }
            j += 1;

            var number2: ?u32 = null;
            var numbersCount2: u32 = 0;
            const numberStart2 = j;
            while (j < memory.len and isNumber(memory[j])) {
                numbersCount2 += 1;
                j += 1;
            }
            if (numbersCount2 < 1 or numbersCount2 > 3) {
                continue;
            }
            number2 = try std.fmt.parseInt(u32, memory[numberStart2..numberStart2+numbersCount2], 10);

            if (j >= memory.len or memory[j] != ')') {
                continue;
            }

            result1 += number1.? * number2.?;
            if (enabled) {
                result2 += number1.? * number2.?;
            }
        }
    }

    std.debug.print("{d}\n{d}\n", .{result1, result2});
}