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
- 3. make_modules_isntall
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

- 設定ファイル`/boot/grub/grub.cfg`
- 記入例：
  - set root=(hd0,1)
  - linux /vmlinuz root=/dev/sda1 ro single
  - initrd /initrd.img

- 新式のブートローダ
- ブートステージの、1.0 , 1.5 , 2.0という概念がなくなっている
- boot，core等の概念に分かれている
- 段階的な実行を想定している
- MBR
  - core.img
  - boot.img
- UEFI
  - efiファイル

#### GRUB起動後
- 1. カーネル解凍
- 2. カーネル初期化
- 3. initramfs解凍
- 4. initramfsのinit実行(ここでファイルシステム)
- 5. /sbin/initの実行
- 6. /etc/inittabの参照(SusVinit)
- 7. レベルに従ったプロセス...


### ブートローダにおけるディスク，パーティションの読み取り
- /boot/grub/device.map
- GRUBインストール時に生成
- UEFIでは不要


### カーネルパニック
- カーネルが起動時に実行する手続きが失敗すると発生
- 再起動するしかない
- 原因
  - ルートファイルシステムが壊れている（initが起動できない）
  - ドライバ，プラグインの故障
  - アプリケーションの衝突（仮想化ソフトなど）
  - メモリの不備
  - リソース不足

### SMP
- Symmetric Multiprocessing
- 複数のCPU,CPUコアを使用する動作
- これを無効化すると，シングルコアで動作
- grub.conf,gtub.cfgなどで以下を指定
  - `nosmp`
  - `maxcpu=1`

#### initramfsって何してんの？
- こいつはgzip + cpioでRAMに展開される
- initが実行され，カーネルを起こすのが仕事
- 1. bin/mknodコマンドで，デバイスファイルを作成
- 2. bin/mkdirコマンドで必要なディレクトリ作成
- 3. bin/mountで/procなどの仮想ファイルをマウント
- 4. bin/mountで，/sysmountにルートを付与
- 5. /sbin/switch_rootでルートを渡す．

#### Syslinuxプロジェクト
- bootroaderを開発している所
- 全部大文字のブートローダはそれ
- SYSLINUX
- ISOLINUX
- EXTLINUX
- PXELINUX

#### inittab
- SysVinitにてinitから参照されるファイル
- 各ランレベルで何を起動するのか指定している
- ここでもデフォルトのランレベルを指定できる
- `id:3:initdefault:`
  - ただし，ブートローダで指定がある場合はそちら優先


#### systemctl ランレベルに相当するターゲット
- default.target
- poweroff.target
- rescue.target
- multi-user.target
- graphical.target
- reboot.target

- systmd.unit ={target}
  - これでも変更できる
journalctl


### systemd-deltaコマンド
- 設定の変更点と上書きを検出する


#### オートマウント
- リムーバルディスクに対して必要な時にマウントする
  - メモリ領域の削減を狙う
- 実行はmountコマンドでマウントしないで実行すること
  - `systemctl start autofs`
  - systemctlを使用しているなら`.automount`ユニットでもよい

#### /etc/rcX.dの優先度
- まずK00{process}が優先される
- ここからK99までを実行．
- 次にS00{process}が優先される

#### rc内を管理する
- RedHat系...chkconfig
- Debian系...update-rc.d {サービス名} 

#### btrf
- `btrfs filesystem {command}`
  - show...ファイルシステムの情報を表示
  - df...ファイルシステムの使用状況を表示
  - lebel...ファイルシステムにラベルを設定
  - resize...ファイルシステムのサイズを変更
- `btrfs subvolume {command}`
  - create　{dir}...サブボリュームを作成
  - delete {dir}...サブボリュームを削除
  - list...サブボリュームを一覧表示
  - snapshot...スナップショット作成
  - show...サブボリュームの情報を表示
- サブボリュームの基本性質

#### XFS
- くそでかサイズのファイルが扱える
- xfs_infoやxfs_dbなどのコマンドから操作

#### ZFS
- Oracleが開発
- RAID等の冗長性を持っている

#### mountコマンド
- 以下の2つで挙動が変わる
  - `mount {マウント先}`
  - `mount {dev_file} {マウント先}`
- 1つ目は，/etc/fstabを参照する．これは/fstabのオプションが適応
- 2つ目は/etc/fstabを見ないので管理者でないと実行できない

