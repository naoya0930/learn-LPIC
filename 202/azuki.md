# 1. DNS

### BINDの設定ファイル
- /etc/named.conf

### named.confバージョンの書き方
- といあわせじの戻り値
- ダブルクォーテーションで指定する
- options {...version = "0.0"}
- unknownとか書いたりする

### named.conf typeの書き方
- `zone "" IN{}`情報に対する記載
- 後続するfile がどんなファイル化説明する
- type master;
  - fileは正引き、もしくは逆引きの正しいゾーン情報
- type hint
  - fileはマスタDNSサーバによって編集されるゾーンファイル

### DNSチェックする系のコマンド
- named-checkconf
- named-checkzone
- named-compilezone -o dump

### ゾーンファイルサンプル
```
$TTL 86400      ; デフォルトのTTL（1日 = 86400秒）
$ORIGIN example.com.

@   IN  SOA  ns1.example.com. root.example.com. (
                2026053101 ; シリアル番号
                3600       ; リフレッシュ（1時間）
                900        ; リトライ（15分）
                604800     ; 有効期限（1週間）
                1200       ; ネガティブキャッシュTTL（20分）
             )

; --- 共通レコード（デフォルトの1日キャッシュが適用） ---
; --- 共通レコード（デフォルトの1日キャッシュが適用） ---
; [ホスト名] [TTL値] [クラス(IN)] [レコードタイプ] [ターゲット]
@   IN  NS   ns1.example.com.
ns1 IN  A    192.168.1.10
www IN  A    192.168.1.100

; --- 個別TTLレコード（この行だけ1分キャッシュに上書き） ---
api 60  IN  A    192.168.1.200
```

### ゾーンファイルのTTL,ORIGINの書く場所
- TTLの書き方
  - 各レコードに記載する
  - $TTLとして指定する
- ORIGINの書き方
  - 行に指定は無い。ORIGIN以降のレコードに追記。
  - 新しくORIGINを書けば、以降のORIGINを上書き
  - dotの終わらない名前の右に追加

### ネガティブキャッシュTTL
- SOAレコードの最後に付帯する。
  - シリアル番号
  - リフレッシュ...スレーブがマスタに聞きに行くまでの時間
  - リトライ...リフレッシュ失敗時の再実行
  - 有効期限...リフレッシュに失敗続ける場合のレコードの有効期限
  - ネガティブTTL...forward後、解決できなかったレコードの保有時間

### ゾーンファイルSOAレコード
- ` @   IN  SOA  ns1.example.com. root.example.com. (...`
- 内容
  - オリジン
  - クラス（インターネットクラス）
  - SOAの宣言
  - マスタDNSのサーバ名。ゾーンファイルを編集する場合、そのサーバ名を書く。
    - ここを見てスレーブサーバは問い合わせに来る。
    - NSレコードとしても記載する必要あり。
  - 管理者のメールアドレス

### サブドメインの委任
- sample.main.com NS ns.sample.main.com
- ns.smaple.main.com A X.X.X.X
- NSレコードと、その委任先のAレコードを記載する必要がある。

### bindの制御コマンド
- `rndc`...remote name daemon control
- 主なコマンド
  - rndc status
  - rndc stop
  - rndc reload
  - rndc dumpd