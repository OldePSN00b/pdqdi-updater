This seems to work correctly. Got the program automation in for DB update. Be nice if the DB updated after software upgrade without having to launch the console once.
(Yes, it's dumb.. Yes, Deploy and Inventory updates itself, i know. It was more an exercise for me to see if I could get it written.)

1. UpdatePDQProducts.ps1 - My first iteration of the script, needed to run it on the D&I host and it worked just fine.
2. UpdatePDQProductsRemote.ps1 - I didn't want to manually have to get into the PDQ server to do stuff, modified the script so i can just fire it off from my desktop and it'd run on the D&I host for me.
3. UpdatePDQProductsRemoteAndLocal.ps1 - Script updated the D&I host just fine, but when i fired them off on my desktop i still had to click on download and do the update install for both D&I. This newest release solves that problem.
