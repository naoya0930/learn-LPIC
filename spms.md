# 1章
# スピマス 201
#### top vs htop
  - htopの方がカラフル
#### topで見えているCPUの情報
- us...アプリ負荷。ユーザ負荷
- sy...カーネル処理
- ni...nice time
  - nice値がデフォルトではないプロセス時間
- wa...I/O待ち
- id...余力
- hi... hardware interrupt
- si... software intetrrupt
- st...仮想化環境に貸出


### アプリパッケージ豆知識
- sar, sadf ... sysstat
- vmstat ... procps
- netstat　... net-tools
- cifsiostat, iostat, mpstat, pidsatat...sysstatc

- sysstatはシステムの性能評価
- net-toolsは設定の変更を実施


### sar デバイスに関する情報収集
- sar -b...ブロックデバイスのI/Oに関する情報を戻す(block I/O)
  - tps...1sあたりのI/Oリクエスト数
  - rtps...1sあたりの読み取り操作数
  - wtps...1sあたりの書き込み操作数
  - bread/s...1sあたりのブロックリード数
  - bwrtn/s...1sあたりのブロックライト数
  - 類似なコマンド
    - iostat
    - vmstat
- sar -d...ブロックデバイス自身の統計を戻す(device)
  - tps...デバイスに対するI/O
  - rd_sec/s...1sあたりに読み取られたセクタ数
  - er_sec/s...1sあたりの書き込みセクタ数
  - avgrq-sz...1回のI/Oの要求の平均セクタ数
  - avgqu-sz...I/Oの詰まり状態
  - await...処理を含むリクエストの待ち時間
  - svctm...デバイスが実際に処理している時間
  - %util...デバイス稼働率
  
### sar 主要なオプション

- sar [option] [interval_sec] [count]
  - インターバルの回数、countの回数だけ実行する
- オプション
  - -o {filename}...格納するファイルの形式。
    - 何も指定しないと`/var/log/sa/saDD`
  - -f {filename}...表示するファイル形式
    - 何も指定しないと`/var/log/sa/saSS`
- sarで表示する内容を選択する
  - -A...すべての統計を表示
  - -r...メモリの情報を表示
  - -b...ブロックIOに関する情報を表示
  - -d...デバイスファイルごとの情報を表示
  - -n [key or ALL]...ネットワークに関する情報を表示
  - -P [core_No | ALL]...CPUコアごとの情報の表示

### saの定期実行
- sar...ログファイルの読み出し
- sa1...書き込む操作を実行
  - cronによって実行
  - これはバイナリ形式で書き込みを実施
- sa2...日時で集計する
  - `-A`で平均などの統計値を生成する。
  - ここで生成されるのはテキスト形式c

#### iptraf
- TUI環境におけるNWモニタリング
  - TCP/UDPパケットのモニター
  - ネットワークIFの統計情報 


# 2章
### Linux基礎知識
- 「Linuxのカーネルのモジュール」
  - これはコンパイル時に組み込まれたOSのこと
- カーネルの歴史
  - 2.6系...X.X.X.Xの四桁だった。最終は2.6.39.4
    - 偶数は安定版、奇数は開発版と言われていた
  - 3.0系...X.X.Xの三桁。
    - X.X-rcXは、Release candidates,開発版。
      - ここが一番頻繁に動いている
    - X.Xはmainline
    - X.X.Xはstablelineと呼ばれる
### ソースコード関連
- `/usr/src/linux`配下
  - ドキュメント関連はDocumentationディレクトリ配下

### Linuxソースコードに含まれるモジュールの配置
- どこかにまとまって入っているわけではなく、散らばっている
- /usr/src/linux/fs/
  - ファイルシステム
- /usr/src/linux/net/
  - ipv4などのネット
- /usr/src/linux/drivers/
  - USB,グラフィクス、SATA,m.2マウント
- /usr/src/limiux/drivers/wireless/
  - 無線LAN

### Linuxをビルドする
- makefileスクリプト(makeコマンド)のフローの中で、.configが作成される
- 主なターゲット
  - make all
    - vlinux,modules,bzimageを生成
    - 引数を指定しないとこれ
  - make mrproper
    - 以前の生成物を削除する
  - make zImage
    - 古い圧縮イメージを生成
  - make bzImage
    - 新しい圧縮イメージを生成
  - make modules
    - すべてのカーネルモジュールを生成
    - vlinuzは生成されない
  - make modules_install
    - 生成したモジュールをインストール
    - /lib/modules/{version}/配下に移動
  - make rpm-pkg
    - カーネルのソースとバイナリをrpm
  - make binrpm-pkg
    - カーネルのバイナリのみをrpm
  - make deb-pkg
    - カーネルをdevpkgとして生成
- 結局何をすればいいの？
- 1. 設定ファイルの作成
  - `make memnuconfig`, `make config`, `make xconfig` `make gconfig`, `make defconfig`　など
- 2. `make`
  - .configに従って、ビルドを実行。
  - ここでは正規の場所には置かれていない。
