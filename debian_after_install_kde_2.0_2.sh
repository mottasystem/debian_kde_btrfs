#!/bin/bash
# Script de pós-instalação Debian NVMe
# Autor: Thiago Motta em Rio de Janeiro, 09-out-2025
# Compatível com Debian 12/13
set -e  # encerra o script se ocorrer qualquer erro
export DEBIAN_FRONTEND=noninteractive  # evita prompts interativos durante instalação

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script precisa ser executado como root."
  exit 1
fi

echo "Iniciando pós-instalação..."
#Variável do do não super-usuário
USER_DIR="/home/${SUDO_USER:-$USER}"

# ------------------------------
# 1. Atualizações e limpeza inicial
# ------------------------------
echo "Atualizando o sistema..."
apt update && apt full-upgrade -y
apt autoremove --purge -y
apt clean

# ------------------------------
# 2. Ferramentas básicas e utilitários
# ------------------------------
echo "Instalando pacotes básicos..."
apt install -y \
  curl \
  wget \
  git \
  ark \
  rar \
  unrar \
  unzip \
  htop \
  lm-sensors \
  nvme-cli \
  firmware-linux \
  firmware-linux-nonfree \
  make \
  zram-tools

# ------------------------------
# 2. Pacotes para funcionamento de impressora
# ------------------------------
echo "Instalando pacotes para funcionamento da impressora..."
apt install -y \
  printer-driver-escpr \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  system-config-printer \
  print-manager \
  colord \
  avahi-daemon
systemctl enable --now cups
usermod -aG lpadmin "${SUDO_USER:-$USER}"

# ------------------------------
# 4. Timeshift (backup de sistema)
# ------------------------------
echo "Instalando Timeshift..."
apt install -y timeshift

# ------------------------------
# 5. Pacotes necessários para grub-btrfs e timeshift-autosnap-apt
# ------------------------------
git clone https://github.com/Antynea/grub-btrfs.git "$USER_DIR/para_instalar_grub-btrfs/grub-btrfs"
git clone https://github.com/wmutschl/timeshift-autosnap-apt.git "$USER_DIR/para_instalar_grub-btrfs/timeshift-autosnap-apt"
chown -R ${SUDO_USER:-$USER}:${SUDO_USER:-$USER} "$USER_DIR/para_instalar_grub-btrfs"

# ------------------------------
# 6. Otimizações Específicas ThinkPad T14 Gen 1 (Intel)
# ------------------------------
echo "Instalando drivers de mídia Intel, firmware ThinkPad, plymouth e Suporte Biométrico..."
apt install -y \
  intel-microcode \
  intel-media-va-driver-non-free \
  vainfo \
  fwupd \
  thermald \
  fprintd \
  libpam-fprintd \
  plymouth \
  plymouth-themes

# ------------------------------
# 7. Fontes, recursos e estética
# ------------------------------
echo "Instalando kde , plugins, recursos e fontes adicionais..."
apt install -y \
  kde-plasma-desktop \
  plasma-wallpapers-addons \
  kde-spectacle \
  gwenview kcalc \
  korganizer \
  kdepim-addons \
  fonts-noto \
  fonts-noto-color-emoji \
  fonts-dejavu \
  ttf-mscorefonts-installer \
  kio-admin \
  syncthing

# ------------------------------
# 8. Firewall com UFW + KDE connect
# ------------------------------
echo "Configurando o firewall UFW e liberando o KDE Connect..."
apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
# Portas para sincronização do KDE Connect / GSConnect na rede local
ufw allow 1716:1764/udp
ufw allow 1716:1764/tcp
ufw --force enable

# ------------------------------
# 9. Flatpak (opcional, útil para KDE)
# ------------------------------
apt install -y \
  flatpak \
  plasma-discover-backend-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# ------------------------------
# 10. Limpeza final e otimização NVMe
# ------------------------------
echo "Limpando e otimizando..."
apt --fix-broken install
apt autoremove --purge -y
apt clean
fstrim -av
journalctl --vacuum-time=14d

# ------------------------------
# Configuração do GRUB para o Plymouth (splash)
# ------------------------------
echo "Configurando os parâmetros do GRUB para habilitar a tela de splash..."

# Garante que o termo 'splash' seja adicionado à linha GRUB_CMDLINE_LINUX_DEFAULT
if grep -q "GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub; then
    # Se 'splash' ainda não estiver na linha, insere antes das aspas finais
    if ! grep -q "splash" /etc/default/grub; then
        sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/s/"$/ splash"/' /etc/default/grub
        # Trata caso a linha termine com aspas simples ou sem espaço interno limpo
        sed -i 's/quiet  splash/quiet splash/g' /etc/default/grub
    fi
fi

echo "Ativando plymouth padrão para o boot..."
plymouth-set-default-theme -R bgrt
echo "Atualizando a imagem initramfs e as configurações do GRUB..."
update-initramfs -u
update-grub

# ------------------------------
# 11. Resumo final
# ------------------------------
echo "Pós-instalação concluída com sucesso!"
echo "Firewall: $(ufw status | grep Status)"
echo "Timeshift instalado e pronto para configurar"
echo "Reinicie o sistema para aplicar todas as otimizações."