#### /etc/fstabオプション
- users...一般ユーザにマウントを許可．アンマウントはユーザのみ許可
- user...一般ユーザにマウントを許可．アンマウントは誰でも可能
- default...rw,suid,dev,exec,auto,nouser,async

#### loopbackマウントする
- mount -o loop {iso,img} {entry}
- --loopとかないので注意！

#### 現在のマウントの確認
- mount
- cat /proc/mounts
- cat /etc/mtab
  - 今マウントしているファイルシステムの情報
  - Mount table
- ※ ftabは設定なのでダメ，file system tabの略らしい．

#### iscsiなどのネットデバイスのマウント
- 専用のサービスの起動が必要
- 先にローカルのモノをマウントするようにRCスクリプトを構成
- mount -a -O no_netdev
- mount -a -O _netdev

#### fuser
- ネームスペースに対する検索
- lsofと似た感じで使用される
  - 何かのプロセスがファイルにアクセスしている状態を検出

#### ext2から3の変更
- オプションは小文字のｊ


#### fsck主要なオプション
- 何も指定しないと，/etc/fstabに沿って検査
- -t...ファイルシステムタイプの指定
- -b...スーパーブロックを指定する
  - ブロックに関するデータ．ブロック間毎に記載がある
- -f...強制
- -p...pcreen．軽微なエラーは自動的に直す
- -n/-y...質問にno/yesと回答

#### fsckのチェック結果
- 参照カウントが1以上のはずが，どこからも参照されてないデータを保管する

#### Linux暗号化ファイルシステム
- EncFS...ファイルの暗号化を実施
- eCtyptfs...ファイルの暗号化を実施
- loop-AES...ファイルをブロックデバイスとして暗号化
- LUKS...ブロックデバイスを暗号化．dm-cyptを使用する
  - cryptsetup

#### LUKS関連コマンド
- cryptsetup luksFormat {dev}...暗号化する
- cryptsetup luksOpen {dev} {name} ...mapper作成
  - mapperのエンドポイントにファイルシステム作成
- cryptsetup luksClose {name} ...mapper削除
- cryptsetup luksDump...LUKSデバイスのヘッダを表示
- cryptsetup lsLuls...LUKSデバイスかどうかを表示

#### automount設定ファイル
- auto.master


# 5章
- RAIDの構成
- mdadmコマンドから実施

#### RAIDの確認
- cat /proc/mdstat
#### LVM
- tune2fsではextファイルシステムの拡張できない

#### udev, udevadm
- udev
  - /etc/udev/rules.d/
    - ここに従ってdevファイル作成
    - カーネルロード
    - 編集可能
  - /lib/udev/rules.d/
    - 編集不可能
- udeadmコマンド
  - udevの監視
  - オプション
    - udevadm info
    - udevadm trigger
    - udevadm settle
    - udevadm control
    - udevadm monitor
    - udevadm test

#### SCSIテープドライブdevファイル
- /dev/st0...テープを戻す
- /dev/nst0...テープを戻さない

#### dev/disk
- デバイスを特定するためのリンクを格納
- /dev/disk/by-uuid
- /dev/disk/by-label
- /dev/disk/by-id
- /dev/disk/bt-path


#### hdparm
- hard disk parameter
- ハードディスクの計測ができる
- オプション
  - -i...詳細表示
  - -t...転送速度計測
  - -A...先読み機能OFF(0)/ON(1)
  - -d...DMA機能
  - -W...書き込みキャッシュ機能

### 仮想インタフェースに2個目のIPをセットする
- `iconfig eth0:1 XXX.XXX.XXX`
- eth0:1...これをラベルと呼ぶ
- この1の部分は何でもいい．英数字が可能
- `ip addr add {ip/mask} eth0`
- `ip addr add {ip/mask} eth0 label X`
- ipコマンドの場合は，ラベルなしでも2個目可能

#### 無線
- iwconfig
- iwscan

#### ipコマンドでARPを表示する
- 以下のどれでもいい
  - ip neigh
  - ip neighboer
  - ip n

#### nmap
- ポートスキャンする

#### ポートを指定したリクエスト
- telnet [host] [port]
- nc [host] [port]

#### tcpdによるフィルタ
- /etc/hosts.denyもしくはhosts.allow
- サービス名：ip(レンジ)
- sshd:172.158.0.0
- レンジを指定する場合
  - プレフィクス表示はNG，/16など
  - サブネットマスクはOK/255.255.255.0など
  - IPを途中で切ってもOK 192.168. など