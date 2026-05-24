# Q1 
### IPパケットの転送
- /etc/sysctl.confを書き換える
  - カーネル設定の方、systemctは関係ない
- net.ipv4.ip_forwardを1に変更

#### nmap オプション
- 基本はTCPをモニタリングするオプション
- -sT...TCPスキャン
- -sU...UDPスキャン
- 特定のTCPフラグ系
  - -sS...SYNフラグ
  - -sF...Finフラグ
  - -sN...NULLフラグ
  - -sX...Xmas(全1フラグ)
- -sR...リモートプロシージャコール
  - well known portの外側で動くやつ
  - 

### OenVPNのstatus
- 今誰がVPNにつないでいるのかを記録するファイル
- 書いてある内容
  - クライアント情報
    - ファイルの更新時刻
    - Common Nmae(接続者の証明書の名前)
    - 接続元の実際のIPアドレスとポート番号
    - 受信・送信データ量
    - 接続開始日時
  - ルーテイング情報
    - Common Name
    - 割り当てた仮想IPアドレス
    - 最後に通信があった日時

# Q2
### IPv6
- 2000::/3 グローバルユニキャスト
  - インターネットでユニーク
- fe80::/10...リンクローカルユニキャスト
  - LAN内で有効
- f00::/7 or fd00::/8 ...ユニークローカルアドレス
  - 組織の中でユニーク
- ff00::/8 ...マルチキャストアドレス
  - 特定のグループに対して送信

### ftp, アクセスユーザを制限する
- 匿名ユーザの制限
  - proftp.conf
    - <Anonymous ~user>
  - pure-ftpd.conf
    - NoAnonymous yes を使用する
    - 匿名ユーザはftpというデフォルトネームが割り当て
  - vsftpd
    - ftp_username={user}にて指定

# Q3

# Q4
### fail2ban
- サービスごとに独立して監視を行う
  - Jailとよばれるセットを作成
- Jail
  - Filter...何をしたらエラーとするか、正規表現
  - Action...不正を見つけた時に何をするか
  - Logpath...どのログパスを監視するか

### chrootした時にプログラムが実行できない
- 参照させるような仕組みは無い。
- 必要なライブラリを適切なユーザに渡してあげる必要がある

### Sambaユーザ認証
- security=userの場合
  - smbpasswd、tdbsamを使用する
- Linuxサーバのユーザ情報`/etc/passwd`,`/etc/shadow`を使用しない
- 同期したいのであれば、aadsを使用したりすること
# Q5

### sambaのwindbindの処理範囲
- security = adsもしくはsecurity = domainの場合はこれ

### samba hiddenなユーザ
- 直接共有名を指定すれば見えるようになるディレクトリ
  - smb.cof上では、末尾にdollerをつける[confidentail$]
- \\サーバ名\共有名で指定
- ファイル非表示 `veto`や`hide`とは違うレイヤーの話

#### NFSの/etc/exportsについて
- 接続されるサーバの設定
  - どこにあるファイルがどうマウントされるのか定義する
- フォーマット
  - `{dir} {IP Prefix}({権限}) {IP Prefix}({権限})`
  - `{dir}/{subdir} {IP Prefix}({権限}) {IP Prefix}({権限})`
- 原則としてルートマウントは一つ。
- これを書いておくとマウント時にクライアントがパスを指定しなくて良くなる

### exportfs
- 現在の/etc/exportsの状態を表示する
- または、メモリ上のexportfsに更新を入れる

### ゾーンファイルのdor「.」
- dotで終了しないと、末尾にORIGINを付与する

# Q7
### DNS
- /etc/named.confが基本
- 基本的なパラメータ
  - acl {}
  - controls {}
  - options {}
  - zone "." IN {type hint;}
  - zone "{sample.com}" IN{type master;file "zonefile"}
    - zoneで指定したドメインはゾーンファイルの「@」に渡される
