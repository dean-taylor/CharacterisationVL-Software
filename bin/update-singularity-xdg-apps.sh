#!/usr/bin/env bash
# 
APPS="${XDG_DATA_HOME:=$HOME/.local/share}/applications"
BIN_DIR='/opt/accs/bin'

[ -d "${APPS}" ] || mkdir -p "${APPS}"

# for every executable file in the path
while IFS= read -r -d '' line; do
	# if file is a singularity executable continue processing
	if file "${line}" |grep -q 'a /usr/bin/env run-singularity script executable'; then
		# get desktop file path from the singularity container labels
		XDG_DESKTOP=$(singularity inspect --labels "${line}" |sed -n 's/^XDG-DESKTOP: \(.*\)$/\1/p')
		[ -z $XDG_DESKTOP ] && continue

		# copy the desktop file from the container into XDG path if not already done
		APP="$APPS/${XDG_DESKTOP##*/}"
		[ -f $APP ] || \
			singularity exec "${line}" sh -c "cat $XDG_DESKTOP" >"${APP}"
	fi
done < <(find "${BIN_DIR}" -type f -executable -print0)
