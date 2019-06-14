# 线程与 RunLoop 的关系 Demo

## 保活线程

[分析](https://github.com/Monsoir/Notes/blob/master/iOS/keep-thread-alive.md)

- 进入 Alive Thread
- 保活线程
    - **Init alive thread**
        - 创建一个可在一定时间内存活的线程（保活线程）
    - **Do something on alive thread**
        - 在上面的保活线程中执行任务
        - 打印出线程相关的信息
        - 预期结果：线程的 `isFinished` 为 `false`
    - **Stop alive thread**
        - 让线程失活
        - 此时再 **Do something on alive thread** 是无法得到原本的结果，因为线程已经不可以再执行任何任务
        - 预期结果：线程的 `isFinished` 为 `true`

- 一次性线程
    - **Init disposable thread**
        - 创建一个一次性线程，一次性在于，线程执行完初始化时派给它的任务后，就失活，不可再执行其他任务
    - **Do something on disposable thread**
        - 线程已经失活了，不可以再执行任务
        - 预期结果：线程的 `isFinished` 为 `true`


## 抢救应用

[分析](https://github.com/Monsoir/Notes/blob/master/iOS/rescue-app.md)

- 进入 Rescue
- **Raise unhandled message exception**
    - 将引发一个 unrecognized selector 的异常
    - 同时界面上将会出现弹窗，让用户决定是否继续运行应用


