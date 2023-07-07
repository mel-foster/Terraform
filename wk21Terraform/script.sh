#! /bin/bash
sudo apt update -y
sudo apt install -y apache2
sudo cat > /var/www/html/index.html << EOF
<html>
<head>
  <title> Apache 2023 Terraform </title>
</head>
<body>
  <p> Welcome Green Team!! WK21 Terraform ASG by Mel Foster 07/23
</body>
</html>
EOF
