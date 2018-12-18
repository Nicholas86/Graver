
# 为 Graver 贡献代码

我们鼓励使用者为 Graver 项目做出贡献，贡献代码的规则可以参考下面的条例。

如果你碰见了一些不明白的问题或者是需要和开发组人员交流，可以通过 [it_graver@meituan.com](mailto:it_graver@meituan.com) 联系我们。

## 目录

<!-- TOC -->

- [为 Graver 贡献代码](#为-graver-贡献代码)
  - [快速入手](#快速入手)
  - [创建 Pull Requests](#创建-pull-requests)
  - [提问](#提问)
  - [报告 Issues](#报告-ISSUE)
    - [参考信息](#参考信息)

<!-- /TOC -->

## 快速入手

为了给 Graver 贡献代码，你应该打开一个终端

1. 首先 fork 本项目，然后 clone 到本地的工作目录。

   `$ git clone https://github.com/YOUR_GITHUB_ID/Graver`

2. 通常一次 Pull Request 是为了解决一个 ISSUE， 已有的 ISSUE 列表可以在 [这里](https://github.com/Meituan-Dianping/Graver/issues) 找到。

   如果没有相关联的 ISSUE， 可以向开发组发邮件 [it_graver@meituan.com](mailto:it_graver@meituan.com)，我们将会与你讨论这次贡献。

3. Graver 项目使用 Apache License 2.0 协议发布。因此每个文件头部信息必须带上相关协议版权信息。对于一个新文件可以通过以下链接 [License](./Copyright.txt) 找到这个模板，将其复制在新文件的顶部即可。

4. 创建新的 PR 前应该保证Build是通过的，并且是经过测试验证没有问题的。
 如果你对创建 PR 有疑问，可以向开发组发邮件 [it_graver@meituan.com](mailto:it_graver@meituan.com)。

5. 提交信息要遵守此 [模板](./commentformat.txt)。

6. 如果以上步骤都满足，就可以创建你的 PR 了。

## 创建 Pull Requests

当你创建一个PR时，请检查如下要求

1. 请在本地做相关的 diff 确保代码风格没有发生改变，如果你认为代码风格有问题，创建一个单独的 PR 来修改这个问题。
2. 提交代码前使用 `git diff --check` 命令检查下是否有多余的空白字符和换行。

## 提问

如果你有其他方面的疑惑或者需要和开发人员沟通, 可以给我们发邮件 [it_graver@meituan.com](mailto:it_graver@meituan.com).。

## 报告 ISSUE

如果有 ISSUE 需要提出，请遵守此 [模板](./issue-template.md)。

---

### 参考信息

- [GitHub 帮助页面](https://help.github.com)
- [如何创建一个拉取请求](https://help.github.com/articles/creating-a-pull-request/)
