#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apache2
sudo apt-getsystemctl start apache2
sudo apt-get systemctl enable apache2

echo "<html><head><title> Apache 2023 Terraform </title>
</head>
<body>
<h1>Congratulations! YOU DID IT!!! <h1>
<hr>
<article>
  <p> Welcome Green Team!! You successfully launched an AWS EC2 Instance with a Custom Apache webpage, and completed the WK21 Terraform ASG Objective! <p>
  <header><p> Completed by Mel Foster 07/09/2023 </p></body>
</html>" >/var/www/html/index.html

