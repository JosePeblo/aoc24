// Aoc day 4 go
// go run day04.go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func ternary(cond bool, ifs int, elses int) int {
    if(cond) {
        return ifs
    }

    return elses    
}

func main() {
    fd, err := os.Open("inputs/input04.txt")
    check(err)
    defer fd.Close()

    var lines []string
    scanner := bufio.NewScanner(fd)
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }
    
    // Part 1
    cols := len(lines)
    rows := len(lines[0])
    xmasCount := 0

    for i := 0; i < cols; i++ {
        for j := 0; j < rows; j++ {
            if lines[i][j] != 'X' { continue }

            k := ternary(i-3 < 0, i, i-1)
            kmax := ternary(i+4 > cols, i, i+1)

            for ; k <= kmax; k++ {
                n := ternary(j-3 < 0, j, j-1)
                nmax := ternary(j+4 > rows, j, j+1)

                for ; n <= nmax; n++ {
                    if i == k && j == n { continue }
                    x := k - i
                    y := n - j
                    
                    if lines[i+x][j+y]     == 'M' && 
                       lines[i+x*2][j+y*2] == 'A' && 
                       lines[i+x*3][j+y*3] == 'S' {
                        xmasCount ++
                    }
                }
            }
        }
    }

    fmt.Printf("XMAS count: %v\n", xmasCount)

    // Part 2
    XmasCount := 0

    for i := 1; i < cols-1; i++ {
        for j := 1; j < rows-1; j++ {
            if lines[i][j] != 'A' { continue }
            mas := 0

            if lines[i-1][j-1] == 'M' && lines[i+1][j+1] == 'S' { mas++ }
            if lines[i-1][j-1] == 'S' && lines[i+1][j+1] == 'M' { mas++ }
            if lines[i-1][j+1] == 'M' && lines[i+1][j-1] == 'S' { mas++ }
            if lines[i-1][j+1] == 'S' && lines[i+1][j-1] == 'M' { mas++ }
            if mas == 2 {
                XmasCount++
            }
        }
    }

    fmt.Printf("X-MAS count: %v\n", XmasCount)

}

