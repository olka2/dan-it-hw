[webservers]
%{ for ip in web_ips ~}
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/dan-amazon-new.pem
%{ endfor ~}