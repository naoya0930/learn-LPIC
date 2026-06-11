### fail2ban jail
- 以下の3つを設定するアクションセット
- Jailを構成する要素
  - Filter
  - Logpath
  - Action

### squid.confのクライアントが側のポート指定
- http_port
  - 基本的にはhttpを使用して通信するため、"http"
  - connectというシグナル後は、http以外も使える

### mod_authz_coreによって使用可能になるapache認証
- method ... httpメソッドによる認証
- all ... 全部を許可する
- expr ... Expression(式)によって複雑な認証

### Nginxのアクセス先
lication/ {
    proxy_pass http://proxy:8080
}

