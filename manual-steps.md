# 手动步骤（需要人工交互）

以下步骤需要在运行 `setup.sh` **之前**手动完成。

## 1. 安装 Xcode Command Line Tools

```bash
xcode-select --install
```

## 2. 安装 Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

安装完成后执行：

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 3. Git 配置与 SSH Key

```bash
git config --global user.name "yuanbo"
git config --global user.email "1397155099@qq.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global safe.directory '*'

# 生成 SSH Key
ssh-keygen -t ed25519 -C "1397155099@qq.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 复制公钥到 GitHub: Settings → SSH and GPG keys → New SSH key
cat ~/.ssh/id_ed25519.pub
```

## 4. GitHub CLI 登录

```bash
brew install gh
gh auth login
```

选择 SSH 协议，按提示完成登录。

---

以上步骤完成后，运行 `setup.sh` 继续自动化安装。
