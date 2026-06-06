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

### Nginxの主な機能
- リバースプロキシが主な機能
  - webにこだわらずにロードバランシングが可能
- webサイトのホスティングも可能

### CGI, FastCGI
- Common Gateway Interface
  - サーバとプログラムをやり取りするインタフェース
  - リクエストに対してプログラムを起動して結果を戻す
- FastCGI
  - CGIの一部分を常駐させておくことで高速化したもの
/etc/squid/squid.conf



### Nginxブロック
- Main
- Event
- Http
- Server
- Location

```
main {             # 1. 全体設定
    events {       # 2. 接続設定
    }
    http {         # 3. HTTP共通設定
        server {   # 4. 仮想サーバーA（例: example.com）
            location / {        # 5. ルートパスの処理
              root /var/www/html
              index index.html
            }
            location /api/ {    # 5. 特定パスの処理
            }
        }
        server {   # 4. 仮想サーバーB（例: another.com）
        }
    }
}
```

### 2-30 squid ディレクティブ
- cache_mem
  - メモリ上に確保するキャッシュ容量
- cache_dir
  - キャッシュを格納するディレクトリなど
- minimux_objct_sia
  - キャッシュされる最大ファイル容量

### 2-30 cache_dir 記法
- cache_dir {storage_type} {dir} {最大ディスク容量MB} {第一階層のサブディレクトリ数} {第二階層のサブディレクトリ数}
- storage_type
  - ufs...基本形式。メインプロセスを直接使用
  - aufs...非同期対応。メインスレッドを使わない
- dir
  - キャッシュを保存するディレクトリ

### 2-34 認証を実施するacl
- auth_param...認証の方法を定義する
  - auth_param program ... 認証を実施するプログラムを呼ぶ
  - auth_param realm ... Kerberos
  - auth param basic ... basic認証
  - auth param digest ... digenst認証
- proxy_auth...auth_paramを通過に関する条件を指定する
  - `acl user proxy_auth REQUIRED`

# ファイル共有
### 3-1 samba予約語
- [global]
- [homes]
- [printers]

### 3-1 共有名とpath
- 共有名に対してアクセスを実行する。
  - `\\server\AccountData`へのアクセス
- pathがサーバのどこに繋がるのかを定義する
  - 直下のディレクトリは/dataにつながる

```
[AccountData] 
   path = /srv/samba/accounting/data 
   read only = no

```

### 3-1 sambaのbrowsableと隠蔽記号の[sam$]
- browsable = no
  - 共有名を変えずにユーザを隠す
- [sam$]
  - こちらはwindowsの仕様を使っている
  - パスの指定の際に\\server\sam$
  - ドルがパスに入ってくる

### 3-6 ファイル共有機能におけるユーザ管理
- これはsecurity=userの話
  - ユーザ名同士でマッチングを実施する
  - ユーザ認証（ID,passのマッチ）はtdbファイルで実施
    - ここの同期はunix password sync=yesを実行
  - ファイル共有ソフトとして使う時に、uidを取得する
    - この時に初めて/etc/passwdを参照する。

- security = adsを使用する場合、以下でマッチングする
  - SID...windowsのユーザ識別ID
  - UID...Linuxのユーザ識別ID

### 3-6 ファイル共有機能で例外的にユーザ名をマッピングする
- 管理者(adminとroot)などの名称の変換を実施する
- `usernamap = /file`
- このfileには、`Liniuxユーザ名 = クライアントユーザ名のリスト`で記載する
  - `root = Administrator `など

### 3-7 vetoによる隠蔽
- smb.confで、`veto files = `で指定する
- ディレクトリ、ファイル共通で隠蔽する。アクセスもできない
- スラッシュで複数を指定できる
- `veto files = /file/dir`

### smb.conf [printers]と[print$]
- プリンタをつかうのであれば、両方使う
- printers
  - sambaサーバに接続されたプリンターを使用する
  - Linux側でクライアントにプリンタの情報を開示する
- print$
  - プリンタドライバの配布
  - これを設定しないと、ネットからドライバを落としてくる必要がある


```

[printers]
    comment = All Printers
    path = /var/spool/samba
    browseable = no
    guest ok = yes
    writable = no
    printable = yes

[print$]
    comment = Printer Drivers
    path = /var/lib/samba/printers
    browseable = yes
    guest ok = yes
    read only = yes

  ```

