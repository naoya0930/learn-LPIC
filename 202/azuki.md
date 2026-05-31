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

### TSIG
- Transaction Signature
- マスタスレーブ間の保護
### DNSSEEC
- 親子関係の保護
- ZSK,KSKを使用する

#### TSIG鍵の生成
- 古い方法 `dnssec-keygen -a HMAC-MD5 -b 512 -n HOST tsigkey`
  - `-n HOST`でTSIG用のキーを作成する
  - こちらはdnssecの鍵生成専用のコマンドになった
  - `-n ZONE`を指定すると、DNSSEC用の鍵を生成する
- 最近の方法 `tsig-keygen -a edsa356 example.com`
- TSIGの鍵は`named.conf`にベタガキできる。ハッシュなのでそんなに長くない

### DNSサーバ色々
- BIND
- dnsmasq
  - プライベートネットワーク向き
- djbdns(Daniel Julius Bernstein DNSのことらしい。)
  - コンテンツDNSサーバ=権威DNSサーバ向き
- PowerDNS
  - バックエンドにデータベースを持っている

# Webサービス

# retry
### いろんなport
- Apache http
  - Port XX...(古い。これだと一つしか指定できない。)
  - Listen XXX...新しい。複数指定できる。(2.2以降)
- squid
  - http_port...フォワードプロキシの受付ポート
- nginx
  - listen...リバースプロキシの受付ポート
- bind
  - listen-on
- Openssh
  - Port

### httpdエラーに関する設定
- ErrorLog...エラーログのパス
- ErrorDocument...失敗の通知画面

### httpd覚えるディレクティブ
- `DocumentRoot "/var/www/html"`
  - 公開する親ディレクトリ
- `DirectoryIndex xxx.php sample.html`
  - ユーザがルートにアクセスしたときにそのファイルに飛ぶ
  - Options Indexes より優先される
  - 左から右に探す
  - ここに記載する時は親パスは書かなくて良い
- `Options -Indexes `
  - ファイル一覧機能
  - Options +Indexesで有効化、Options -Indexesで無効化
- IndexesOptions
  - Option Indexesによって描写される描写方法の補足
  - 有効にする場合は、フォント情報などを入れる
  - 例：`indexOptions FancyIndexing`
- `<Directory "var/www/html/source">`
  - フォルダに対して権限や、ルールを指定する
  - ここでの指定は、DocumentRootに依存しない。
  - Aiasにて転送した後の設定にも使用できる。
  
### optionディレクティブ
- Options Indexes...インデックスを出すかどうか
- Options FollowSymLinks
  - ドキュメントルート配下のシンボリックリンクの有効化
- Options SymLinksIfOwnerMatch
  - `シンボリックリンクの所有者`と`リンク先のファイルの所有者`を比較
- Options MultiViews
  - 拡張子を省略したアクセスに対して、補完して結果を表示する


### httpdコマンド
- httpd -v ...バージョン
- httpd -t ...設定ファイルの構文チェック
- httpd -M ... APacheにロードされているモジュールを出力a
- httpd -S ... バーチャルホストを一覧化
- httpd -l ... DSO以外の本体への組み込みモジュールを表示

### apachectlコマンド
- apachectl start
- apachectl stop
- apachectl restart ... 強制的に再起動
- apachectl graceful ... 安全に再起動を実施
- apachectl configtest ... 設定ファイルの確認
- apachectl -t ... 設定ファイルの確認


### 外部参照ファイル
- システム起動時にファイルを持ってくる制御
  - `Include conf.d/*.conf`
    - コピーして貼り付けるような形。
  - `IncludeOptional conf/modules.d/*.conf`
    - 引用時にエラーが出た場合はincludeせずに無視する
- ユーザアクセス時に起動する(.htaccesの制御)
  - `AllowOrverride All`
    - .htaccesが変更できる権限を決める
    - 例：`AllowOrverride AuthConfig Options`
### そもそも.htaccessって何？
- `AccessFileName .htaccess`で定義される外部設定ファイル
- `<Directoy "/var/sampe/images">`などのディレクトリ配下に配置する
  - 設定ファイルの臨時の書き換えを実行する

### basic認証
- ここで使用するユーザはapache用に使用することが一般的
  - `AuthUserFile "dir"`によって判断する
  - モジュール入れれば、/etc/passwdや/etc/shadowも参照できる
- 下記のいずれかで定義する。最近のapacheでは下記が主流。
  - Require ... user,group,valid-user(認証の要求)
  - RequireAll{}...全てにマッチすれば真
  - RequireAny{}...いずれかにマッチすれば真
  - RequireNone{}...どれにもまっちしなければ真
- 昔のapacheでは下記
  - satisfy Any|All...2つの条件に対して、両方、片方の認証で通すか？
  - Order Deny,Allow...条件に該当しないメンバを許可
  - Order Allow,Deny...条件に該当しないメンバを拒否

### 上記の記法の違い
- 根本的にあるのはセキュリティモジュールの拡張が原因
- `LoadModule mod_auhz_core_module`した場合
  - `Allow from All` -> `Require all granted`
    - すべてのユーザからのアクセスを受領する
  - `Deny form All` -> `Require all denied`
    - すべてのユーザからのアクセスを拒否する
- `LoadModule mod_authz_host_module`した場合
  - require句に以下が追加できる
  - `require ip XXX.XXX`
  - `require host name.com`
  - `require local`
  - IP制限において、下記が必要なくなる
    - Order 
    - Allow from
    - Deny from

### basic認証用のユーザ、パスワードを作成
- `htpasswd`
- `htpasswd -c /var/www/htpasswd user1`
  - パスワードファイルを新規で作成してユーザを作成
- `htpasswd /var/www/htpasswd user2`
  - 既存のファイルにユーザを追記
- `htpasswd -D /var/www/htpasswd user1`
  - 削除
- `htpasswd -n user1`
  - 標準出力に出す

### クライアント証明書を要求する
- SSLVerifyClient
  - SSLVerifyClient require...必須で要求する
  - SSLVerifyClient optional...なくても良い

### サーバ証明書を利用する(SSL)
- 以下3つの有効化が必要
  - SSL Engine on 
  - SSLCertificateFile xxx.crt ... 公開鍵
  - SSLCertificateKeyFiile XXX.key...秘密鍵

### VirtualHost vs NameVirtualHost
- VirtualHost
  - httpdのサブプロセス
  - 1つの物理サーバで複数のサイトを運営するための役割
  - ポート、ヘッダ、IP、ホスト名で異なるサイトに飛ばすことができる
- NameVirtualHost
  - httpdに対してVirtualhostを使うことを知らせるディレクティブ
  - 2.4以降、必須ではなくなった。

### ホスト名で分けるという事

```
<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/com
</VirtualHost>

<VirtualHost *:80>
    ServerName example.net
    DocumentRoot /var/www/net
</VirtualHost>
```

- 上記は、example.comとexample.netを同じサーバで管理している
- ドメインは2つ取らなければならず、それぞれのDNSも用意する必要がある。
- Aレコードの指定が同じIPを指す
- Apache2側で、到達ドメインから異なるページを戻す仕組み
  
### IPベースで分けるということ
- 物理マシンに2つのネットワークカード(IP)が必要

```
# こちらはメイン。サーバが持つENIのIP
DocumentRoot "/var/www/site_main"

# メインとは違う「もう1つのIP」だけを、VirtualHostとして追加する
<VirtualHost 192.168.1.20:80>
    DocumentRoot "/var/www/site_secondary"
</VirtualHost>
```

2-25～