- 3. make_modukes_isntall
  - モジュールを/lib/modules/に移動
  - modules.depが生成。これはinitramfsに参照される
- 4. make install
  - カーネルを/boot 配下に移動する
  - vlinuzが後でないと、ここで作成されるinitramfsの参照が壊れる

### configファイルの作成いろいろ
- make config...古い
- make menuconfig...TUI
- make nconfig...TUI
- make xconfig...Qt GUIベース
- make gconfig...GTK GUIベース
- make defconfig...アーキテクチャに沿ったデフォルトの設定を生成


### 古いconfigを利用する
- 現存のconfigをコピーしてから、`make oldconfig`
- 1. cp /boot/config-{version} /usr/src/linux/.config
- 2. make clean...以前の生成ファイルを削除する。ただし、.configは削除しない
- 3. make oldconfig...既存のカーネルの構成を記載したファイルを.ベースに新しく、.configを作成する。新設された設定に関しては、随時尋ねられる。


### DKMS
- Dynamic Kernel Modules Supports
- カーネルのモジュールを自動的にアップデートしてくれる仕組み
- apt upgradeや手動でのカーネルバージョンアップにも対応している

### zImage,bzImage
- 圧縮カーネルのサイズが関係してくる。
- zImageは512KB,bzImageはそれ以上のサイズも可能

### カーネルのバージョンアップのためのパッチファイル
- patch-X.XX.yyyが配布されている
- この差分は、/usr/src/linux-X.XXからの差分
  - 直前のバージョンからの差分ではない!


### カーネルに対するパッチ専用スクリプト patch-kernel
- バージョンアップ以外のパッチファイル
- バージョンに変化はない。
- 稀にカーネルをダウンロードすると付いてくる
- /usr/src/linux-{version}/patch-kernel

### カーネルメモリ内のパラメータの値を一時的に変更する
- 稼働中のカーネルパラメータを変更する
- 1. `sysctl`が使える
  - オプション
    - `sysctl -a`...現在利用できるすべてのパラメータを表示
    - `sysctl -p`...指定したファイルから設定を読み込む(/etc/sysctl.conf)
    - `sysctl -w kernel.{PARM}={VALUR}`...パラメータを更新する
- 2. 仮想ファイルに直接echoしてもよい
  - `echo {val} > /proc/sys/kernel/{PARAM}`

### カーネルメモリのパラメータを恒久的に変更する
- /etc/sysctl.confを変更する
- `sysctl -p` はこのファイルを参照している。


### /proc/sys/以外の設定のカテゴリ
- kernel.hogehoge以外にも色々ある
- これらもsysctlで管理できる
- sysctlパラメータ
  - net.
  - vm.
  - fs.
  - dev.
  - netfilter.

### initramfsの構成
- 起動時にメモリに読み込まれるルートファイルシステム
- 本来のマウントポイントを確立するまで使用される
- initramfs.imgという形で見えるが、gunzip圧縮+cpioのアーカイブが入っている。
- なので直接マウントできない
- `file initramfs.img`...圧縮方式の確認
- `unzip initramfs.img initram.cpio`...圧縮の解答
- `cpio -id< initramfs.cpio`...アーカイブの展開


### initramfsの作成

- make installの実行
- apt upgrageの実行
- mkinitrdの実行
- dracutの実行

### initramfs vs initrd
- initrd
  - ループバックデバイスとしてマウント必須
  - 現在では廃止
  - `mkinitrd`はinitramfsファイルをはじめから作成するになった
- initramfs
  - gzip + cpioファイル
  - カーネルによって展開され、tmpfsに展開される
### mkinitrd
- ちょっと古い
- `mkiintrd [option] [生成ファイル名] [kernelversion]`
- オプション
  - --with {module}...モジュールの追加
  - --preload {driver}...追加ドライバ
### dracut
- 汎用的で最小限のinitramfs
- `dract {option} [生成ファイル名] [カーネルver.]`
- `dract --hostonly`
- オプション
  - `--add {module}` 指定モジュールを追加
  - `--omit {module}` 指定モジュールを除外
  - `--hostonly` 現在の環境で必要なモジュールを入れる
  - `--mount` テストのための仮想マウント



### modinfo
- モジュールの情報を表示する

### modprove
- 何も指定しないとload
- --removeや-rを使用するとunloadする

### モジュールの依存関係
- /lib/modules/{kernel version}/modules.dep
- `depmod`によって管理が実施されるが覚えなくてOK

# 3章
### grub legacy
- `/boot/grub/grub.conf`
- 旧式のブートローダ、MBR限定。
- 記入例
  - root (hd0,0)
  - kernel /boot/vmlinuz-version root=LABEL=/ dev_name=sda1
  - initrd /boot/initrd-version.img
### grub2
- `/boot/grub/grub.cfg`
- 新式のブートローダ
- ブートステージの、1.0 , 1.5 , 2.0という概念がなくなっている
- 