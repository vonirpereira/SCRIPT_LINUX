#!/bin/bash

# =========================================================================
# Script de Instalação e Configuração para o Laboratório - ALUNO
# Autor: Vonir Antônio Pereira
# Última alteração: 04/10/2025
# =========================================================================

echo "Iniciando a instalação e configuração do sistema."

###----------------------------------------------###
# 1. Deleta o arquivo anterior - usado para criar usuario aluno ao sudo
rm usuario.sh

###----------------------------------------------###
# 2. Comenta a primeira linha do source.list
sudo sed -i '1s/^/# /' /etc/apt/sources.list

###----------------------------------------------###
# 3. Atualiza e faz upgrade do sistema
echo "Atualizando a lista de pacotes e fazendo upgrade..."
sudo apt update -y
sudo apt upgrade -y 

###----------------------------------------------###
# 4. Instalação de aplicativos e pacotes necessários
echo "Instalando aplicativos de software livre..."
sudo apt install -y tuxmath tuxpaint kolourpaint inkscape default-jre gcompris-qt snapd arduino knetwalk gedit bilibop-lockfs

###----------------------------------------------###
# 5. Instalação do Snap e do scratux
echo "Instalando Snap e scratux..."
sudo snap install scratux

###----------------------------------------------###
# 6. Movimenta e configura arquivos
echo "Movendo e configurando arquivos..."
sudo chmod a+x eduactiv8_4.25.07-1_all.deb 
sudo chmod 777 xlogo.jar xlogo.png wallpaper.png freeze
sudo mv xlogo.jar /opt
sudo mv xlogo.png /opt
sudo mv eduactiv8_4.25.07-1_all.deb /opt
sudo mv wallpaper.png /opt
#sudo mv freeze /opt
sudo mv /home/aluno/Downloads/Compartilhar.png /home/aluno/Documentos/
mv *.desktop /home/aluno/Área\ de\ trabalho/

###----------------------------------------------###
# 7. Configurações do ambiente de desktop (MATE)
echo "Configurando o ambiente MATE..."
dconf write /org/mate/caja/desktop/trash-icon-visible true
dconf write /org/mate/caja/desktop/computer-icon-visible true
gsettings set org.mate.Marco.general num-workspaces 1
dconf reset -f /org/mate/panel/toplevels/bottom/
dconf write /org/mate/panel/toplevels/top/orientation "'bottom'"
mate-panel --replace &
gsettings set org.mate.background picture-filename '/opt/wallpaper.png'
gsettings set org.mate.screensaver lock-enabled false

###----------------------------------------------###
# 8. Instalação do EduActiv8
echo "Instalando o EduActiv8..."
sudo dpkg -i /opt/eduactiv8_4.25.07-1_all.deb 
sudo apt install -y python3-pygame
sudo apt --fix-broken install -y
sudo dpkg -i /opt/eduactiv8_4.25.07-1_all.deb 

###----------------------------------------------###
# 9. Criação de atalhos de aplicativos
#echo "Criando atalhos de aplicativos na área de trabalho..."
#DESKTOP_PATH="/home/aluno/Área de trabalho"
## Atalho Xlogo
#DESKTOP_FILE_XLOGO="$DESKTOP_PATH/xlogo.desktop"
#ICON_PATH="/opt/xlogo.png"
#echo "[Desktop Entry]
#Version=1.0
#Type=Application
#Terminal=false
#Exec=java -jar /opt/xlogo.jar
#Name=Xlogo
#Comment=Aplicativo de exemplo Xlogo em Java
#Icon=${ICON_PATH}
#Categories=Education;Utility;" | sudo tee "$DESKTOP_FILE_XLOGO" > /dev/null
#sudo chmod +x "$DESKTOP_FILE_XLOGO"
#sudo chown aluno:aluno "$DESKTOP_FILE_XLOGO"
## Atalho GCompris
#DESKTOP_FILE_GCOMPRIS="$DESKTOP_PATH/gcompris.desktop"
#echo "[Desktop Entry]
#Version=1.0
#Type=Application
#Terminal=false
#Exec=gcompris-qt
#Name=GCompris
#Comment=Pacote de software educacional para crianças
#Icon=gcompris-qt
#Categories=Education;Game;" | sudo tee "$DESKTOP_FILE_GCOMPRIS" > /dev/null
#sudo chmod +x "$DESKTOP_FILE_GCOMPRIS"
#sudo chown aluno:aluno "$DESKTOP_FILE_GCOMPRIS"

###----------------------------------------------###
# 10. Configuração do Veyon
echo "Configurando o Veyon..."
sudo chmod a+x veyon_4.9.6.1-debian.12_amd64.deb
sudo mv veyon_4.9.7.0-debian.13_amd64.deb /opt
sudo dpkg -i /opt/veyon_4.9.7.0-debian.13_amd64.deb
sudo apt install -y libvncserver1
sudo apt --fix-broken install -y
sudo dpkg -i /opt/veyon_4.9.7.0-debian.13_amd64.deb
# cria a pasta se não existir
sudo mkdir -p /etc/veyon
# remove a pasta de chaves existente 
sudo rm -rf /etc/veyon/keys
# move a pasta de chaves
sudo mv keys/ /etc/veyon/
sudo veyon-cli config set Authentication/Method 1
sudo systemctl restart veyon.service