### 3-13 winbindのコンポーネント
- Sambaの認証をADに委託するもの
- Sambaで設定したユーザをADのユーザとして利用できるものではない
- /etc/nsswitch.confに追記することで利用可能
  - `passwd: files winbind`
  - `group: files winbind`
  - 利用には、sssライブラリも必要
    - `libnss_winbind.so`
- 専用のPAMも必要
  - `pam_winbind.so`

### 3-13 winbind vs sssd
- sssd
  - 複数のLinuxユーザ情報をまとめる
    - windowsはAD、LinuxはOpenLDAP、パートナーはローカルファイルなど
  - 認証プロセスにおいてwinbind競合する
  - sssdはRedhat公式が開発
  - Sambaと互換があるわけではない
  - OpenLDAPなどの文脈で利用する
  - こちらはADやDCを持たず、完全にwindowsログインプロセスと互換しない
  - あくまで認証としてADをLDAP、Kerberosで利用するだけ。
    - windows端末のログインプロセスの機能ではない
    - Linuxサーバ側をADにメンバとして追加する

### smb.confの組織
- netbios name...sambaサーバ自身の名前
  - なければLinuxのユーザ名が使用される
  - ファイル共有ではこの名前が使用される
  - OSとしての名前ではないため、ここを変えると面倒
- workgroup...サーバが所属する組織
  - Netbiosではメインで使用されていた
  - 短いドメイン名
  - 管理者がいないチームのようなもの
  - LANが超えられないアレ
- realm...Kerberos認証におけるユーザの認証範囲
  - DNS形式で記載する

### nfsd操作コマンド
- `exportfs` .../etc/exportsを更新する
  - exportfs -a
    - /etc/exports全てをエクスポート
  - exportfs -u [-o option] client:dir
    - 指定したものをアンエクスポート
  - exportfs -r
    - /etc/exportsの設定を再ロード
  - exportfs -v
    - 詳細情報を表示

### 3-20 nfsをマウントする
- ファイルシステムに依存しない
- コマンドからマウントする
  - `mount -t nfs 192.168.1.50:/sec/nfs/share /mnt/nfs`
- fstabに記載する
  - [デバイス・共有名] [マウント先] [ファイルシステム] [オプション] [dump] [pass]
  - `192.168.1.50:/srv/nfs/share /mnt/nfs nfs defaults,soft,nofail 0 0`

### 3-22 利用可能なNFS共有を表示する
- サーバで実行すれば、接続があるクライアントを表示する
- クライアントで実行すれば、マウント可能なサーバが見える
- `showmount [NFSサーバ]`
  - サーバの指定として、IPv6、ホスト名、FQDNが使用可能
  - `showmount -t`...
    - サーバがエクスポートしているディレクトリとクライアントを戻す
  - `showmount -a`...
    - /var/libs/nfs/rmtabの内容を返す
  
### 3-26 NFSの主要なデーモン
- NFS v3
  - rpc.nfsd
  - rpc.mountd...マウントサービスを提供
  - rpc.statd...NFSサーバの状態をモニタ

- NFS v4
  - rpc.nfsd
  - rpc.idmapd...ユーザ名で一致させる
    - v3までは、uid/gidの完全一致が必要だった。


# ネットワーククライアント管理

### 4-2 dhcpd.conf
```

# グローバル設定（必須のネットワーク情報）
option domain-name-servers 8.8.8.8;
default-lease-time 86400;
authoritative;

# サブネット設定（IPの配布範囲とルーターの指定）
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.200;
  option routers 192.168.1.1;
}
```

### 4-2 dhcp.conf IPの指定方法
- `subnet [address] netmask [subnet_mask]{}`
  - このLANについてのIP、自身が所属している必要がある
  - この配下で割り当て対象を指定する
- `{}`の中
  - range {from} {to}...DHCPクライアントに割り当て。
    - 単一の場合は、toはなくてもいい
  - range dynamic-bootp...bootpにも割り当て

#### bootpって何？
- bootp (Bootstrap Protocol)
  - リース期間の概念が無い
  - ディスクレス環境に対してIPを割り当てる
    - プリンター、制御端末、旧式のPXEブートなど
  - mac addressに対して割り当てる
  - DHCPが永久に割り当てるため、IPが枯渇する

