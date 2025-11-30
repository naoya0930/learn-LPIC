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
###
