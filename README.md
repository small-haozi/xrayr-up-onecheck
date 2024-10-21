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
haha 节点id 节点类型 对接域名 对接密钥 上报阈值 是否开启审计 是否优化连接配置 "解锁项目,以逗号隔开"
```
示例：haha 1 Shadowsocks example.com your_secret_key 2000 yes yes "YouTube,Netflix"<br><br>
如果只是对接节点   最后两个参数可不写！！！本脚本目前仅支持Shadowsocks  Vmess   其他协议自行修改其他参数

一条命令解决问题  一条命令的情况下 要加一个参数NF lock的uuid
```
curl -sSL https://raw.githubusercontent.com/small-haozi/xrayr-up-onecheck/main/install.sh | bash -s -- <解锁项目的uuid> 节点id 节点类型 对接域名 对接密钥 上报阈值 是否开启审计 是否优化连接配置 "解锁项目,以逗号隔开"
```


解锁类型：<br>
1.为NF解锁的配置<br>
2.为自建分流节点的配置

解锁项目：


| 解锁项目            | 解锁项目            | 解锁项目            |
|---------------------|---------------------|---------------------|
| YouTube             | LineTV              | Watcha              |
| Netflix             | CatchPlay           | SpotvNow            |
| Disney+             | Niconico            | Discovery+          |
| Bilibili            | FOD                 | ESPN+               |
| TikTok              | DAM                 | Fox                 |
| DAZN                | UNEXT               | FuboTV              |
| Abema               | Music_JP            | Paramount+          |
| Bahamut             | Radiko              | PeacockTV           |
| HBO Max             | Telasa              | Star+               |
| ChatGPT             | Hulu                | BritBox             |
| Steam               | WOWOW               | FXNOW               |
| PrimeVideo          | J-OnDemand          | Philo               |
| TVB                 | DMM                 | Shudder             |
| Spotify             | JapaneseGames       | TLCGO               |
| VIU                 | Wavve               | BBC                 |
| MyTvSuper           | Tving               |                     |
| NowE                | CoupangPlay         |                     |
| HboGO               | NaverTV             |                     |
| KKTV                | AfreecaTV           |                     |
| LiTV                | KBSDomestic         |                     |


