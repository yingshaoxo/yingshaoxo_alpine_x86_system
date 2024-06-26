#!/bin/sh
# Copyright (c) 2012 Alexander Vershilov <qnikst@gentoo.org>
# Released under the 2-clause BSD license.
extra_stopped_commands="${extra_stopped_commands} cgroup_cleanup"

cgroup_find_path()
{
	local OIFS n name dir result
	[ -n "$1" ] || return 0
	OIFS="$IFS"
	IFS=":"
	while read n name dir; do
		[ "$name" = "$1" ] && result="$dir"
	done < /proc/1/cgroup
	IFS="$OIFS"
	echo $result
}

cgroup_get_pids()
{
	local p
	pids=
	while read p; do
		[ $p -eq $$ ] || pids="${pids} ${p}"
	done < /sys/fs/cgroup/openrc/${RC_SVCNAME}/tasks
	[ -n "$pids" ]
}

cgroup_running()
{
	[ -d "/sys/fs/cgroup/openrc/${RC_SVCNAME}" ]
}

cgroup_set_values()
{
	[ -n "$1" -a -n "$2" -a -d "/sys/fs/cgroup/$1" ] || return 0

	local controller="$1" h=$(cgroup_find_path "$1")
	cgroup="/sys/fs/cgroup/${1}${h}openrc_${RC_SVCNAME}"
	[ -d "$cgroup" ] || mkdir -p "$cgroup"

	set -- $2
	local name val
	while [ -n "$1" -a "$controller" != "cpuacct" ]; do
		case "$1" in
			$controller.*)
				if [ -n "$name" -a -f "$cgroup/$name" -a -n "$val" ]; then
					veinfo "$RC_SVCNAME: Setting $cgroup/$name to $val"
					echo $val > "$cgroup/$name"
				fi
				name=$1
				val=
				;;
			*)
				val="$val $1"
				;;
		esac
		shift
	done
	if [ -n "$name" -a -f "$cgroup/$name" -a -n "$val" ]; then
		veinfo "$RC_SVCNAME: Setting $cgroup/$name to $val"
		echo $val > "$cgroup/$name"
	fi

	if [ -f "$cgroup/tasks" ]; then
		veinfo "$RC_SVCNAME: adding to $cgroup/tasks"
		echo 0 > "$cgroup/tasks"
	fi

	return 0
}

cgroup_add_service()
{
    # relocate starting process to the top of the cgroup
    # it prevents from unwanted inheriting of the user
    # cgroups. But may lead to a problems where that inheriting
    # is needed.
	for d in /sys/fs/cgroup/* ; do
		[ -f "${d}"/tasks ] && echo 0 > "${d}"/tasks
	done

	openrc_cgroup=/sys/fs/cgroup/openrc
	if [ -d "$openrc_cgroup" ]; then
		cgroup="$openrc_cgroup/$RC_SVCNAME"
		mkdir -p "$cgroup"
		[ -f "$cgroup/tasks" ] && echo 0 > "$cgroup/tasks"
	fi
}

cgroup_set_limits()
{
	local blkio="${rc_cgroup_blkio:-$RC_CGROUP_BLKIO}"
	[ -n "$blkio" ] && cgroup_set_values blkio "$blkio"

	local cpu="${rc_cgroup_cpu:-$RC_CGROUP_CPU}"
	[ -n "$cpu" ] && cgroup_set_values cpu "$cpu"

	local cpuacct="${rc_cgroup_cpuacct:-$RC_CGROUP_CPUACCT}"
	[ -n "$cpuacct" ] && cgroup_set_values cpuacct "$cpuacct"

	local cpuset="${rc_cgroup_cpuset:-$RC_CGROUP_cpuset}"
	[ -n "$cpuset" ] && cgroup_set_values cpuset "$cpuset"

	local devices="${rc_cgroup_devices:-$RC_CGROUP_DEVICES}"
	[ -n "$devices" ] && cgroup_set_values devices "$devices"

	local memory="${rc_cgroup_memory:-$RC_CGROUP_MEMORY}"
	[ -n "$memory" ] && cgroup_set_values memory "$memory"

	local net_prio="${rc_cgroup_net_prio:-$RC_CGROUP_NET_PRIO}"
	[ -n "$net_prio" ] && cgroup_set_values net_prio "$net_prio"

	return 0
}

cgroup_cleanup()
{
	cgroup_running || return 0
	ebegin "starting cgroups cleanup"
	for sig in TERM QUIT INT; do
		cgroup_get_pids || { eend 0 "finished" ; return 0 ; }
		for i in 0 1; do
			kill -s $sig $pids
			for j in 0 1 2; do
				cgroup_get_pids || { eend 0 "finished" ; return 0 ; }
				sleep 1
			done
		done 2>/dev/null
	done
	cgroup_get_pids || { eend 0 "finished" ; return 0; }
	kill -9 $pids
	eend $(cgroup_running && echo 1 || echo 0) "fail to stop all processes"
}
