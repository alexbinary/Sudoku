
import Foundation



struct Sudoku {
    
    
    struct Cell: Hashable {
        
        let line: Int
        let column: Int
    }


    enum Number: Int, CaseIterable {
        
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
        case nine = 9
    }
    
    
    // initially, grid is empty, no number is fixed, and all numbers are possible everywhere
    
    private var fixedNumbers: [Cell: Number] = [:]
    
    private var possibleNumbers: [Cell: Set<Number>] = {
        
        var possibleNumbers = [Cell: Set<Number>]()
        for cell in allCells {
            possibleNumbers[cell] = Set<Number>(Number.allCases)
        }
        return possibleNumbers
    }()
    
    public func fixedNumber(at cell: Cell) -> Number? {
        
        return fixedNumbers[cell]
    }
    
    public func possibleNumbers(for cell: Cell) -> Set<Number> {
        
        return possibleNumbers[cell] ?? Set<Number>()
    }
    
    public func printGrid() {
        
        print("++=======+=======+=======++=======+=======+=======++=======+=======+=======++")
        for l in 0..<9 {
            for i in 0..<3 {
                print("||", terminator: "")
                for c in 0..<9 {
                    if let number = fixedNumber(at: Cell(line: l, column: c)) {
                        if i == 1 {
                            print("  [", terminator: "")
                            print(number.rawValue, terminator: "")
                            print("]  ", terminator: "")
                        } else {
                            print("       ", terminator: "")
                        }
                    } else {
                        let possibleNumbersforCell = possibleNumbers(for: Cell(line: l, column: c))
                        
                        if i == 0 {
                            
                            print(" ", terminator: "")
                            for n in [Number.one, .two, .three] {
                                if possibleNumbersforCell.contains(n) {
                                    print(n.rawValue, terminator: "")
                                } else {
                                    print(" ", terminator: "")
                                }
                                print(" ", terminator: "")
                            }
                            
                        } else if i == 1 {
                            
                            print(" ", terminator: "")
                            for n in [Number.four, .five, .six] {
                                if possibleNumbersforCell.contains(n) {
                                    print(n.rawValue, terminator: "")
                                } else {
                                    print(" ", terminator: "")
                                }
                                print(" ", terminator: "")
                            }
                            
                        } else if i == 2 {
                            
                            print(" ", terminator: "")
                            for n in [Number.seven, .eight, .nine] {
                                if possibleNumbersforCell.contains(n) {
                                    print(n.rawValue, terminator: "")
                                } else {
                                    print(" ", terminator: "")
                                }
                                print(" ", terminator: "")
                            }
                        }
                    }
                    print("|", terminator: "")
                    if c % 3 == 2 {
                        print("|", terminator: "")
                    }
                }
                print("", terminator: "\n")
            }
            if l % 3 == 2 {
                print("++=======+=======+=======++=======+=======+=======++=======+=======+=======++")
            } else {
                print("++-------+-------+-------++-------+-------+-------++-------+-------+-------++")
            }
        }
    }
    
    private mutating func set(_ number: Number, inCell cell: Cell) {
        
        fixedNumbers[cell] = number
        possibleNumbers.removeValue(forKey: cell)
        
        var cells: [Cell] = []
        
        cells.append(contentsOf: allFreeCellsOnSameLine(as: cell))
        cells.append(contentsOf: allFreeCellsOnSameColumn(as: cell))
        cells.append(contentsOf: allFreeCellsOnSameSquare(as: cell))
            
        cells.removeAll(where: { $0 == cell })
        
        for cell in Set<Cell>(cells) {
            possibleNumbers[cell]!.remove(number)
        }
    }

    init(_ numbers: [(line: Int, column: Int, number: Number)]) {
        
        for (line, column, number) in numbers {
            self.set(number, inCell: Cell(line: line, column: column))
        }
    }
    
