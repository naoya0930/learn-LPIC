### ツール
- Nagios...ネットワーク上のホストの状態を監視。結果をブラウザにグラフ表示
- MRTG...Multi Router Traffic Graoher。グラフ画像をWebサーバから見る
- Cacti...RRD(Round Robin Database)形式のデータでブラウザにグラフ表示
- Icinga2...オープンソースネットワーク管理ツール
- colledctd...システムの統計情報を収集し、結果をRRDファイルに保存

### vmstatの結果
- procs
  - r...runnable。待ちプロセス数
  - b...blocked。割り込み不可状態のプロセス数
    - ddやcatの結果。書き込み作業などはこの状態。killコマンドなどを受け付けない状態になっている
- memory
  - swpd...使用中スワップ量
  - free...未使用物理メモリ量(スワップを含まない)
  - buff...使用されているバッファ量
  - cache...使用されているキャッシュ量
- swap
  - si...swap in
  - so...swap out
- io
  - bi...block in
  - bo...block out
- system
  - in...interrupt
  - cs...context switch
- cpu
  - us...user。ユーザによって使用された領域
  - sy...system。カーネルによって使用された領域
  - ☆ id...idle。CPUが何もしていない時間
  - ☆ wa...wait。CPUは動いているがI/O待ちの上チア
  - st...stolen。仮想環境に持って行かれた

### sarコマンドで収集するオプション
- sar -o [name]...実行時のsarコマンドで参照可能な情報を取得してファイルで保存する
  - デフォルトでは、/var/log/sa/saXX/
- sar -f {name}...sarによって作られたファイルを参照する
  - `sar -r -f {file}`など。参照オプションが必須

### sarコマンドで統計を表示するオプション
- sar -A...全統計を表示
- sar -b...ブロックIOに対する統計。ディスク単位ではなく、全アクセスをカウント
  - sar -d...デバイス単位。何もしてしなければ、全デバイス
- sar -r...メモリに対する統計上上の表示
- sar -n {}...ネット関係。デバイス指定、もしくはALLが必須
- sar -u...CPU統計。
  - sar -P [coore_num]...CPU統計。コア指定必須

### sar -n の表示内容
- IFACE...インタフェース名
- rxpck/s...1sあたりの受信パケット数
- txpck/s...1sあたりの送信パケット数
- rxkB/s...1sあたりの受信KB数
- txkB/s...1sあたりの送信KB数

### sar -bの表示内容
- リクエスト数を管理する
- だいたい1ブロック512バイトなので、概算は可能
- tps...transfers per second
- rtps...read request per second
- wtps...write requests per second
- bread/s...brock read per second
- bwrtn/s...block write per seconed


### sar自動実行コマンド
- sa1...収集を実行。sarcデーモンを実行
  - sadc...system activity data collector 
- sa2...統計レポート化を実行。sarコマンドを実行

### iptraf
- ネットワークモニタリングツール
- 今はiptraf-ngという名称になっている
- TCP/UDPのモニタ
- ネットーワークI/Fの統計情報の表示

### モジュールの定義
- カーネルによって使用されるプログラム
- make modules_install 

### Linux バージョンの体系
- 4つある！！！
- 読み方
  - {メジャー}.{マイナー}.{パッチ}[-エクストラ]
- prepatch
  - RC版とも。開発が実施されている状況
- mainline
  - すべての新機能を含むバージョン。2,3ヶ月ごとにリリース
  - 3.0, 3.1, 3.2 ...
- stable
  - バグフィックスを実施している。
  - パッチが当てられている3.0.1, 3.0.2など
  - longterm以外のバージョンもリリースされる
- longterm
  - 長期間サポートを実施するバージョン
  - 3.2.87など
  - 2年程度の保証期間


### カーネル配下のフォルダ、ディレクトリ
- /usr/src/linux/Documentation
  - ドキュメント
- /usr/src/linux/kernel
  - カーネルそのもの
- /usr/src/linux/arch/
  - アーキテクチャごとのコード
- /usr/src/fs/
  - ファイルシステム系のモジュールはここ
- /usr/src/net/
  - ネットワーク系のモジュールはここ


### カーネルのソースコードビルド
- .configファイルを生成する。これはカーネルに含まれているわけではない
  - make config
  - make menuconfig...TUI
  - make xconfig...Qt(要X Sysetm)
  - make gconfi...Gtk(要X Sysetm)
  - make defconfig
  - ここで、.configが作成される。
  - .configureではないので注意！！！
