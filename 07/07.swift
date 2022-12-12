#!/usr/bin/env swift

import Foundation

// Having a base node type is a very neat solution that allows for easy size
// computation but Swift hates easy things, apparently, so I had to make this
// a protocol. I mean, no biggie, but why do you hate developers, Apple?!

protocol Node {
    var parent: Node? { get set }
    var name: String { get set }
    var size: Int { get }
    var children: [Node] { get set }
}

class Directory: Node {
    var parent: Node? = nil
    var name: String = ""
    private var _children: [Node] = []
    var children: [Node] {
        get { return _children }
        set(children) {
            _children = children
            for var child in _children {
                child.parent = self
            }
        }
    }
    var size: Int {
        get { return children.map { $0.size }.reduce(0, +) }
    }
    init(name: String) {
        self.name = name
    }
    func append(node: Node) {
        var n = node
        n.parent = self
        _children.append(n)
    }
    func findBy(name: String) -> Node? {
        if let i = _children.firstIndex(where: { $0.name == name }) {
            return _children[i]
        }
        return nil
    }
}

class File: Node {
    var parent: Node? = nil
    var name: String = ""
    var children: [Node] = []
    private var _size: Int = 0
    var size: Int {
        get { return _size }
        set(size) { self._size = size }
    }
    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }
}

func buildTree() -> Directory {
    let input = try! String(contentsOfFile: "input.txt").split(separator: "\n")
    var pwd: Directory = Directory(name: "/")

    for line in input[1..<input.count] {
        let parts = line.split(separator: " ")
        if parts[0] == "$" {
            if parts[1] == "cd" {
                if parts[2] == ".." {
                    pwd = pwd.parent as! Directory
                } else if let candidate = pwd.findBy(name: String(parts[2])) {
                    pwd = candidate as! Directory
                } else {
                    let newDirectory = Directory(name: String(parts[2]))
                    pwd.append(node: newDirectory)
                    pwd = newDirectory
                }
            }
        } else if parts[0] == "dir" {
            // nop
        } else {
            pwd.append(node: File(name: String(parts[1]), size: Int(parts[0])!))
        }
    }
    while pwd.parent != nil {
        pwd = pwd.parent as! Directory
    }
    return pwd
}

func flatten(tree: Directory) -> [Directory] {
    var directoriesToGo: [Directory] = [tree]
    var flattenedDirectories: [Directory] = [tree]
    while directoriesToGo.count > 0 {
        let dirs = directoriesToGo[0].children.filter { type(of: $0) == Directory.self } as! [Directory]
        directoriesToGo.append(contentsOf: dirs)
        flattenedDirectories.append(contentsOf: dirs)
        directoriesToGo.removeFirst()
    }
    return flattenedDirectories
}

var root = buildTree()
let flattenedTree = flatten(tree: root)
let sumOfSmallDirs = flattenedTree.map { $0.size }
                                  .filter{ $0 < 100000}
                                  .reduce(0, +)
print("The total size of the directories smaller than 100000 is \(sumOfSmallDirs)")
let diskSize = 70000000
let updateSize = 30000000
let smallestDirToRemove = flattenedTree.sorted(by: { $0.size < $1.size })
                                       .map { $0.size }
                                       .filter { $0 > updateSize - (diskSize-root.size) }[0]
print("The smallest directory to allow the update to run has a total size of \(smallestDirToRemove)")