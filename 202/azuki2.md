### dnsサーバ問い合わせクライアント許可
- options{}内で宣言
  - allow-query {}:


### apache,httpdの待ちポート
- listen

### smb.confのglobalに関する設定事項
- netbios名
  - そのコンピュータ自身の名称
  - 共有ファイルアクセスで使用する
  - ADでもユーザ名として使用できる
- workgroup名
  - 所属するグループ名
  - realmの文頭がこれになっていることが多い
  - 設定必須
    - windowsの使用上、ドメインか、workgroupに所蔵する制約がある。
- realm
  - Kerberos認証の管理単位
  - netbios名 + realm名で、物理PCを特定する

### DHCPが渡す情報
- option routers
- option subnet-mask
- option domain-name
- option donmain-name-servers
- option nisplus-domain
  - SNIとは別物なので注意
- option nis-servers

### iptablesルールの考え方
- iptables
  - -s...sourceなので、送信元
  - -d...destinationなので、送信先
### iptables natの考え方
- PREROUTINGチェーン
  - ここではルーティングする前の情報が扱える
  - `-to-destination`で宛先のIPへの変換を許可
  - `-j DNAT`はこいつのこと

- POSTROUTINGチェーン
  - ここではルーティングした後の情報が扱える
  - `-to-source`で送信元のIPの変換を許可
  - `-j SNAT`はこいつのこと
  - natで変えた後にsourceを変えるというのは変な感じですね
- 外部から受け取ったパケット
  - PREROUTING -> FOWARD -> POSTROUTING
- 自身から発生したパケット
  - OUTPUT -> POSTROUTING


### 1-7
### 1-15
### 1-19
### 1-21

### 2-2
### ☆2-5
### ☆2-6
### 2-15
### ☆2-18
### 2-23
### 2-26
### 2-28
### 2-30
### ☆2-34

### 3-6
### 3-16
### 3-21
### 3-24

### 4-4
### ☆4-12
### 4-30

### ☆5-6
### 5-7
### ☆5-15
### 5-20
### 5-22

### 6-5
### 6-8
### ☆6-11
### 6-14
### 6-24

