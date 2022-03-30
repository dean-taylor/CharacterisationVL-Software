#!/usr/bin/env bash
# Update a host XDG environment with application specific settings
# contained within the Singularity image
# AUTHOR: Dean Taylor <dean.taylor@uwa.edu.au>
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

exit 0

Copyright 2022 Dean Taylor

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