    mutating func solve() -> Result<Sudoku, Error> {
        
        print("solving...")
        
        for cell in allFreeCells {
            
            let possibleNumbersForCell = possibleNumbers(for: cell)
            
            if possibleNumbersForCell.count == 0 {
                
                print("found cell with zero possible numbers: \(cell)")
                return .failure("no possible numbers")
                
            } else if possibleNumbersForCell.count == 1 {
                
                print("found cell with only one possible number: \(cell): \(possibleNumbersForCell.first!.rawValue)")
                
                var workingGrid = self
                workingGrid.set(possibleNumbersForCell.first!, inCell: cell)
                workingGrid.printGrid()
                
                return workingGrid.solve()
            }
        }
        
        for area in allFreeCellsByArea {
            for number in Number.allCases {
            
                let possibleCellsForNumber = area.filter { possibleNumbers(for: $0).contains(number) }
                if possibleCellsForNumber.count == 1 {
                
                    print("found number with only one possible cell: \(number.rawValue): \(possibleCellsForNumber.first!)")
                    
                    var workingGrid = self
                    workingGrid.set(number, inCell: possibleCellsForNumber.first!)
                    workingGrid.printGrid()
                    
                    return workingGrid.solve()
                }
            }
        }
        
        guard let cell = firstFreeCell else {
            
            print("no more free cells, sudoku is solved")
            return .success(self)
        }
        
        let possibleNumbersForCell = possibleNumbers(for: cell)
        
        for number in possibleNumbersForCell.sorted(by: { $0.rawValue < $1.rawValue }) {
            
            print("trying next possible number for first free cell: \(cell): \(number.rawValue)")
            
            var workingGrid = self
            workingGrid.set(number, inCell: cell)
            workingGrid.printGrid()
            
            switch workingGrid.solve() {
            case .success(let sudoku) :
                return .success(sudoku)
            case .failure:
                continue
            }
        }
        
        print("all possible numbers have been tried for first free cell: \(cell)")
        return .failure("all possible numbers have been tried")
    }
    
    private func cellIsFree(_ cell: Cell) -> Bool {
        
        return fixedNumbers[cell] == nil
    }
    
    private func keepOnlyFreeCells(_ cells: [Cell]) -> [Cell] {
        
        return cells.filter { cellIsFree($0) }
    }
    
    private static var allCells: [Cell] {
        
        var cells: [Cell] = []
        for line in 0..<9 {
            for column in 0..<9 {
                cells.append(Cell(line: line, column: column))
            }
        }
        return cells
    }
    
    private var allFreeCells: [Cell] {
        
        return keepOnlyFreeCells(Self.allCells)
    }
    
    var firstFreeCell: Cell? {
        
        return allFreeCells.first
    }
       
    private func allFreeCellsOnLine(_ line: Int) -> [Cell] {
    
        return allFreeCells.filter { $0.line == line }
    }
    
    private func allFreeCellsOnColumn(_ column: Int) -> [Cell] {
    
        return allFreeCells.filter { $0.column == column }
    }
    
    private func allFreeCellsOnSquare(startingAtLine squareStartLine: Int, andColumn squareStartColumn: Int) -> [Cell] {
        
        return allFreeCells.filter {
            $0.line >= squareStartLine && $0.line <= (squareStartLine+2)
            &&
            $0.column >= squareStartColumn && $0.column <= (squareStartColumn+2)
        }
    }
    
    private func allFreeCellsOnSameLine(as cell: Cell) -> [Cell] {
    
        return allFreeCellsOnLine(cell.line)
    }
    
    private func allFreeCellsOnSameColumn(as cell: Cell) -> [Cell] {
    
        return allFreeCellsOnColumn(cell.column)
    }
    
    private func allFreeCellsOnSameSquare(as cell: Cell) -> [Cell] {
    
        return allFreeCellsOnSquare(startingAtLine: (cell.line/3)*3, andColumn: (cell.column/3)*3)
    }
    
    private var allFreeCellsByLine: [[Cell]] {
        
        var cellGroups: [[Cell]] = []
        for l in 0..<9 {
            cellGroups.append(allFreeCellsOnLine(l))
        }
        return cellGroups
    }
    
