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


### 