- 基本的なoptionsパラメータ
  - recursion yes
  - allow-recursion {}
  - allow-query {}
  - allow-query-cache {}
  - allow-transfer {}
  - notify yes
  - directory ""
  - pid-file ""
  - dump-file ""
  - dnssec-calidation yes
  - dns-enable
  - forwarders {}
  - forward only | first
  - max-cache-size
  - minimal-response yes
  - 
### DNSグルーレコード
- NSレコードを指すレコードのこと
- ネームサーバの場所がわからず、クエリが未達になるのを防ぐ
  - ネームサーバもドメインのため
- NSレコードに対して直接IPを書いてはいけないため、こうなっている

### httpd.conf
#### ログファイルの仕組み
- ERRORLOGでディレクトリを指定する
- CUSTOMLOGでログの指定先を変更する
  - エラーも含めた全てのログがここに記載される
  - 昔はフォーマットが固定だったので、「Cusom」という名前

#### エイリアス、ディレクトリ
- DocumentRoot配下以外の場所を参照させる
  - Directoryで呼び出す感じ

### squid.conf
#### 基本
- アクセスコントロール名を定義する
- アクセスコントロール名を使ってhttp_accessを定義
#### 書式
- http_access allow {条件。幾つ並べてもいい。andを取る}
###　ポートが登場する場合
- acl safe_p port 80
  - squidが転送先に送る際のポート
- acl my_p myport 3132
  - squidがクライアントから受けるポート
  - http_portで指定されていないと意味を成さない
- http_port 3132 8080
  - squidが稼働する受け付けポート

### httpd.confセキュリティモジュール
- 1. mod_auth_basicで基本認証を使える。
  - これは、AuthType,AuthNameで制御
- 2. .htaccessでも認証を使える。
  - AuthUserFileなどで制御
- 3. mod_authz_ ~ で始まるモジュール
  - httpd.confのrequire句を使用して認証を呼べる
    - Requireの拡張系
    - RequireAll {}...全てにマッチ
    - RequireAny {}...1つ以上の条件にマッチで真
    - RequireNone {}...いずれの条件にもマッチしなければ真
#### mod_authz_*について
- mod_authz_core
  - all granted...全許可
  - all denied ...全拒否
  - method ...メソッドタイプ
  - epr...評価式を使う。時刻。cgiなどなどを呼び出せる。

### Nginex設定ファイル
- /etc/nginx/nginx.conf
- 主なブロック
  - main...nginx自体のプロセス設定
  - http{}...httpに関する記載
  - server...ポート、ドメイン名宛のリクエストの記載
  - location {URI}....パスごとの処理分岐
  - Stream...http以外のTCP,UDPの処理

```
# ▼ L4（TCP/UDP層）の処理領域
stream {
    # データベースへの接続を待ち受ける仮想ホスト
    server {
        listen 3306;             # MySQLのデフォルトポート
        proxy_pass db_backend;   # 裏側のDBサーバーにそのまま通信を流す
    }
}

# ▼ L7（HTTP/HTTPS層）の処理領域
http {
    # Webサーバー全体の共通設定
    include       mime.types;
    default_type  application/octet-stream;

    # 1つ目のWebサイト（example.com）
    server {
        listen 80;
        server_name example.com;

        # http://example.com/ へのアクセス（静的ファイルを返す）
        location / {
            root /var/www/html;
            index index.html;
        }

        # http://example.com/api/ へのアクセス（裏のアプリに流す）
        location /api/ {
            proxy_pass http://localhost:8080;
        }
    }

    # 2つ目のWebサイト（test.jp）
    server {
        listen 80;
        server_name test.jp;
        # ...独自のlocationなどを設定...
    }
}
```

### slapd.conf
- 設定そのものがDN形式で記述されている
- 設定自体は、`cn=config`にある
- ユーザは、`cn=config,olcDatabase={1}`の配下に保存されている

