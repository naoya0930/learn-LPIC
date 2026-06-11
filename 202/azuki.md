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

### 4-12 slapd.confログ管理
- `loglevel` ... ログに出す情報量を定義。数値で管理する
- `logfile` ... syslog(OS経由)でないログの出力先の定義

### slapd.conf主要なディレクトリ
- /etc/openldap/、もしくは/etc/ldap/配下にだいたい存在
  - slapd.d/
    - LDIF形式の設定ファイル
  - schema/
    - スキーマファイル
    - 利用可能なすべてのカタログがここに記載されている

### データベースの実態ディレクトリ
- /var/lb/ldap/配下に存在
  - *.mdb等の形式で存在
- 設定ファイルとは別の場所に保存されている

### suffix,rootdnに関して
- suffix...そのLDAPサーバがどのドメインツリーを管理するか定義する
- RootDN ... 最も強いユーザのDN識別子名
- suffixの数だけ、RootDNが存在する
- 近年の設定ファイルをツリー構造で記載する(cn=config)形式もある
  - それぞれ、olcSuffix,olcRootDNというパラメータで管理


### OpenLDAPデータベースバックエンド
- データベースへの保存、処理を実行するエンジン
  - bdb
  - config
  - dnssrv
  - hdb
  - ldap
  - ldif
  - mdb
  - meta
  - monitor
  - null
  - passwd
  - perl
  - relay
  - shell
  - sql

### 4-25 pamの優先順位
- /etc/pam.conf, /etc/pam.d/がある場合
  - /etc/pam.confが無視される

### PAM基本動作
- 認証を必要とするライブラリのインストール
- ここで、/etc/pam.d/配下に設定ファイルが記載される
  - auth,account,password,sessionとか書かれたあれ
- 呼び出し時に以下から該当の.soファイルを実行
  - /usr/lib/security/配下に存在

### PAMモジュール
- pam_unix.so
- pam_ldap.so
- pam_rootok.so...ルートアクセスを許可
- pam_securetty.so../etc/securettyファイルのデバイスからアクセスを許可
- pam.nologin.so
- pam_wheel.so
- pam_cracklib.so...パスワードの安全性検証
- pam_limits.so
- pam_listfile.so
- pam_permit.so
- pam_deny.so
- pam_access.so...ログインユーザの制御
  - ユーザごとのアクセス可能IPの制限
- pam_env.so...環境変数の設定と削除


### pam.d/ファイルのタイプ
- auth ... ユーザ認証
- account ...アカウントのチェック
- password ... パスワードの（再）設定
- sesion ... 認証後の処理。


### 制御フラッグ
- required ...失敗しても全てを実行する。
- requisite ... 失敗すると即時失敗と扱う
- sufficient... 以前のrequiredと本節が成功した場合、全体で成功とする
  - 失敗した場合は、次の条件を実行する。全体の成否には影響なし

### pam.d/配下にファイルが存在しない場合
- /etc/pam.d/otherファイルが使用される


# メール
### postfix設定ファイル
- /etc/postfix/main.cf
  - MTAとしての挙動の設定
- /etc/postfix/master.cf
  - postfixデーモンの挙動を設定

### main.cfの設定
- myhostname
- mudomain
- mynetwork
- relay_domains
  - 外部で受信して内部にメールを転送するドメイン
  - 特定のドメインを特別に受信したい場合に設定
- relayhost
  - 内部で受信した外部あての転送ドメイン
  - 信頼性の高い中継サーバへの転送依頼
- inet_interface
- onet_protocols
- mydestination
- home_mailbox

### エイリアスの設定
- \etc\aliases

- 他のユーザにメールを転送する設定
  - `user1: user2, user3`
- 外部のメールアドレスに飛ばす
  - `user: user@admin.com`
- メールに書き込む
  - `user: /var/log/archive.log`
- メールを標準入力としてプログラムを実行する
  - `user: "| /home/work/sample.sh"`
- 他のファイルを読み込む
  - `user: :include:/home/work/maillist`

### aliasesの更新を実行する
- postalias
- newaliases
  - ここエーリアスなので超注意！
  - /etc/aliasesを更新する

### RBL拒否リスト
- real time black hole listの略
- IPのブラックリスト
- DNS経由で問い合わせを実施
- これから受信しようとしているIPの安全性を検証
- Aレコードだったり、TXTレコードで拒否リストが管理されている


### 5-15 postfixのスプールのメールの操作
- 閲覧
  - postqueue -p
  - mailq
- 強制送信
  - postqueue -f
  - postfux flush
