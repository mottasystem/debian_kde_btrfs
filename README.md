# Posinstall_Debian_Thinkpad_intel_T14_gen1_KDE
Script para instalação de pacotes KDE em notebooks Thinkpad T14 Gen1 com btrfs

# 🚀 Debian KDE Post-Install Script

Um script em Bash automatizado e otimizado para a pós-instalação do **Debian (Testing/Stable)** com ambiente de trabalho **KDE Plasma**, focado em hardware **ThinkPad** (Intel) e unidades de armazenamento **NVMe/Btrfs**.

---

## 🛠️ O que este script faz?

* **Atualização do Sistema:** Executa a atualização completa dos pacotes (`full-upgrade`) e limpa resíduos do sistema.
* **Ferramentas de Sistema & Utilidades:** Instala pacotes essenciais como `curl`, `wget`, `git`, `htop`, `lm-sensors`, `nvme-cli`, utilitários de descompactação e `zram-tools`.
* **Suporte a Impressão:** Configura o **CUPS**, filtros de impressão, suporte a Avahi (AirPrint/Driverless) e o gerenciador de impressão nativo do KDE Plasma.
* **Firmware & Otimizações ThinkPad:** Instala microcódigo Intel, drivers de mídia `VA-API`, `thermald`, `fwupd` e suporte a biometria (`fprintd`).
* **Ambiente KDE Plasma Completo:** Instala o desktop Plasma, extensões de wallpaper, utilitários (Spectacle, Gwenview, KCalc, KOrganizer), fontes essenciais e integração de permissões Flatpak (`kde-config-flatpak`).
* **Segurança:** Configura e ativa o firewall **UFW**, liberando automaticamente as portas para sincronização com o **KDE Connect**.
* **Suporte a Flatpak:** Habilita o suporte nativo e adiciona o repositório Flathub.
* **Snapshots Btrfs & Backup:** Instala o **Timeshift**, dependências para o `grub-btrfs` e clona repositórios auxiliares na pasta do usuário sem conflito de permissões.
* **Estética & Boot:** Configura e ativa a tela de boot **Plymouth** com o tema `bgrt` (logo do fabricante) e atualiza o GRUB com os parâmetros corretos (`splash`).
* **Manutenção NVMe:** Executa `fstrim` para otimização de SSDs/NVMes e reduz o acúmulo de logs do `journalctl`.

---

## 📋 Pré-requisitos

1. Uma instalação limpa do Debian (12 / 13) configurada preferencialmente com Btrfs.
2. Acesso à internet durante a execução do script.
3. Permissões de superusuário (`sudo` ou `root`).

---

## 🚀 Como Executar

Clone este repositório e execute o script com permissões de administrador:

```bash
# 1. Clone o repositório
git clone https://github.com/mottasystem/debian_kde_btrfs.git
cd debian_kde_btrfs

# 2. Dê permissão de execução ao script
chmod +x debian_after_install_kde_2.0_2.sh

# 3. Execute o script
sudo ./debian_after_install_kde_2.0_2.sh

```

> **Nota:** É recomendável reiniciar o computador após a conclusão da execução para que todas as alterações do kernel, GRUB, grupo de usuários e firewall entrem em vigor.

---

## 🔬 Testando em Ambiente Virtualized

Se deseja testar modificações no script com segurança antes de aplicar em seu hardware principal, recomendo importar uma ISO do Debian no **Virt-Manager (KVM/QEMU)**, tirar um *snapshot* do sistema limpo e rodar os testes.

---

## 📄 Licença

Sinta-se à vontade para clonar, modificar e adaptar este script para as suas necessidades pessoais.