```
# =====================================================================
# 1. スキーマの読み込み (一般的なユーザー管理に必要な標準セット)
# =====================================================================
include         /etc/openldap/schema/core.schema
include         /etc/openldap/schema/cosine.schema
include         /etc/openldap/schema/nis.schema
include         /etc/openldap/schema/inetorgperson.schema

# =====================================================================
# 2. グローバル設定
# =====================================================================
pidfile         /var/run/openldap/slapd.pid
argsfile        /var/run/openldap/slapd.args

# モジュールの読み込み (環境によってはパスが /usr/lib/ldap 等になります)
# modulepath    /usr/lib64/openldap
# moduleload    back_mdb.la

# =====================================================================
# 3. アクセス制御 (Access Control List)
# =====================================================================
# パスワードは自分自身のみ変更可能。匿名ユーザーは認証(ログイン照合)のみ可能。
access to attrs=userPassword,shadowLastChange
    by self write
    by anonymous auth
    by * none

# その他のデータは、自分自身は更新可能。ログイン済みユーザーは閲覧可能。
access to *
    by self write
    by users read
    by * none

# =====================================================================
# 4. データベース設定 (MDBバックエンド)
# =====================================================================
database        mdb

# データベースの最大サイズ (MDBの必須設定。例: 1GB = 1073741824 bytes)
maxsize         1073741824

# ドメイン名 (環境に合わせて変更してください)
suffix          "dc=example,dc=com"

# 管理者(Root)のDN
rootdn          "cn=Manager,dc=example,dc=com"

# 管理者のパスワード (※1)
# 平文で「secret」と設定しています。運用時は slappasswd コマンドで生成したハッシュに置き換えてください。
rootpw          secret

# データベースファイルの保存先 (※2)
# このディレクトリは事前に作成し、ldapユーザーに所有権(chown)を付与しておく必要があります。
directory       /var/lib/ldap

# =====================================================================
# 5. インデックス設定 (検索パフォーマンスの最適化)
# =====================================================================
index   objectClass             eq
index   cn,uid,sn               eq,pres,sub
index   mail                    eq,sub

```


#### デフォルトのslapd.conf
- anonymousにはnone,*にはreadがかかっている
  - つまり、認証前ユーザは何もできない
  - その他のユーザには読み取り権限だけ持っている
#### slapdのルートアカウント削除
- rootdn,rootpwを消しても動作する
- 「access to *」などの制約を受けるようになる


# Q12
### LDIFの読み方
- アクティブディレクトリのスキーマでよくあるやつ
  - dc...ドメインコンポーネント
  - ou...組織単位
  - cn...一般名
  - dn...識別名
- 

### 操作のためのLDIF
- 新しいLDIFを定義してそれをデータベースに投げつけて変更を知らせる
- LDIF中に`changetype:`を与えることで変更を定義
- パラメータによって挙動が変わる
  - `changetype: add`...エントリを追加する
  - `changetype: modify`
    - LDIF中に`add:{pram}`...paramをキーに持つエントリを追加
    - LDIF中に`replace:{param}`...paramがキーの値を書き換え
    - LDIF中に`delete:{param}`...paramがキーの値を削除
  - `changetype: delete`...そのエントリを削除する
  - `changetype: modrdn`...エントリを引越する

### LDAP操作
- ldapadd
- ldapsearch
- ldapdelete
- ldapmodify
- ldappasswd

### PAMモジュール
- 各サービス(ssh,su,sido,login)等、認証を使うサービスが使用
- /exc/pam.d/に配置して認証ロジックを定義
- 主にauthで使うモジュール
  - pam_unix.so
  - pam_rootok.so 
  - pam_wheel.so
  - pam_listfile.so 
  - pam_securetty.so
  - pam_nologin.so 
- 主にaccountで使うモジュール
  - pam_unix.so
  - pam_time.so
  - pam_succeed_if.so
- 主にpasswordで使うモジュール
  - pam_unix.so
  - pam_cracklib.so
  - pam_env.so 
  - pam_pwdb.so 
- 主にsessionで使うモジュール
  - pam_limits.so 
