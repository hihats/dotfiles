# Creation of an Environment 環境構築

## Mac OSX
[XCode Install](https://developer.apple.com/jp/xcode/)
```zsh
$ sudo xcodebuild -license
# install homebrew
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# enable brew-bundle
$ brew tap homebrew/bundle
```
:warning:**brewdlerは[bundle](https://github.com/Homebrew/homebrew-bundle)にReplaceされたようです**

```zsh
$ mkdir -p ~/github/hihats && cd ~/github/hihats
$ git clone https://github.com/hihats/dotfiles.git
$ git clone https://github.com/mbadolato/iTerm2-Color-Schemes
```
ここではMacOS標準搭載のgitを使い、以後はbrew installしたgitを使う

Applications can be in [Brewfile](https://github.com/hihats/dotfiles/blob/master/Brewfile)

```bash
$ cd dotfiles
$ brew bundle
```

### bashrc,vimrcなど

```bash
$ sh makesymlink.sh
```
:warning:**ssh/configは公開可能なものだけかチェック**

### Finicky設定
URLを自動的に適切なブラウザで開くためのFinicky v4設定

設定ファイル: `.finicky.js`

#### Finicky v4対応
- ECMAScript modules (`export default`) を使用
- 新しいURL interfaces対応
- オンデマンド起動でリソース消費削減

#### トラブルシューティング

**設定変更が反映されない場合:**
1. Finicky.appを再起動
   ```bash
   $ open -a Finicky
   ```

2. キャッシュクリア（古いバージョンから移行時）
   ```bash
   $ pkill -f finicky
   $ rm -rf ~/Library/Caches/net.kassett.finicky  # v3キャッシュ
   $ rm -rf ~/Library/Caches/se.johnste.finicky   # v4キャッシュ
   ```

### Neovim
Neovim + lazy.nvim 構成

#### ディレクトリ構成

```
.config/nvim/
├── init.lua                 -- エントリポイント（読み込み順序を制御）
└── lua/
    ├── config/
    │   ├── options.lua      -- Vim オプション（.vimrc から移植 + 拡張）
    │   ├── keymaps.lua      -- キーマッピング（リーダー: Space）
    │   └── lazy.lua         -- lazy.nvim ブートストラップ
    └── plugins/
        ├── lsp.lua          -- LSP + Mason（サーバー自動管理）
        ├── cmp.lua          -- blink.cmp（補完エンジン）
        ├── treesitter.lua   -- Tree-sitter（構文解析）
        ├── telescope.lua    -- ファジーファインダー
        ├── ui.lua           -- カラースキーム + ステータスライン + which-key
        ├── git.lua          -- Git 差分表示
        └── ai.lua           -- AI コーディング支援
```

#### プラグイン一覧

| プラグイン | 用途 | 備考 |
|-----------|------|------|
| [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | プラグインマネージャ | 遅延ロード対応、`lua/plugins/` を自動スキャン |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP クライアント設定 | `gd`, `gr`, `K`, `<leader>ca` 等のキーマップ付き |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | LSP サーバー管理 | `lua_ls`, `ts_ls`, `pyright` を自動インストール |
| [saghen/blink.cmp](https://github.com/saghen/blink.cmp) | 補完エンジン | nvim-cmp の後継、Rust 製で高速 |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト | 高精度な構文解析ベースのハイライト + インデント |
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー | fzf-native 拡張で高速ソート |
| [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | カラースキーム | night スタイル |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン | モード / ファイル名 / Git / 診断を表示 |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | キーバインド表示 | リーダーキー押下後に候補をポップアップ |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 差分表示 | signcolumn に追加/変更/削除を表示 |
| [yetone/avante.nvim](https://github.com/yetone/avante.nvim) | AI コーディング支援 | Claude 連携（`ANTHROPIC_API_KEY` 環境変数が必要） |

#### 主要キーマップ

| キー | モード | 動作 |
|------|--------|------|
| `Space` | - | リーダーキー |
| `<leader>ff` | Normal | ファイル検索 (Telescope) |
| `<leader>fg` | Normal | テキスト検索 (live grep) |
| `<leader>fb` | Normal | バッファ一覧 |
| `<leader>fr` | Normal | 最近のファイル |
| `<leader>/` | Normal | バッファ内検索 |
| `gd` | Normal | 定義へジャンプ (LSP) |
| `gr` | Normal | 参照一覧 (LSP) |
| `K` | Normal | ホバー情報 (LSP) |
| `<leader>ca` | Normal | コードアクション (LSP) |
| `<leader>rn` | Normal | リネーム (LSP) |
| `]h` / `[h` | Normal | 次/前の Git hunk |
| `<leader>gb` | Normal | Git blame |
| `C-h/j/k/l` | Normal | ウィンドウ移動 |
| `S-h` / `S-l` | Normal | 前/次のバッファ |
| `J` / `K` | Visual | 行を上下に移動 |

#### ヘルスチェック

```bash
$ nvim
:checkhealth          # 全体の環境確認
:Lazy                 # プラグイン管理画面
:Mason                # LSP サーバー管理画面
```

#### LSP サーバーの追加

`plugins/lsp.lua` の `ensure_installed` にサーバー名を追加すると Mason が自動インストール:

```lua
ensure_installed = {
  "lua_ls",
  "ts_ls",
  "pyright",
  "gopls",         -- 追加例: Go
  "rust_analyzer", -- 追加例: Rust
},
```

利用可能なサーバー一覧: `:Mason` で確認、または [mason-lspconfig README](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) を参照。

---

### Ruby Env
基本はDockerで開発するが、ローカルでちょっとしたスクリプトを動かすケースなど
```bash
rbenv global 2.2.0
rbenv rehash

rbenv exec gem install bundler
```

### Python Env
```
pip install pylama pylama-pylint
```

### atom
[sync setting](https://github.com/atom-community/sync-settings)で設定を同期
- Copy the access token to Sync Settings configuration.(別保管)
- [Gist ID](https://gist.github.com/hihats/e6d56a103a8e61be4f32) (username/******部)を設定する

ローカルは以上

## aws EC2 instance setup
```bash
$ sudo vim /etc/hosts
$ sudo vim /etc/sysconfig/network
$ sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
$ sudo vim /etc/sysconfig/clock
ZONE="Asia/Tokyo"
```
### create user
```bash
$ sudo useradd hihats
$ sudo passwd hihats
$ sudo visudo
$ sudo gpasswd -a hihats wheel
```
### install middleware

```bash
$ sudo vim /etc/sysconfig/i18n
sudo yum update
sudo yum install ruby-devel gcc sqlite-devel gcc-c++
sudo yum install openssl-devel readline-devel zlib-devel curl-devel libyaml-devel
sudo yum list
sudo yum list | grep mysql
sudo yum install patch
yum repolist
sudo yum install mysql-server mysql-devel
sudo yum install httpd httpd-devel
sudo yum install graphviz
sudo yum install memcached
sudo yum install make bzip2 autoconf automake libtool bison git
sudo yum install libffi
sudo yum install libffi-devel
```


### LinuxにRails環境構築
[Linux環境へrbenv install](http://weblabo.oscasierra.net/install-rbenv-rubybuild-to-redhat/)
[rbenvをシステムワイドにインストールする](http://office.tsukuba-bunko.org/ppoi/entry/systemwide-rbenv)
[CentOSでsystem wideなrbenv+ruby-build環境を構築する](http://nomnel.net/blog/centos-system-wide-rbenv-and-ruby-build/)

root
```bash
cd /usr/local/
git clone https://github.com/sstephenson/rbenv.git
echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile
echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile
echo 'eval "$(rbenv init -)"' >> /etc/profile
cat /etc/profile

mkdir rbenv/plugins
cd rbenv/plugins/
git clone git://github.com/sstephenson/ruby-build.git
. /etc/profile
rbenv install -l
rbenv install 2.0.0-p643
rbenv global 2.0.0-p643
ruby -v
exit
grep 'secure_path' /etc/sudoers
grep -n 'secure_path' /etc/sudoers
vim /etc/sudoers
exit
cd /usr/local/
mkdir rbenv/shims rbenv/versions
groupadd rbenv
chgrp -R rbenv rbenv
chmod -R g+rwxXs rbenv =>  Seccurity Error!!
```

SGID権限はRuby2.0以降でErrorとなる
:warning:[システムワイドな rbenv の SecurityError](http://indeep.xyz/system-wide-rbenv-securityerror/)
```bash
sudo visudo
bash -c 'cat <<\__EOT__ >> ~/.bash_profile
export RBENV_ROOT="/usr/local/rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
eval "$(rbenv init -)"
__EOT__'

sudo gem install passenger
```
root

	passenger-install-apache2-module

### LinuxにPython環境構築
pyenv install
```bash
$ cd /usr/local/
$ git clone https://github.com/yyuu/pyenv.git
$ echo 'export PYENV_ROOT="/usr/local/pyenv"' >> /etc/profile
$ echo 'export PATH="${PYENV_ROOT}/bin:${PATH}"' >> /etc/profile
$ echo 'eval "$(pyenv init -)"' >> /etc/profile
```
python install (e.g. 3.5.0)
```bash
$ pyenv install 3.5.0
$ pyenv global 3.5.0
$ pyenv local 3.5.0
$ sudo pip install --upgrade pip
```

### LinuxにPHP環境構築
phpenv使用
```bash
$ cd /usr/local/
$ git clone https://github.com/CHH/phpenv
$ cd phpenv/bin
$ ./phpenv-install.sh
$ echo 'export PHPENV_ROOT="/usr/local/phpenv"' >> /etc/profile

$ yum install bison re2c
$ yum install libxml2 libxml2-devel
$ yum install jpeglib.h
$ yum install libpng-devel libjpeg-devel
$ yum install libmcrypt-devel.x86_64
$ yum install libtidy libtidy-devel
$ yum install autoconf.noarch
$ export PHPENV_APACHE_MODULE_PATH="/etc/httpd/modules"
$ vim plugins/php-build/share/php-build/default_configure_options
$ phpenv install 5.6.14
$ phpenv rehash
$ phpenv global 5.6.14
$ cp /usr/lib64/httpd/modules/libphp5.so versions/5.6.14/
```
[20+ common PHP compilation errors and fix – Unix](http://crybit.com/20-common-php-compilation-errors-and-fix-unix/)  
Apache
[phpenvをシステムワイドにインストールする方法](http://qiita.com/ryurock/items/2b8eb451f12761c18b9c)  
[phpenv+php-build環境によるphpバージョン管理~Mac（Yosemite）編~](http://qiita.com/omega999/items/c5b1c177331f8d342efd)  
[ubuntuにphp-buildでphp5.5を入れるためにシェルスクリプトと格闘した記録](http://hirobanex.net/article/2013/09/1379231000)  
`rbenv: version \`2.2.3\' is not installed (set by RBENV_VERSION environment variable)`とRBENV_VERSIONについて怒られる場合がある。phpenvがRBENV_VERSION変数を見に行ってしまっている。

### Passenger install
EC2のt2.microではメモリが足りなくてコンパイル出来ませんでした。t2.small以上を選択する必要があります。
[Virtual Memory Exhausted: Cannot Allocate Memory While Install Passenger on AWS](http://dynamicy.github.io/blog/2014/11/01/virtual-memory-exhausted/)


### apacehグループにgpasswdで追加できない問題発生
/etc/groupにはある


### MySQL起動
	CREATE USER
	SET PASSWORD for hihats = PASSWORD('******');
	GRANT ALL PRIVILEGES ON *.* TO
	CREATE DATABASE itbee_development DEFAULT CHARACTER SET utf8;
