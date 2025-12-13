[jenkins_master]
public ansible_host=${public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/dan-amazon-new.pem

[jenkins_worker]
private ansible_host=${private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/dan-amazon-new.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyJump=ubuntu@${public_ip}'