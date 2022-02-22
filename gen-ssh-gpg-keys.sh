stty sane # prevent the ^M on enter issue
read -p "Your Name: " name
read -p "Your Email: " email

echo "-----------------------  SSH KEY  ------------------------"

echo "\n" | ssh-keygen -C "$email" -N ""

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_rsa

cat ~/.ssh/id_rsa.pub

echo "-----------------------  GPG KEY  ------------------------"

gpg --quick-generate-key "$name <$email>" rsa4096 default never

gpgkey=$(gpg --list-secret-keys --keyid-format LONG | grep -B 2 $name | grep 'sec\s*rsa4096' | sed 's/\//\ /g' | awk -F " " 'NR==1{print $3}')

gpg --armor --export $gpgkey

git config --global user.signingkey $gpgkey

echo "----------------------------------------------------------"