- 補助的にどこでも使うモジュール
  - pam_deny.so 
  - pam_stack.so 
  - pam_warn.so

### required,reqisite
- required...この認証の失敗は失敗とみなすが、すべての認証を施行する。
- requisite...失敗すれば即座に失敗と返答する。

### OpenLDAPのディレクトリサービスのスキーマのルート
- cn=configが採用、昔は、slapdだった時期もある

# Q13
### 【復習】linuxファイル構成
- /lib/modules/
  - ここには.koファイルが配置される
  - Kernel Object
  - デバイスドライバ、ファイルシステムなど
- /lib/,/usr/lib/
  - ここには.shared objectが配置される
  - カーネルには直接影響しない
- ☆ authは`/usr/lib`に配置


### dhcp.conf
- 4つのブロックで構成
  - subnet... 特定ネットワーク(サブネット)ごとに割り当て範囲やルータを指定。    
    - ここで指定するIP範囲に自身を含んでいる必要がある。
    - 実際にクライアントに割り当てるIP範囲では無いので注意。
      - range...subnetをより制限した範囲で設定を適応させる
  - host...特定の機器(MACアドレス)に対して同じIPを割り当てる設定
  - pool...subnetの中にさらに作成する。
    - IPアドレスの割り当てルールを適応する
  - group...hostやsubnetに同じoptionを割り当てるブロック
- ブロックの優先順位
  - 1. ブロックなしで記述された内容
  - 2. shared-networkブロック(記載がある場合)
  - 3. subnet
  - 4. pool
  - 5. host

### DHCP登録済みの機器とは
- known-clients
  - dhcpに記載のあるクライアント
  - `host XXXX {hardware ethenet AA:BB:CC }`で記述されたホスト
- unknown-clinets
  - known-clientsでないクライアント
- ☆ 上記は`pool`ディレクティブで拒否、許可できる

```
# --- グローバル設定（全体の基本ルール） ---
default-lease-time 600;       # 通常のリース期間（秒単位：ここでは10分）
max-lease-time 7200;         # クライアントが要求できる最大のリース期間（2時間）
option domain-name-servers 8.8.8.8, 8.8.4.4; # 通知するDNSサーバー

# --- サブネット設定（特定のネットワークごとのルール） ---
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.50 192.168.1.150;        # 自動で配るIPアドレスの範囲
    option routers 192.168.1.1;              # デフォルトゲートウェイ（ルーター）
    option broadcast-address 192.168.1.255;  # ブロードキャストアドレス
}

# --- 特定の機器への固定割り当て（ホスト設定） ---
host MyServer {
    hardware ethernet 00:11:22:33:44:55;     # ターゲット機器のMACアドレス
    fixed-address 192.168.1.200;             # その機器に常に割り当てる固定IP
}
```

# Q14
###　メール関係のツールのライブラリ
- MTA
  - Postix
    - /etc/postfix/main.cf ... postfixの工藤構成
    - /etc/postfix/master.cf ...内部コンポーネントの挙動を設定
  - Sendmail ...
- MDA
  - Dovecot
    - /etc/dovecot/dovecot.conf ... 主要な設定
    - /etc/dovecot/conf.d/ ...MDAの挙動、仕分けの設定

### /etc/postfix/main.cfについて