#### 固定IPを割り当てる
- ここで割り当てるアドレスは、DHCPでrange指定しているIPから外すことが推奨
  - 自動割り当て側で突合する可能性がある。
```
# 例：特定のサーバーやプリンターに固定IPを割り当てる場合
host my-target-host {
  hardware ethernet 00:11:22:33:44:55; # 対象機器のMACアドレス
  fixed-address 192.168.1.50;          # 常に割り当てたいIPアドレス
}
```


### DHCPが伝達するもの
- ドメイン名
  - option domain-name
- デフォルトゲートウェイのIP
  - option router
- サブネットマスク
  - option subnet-mask
- DNSサーバ
  - option domain-name-server
- LANのドメイン名
  - option domain-name
- NISサーバ名
  - option nis-domain
  - option nis-ip

#### ドメインネームって何?
- LANにおける有効な識別子
- 端末は[ホスト名].[ドメイン名]で識別される。
- このドメインを

#### FQDNを見る
- ispを通している場合、どんな名前で入っているかわからん
- インターネットから見た場合
  - webサイトから見る
  - コマンドで見る
    - `curl inet-ip.info`これで自身の外部IPが戻る
    - 逆引きすればFQDNが判明`dig -x XXX.XXX`

#### dhcp割り当てロジック
- 複数のpoolが存在する場合、`pool{range XXX;deny XXX}`など
  - 上の記述から順番に評価していく。
  - 割り当て不可(割り当てが一杯になった場合)は下層の判断に入ったりする

### 4-9 ipv6
- 手法が2つある
- SAALC...自動割り当て
  - ルータが64bit生成して、ホストがMACアドレスから64bit生成する
  - 実態は、radvdサービスを実行している
  - RA(Router Advertisement)とも呼ばれる
  - ルータ側(もしくはradvd実行Linux機)は割り当てを記録しない
    - ステートレスと呼んだりする
- DHCPv6
  - DHCPで管理する
  - ISC DHCPが代表的なIPv6対応DHCP
  - DHCP側でどのマシンにどのIPを割り当てたか記憶している
    - ステートフルと呼んだりする

### 4-10 IPv6でのdhcp.confの記法
- 基本は同じ
- `subnet`や`range`に対して、6をつける
- `subnet6`,`range6`
- MACアドレスだけでなく、DUIDという値が使用できる

####  DUID
- クライアントOS等が生成して使っている自己識別子
  - どれをつかわなければならないという制約はない
- DUID-LLT
  - Link-Local address plus time
  - 生成した時刻+MACアドレス
- DUID-EN
  - Enterprise-Number
  - 製造番号で使用。ルータとかの機器はこれを使用することが多い
- DUID-LL
  - Link-Local address
  - MACアドレスそのもの


## LDAP
### DNの順序性
- Distinguished Name
- 右に行くにつれて大きな領域を指すように記述する
- 親となるエントリが存在していない場合、子となる構造は作成できない
- DITの記法で決まっている
- `dn:uid=sample,ou=engineering,dc=example,dc=com`
  
### LDIF
- LDAP Data Interchange Format
- データの変換形式。.ldifファイルはこの形式
- LDIFの中でDN形式が使われることもある
- `dn: uid=XXX,ou=DDD`
- `changetype: add`
- などなど
- 記法
  - エントリは改行で区分けする
  - 属性と値
    - 「:」key-valueの関係
    - 「::」base64 による記法
    - 「:<」外部ファイル参照
    - 「sample;sample2:value」オプションを指定した属性

### slapd主要なコマンド
- サーバ上から操作を実行する。ldapを経由しない
  - slappasswd
  - slapcat
  - slapadd
  - slaptest
- ldapを使用して問い合わせる
  - ldapsearch
  - ldapadd
  - ldapmodify
  - ldapdelete
  

### 4-16 slapd.conf継承と依存性
- slapd.confは上から順番に読み込む性質がある
- 一部のスキーマには依存性がある
  - 上位(SUP)が読み込まれていないとエラーになる
- `core.schema`は最上位にあることが多い
- `inetorgperson.schema`はcoreに依存性がある

### 4-20 OID
- Object identifier
- オブジェクトの定義を決める

### 4-12 ldap.confログ管理