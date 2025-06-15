package main

import (
    "graphics.gd/classdb"
    "graphics.gd/startup"
    "graphics.gd/variant/RefCounted"
)

type GoUtils struct {
    classdb.Extension[GoUtils, RefCounted.Instance] `gd:"GoUtils"`
}

func (utils *GoUtils) Multiply(a, b int32) int32 { return a * b }

func main() {
    classdb.Register[GoUtils]()
    startup.Scene()
}