```

# 1. ドメイン・ホスト・ネットワークの基本設定

# サーバーの完全修飾ドメイン名 (FQDN)
myhostname = mail.example.com

# 担当するドメイン名
mydomain = example.com

# 送信元メールアドレスの「@以降」のデフォルト値（例: user@example.com になる）
myorigin = $mydomain

# このサーバーが「自分宛て」として受信するドメインのリスト
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

# メールを待ち受けるネットワークインターフェース
# 全てから待ち受ける場合は "all"、ローカルのみなら "localhost"
inet_interfaces = all

# 使用するプロトコル（ipv4, ipv6, または両方の場合は all）
inet_protocols = all

# 2. リレー（転送）および信頼するネットワークの設定

# 認証なしでメールの「外部送信（リレー）」を許可する信頼されたネットワーク
# ローカルホストと、自身の所属するLANセグメントを指定します
mynetworks = 127.0.0.0/8, 192.168.1.0/24


# 3. メールボックス・配信設定

# メールボックスの保存形式。
# 現代の標準である「Maildir/」（1メール1ファイル、ディレクトリ管理）を推奨
home_mailbox = Maildir/

# メールの最大サイズ制限（バイト単位：以下は約20MBの例）
message_size_limit = 20480000


# 4. セキュリティ・アクセス制御 (SMTP制限)

# クライアントが接続してきた際の制限規則
# 信頼されたネットワーク（mynetworks）からの接続、または認証済みユーザーのみ外部送信を許可
smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination


# 5. SASL認証設定（SMTP認証：送信時のパスワード確認）
# ※DovecotをMDA/MRAとして併用し、その認証機構を利用する設定例
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain = $myhostname
broken_sasl_auth_clients = yes

# 6. TLS設定（通信の暗号化：SSL/TLS）

# 受信（SMTPサーバー）側の暗号化設定
smtpd_tls_cert_file = /etc/pki/tls/certs/mail.example.com.crt
smtpd_tls_key_file = /etc/pki/tls/private/mail.example.com.key
smtpd_tls_security_level = may
smtpd_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1
smtpd_tls_loglevel = 1

# 送信（SMTPクライアント）側の暗号化設定
smtp_tls_security_level = may
smtp_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1


# 7. その他の基本運用設定

# エラーなどの通知をシステム管理者に送る設定
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases

# バージョン情報を隠蔽（セキュリティ対策）
smtpd_banner = $myhostname ESMTP

```


### main.cfmのmydomain、myhostnameについて
- myhostname
  - これは自身のドメイン名
  - mail.example.com
- mydomain
  - 自身の担当するドメイン名
  - example.com
- 上記設定の場合、NXレコードは下記
  - `example.com. MX 10 mail.example.com.`


### 会社が新しいドメインを取得した場合の処置
- DNSに既存のものと併せて新しいMXレコードを追加する
  - old-example.com MX 10 mail.old-example.com
  - new-example.com MX 10 mail.old-example.com　（追記）
- 設定ファイルを以下に変更
  - myhostname      mail.old-example.com
  - mydomain        old-example.com
  - mydestination   $myhostname, ... , new-example.com (追記)

- ☆ mydomainはmain.cfに一つしか設定できない。
  - そのため、新しいドメインを追加してもここに書くことはできない
  - 設定の見た目は変だけど


# Q15
### dovecot configration
- docvecot.cof主要な設定
  - `disable_plaintext_auth`
    - 暗号化されていない接続でのプレーンテキスト配信許可(yes,no)
  - `auth_mechanisms`
    - 認証方式の選択
    - plain,logon,cram-md5から選択
  - `ssl`
    - SSL設定の有効化設定(yes,no,required)
    - yes...暗号化していない通信でも受け付ける
    - no...sslを使わない
    - required...暗号化された通信のみを許可する
  - `mail_location`
    - MTAがMaildir指定の場合、`mail_location = maildir:~/Maildir`など
    - 具体的なメールの配置先を記載する

#### dovecot認証メカニズム
- IMAP,POP3での使用
- 旧版のIMAP,POP3には脆弱な認証しか定義されていなかった
- SASL(Simple Authentication and Security Layer)によっていくつかの認証を定義
- SASL(RFC 4422)での認証
  - plain
  - login...IDを送ってからパスを送る(古い)
  - cram-md5
  - digent-md5
  - scram-sha-1
  - apop

### SIEVEの記法
- fileinto...指定した配送先へ
- keep...デフォルトのメールボックスへ
- discard
- reject
- redirect...指定したアドレスに転送
- stop ...処理を停止する
- vacation

### コマンドエイリアスの設定を最新版にする
- newaliases


# Q 16
###