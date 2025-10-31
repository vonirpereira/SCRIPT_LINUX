#!/bin/bash
# =========================================================================
# Script de Instalação e Configuração para o Laboratório - ALUNO
# Autor: Vonir Antônio Pereira
# Última alteração: 04/10/2025
# =========================================================================

echo "Atribuir sudo ao usuário aluno"

sudo usermod -aG sudo aluno

echo "Atribuído sudo ao usuário aluno"

# 1. Habilita o login automático para o usuário 'aluno'
echo "Configurando o login automático para 'aluno'..."
sudo sed -i 's/#  AutomaticLoginEnable = true/AutomaticLoginEnable = true/' /etc/gdm3/daemon.conf
sudo sed -i 's/#  AutomaticLogin = user1/AutomaticLogin = aluno/' /etc/gdm3/daemon.conf

echo "Configurado login automático para 'ALUNO'..."

# --------------------------
# 2. FUNÇÃO CONTADOR DE TEMPO
# --------------------------
# Exibe um contador regressivo na tela, substituindo a linha a cada segundo.
# Uso: countdown_sleep <segundos>
countdown_sleep() {
    local DURATION=$1
    local i=$DURATION # Inicializa o contador
    
    # Loop 'while' para compatibilidade total com /bin/sh (dash)
    while [ $i -ge 1 ]; do
        # \r: Volta o cursor para o inicio da linha
        # \033[K: Limpa a linha do cursor ate o final (para nao deixar digitos antigos)
        # Nota: O '\r' (retorno de carro) aqui substitui a linha anterior
        echo -ne "\rReiniciar SISTEMA em ${i} segundos... \033[K"
        sleep 1
        i=$((i - 1)) # Decrementa o contador
    done
    # Após o loop, limpa a linha e imprime a mensagem final.
    echo -e "\rReiniciando agora...               \033[K"
}

echo "-------------------------------------"
echo "        SEU SISTEMA SERÁ REINICIADO!"
echo "-------------------------------------"

# O valor '10' define o tempo de espera em segundos.
countdown_sleep 10


/sbin/reboot

exit 0
