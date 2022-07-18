message=$(curl http://whatthecommit.com | grep \<p\> | cut -d ">" -f 2)
git add .
git commit -m "$message"
git push
