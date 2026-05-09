#!/bin/bash
# =============================================
# Vinaluma Admin - Flutter Web Deploy
# panel.vinaluma.com subdomain'ine deploy eder
# =============================================

set -e

DEPLOY_DIR="$HOME/panel.vinaluma.com"
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Vinaluma Admin Panel deploy ediliyor...${NC}"

# Dizin yoksa oluştur
mkdir -p "$DEPLOY_DIR"

# Eski dosyaları temizle
rm -rf "$DEPLOY_DIR"/*

# build/web içeriğini kopyala
cp -r build/web/* "$DEPLOY_DIR/"

echo -e "${GREEN}✅ Deploy tamamlandı!${NC}"
echo "  🌐 https://panel.vinaluma.com"
echo ""
