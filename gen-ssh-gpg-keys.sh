stty sane # prevent the ^M on enter issue
read -p "Your Name: " name
read -p "Your Email: " email
KEY_TYPE=ed25519

echo "-----------------------  SSH KEY  ------------------------"

ssh-keygen -t $KEY_TYPE -f ~/.ssh/id_$KEY_TYPE -C "$email" -N ""

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_$KEY_TYPE

cat ~/.ssh/id_$KEY_TYPE.pub

echo "-----------------------  GPG KEY  ------------------------"

gpg --quick-generate-key "$name <$email>" $KEY_TYPE default never

gpgkeyid=$(gpg --list-secret-keys --keyid-format LONG | grep -B 2 "$name" | grep "sec\s*$KEY_TYPE" | sed 's/\//\ /g' | awk -F " " 'NR==1{print $3}')

gpg --armor --export $gpgkeyid

gpgfingerprint=$(gpg --list-secret-keys | grep $gpgkeyid | sed 's/\s//g')

cat > ~/.gitconfig.local <<EOF
[user]
	signingkey = $gpgfingerprint
EOF

echo "----------------------------------------------------------"