- キュー中のメールを削除
  - postsuper -d {id}
  - postsuper -d ALL

### 5-16 メール記述時の基礎構文
- 送信時
  - EHLO 送信元ホスト
  - MAIL FROM 送信元アドレス
  - RCPT TO 送信先アドレス
  - DATA
  - 以降、本文を記入する

- 普通のFROM, TOはどこ行った？
  - これは受信者が読み込む内容
  - 送信時にはBCCやメールリストの関係から、これを直接書かない

### 5-18 dovecot.confでの認証
- mechanism,auth_mechanismで指定する
- メール受信時の認証
- SASLによる拡張認証
  - plain
  - login
  - cram-md5
  - digest-md5
  - scram-sha-1
  - apop

### doveadmコマンド
- doveadm reload ...設定ファイルの再読み込み
- doveadm stop ... デーモンを停止
- doveadm mailbox ... ユーザのメールボックスの管理
- doveadm who ... Dovecotに接続しているユーザ一覧を表示

### 5-22 Sieve 主要なアクション
- fileinfo ... 指定したメールボックスへ
- keep ... デフォルトのメールボックスへ
- discard ... 破棄する
- reject ... 拒否する
- redirect ... 指定したメールアドレスに回送
- stop ... 処理の停止
- vacation ... 自動返信

- Sieveサンプルファイル

```
# =====================================================================
# 必要な拡張機能（機能モジュール）の読み込み
# =====================================================================
require ["fileinto", "reject", "copy", "vacation"];

# =====================================================================
# ルール1: スパムメールの自動破棄 (discard)
# =====================================================================
# メールのヘッダに「X-Spam-Flag: YES」がある場合は、
# ユーザーの目に触れさせず、完全に消去します。
if header :contains "X-Spam-Flag" "YES" {
    discard;
    stop; # ここで処理を終了し、これ以降のルールは評価しない
}

# =====================================================================
# ルール2: 重大なエラーや不正アクセス通知の受信拒否 (reject)
# =====================================================================
# 特定のブラックリストに載っている送信元（例: bad-robot@example.com）からの
# メールの受信を拒否し、送信元にエラーメッセージを突き返します。
if address :is "from" "bad-robot@example.com" {
    reject "Your email was rejected by the system administrator due to security policies.";
    stop;
}

# =====================================================================
# ルール3: 特定の重要な報告書を別のアドレスへ転送 (redirect)
# =====================================================================
# 件名（Subject）に「月次報告書」が含まれている場合、
# 自分の手元に残しつつ、上司やアーカイブ用のアドレスへ自動転送します。
if header :contains "Subject" "月次報告書" {
    # 自分のメールボックスに通常通り保存する (keep)
    keep;
    # 指定した別のアドレスへメールを転送する (redirect)
    redirect "manager@example.com";
    stop;
}

# =====================================================================
# ルール4: 請求書メールの専用フォルダへの自動振り分け (fileinto)
# =====================================================================
# 件名に「請求書」または「Invoice」が含まれている場合、
# 受信トレイではなく「Invoices」というフォルダへ直接移動します。
if header :contains "Subject" ["請求書", "Invoice"] {
    fileinto "Invoices";
    stop;
}

# =====================================================================
# ルール5: 休暇中の自動返信設定 (vacation)
# =====================================================================
# 上記のどのルールにも該当しなかった通常のメールに対して、
# 自分が不在（休暇中）であることを送信元へ自動で返信します。
vacation
    :days 7
    :subject "【自動応答】ただいま休暇をいただいております"
    :addresses ["me@example.com"]
    "お送りいただきありがとうございます。
    ただいま長期休暇をいただいており、メールの確認ができません。
    急を要する用件につきましては、緊急連絡先（090-xxxx-xxxx）までご連絡ください。
    よろしくお願いいたします。";

# 最後に、自動返信を行った上で、届いたメール自体は自分の受信トレイに通常通り保存します。
keep;
```

# システムセキュリティ
### sysctlの効果
- カーネル設定の変更
- /proc/sys/配下に変更を入れる
- オプション
  - `sysctl -a`
    - 一覧表示
  - `sysctl {key}`
    - キーで検索
  - `sysctl -w {param} = {value}`
    - 値の変更
  - `sysctl -p `
    - `/etc/sysctl.conf`を読み込む

### /etc/proc/の主要なファイル
- /proc/sys/fs ... ファイルシステム
- /proc/sys/kernel ... カーネルパラメータ
- /proc/sys/vm ... 仮想記憶のパラメータ
- /proc/sys/net ... ネットワーク関連
- /proc/sys/net/ipv4/ip_forward ... ip転送
  - 1で有効、0で無効
