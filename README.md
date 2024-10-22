安装：
```
# 使用 wget 下载并直接运行安装脚本
wget -qO- https://raw.githubusercontent.com/small-haozi/xrayr-up-onecheck/main/install.sh | bash
```
-------------------------------------------------------------------------------------------------------
```
# 使用 curl 下载并直接运行安装脚本
curl -s https://raw.githubusercontent.com/small-haozi/xrayr-up-onecheck/main/install.sh | bash
```

注意：此版本必须携带参数 否则执行了就像放了个气体

```
# 携带参数执行脚本
haha 节点id 节点类型 对接域名 对接密钥 上报阈值 是否开启审计 是否开启真实ip传递 是否优化连接配置 "解锁项目,以逗号隔开"
```
示例：haha 1 Shadowsocks example.com your_secret_key 2000 y n y "YouTube,Netflix"<br><br>

一条命令解决问题  一条命令的情况下 要加一个参数NF lock的uuid（也就是分流节点的密码）
```
curl -sSL https://raw.githubusercontent.com/small-haozi/xrayr-up-onecheck/main/install.sh | bash -s -- <解锁项目的uuid> 节点id 节点类型 对接域名 对接密钥 上报阈值 是否开启审计 是否开启真实ip传递 是否优化连接配置 "解锁项目,以逗号隔开"
```


解锁项目：

如果你嫌复制项目太麻烦，可以[点击这里](https://jiesuo.588766.xyz)使用我制作的网页生成需要解锁的项目

<a href="https://example.com" target="_blank">点击这里打开新页面</a>

| A                  | B                  | C                  | D                  | E                  | F                  | H                  | J                  | K                  |
|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|
| Abema              | Bilibili           | CatchPlay          | Disney+            | ESPN+              | FOD                | HboGO              | J-OnDemand         | KKTV               |
| AfreecaTV          | Bahamut            | ChatGPT            | DAZN               |                    | Fox                | HBO Max            | JapaneseGames      | KBSDomestic        |
|                    | BBC                | CoupangPlay        | DAM                |                    | FuboTV             | Hulu               |                    |                    |
|                    | BritBox            |                    | DMM                |                    | FXNOW              |                    |                    |                    |
|                    |                    |                    | Discovery+         |                    |                    |                    |                    |                    |

| L                  | M                  | N                  | p                  | R                  | S                  | T                  | U                  | W                  | Y                  |
|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|
| LiTV               | Music_JP           | Netflix            | PrimeVideo         | FOD                | SpotvNow           | TikTok             | UNEXT              | Watcha             | YouTube            |
| LineTV             |                    | NowE               | Paramount+         | Fox                | Star+              | TVB                | VIU                | WOWOW              |                    |
|                    |                    | Niconico           | PeacockTV          | FuboTV             | Spotify            | Telasa             |                    |                    |                    |
|                    |                    | NaverTV            | Philo              | FXNOW              | Steam              | Tving              |                    |                    |                    |
|                    |                    |                    |                    |                    |                    | TLCGO              |                    |                    |                    |



