#!/data/data/com.termux/files/usr/bin/bash
# 把 ~/blog 发布到 https://b9116048-art.github.io/ygblog/
cd "$(dirname "$0")" || exit 1
TOKEN=$(cat "$HOME/.gh-token" 2>/dev/null)
[ -z "$TOKEN" ] && { echo "[X] 找不到 ~/.gh-token"; exit 1; }
if [ ! -d .git ]; then
  git init -q
  git config user.email "b9116048@gmail.com"
  git config user.name "YG"
  git symbolic-ref HEAD refs/heads/main
fi
git add -A
if git diff --cached --quiet 2>/dev/null; then
  echo "[=] 内容没变，跳过提交"
else
  git commit -q -m "update $(date '+%Y-%m-%d %H:%M')" && echo "[+] 已提交"
fi
echo "[..] 推送到 GitHub ..."
if git push -q "https://x-access-token:${TOKEN}@github.com/b9116048-art/ygblog.git" main:main 2>$HOME/.ghpush.err; then
  echo "[OK] 发布成功 -> https://b9116048-art.github.io/ygblog/"
else
  echo "[X] 推送失败："; tail -6 $HOME/.ghpush.err
fi