- make all
- make modules_install
- make install


### make oldconfig
- /boot配下の現行の.configファイルを持ってきてくれるわけではない
  - cpして持ってくる必要あり
  - cp /boot/$(uname -r).config
- make oldconfig

### 圧縮系コマンドオプション
- tar
  - z,j,J...gzip,bzip2,xz形式を指定
  - c,x,t...作成、展開、中身の確認
  - l...メタデータの表示(bzip2には無い)
    - 圧縮率、チェックサムの種類、ブロック数など
  - v...処理の詳細情報の表示
  - f...アーカイブファイル名を指定
    - これが入ると、ファイル名が圧縮元より先にくることになる
    - ストリームを扱う場合以外は、tarは必須なオプション

- gzip,bzip2,xz
  - k...圧縮前後のファイルを保持する
  - d...解凍
  - c...標準出力に出す
  - r...再起的にディレクトリの中身の圧縮ファイルを作成

### patchコマンド
- `command | patch`でも実行可能
  - 標準出力に出された内容を適応する
- `patch < patchfile`
  - ファイルを入力

### カーネルの設定ファイル
- /proc/sys/ ... ここにあるのが現在の設定
- /etc/sysctl.conf...sysctlによって管理される
- 現在では，/etc/sysctl.d/*.confになっている

### initramfsを作成するコマンド
- dracut
  - ドラクートとか発音する．draculaっぽいね．
  - ドラカットでも正解っぽい
- mkinitrd

### grub レガシーにおけるディスクの参照
- `/boot/grub/device.map`
  - どのデバイス，パーティション番号(hd0)が，どのデバイスファイル/dev/sdaに結びついているか確かめられる
- これはあくまでBIOS経由
  - なので，bootloadrと/bootだけの記述されていればよい．
- Linuxカーネルはドライバから存在を検知するので，独立している

### ブート時にカーネルに渡したパラメータ
- 3.17
- /proc/cmdline

### SysVinit
- /etc/inittab ... initが最初に参照する設定ファイル
- /etc/rc.d/rc.sysuit...全てのランレベルで事前に実行される
- /etc/rc.d/rcX.d/...それぞれのランレベルのS/Kが格納
- /etc/init.d/ ... initで使用する実プログラムの場所


### カーネルパラメータでsystemdを制御
- grub.cnf等に systemd.unit=rescue.targetなどと記述可能
- カーネルはこのオプションを無視する
- systemdによって読み取れる

### systemd起動シーケンス
- 色々なtargetがtargetを呼んで起動している
- どんなランレベルでも`sysinit.target`は起動する
- `resucue.target`以外は，以下を経由する
  - `basic.target`，そのあとに，
  - `multi-user.taget`を経由

### systemdで使われているストレージを見る
- mountユニット
  - ローカルファイルシステムのマウント
  - NFSマウント
- automountユニット
  - オートマウント
- swapユニット
  - スワップ領域

### スワップ領域をfstabに書く
- 起動時に自動的にmountしてくれる
## 3-30
### chkconfig
- RedHat系で/etc/rcX.d/配下にリンクを作る
- chkconfig {serbvice} on
- chkconfig {service} off

### update-rc.d
- Debian系で/etc/rc.X.d/配下にリンクを作る
- update-rc.d service default
- update-rc.d service -f remove

### XFS
- スナップショットは無い
- くそでかいファイルを使える

### ZFS
- Linuxコミュニティのサポートではない
- Btrfsと同じような性能だが，より強力
- 高い信頼性を保有するが，要求メモリが膨大
- RAIDあり．専用コマンド有
  

### ISOファイルを作成する
- `mkisofs`
  - -R...Unix対応
  - -J...Microsoft規格
  - -o...出力先ファイル名を指定
  - -T..Trans.TBLを作成．長いファイル名を作成可能
- 規格
  - Rock Ridge...Unix規格
  - Joliet..Microsoft規格(アメリカのイリノイ州の地名)
  - UDF... Universal Disk Format規格
- `mkisofs -T -J -o filename`

### iso とimgって何が違う？
- iso..CD,DVD
  - パーティションを持たない
  - CD,DVDのフォーマット
  - 最近はUSBに置くこともできる（Hybrid ISO）
- img...CD,imgのファイル

### マウントオプションusers, user
- users
  - 誰でもマウントできる
  - 誰でもアンマウント
- user
  - 誰でもマウント
  - そのユーザのみアンマウント
- usersの方が寛容と覚える

### isoファイルをマウントする 
- `mount -o loop fs.iso /mnt`

### iscsi
- Internet Small Conputer System Interface
  - SCSIをTCP/IPで行う
- ISCSIはストレージとして扱う
- PXEブートローダでは，カーネル，initramfsだけ
  - 全く違う通信
### iscsiの用語
- Initiator
  - ディスクを利用する側
- Target
  - ディスクを提供し，要求に答える
- iqn
  - iSCSI Qtantified Name
  - SCSIデバイスを識別するための番号
  - iqn.yyyy-mm.{domain}:{freename}
- eui
  - Extended Unique Identifier
  - こちらもSCSIデバイスを識別するための番号
  - eui.{preserved ID}
  - IEEEが番号払い出ししてくれる

### iscsi利用までのプロセス
- 1. iSCSIセッションの確立
- 2. SCSIデバイスとしてカーネルに認識(/dev/sdX)
- 3. そのデバイスをマウント

### iscsiadm
- イニシエータ側が接続するためのコマンド
- モードという概念がある
- `iscsiadm -m` が主要
- `iscsiadm -m discovery -r sendtarget -p {ip}`
  - -m discovery で探索モード
  - -r sendtargetで一覧取得．他にもisns(isns nameserver)も指定可能
- `iscsiadm -m node`
  - 探索済みのターゲット情報を表示
- `iscsiadm node --login -p {ip}`
  - ログイン．認証には/etc/iscsi.confを使用

### iscsiで使用するファイル
- /etc/iscsi/
  - descoveryモードで発見したターゲットの保存
- /etc/iscsi.conf
  - このファイルの変更時には，systemctl restart iscsidを実行
  - iscsiadmの設定ファイルが入っている
  - `node.setup = manual`
    - OS起動時に自動でログインしない
  - `node.setup = automatic`

### iscsiにおけるログイン
- 基本はCHAP=ID + Pass
- /etc/iscsi.confに以下を設定
  - node.session.auth.authmethod = CHAP
  - node.session.auth.username =
  - node.session.auth.password = 

### fuser
- lsofと並ぶファイルに対するアクセス者を特定するコマンド
- fuser -v {filename}が基本
  - ファイルを確保しているPID,ユーザ，COMMANDを見せる
### nmap
- ポートスイープに使うやつ
- nmap -p が基本

### tune2fs
- オプション
  - `-l`...スーパーブロックの内容を表示
  - `-L`...ラベルをつける
  - `-j`...ext3ジャーナルに変更

### dumpe2fs
- バックアップの取得コマンドではない！！！
- ext系の形式のファイルシステムの設定を確認
- 基本的にはマウントを外して実行
- `dumpe2fs -h {ext_dev}` ...スーパブロックのみ表示
- `dumpe2fs -b {ext_dev}`...ブロックの使用状態の表示
- `dumpe2fs -f {ext_dev}`...マウント中でも強制実行

### debugfs
- 対話モードでext系のファイルシステムの検証
- オプション
  - -r...読み取り専用で開く
  - -R...一度だけコマンドを実行
  - -f...コマンドが記載されたファイルを実行
- 対話で使用できるコマンド

### ★【40-24】fsckの自動修復
- `fsck -p`

### 【4-29】cryptsetup
- Linux Unified Key Setupの略
- /dev/mapper/{mapper_name}からアクセス
- LUKSは鍵管理と暗号化を実現した仕組み名
- dm-cryptはLUKSの暗号化エンジン
- アクション
  - `cryptsetup luksFormat {dev}`
    - LUKSパーティションを初期化する
  - `cryptsetup lulksOpen {dev} {map_name}`
    - パスフレーズを使用してmapper作成
  - `cryptsetup luksClose {map_name}`
    - mapper削除
    - アンマウントした後に実行
  - `cryptsetup luksDump {dev}`
    - LUKSのヘッダ情報の表示
  - `cryptsetup luksAddkey {dev}`
    - パスフレーズの追加
    - パスフレーズは8個まで
  - `cryptsetup luksRemovekey {dev}`
    - パスキーを削除する
    - 0個にすることもできる（完全削除）
  - `cryptsetup isLuks {dev}`
    - デバイスがLUKSかどうかを判断する

### LUKSディスクレイアウト
- 現行はLUKS2が主流だが、LPICではLUKS1を扱う
- LUKS1
  - ヘッダが固定サイズ
    - マスターキーはここに入っている
  - マスタキー
    - ディスクを暗号化する暗号化キー
  - パスフレーズ
    - データの暗号化には使用しない
  - キースロット(8個)
    - ここにはパスフレーズとセットの鍵
    - この鍵を使用してマスターキーにアクセス

### lsof
- list open filesの略。忘れやすい注意。

### autofs
- オートマウント機能を実行する
- `/etc/auto.master`の内容にそって実行
  - これを変更したら再起動
  - マスタファイルとはこれを指す
- `/etc/auto.{any}`の記載内容に沿ってマウント
  - この部分は編集しても再起動不要
  - マップファイルとはこれを指す
#### マスターフファイル
- 関節マウント
  - `/auto  /etc/auto.misc`等の記載
  - /autoディレクトリを作成する
  - `/etc/auto.misc`ファイルの内容を展開する
  - `etc/auto/share`や`etc/auto/backup`などが展開
- 直接マウント
  - `/-   /etc/auto.direct`
  - マウントトップのディレクトリを作成しない
  - `/mnt/share`や`/home/backup`などが展開

#### マップファイル
- key
  - アクセスされる名称
- オプション
  - fstype=nfs,rwなど
- マウント対象(location)
  - 実際にマウントされるデバイスやリモート共有

#### マップファイルのキー
- 間接マウントの場合は，ディレクトリ名を記載
  - `share`など
- 直接マウントの場合は，絶対パスを指定
  - `/mnt/share`など
#### マップファイルのマウント対象
- ローカルから見えるマウント対象
  - :dev/sda1
  - :dev/mapper/vg0-1v_data
- NFS
  - sever:/export/share
  - mfssserver:/home
- CIFS/SNB
  - //fileserver/share
- SSHFS
  - user@host:/data

## 5章
#### mdadm
- モード
- Assenble..作成済みRAIDアレイの情報参照(-A)
- Create...新規に作成する（-c）
- Manage...デバイスの追加，削除
- Monitor...定期的な確認(-F,--follow,--monitor)
- Misc...そのほか

#### mdadm マネージオプション
- mdadm -add (md) (dev)
- mdadm -fail (md) (dev)
- mdadm -remove (md) (dev)

#### mdadm設定ファイル
- /etc/mdadm.conf

#### mdadmの状態観測
- /proc/mdstat

#### udevadm
- udevの管理コマンド
  - udevはコマンドではない
#### udevadmの設定ファイル
- デバイスをマウントする条件を決める
  - `/etc/udev/rules.d`

#### テープデバイスの仮想ファイル
- /dev/st0...作業後にテープを巻き戻す
- /dev/nst0...作業後に巻き戻さない

#### 仮想devファイルに対する情報の取得
- /dev/disk/{file}
- 主要なファイル
  - by-uuid
  - bu-path
  - by-dname　など

### hdparm
- オプション
  - -l...設定の一覧表示
  - -t...読み込み時の転送速度計測
  - -A...先読み機能を利用(0でオフ，1でオン)
    - read-ahead
    - 要求された少し先のブロックも一緒に読み込んでキャッシュに乗せる
  - -d...DMAモードの利用
    - Direct Memory Access
    - デバイスがメモリを直接転送
  - -W...書き込みキャッシュの利用
#### hdparm,sdparm
- hdparm...ATA系デバイス(ATA,SATA)
- sdparm...SCSI系デバイス（SCSI,SAS,USB-SCSI）



## 6章
#### ifconfig
- オプション
  - -a...停止しているインタフェースも表示
  - -s...短縮系で表示
  - -V...ifconfigのバージョンを表示
- インタフェース操作
  - `ifconfig eth0 up`など
  - up...起動
  - down...停止

#### インタフェースフラッグ
- そのインタフェースがどういう状態か示す
- `UP`...起動中，ダウンしている場合は，何も表示しない
- `LOOPBACK`...ループバックインタフェース
- `BROADCAST`...ブロードキャスト受信が有効
- `RUNNING`...データリンクのリソースを確保する
- `MULTICAST`...マルチキャスト受信

### 【6-4】2番目のIP設定におけるifconfig vs ip addr
- セカンダリIP付与などと呼ぶ
- `{ethX}:{lebel}`という書式はifconfigでしか使用しない
- 実の所，labelは表示上の制御でしかない
- `ifcofig eth0:{label} XX.XX.XX.XX`はOK
- `ip addr add {ip} dev eth0`もOK．
  - ちゃんとセカンダリとして割り当てられる
- `ip addr add {ip} dev eth0 label eth:0:0`
  - この書き方もできるが非推奨

#### 無線ネットワーク関連のコマンド
- iw
- iwconfig
- iwlist

#### 物理デバイス(phy)，デバイス(dev)
- phy...チップそのもの
  - 電波，周波数，出力を管理
  - `iw phy`で見える
  - チップが何ができるかを表示する
  - L1(物理層レイヤの情報)
- dev...OSから見えるネットワークインタフェース
  - アップダウンする対象
  - OSが扱う
  - IPを持っている

### 【6-19】特定ドメインの特定ポートを検証する
- nc,telnet

### 【6-22】ルートテーブルのフラッグ
- arpじゃないよ！IPとIPの通信
  - ip route addで追加
  - DHCPのOption
  - OSPF/RIP/BGP
- Flags
  - U...有効
  - H...宛先がホスト
  - G...ゲートウェイに送信
  - I...経路が無効
  - !...送信の拒否，転送をしない

### routeコマンド
- このコマンドはメモリ上のroute tableに対する操作
- なので，再起動で消える
- `route -n`...テーブルの確認
- `route add -net X netmask X`...テーブルへのネットマスク有の追加
- `route add -host X` ... 単一ホストへの転送．Hフラグが付く
- `route add default gw X` ... これには -netや-hostは必要ない
   - `-net 0.0.0.0 netmask 0.0.0.0 gw X`
- `route del -net X netmask X`
- `route del -host X`
   - ★`ip route del` の場合は，netやhostは必要ない

### ipコマンドにおけるルートの追加
- `gw`ではなく，`via`になる
- シンタックス上は`ip route X gw Y`でも可能だが，LPICでは認めない
- `via`修飾子を手前に持ってきてもいい
  - `ip route add via {gw} {ip/prefix}`
  - ★ routeではこの記法は認められない
  - さらにデフォルトゲートウェイの指定はipを省略可
  - `ip route add via {defaultgw}`
### 【6-31】ip route showの見方
- metric... 低い方が優先される
- リンクダウンしていないか確認すること
  - ethXに対して，linkdownステータスが見えているしている場合は，そのENIはダウンしている可能性が高い

### ホスト名の解決
- `/etc/nsswitch.conf`のhosts:XXXに従う
  - ここの設定項目は先に書かれたものを優先する
- `hosts: files dns`と記載した場合，
  - `/etc/hosts`を参照
  - その後，`etc/resolve.conf`のdnsに聞きに行く

### hostコマンド
- digと似たようなコマンド
  - digはdnsに対して検索を実行する
  - `/etc/hosts`の内容を見ない
- hostコマンド
  - こちらもdnsに対して問い合わせする
  - 他のレコードを持ってこないのでシンプル
  - `host {hostname}`...ホストネームからＩＰ検索
  - `host {ip}`...IPからホストを検索

### オンラインストレージ管理コマンド
- cifsiostat
  - common internet filesystem io statistics
  - SMBのこと．CIFSとも呼ばれていることから
  - 代表的にはSAMBAサーバを使用する
- nfsstat
  - network file server statistics
- nfsiostat
  - network file io statistics


### 7章
- Linuxの一般的なアプリケーションの構成
### Autotools
- アプリケーションの開発者がセットアップのために使用する
- 開発者は，configureというファイルを出力してパッケージに入れる
- 配布後，ダウンロードしたユーザはこれを実行する
- CMakeでは，CMakeList.txtと命名されていたりする．
- ★ Linuxのソースコードではこの方式ではない
  - `make menuconfig`などを利用する

### automake
- Makefileを作るためのMakefile.inを作成するツール
- 設定ファイルは`Makefile.am`
- 
### LVMにおけるPV,LG,LVの配置

### 主要なポートとプロトコル



cryptsetup