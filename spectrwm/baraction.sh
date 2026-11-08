#!/bin/sh

print_date() {
	# The date is printed to the status bar by default.
	# To print the date through this script, set clock_enabled to 0
	# in spectrwm.conf.  Uncomment "print_date" below.
	#FORMAT="%a %b %d %R %Z %Y"
	FORMAT="%T %d-%m-%y"
	DATE=$(date "+${FORMAT}")
	echo -n "${DATE}"
}

# Convert bytes to mb
mb() {
	echo $1/2^20 | bc
}

# Calculate percentage
percent() {
	echo "scale=4; ($1 / $2) * 100"  | bc | cut -d . -f1
}

print_mem() {
	# This i can understand...
	#mem_phys=$(sysctl hw.physmem | sed 's/^.*: //')
	mem_phys=$(sysctl -n hw.physmem)

	# Oh god....
	mem_pagesize=$(sysctl -n hw.pagesize)

	# Makes sense, fully available for allocation
	mem_free=$(echo "$(sysctl -n vm.stats.vm.v_free_count) * $mem_pagesize" | bc)
	
	# I guess recently allocated but unused
	mem_inactive=$(echo "$(sysctl -n vm.stats.vm.v_inactive_count) * $mem_pagesize" | bc)
	
	# Calculate available memory
	mem_avail=$(echo "$mem_free + $mem_inactive" | bc)

	# Calculate used memory
	mem_used=$(echo "$mem_phys - $mem_avail" | bc)
	
	used_p=$(percent $mem_used $mem_phys)

	# Display
	#echo  Used: $(mb $mem_used) MB \| free: $(mb $mem_free) MB \| phys: $(mb $mem_phys) MB
	echo $(mb $mem_used)mb / $(mb $mem_phys)mb \($used_p%\)
}

print_disk() {
	disk=$(df -h | grep -m 1 /dev/)
	size=$(echo $disk | awk '{print $2}' | cut -d 'G' -f 1)
	used=$(echo $disk | awk '{print $3}' | cut -d 'G' -f 1)
	used_p=$(percent $used $size)
	echo ${used}G / ${size}G \($used_p%\)
}

print_vol() {
	muted=$(mixer vol.mute | cut -d "=" -f 2)
	vol_raw=$(mixer vol.volume | cut -d ":" -f 2)
	vol="$(echo "$vol_raw * 100" | bc | cut -d . -f 1)"
	vol_str=""
	#if [ $muted = 1 ] || [ $vol = 0 ]; then
	if [ $muted = 1 ]; then
		vol_str="muted"
	else
		vol_str=$(echo "$vol%") 
	fi

	echo $vol_str
}




while :; do
	echo "+@fg=1;vol +@fg=4;$(print_vol)+@fg=0; | +@fg=1;mem +@fg=3;$(print_mem)+@fg=0; | +@fg=1;hdd +@fg=5;$(print_disk)+@fg=0; | +@fg=1;date +@fg=6;$(print_date)+@fg=0;"
	sleep 1
done