###----------------------------------------------###
# 11. Oculta o Veyon Master
echo "Ocultando o Veyon Master do menu de aplicativos..."
VEYON_MASTER_DESKTOP="/usr/share/applications/veyon-master.desktop"
if [ ! -f "$VEYON_MASTER_DESKTOP" ]; then
    echo "Erro: O arquivo .desktop do Veyon Master não foi encontrado."
else
    if grep -q "NoDisplay=true" "$VEYON_MASTER_DESKTOP"; then
        echo "O atalho do Veyon Master já está oculto."
    else
        echo "NoDisplay=true" | sudo tee -a "$VEYON_MASTER_DESKTOP" > /dev/null
        echo "Ocultado com sucesso."
    fi
fi

###----------------------------------------------###
# 12. Modifica configuração do Tuxpaint - usar tela cheia
sudo mv tuxpaintrc_ajustado /home/aluno/.tuxpaintrc

###----------------------------------------------### 
# 13. Adiciona ARDUBLOCK no arduino e o usuário ao grupo dialout (acessar USBs)
# cria a pasta se não existir
mkdir -p /home/aluno/Arduino
# remove a pasta tools existente
sudo rm -rf /home/aluno/Arduino/tools
# move a pasta tools
sudo mv tools/ /home/aluno/Arduino/
# Torna aluno dono da pasta
sudo chown -R aluno:aluno /home/aluno/Arduino
sudo usermod -aG dialout aluno

###----------------------------------------------###
# 14. INSTALAR SSH
# para ACESSAR: ssh aluno@debian-professor ou aluno (usuario@nomedamaquina)
# para restaurar servico veyon: sudo systemctl restart veyon.service
sudo apt install -y openssh-server openssh-client sshpass ssh 

###----------------------------------------------###
# 15. LIMPAR A LIXEIRA - NECESSARIO COMANDO trash-empty DO PACOTE trash-cli
sudo apt install -y trash-cli 
# yes: É um comando que simplesmente repete a palavra "yes" (sim) 	indefinidamente.
# | (pipe): Redireciona a saída do comando yes para a entrada do comando trash-empty.
yes | trash-empty

###----------------------------------------------###
# 16. ORGANIZAR OS ÍCONES NA AREA DE TRABALHO
# Instale o xdotool se ainda não o tiver: sudo apt install xdotool
sudo apt install -y xdotool
# Posição segura na área de trabalho para abrir o menu
X=200
Y=200
# 1. Abre o menu de contexto na posição (clique direito)
xdotool mousemove $X $Y click 3
# Aumenta a pausa para garantir que o menu apareça completamente
sleep 0.5 
# 2. Garante que o foco está no topo (opcional, mas ajuda a redefinir a navegação)
xdotool key Home
sleep 0.1
# 3. Navega até a opção "Organizar por nome"
# Contagem: 
# Home/Cima: Criar pasta
# Down 1: Criar lançador...
# Down 2: Criar documento
# Down 3: Organizar por nome (Este é o alvo)
xdotool key Down Down Down
sleep 0.1
# 4. Seleciona a opção
xdotool key Return
echo "Ícones da área de trabalho organizados por nome."
sleep 5

###----------------------------------------------###
# 17. BLOQUEAR POSIÇÃO DOS ÍCONES DA AREA DE TRABALHO
# Posição segura na área de trabalho para abrir o menu
X=200
Y=200
# 1. Abre o menu de contexto na posição (clique direito)
xdotool mousemove $X $Y click 3
# Aumenta a pausa para garantir que o menu apareça completamente
sleep 0.5 
# 2. Garante que o foco está no topo (opcional, mas ajuda a redefinir a navegação)
xdotool key Home
sleep 0.1
# 3. Navega até a opção "Bloquear a posição dos ícones"
# Contagem: 
# Home/Cima: Criar pasta
# Down 1: Criar lançador...
# Down 2: Criar documento
# Down 3: Organizar por nome 
# Down 4: Manter alinhado
# Down 5: Bloquear a posição dos ícones (Este é o alvo)
xdotool key Down Down Down Down Down
sleep 0.1
# 4. Seleciona a opção
xdotool key Return
echo "Bloqueado posição dos ícones na Área de trabalho"
sleep 5

###----------------------------------------------###
# 18. BILIBOP-LOCKFS - SE QUISER STARTAR É SÓ REMOVER # DO ARQUIVO /etc/bilibop/bilibop.conf
# Script para deixar Documentos, Downloads, Modelos e Vídeos persistentes

echo ">>> Configurando bilibop-lockfs..."
CONF=/etc/bilibop/bilibop.conf
sudo cp $CONF $CONF.backup.$(date +%F-%H%M)

# Garante que o lockfs está ativo
if grep -q '^BILIBOP_LOCKFS=' $CONF; then
    sudo sed -i 's/^BILIBOP_LOCKFS=.*/#BILIBOP_LOCKFS="true"/' $CONF
else
    echo '#BILIBOP_LOCKFS="true"' | sudo tee -a $CONF
fi


###----------------------------------------------###
# 19. AUTODESTRUIÇÃO DO ARQUIVO 
rm "$0"

echo " "
echo " "
echo ">>> Tudo pronto!"
echo " "
echo "SEU SISTEMA PRECISA SER REINICIADO!"

exit 0
