## Pipeline

##### Stencil

![stencil](F:\GithubProject\customEditor\unityCustomEditor\doc\image\stencil.png)

而模板缓冲则是用来重写深度测试，从而改变深度关系，并基于更改后的测试来更换或丢弃像素。

```
Stencil {
  Ref 4
  Comp lequal
  Pass Replace
  ZFail Keep
}
```

Pass Replace表示如果通过了模板测试，则会用参考值替换模板缓冲中的值，模板缓冲内的默认值为0，于是拿4换缓冲内的0。最后ZFail的处理为Keep，Ref值不变。参考值 与当前模板缓冲区的值做对比满足comp条件lequal则通过测试

