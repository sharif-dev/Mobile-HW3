//
//  hw3.swift
//  
//
//  Created by Roodabeh Safavi on 6/12/20.
//
import Foundation
class Trie {
    var max_row_num = 0
    var max_col_num = 0
//    var matrix = []
    
    class Node {
        var is_leaf = false
        var children = [Node?](repeating: nil , count: 26)
    }
    
    var root: Node = Node()
    
    func insert(str: String) {
        var next_node: Node = root
        for char in str {
            let index = Int((char.asciiValue)! - (Character("A").asciiValue)!)
            if (next_node.children[index] == nil) {
                next_node.children[index] = Node()
            }
            next_node = next_node.children[index]!
        }
        next_node.is_leaf = true
    }
    
    func get_valid_neighbors(row_num: Int, col_num: Int, visited: [[Bool]]) -> [(row: Int, col: Int)] {
        var neighbors: [(row: Int, col: Int)] = []

        if (row_num + 1 < max_row_num && col_num + 1 < max_col_num && !visited[row_num + 1][col_num + 1])
            {neighbors.append((row_num + 1, col_num + 1))}
        
        if (col_num + 1 < max_col_num && !visited[row_num][col_num + 1])
            {neighbors.append((row_num, col_num + 1))}
        
        if (row_num - 1 >= 0 && col_num + 1 < max_col_num && !visited[row_num - 1][col_num + 1])
            {neighbors.append((row_num - 1, col_num + 1))}
        
        if (row_num + 1 < max_row_num && !visited[row_num + 1][col_num])
            {neighbors.append((row_num + 1, col_num))}
        
        if (row_num + 1 < max_row_num && col_num - 1 >= 0 && !visited[row_num + 1][col_num - 1])
            {neighbors.append((row_num + 1, col_num - 1))}
        
        if (col_num - 1 >= 0 && !visited[row_num][col_num - 1])
            {neighbors.append((row_num, col_num - 1))}
        
        if (row_num - 1 >= 0 && col_num - 1 >= 0 && !visited[row_num - 1][col_num - 1])
            {neighbors.append((row_num - 1, col_num - 1))}
        
        if (row_num - 1 >= 0 && !visited[row_num - 1][col_num])
            {neighbors.append((row_num - 1, col_num))}
        
        return neighbors
    }
    
    func search(next_node: Node, discoverd_str: String, row_num: Int, col_num: Int, matrix: [[Character]], visited: inout [[Bool]], result: inout Set<String>) {
        if next_node.is_leaf {
            result.insert(discoverd_str)
            return
        }
        
        visited[row_num][col_num] = true
        for index in 0...25{
            if (next_node.children[index] != nil){
                let next_char: Character = Character((UnicodeScalar(index + Int((Character("A").asciiValue)!)))!)
                for position in get_valid_neighbors(row_num: row_num, col_num: col_num, visited: visited) {
                    if (matrix[position.row][position.col] == next_char)
                    {search(next_node: next_node.children[index]!, discoverd_str: discoverd_str + String(next_char), row_num: position.row, col_num: position.col, matrix: matrix, visited: &visited, result: &result)}
                }
                
            }
        }
        visited[row_num][col_num] = false
    }
    
    func start_searching(matrix: [[Character]]) -> Set<String> {
        var result = Set<String>()
        var visited = [[Bool]](repeating: [Bool](repeating: false , count: max_col_num) , count: max_row_num)
        var discoverd_str = ""
        for row in 0...(max_row_num - 1) {
            for col in 0...(max_col_num - 1) {
                let next_node = root.children[Int((matrix[row][col].asciiValue)! - (Character("A").asciiValue)!)]
                if (next_node != nil){
                    discoverd_str += String(matrix[row][col])
                    search(next_node: next_node!, discoverd_str: discoverd_str, row_num: row, col_num: col, matrix: matrix, visited: &visited, result: &result)
                    discoverd_str = ""
                }
            }
        }
        return result
    }
    
    func split(str: String) -> [String] {
        var substr: String = ""
        var li: [String] = []
        for char in str{
            if (char == " ") {
                li.append(substr)
                substr = ""
            } else {
                substr += String(char)
            }
        }
        if (substr != "") {
            li.append(substr)
        }
        return li
    }
    
    
}



var searching_words = readLine()
let my_trie = Trie()
for str in my_trie.split(str: searching_words!){
    my_trie.insert(str: str)
}
var next_line = my_trie.split(str: readLine()!)
my_trie.max_row_num = Int(next_line[0])!
my_trie.max_col_num = Int(next_line[1])!
var matrix: [[Character]] = []
for r in 0...(my_trie.max_row_num - 1){
    next_line = my_trie.split(str: readLine()!)
    matrix.append([])
    for c in next_line {
        matrix[r].append(Character(c))
    }
}
var res = my_trie.start_searching(matrix: matrix)
for str in res {
    print(str)
}
