function setup_ps1 {
	# echo $DIR
	
	. $DIR/modules/git.sh
	PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'; PS1='\u at \H in \w${PS1_CMD1}\n\$ '
}


