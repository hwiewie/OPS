package snowFlakeByGo

import (
    "testing"
    "fmt"
)

func TestSnowFlakeByGo(t *testing.T) {
    // 測試腳本

    // 生成節點實例
    worker, err := NewWorker(1)

    if err != nil {
        fmt.Println(err)
        return
    }

    ch := make(chan int64)
    count := 10000
    // 並發 count 個 goroutine 進行 snowflake ID 生成
    for i := 0; i < count; i++ {
        go func() {
            id := worker.GetId()
            ch <- id
        }()
    }

    defer close(ch)

    m := make(map[int64]int)
    for i := 0; i < count; i++ {
        id := <- ch
        // 如果 map 中存在為 id 的 key, 說明生成的 snowflake ID 有重複
        _, ok := m[id]
        if ok {
            t.Error("ID is not unique!\n")
            return
        }
        // 將 id 作為 key 存入 map
        m[id] = i
    }
    // 成功生成 snowflake ID
    fmt.Println("All", count, "snowflake ID Get successed!")
}