    private var allFreeCellsByColumn: [[Cell]] {
        
        var cellGroups: [[Cell]] = []
        for l in 0..<9 {
            cellGroups.append(allFreeCellsOnColumn(l))
        }
        return cellGroups
    }
    
    private var allFreeCellsBySquare: [[Cell]] {
        
        var cellGroups: [[Cell]] = []
        for line in 0..<3 {
            for column in 0..<3 {
                cellGroups.append(allFreeCellsOnSquare(startingAtLine: line*3, andColumn: column*3))
            }
        }
        return cellGroups
    }
    
    private var allFreeCellsByArea: [[Cell]] {
        
        var cellGroups: [[Cell]] = []
        
        cellGroups.append(contentsOf: allFreeCellsByLine)
        cellGroups.append(contentsOf: allFreeCellsByColumn)
        cellGroups.append(contentsOf: allFreeCellsBySquare)
        
        return cellGroups
    }
}


extension String: Error {
    
}



var sudokuGrid_difficile = Sudoku([
    
    (line: 0, column: 0, number: .seven),
    (line: 0, column: 2, number: .six),
    (line: 0, column: 6, number: .one),
    (line: 0, column: 8, number: .nine),
    
    (line: 2, column: 0, number: .three),
    (line: 2, column: 3, number: .one),
    (line: 2, column: 5, number: .four),
    (line: 2, column: 8, number: .seven),
    
    (line: 3, column: 2, number: .three),
    (line: 3, column: 3, number: .two),
    (line: 3, column: 5, number: .five),
    (line: 3, column: 6, number: .six),
    
    (line: 5, column: 2, number: .nine),
    (line: 5, column: 3, number: .eight),
    (line: 5, column: 5, number: .seven),
    (line: 5, column: 6, number: .four),
    
    (line: 6, column: 0, number: .two),
    (line: 6, column: 3, number: .seven),
    (line: 6, column: 5, number: .eight),
    (line: 6, column: 8, number: .four),
    
    (line: 8, column: 0, number: .six),
    (line: 8, column: 2, number: .eight),
    (line: 8, column: 6, number: .nine),
    (line: 8, column: 8, number: .one),
])


var sudokuGrid_facile1 = Sudoku([
    
    (line: 0, column: 1, number: .eight),
    (line: 0, column: 4, number: .two),
    (line: 0, column: 7, number: .seven),
    
    (line: 1, column: 0, number: .two),
    (line: 1, column: 4, number: .five),
    (line: 1, column: 6, number: .six),
    (line: 1, column: 7, number: .three),
    
    (line: 2, column: 0, number: .nine),
    (line: 2, column: 3, number: .seven),
    (line: 2, column: 7, number: .two),
    (line: 2, column: 8, number: .one),
    
    (line: 3, column: 0, number: .five),
    (line: 3, column: 1, number: .three),
    (line: 3, column: 4, number: .six),
    (line: 3, column: 7, number: .one),
    
    (line: 4, column: 1, number: .nine),
    (line: 4, column: 2, number: .four),
    (line: 4, column: 3, number: .eight),
    (line: 4, column: 5, number: .five),
    (line: 4, column: 6, number: .three),
    (line: 4, column: 7, number: .six),
    
    (line: 5, column: 1, number: .six),
    (line: 5, column: 4, number: .seven),
    (line: 5, column: 7, number: .eight),
    (line: 5, column: 8, number: .five),
    
    (line: 6, column: 0, number: .eight),
    (line: 6, column: 1, number: .four),
    (line: 6, column: 5, number: .three),
    (line: 6, column: 8, number: .seven),
    
    (line: 7, column: 1, number: .two),
    (line: 7, column: 2, number: .nine),
    (line: 7, column: 4, number: .eight),
    (line: 7, column: 8, number: .six),
    
    (line: 8, column: 1, number: .seven),
    (line: 8, column: 4, number: .four),
    (line: 8, column: 7, number: .nine),
])


var sudokuGrid = sudokuGrid_difficile

sudokuGrid.printGrid()

_ = sudokuGrid.solve()