- /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
  - ICMPのブロードキャストに対する応答。
  - 1で無視機能をオン、0で無視機能をオフ
- /proc/sys/net/ipv4/tcp_syncookies
  - SYN FLOODの回避方法
    - SYNリクエストを大量に送り付けてメモリ消費を狙う仕組み
  - 1で有効、0で無効化

### iptables主要なコマンド
- iptables -A/-D/-P [chain] [rule]
  - chainにルールを追加/削除/変更
- iptalbes -L/-F/-N/-X [chain]
  - chainを表示/すべて削除/作成/削除

### iptables -A/-D/-Pに続くルールの記法
- -s/-d/-sport/-dport ...送信元/送信先/送信元ポート/送信先ポート
- -j [target]
  - ACCEPT,REJECT,DROP,DNAT,SNAT,MASQUAEADEW,LOG,他、ユーザ定義ターゲット

### 宛先ごとのテーブルの行先
- 外部から受信してその場で処理する
  - 1. natテーブル、PREROUTINGチェイン
  - 2. filterテーブル、INPUTチェイン
- 外部から受信して転送する
  - 1. natテーブル、PREROUTINGチェイン
  - 2. filterテーブル、FORWARDチェイン
  - 3. natテーブル、POSTROUTINGチェイン
- ローカルから外部に送る
  - 1. natテーブル、OUTPUTチェイン
  - 2. filterテーブル OUTPUTチェイン
  - 3. natテーブル、POSTROUTINGチェイン


### ipv6におけるgw指定
- route add -A inet default gw XXXXX dev ethX
  - 上記において、ethコネクタを指定しなければならない場合がある。
- リンクローカルアドレス(fe80::)を使用する場合
  - リンクにおいて有効な範囲が決まっている為、指定が必須
  - 間違えると、飛ばなくなる
- グローバルアドレス(2001::)の場合
  - 世界的に一意なので、間違えても問題が無い
  - なんにせよルータに到達できる

### ipv6における送信先指定
- route add -A inet6 2001:xxx via xxxx
- リンクローカルアドレスは原則として利用できない
  - 異なるNWへ飛ばすためのroute addを記載するはずだが、スコープ外


### 匿名ftpクライアントの操作権限
- 読み込み権限を渡さないのが一般的
  - `-wx --- ---`
  - 一覧を読ませないためらしい・・・

### 6-14 vsftpd.confの設定
- 設定ファイルが超簡単
- `chroot_local_user=YES`でホームディレクトリ割り当て
- `anonymous_enable=YES`で匿名ユーザアクセス有効化
- `anon_root= \var\ftp\pub` で匿名ユーザのルートを決める



### 6-20 OpenSSH ログイン時のパスフレーズ省略
- `~/.shosts`ファイル
  - ホスト名とIPを書くと、そこからの接続に認証を入れなくなる

### 6-23 sshポートフォワーディングの設定
- -L ローカルからリモートへポート転送を実行
- -R リモートからローカルへ転送を実行

### sshでX11を許可する設定
- `X11Fowarding yes`
- クライアント
  - `ssh -X sample@server-remote`

### 6-27 fail2ban vs tcp wrapper
- fail2ban
  - 基本はL4で動作
  - ログを観察して動的なブロックが可能
  - iptableレベルでパケットを落とすのでアプリに到達しない
- tcp wrapper
  - L7で動作
  - tcp自体は確立している状態で判断を実施する
  - /etc/hosts.allow、/etc/hosts.denyで定義
  - 旧式


### 6-33 Open VPN
- ポートフォワーディングではなく、仮想敵にeth(tapX)を作ってそこで通信する
- クライアント側、サーバ側で専用のtap同士で通信
- 外部に出ていくときにはサーバが送信元IPを変更して通信
  - 送信元は内部IPで、戻ってこなくなるため。
- デフォルトポート 1194

### 6-34 OpenVPNクライアント同士の通信
- 通常は許可されない
  - サーバ設定ファイル`server.conf`で`client-to-client`の追記が必要
- 内部的には、サーバ側のeth(tap)を共有している
- L2/L3でクライアント同士を接続するか設定で変更できる

### セキュリティ組織
- CERT
  - Computer Emergency Response Team
- CSIRT
  - Computer Secutrity Incident Response Team
- CIAC
  - Computer Incident Advisory Capability
- Bugtraq
  - セキュリティに関するメーリングリスト