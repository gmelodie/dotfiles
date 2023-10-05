git stash
git pull
message=$(curl https://whatthecommit.com | grep \<p\> | cut -d ">" -f 2)
git stash pop
git add .
git commit -m "$message"
git push
