# 最後の見直し用
### 【1-9】
- sar
  - -A...全統計
  - -r...メモリ
  - -d...ストレージデバイス
  - -b...各ブロックストレージ
  - -n...ネットワーク。DEV
  - -u...CPU統計
  - -P...CPUコア
- sar
  - -o...出力ファイル
  - -f...入力バイナリファイル
- /var/log/sa/saDD


### 【1-12】
- Nagios...ネットワーク上のホストの状態を監視。結果をブラウザにグラフ表示
- MRTG...Multi Router Traffic Graoher。グラフ画像をWebサーバから見る。SNMP
- Cacti...RRD(Round Robin Database)形式のデータでブラウザにグラフ表示。SNMP
- Icinga2...オープンソースネットワーク管理ツール
- colledctd...システムの統計情報を収集し、結果をRRDファイルに保存
- iptraf(iptraf-ng)...TUI方式のモニタ。TCP,UDPとネットワークI/Fを見る。ローカルの監視のみ

### 【2-2】
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
  - LTSはこいつのこと
  - 3.2.87など
  - 2年程度の保証期間
  - これは明示的に保証しているわけではないので注意

### linuxカーネルのソースコードの配置
- `/usr/src/linux`


### 【2-12】zImage,bzImage
- 圧縮はgzip。
- cpioは、initramfsの方


### 【2-20】　sysctlは何を変更するか？
- `/proc/sys/`配下のディレクトリ


### 【2-30】modules.dep
- 依存関係はここに書いてある

### 【3-3】grubの設定ファイルの作成方法
- grub legacy
  - /boot/grub/grub.conf
  - /boot/grub/menu.lst
- grub2
  - /boot/grub/grub.cfg
    - /etc/grub.d/を参照
    - grub2-mkconfigで生成

### 【3-5】grubが確認するデバイス情報が書いてある場所
- /boot/grub/device.map

### 【3-7】efibootmgrの出力内容
- BootCurrent:{num}...現在ブート中のエントリ
- Timeout: {cnt}...UEFIの待機時間
- BootOrder...ブート順
- Boot0001,0002 ...ブートのエントリと、名称

### 【3-17】PXEのboot事情
- /bootが存在しないイメージ
- TFTPを使用して、一部のefiファイルのダウンロードを実行
- カーネルと、initramfaをダウンロードしてメモリに展開
- つまり、ストレージが0GBでも原理上は動作する
- 
### 【3-19】色んなinit
- (initramfs)init
- /sbin/init
- /etc/inittab
- /etc/init/init.d/
- /etc/init/rc.d
- /etc/rcX.d/

### 【3-29】chkconfig
- RedHat系の/etc/rcN.dの管理
- chkconfig {} on
- chkconfig {} off
### 【3-30】update-rc.d
- Debian系の/etc/rcN.dの管理
- update-rc.d {} defaults
- update-rc.d {} remove

### 【4-8】mkisofs
- フォーマットオプション
  - -R...Unix(POSIX)に対応するRock Ridge
  - -J...WindowsでよめるJoliet
  - -T...長い名前を使用可能にするTransaction Table
  - ※ フォーマットは全部大文字

### 【4-18】プロセスが抱えているファイル
- lsioじゃない！
- lsof(list open file)

### 【4-19】fuser

### 【4-20】tune2fs
- eは一個でいい

### 【5-4】mdadmの設定ファイル
- 起動時の自動組み立て構成や
- メール通知の設定が含有
- `/etc/mdadm.conf`が一般だが，配置は決まっていない
- ルートファイルシステムをRAIDに乗り上げつ場合
  - initramfsにmdadm.confを入れることもある

### RAIDの通称名
- RAID0...ストライピング
- RAID1...ミラーリング
- RAID5...分散パリティ
- RAID6...ストライプド・ミラー

### 【5-19】udevadm
- `udevadm monitor`
  - デバイスの追加，削除，変更を監視

### 【5-20】テープストレージ
- /dev/nst0
  - No Rewind SCSI Tape Device
- /dev/st
  - SCSI tape Device


### 【5-24】 hdparm
- IDEデバイスのパラメータ観測
- オプション
  - -l...詳細を表示
  - -t...読み込み時の転送速度を測定
  - -A...先読み機能
  - -d...DMAモード
  - -W...Write Cache

### 【5-25】sdparm
- SCSIデバイスのパラメータ

### libata
- こいつのおかげで現在はIDEデバイスでもSCSI互換性がある


### 【6-32】tracerouteが使用するプロトコル
- ICMP
- UDP




chkconfig Redhat

chkconfig sshd --level 1 on 
update-rc.d sshd defaults/remove



