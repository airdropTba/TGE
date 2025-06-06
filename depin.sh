#!/bin/bash

#基本安装功能（选择1）
basic_installation() {
    # Update system package list
Sudo apt更新

    # Install prerequisites for NVM
    sudo apt install curl -y

    # Install NVM (Node Version Manager)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    # Load NVM into the current shell session
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

    # Install Node.js version 16 using NVM
    nvm install 16

    # Install PM2 globally
    npm install pm2@latest -g

    # Set up PM2 to auto-start on system startup
    pm2 startup systemd -u $USER --hp $HOME
    sudo env PATH=$PATH:/home/$USER/.nvm/versions/node/$(nvm version)/bin pm2 startup systemd -u $USER --hp $HOME

安装Docker依赖项
安装apt-transport-https ca-certificates curl软件-properties-common

添加Docker的官方GPG密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg——dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

建立Docker的稳定库
“deb [arch=$(dpkg—print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring”。gpg) \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
Sudo tee /etc/apt/sources.list.d/docker。列出> /dev
妳

#重新更新包数据库
Sudo apt更新

#安装Docker
安装docker-ce docker-ce cliio - y

启用Docker服务启动
执行命令systemctl启用docker

#提示用户输入乒乓球设备ID
读取-p“乒乓设备ID：”device_id

#创建带有设备ID的JSON文件
    cat <<EOF > secrets.json
{
:“pingpong_device_id device_id美元”
}
EOF

#安装jq解析JSON
安装jq -y

#从secrets.json中读取pingpong_device_id
Pingpong_device_id =$（jq -r）。pingpong_device_id secrets.json)

#下载乒乓球可执行文件
乒乓球https://pingpong-build.s3.ap-southeast-1.amazonaws.com/linux/latest/PINGPONG

#使其可执行
chmod x ./乒乓

#使用带有设备ID的PM2启动乒乓球
    pm2 start ./PINGPONG --name PINGPONG -- --key "$pingpong_device_id"

    # Save the PM2 process list and corresponding environments
    pm2 save
    source ~/.bashrc

    # Print completion message
    echo "Installation complete! NVM, Node.js 16, PM2, and Docker have been installed."
    echo "PINGPONG is now running under PM2 with auto-restart on reboot or crash."
}

# Function for turning on/restarting Blockmesh (Selection 2)
turn_on_blockmesh() {
    # Prompt the user for Blockmesh email and password
    read -p "Blockmesh Email: " blockmesh_email
    read -s -p "Blockmesh Password: " blockmesh_password
    echo

    # Update secrets.json with Blockmesh credentials
    jq --arg email "$blockmesh_email" --arg pwd "$blockmesh_password" '. + {blockmesh_email: $email, blockmesh_pwd: $pwd}' secrets.json > temp.json && mv temp.json secrets.json

    # Read credentials from secrets.json
Blockmesh_email =$（jq -r）。blockmesh_email secrets.json)
Blockmesh_pwd =$（jq -r）。blockmesh_pwd secrets.json)

    # Configure PINGPONG with Blockmesh credentials
./乒乓配置设置——blockmesh。电子邮件= " $ blockmesh_email”——blockmesh.pwd = " $ blockmesh_pwd "

    # Restart Blockmesh dependency
./乒乓球停止——depins=blockmesh
./乒乓球开始——depins=blockmesh

“Blockmesh已配置并重启。”
}

#开启/重启黎明的功能（选择3）
turn_on_dawn() {
    # Prompt the user for Dawn email and password
    read -p "Dawn Email: " dawn_email
    read -s -p "Dawn Password: " dawn_password
    echo

    # Update secrets.json with Dawn credentials
Jq——arg email“ $dawn_email”——arg PWD "$dawn_password" '。{dawn_email: $email, dawn_pwd: $pwd}' secrets。Json > temp.json && mv temp.json secrets.json

#从secrets.json中读取凭证
Dawn_email =$(jq -r '。dawn_email secrets.json)
Dawn_pwd =$（jq -r）dawn_pwd secrets.json)

#配置乒乓与黎明凭据
./乒乓配置设置——黎明。电子邮件= " $ dawn_email”——dawn.pwd = " $ dawn_pwd "

重启Dawn依赖
/乒乓球停止——depins=黎明
/乒乓球开始——开始=黎明

echo“Dawn已配置并重新启动。”
}

#打开/重新启动草（选择4）
turn_on_grass() {
    # Prompt the user for Grass access and refresh tokens
读取-p“草访问令牌：”grass_access
读取-p“草刷新令牌：”grass_refresh

    # Update secrets.json with Grass tokens
Jq——arg访问$grass_access——arg刷新$grass_refresh{grass_access: $access, grass_refresh: $refresh}’的秘密。Json > temp.json && mv temp.json secrets.json

#从secrets.json中读取令牌
$(jq -r)；grass_access secrets.json)
Grass_refresh =$（jq -r）。grass_refresh secrets.json)

#配置乒乓球与草令牌
./乒乓配置设置-草。访问= " $ grass_access”——grass.refresh = " $ grass_refresh "

    # Restart Grass dependency
    ./PINGPONG stop --depins=grass
    ./PINGPONG start --depins=grass

echo“Grass已配置并重新启动。”
}

#主菜单功能
show_menu() {
echo “Please select an option:”
1)基础安装
2)打开（重启）Blockmesh
3)打开（重启）黎明”
4)打开（重启）草
echo “5) Exit”
    read -p "Enter your choice [1-5]: " choice

Case $choice in
        1)
            basic_installation
            ;;
        2)
            turn_on_blockmesh
            ;;
        3)
            turn_on_dawn
            ;;
        4)
            turn_on_grass
            ;;
        5)
回声“退出……”
            exit 0
            ;;
        *)
“无效选择！”
            show_menu
            ;;
    esac
}

# Run the menu
show_menu


