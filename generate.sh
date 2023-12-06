#!/bin/bash

BINLS=$(ls bin/|base64)
BINDIR=$(tar -cz -O bin/ | base64)
VIMRC=$(base64 .vsenv/.vimrc)
SCREENRC=$(base64 .vsenv/.screenrc)
BASHRC=$(base64 .vsenv/.bashrc)

cat << VSENV > vsenv.sh
#!/bin/bash

VSENV=\$HOME/.vsenv

binls='
$BINLS
'
bindir='
$BINDIR
'
vimrc='
$VIMRC
'
screenrc='
$SCREENRC
'
bashrc='
$BASHRC
'

remove () {
	echo "remove"
	rm -rf \$VSENV
	for file in \$(echo \$binls|base64 -d); do
		rm -f \$HOME/bin/\$file
	done
}

create () {
	remove
	echo "create"
	mkdir -p \$VSENV

	base64 -d <<< "\$bashrc" 	> \$VSENV/.bashrc
	base64 -d <<< "\$screenrc" 	> \$VSENV/.screenrc
	base64 -d <<< "\$vimrc" 	> \$VSENV/.vimrc

	cd \$HOME
	tar -xzf <(base64 -d <<< "\$bindir")
	cd -
	
	cp "\$0" $HOME/bin/vsenv
	rm -- "\$0"
}
	
while getopts "rc" flag
do
	case \$flag in
		r) 	remove;;
		c) 	create;;
	esac
done

if [ -d \$VSENV ]; then
	screen -S \$USER -c \$VSENV/.screenrc
fi

VSENV

chmod +x vsenv.sh
