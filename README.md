# vim-configurator-script
## Configures Vim on any machine as per my needs.
Make sure you have Python3 Installed.<br>
<br>Run the following Commands: <br>
```
wget https://raw.githubusercontent.com/dragod812/vim-configurator-script/master/vim.py

sudo python3 ./vim.py -u "<username>"
```
You might get an error like this:<br>
```
Command failed: chown -H -R <username>:<username> /home/<username>/
```
Just Ignore it.<br><br>
After installation open Vim and Type:
```
:PluginInstall
```
<br>

For help: <br>
```
./vim.py --help
```

For MacOS -
replace the /home/ for directory inside the vim.py files with /Users/. 
<br><br>
 **Credits: thesheff17**
