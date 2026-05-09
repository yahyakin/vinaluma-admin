#!/bin/bash
# =============================================
# Vinaluma Admin - Flutter Web Deploy
# panel.vinaluma.com → ~/panel
# =============================================

set -e

DEPLOY_DIR="$HOME/panel"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Vinaluma Admin Panel deploy ediliyor...${NC}"

# 1. Repo çek
if [ -d "$HOME/vinaluma-admin" ]; then
  echo -e "${YELLOW}Repo güncelleniyor...${NC}"
  cd "$HOME/vinaluma-admin"
  git pull origin main
else
  echo -e "${YELLOW}Repo klonlanıyor...${NC}"
  cd "$HOME"
  git clone https://github.com/yahyakin/vinaluma-admin.git
  cd "$HOME/vinaluma-admin"
fi

# 2. Flutter web build
echo -e "${YELLOW}Flutter web build...${NC}"
flutter build web --release

# 3. Deploy
echo -e "${YELLOW}Dosyalar kopyalanıyor...${NC}"
rm -rf "$DEPLOY_DIR"/*
cp -r build/web/* "$DEPLOY_DIR/"

echo ""
echo -e "${GREEN}✅ Deploy tamamlandı!${NC}"
echo "  🌐 https://panel.vinaluma.com"
echo ""
