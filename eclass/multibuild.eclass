# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/multibuild.eclass,v 1.3 2013/03/04 19:27:00 mgorny Exp $

# @ECLASS: multibuild
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# @BLURB: A generic eclass for building multiple variants of packages.
# @DESCRIPTION:
# The multibuild eclass aims to provide a generic framework for building
# multiple 'variants' of a package (e.g. multilib, Python
# implementations).

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	5)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_MULTIBUILD} ]]; then

inherit multiprocessing

# @ECLASS-VARIABLE: MULTIBUILD_VARIANTS
# @DESCRIPTION:
# An array specifying all enabled variants which multibuild_foreach*
# can execute the process for.
#
# In ebuild, it can be set in global scope. Eclasses should set it
# locally in function scope to support nesting properly.
#
# Example:
# @CODE
# python_foreach_impl() {
#	local MULTIBUILD_VARIANTS=( python{2_5,2_6,2_7} ... )
#	multibuild_foreach_variant python_compile
# }
# @CODE

# @ECLASS-VARIABLE: MULTIBUILD_VARIANT
# @DESCRIPTION:
# The current variant which the function was executed for.
#
# Example value:
# @CODE
# python2_6
# @CODE

# @ECLASS-VARIABLE: MULTIBUILD_ID
# @DESCRIPTION:
# The unique identifier for a multibuild run. In a simple run, it is
# equal to MULTIBUILD_VARIANT. In a nested multibuild environment, it
# contains the complete selection tree.
#
# It can be used to create variant-unique directories and files.
#
# Example value:
# @CODE
# amd64-double
# @CODE

# @ECLASS-VARIABLE: BUILD_DIR
# @DESCRIPTION:
# The current build directory. In global scope, it is supposed
# to contain an 'initial' build directory. If unset, ${S} is used.
#
# multibuild_foreach_variant() sets BUILD_DIR locally
# to variant-specific build directories based on the initial value
# of BUILD_DIR.
#
# Example value:
# @CODE
# ${WORKDIR}/foo-1.3-python2_6
# @CODE

# @FUNCTION: multibuild_foreach_variant
# @USAGE: [<argv>...]
# @DESCRIPTION:
# Run the passed command repeatedly for each of the enabled package
# variants.
#
# Each of the runs will have variant-specific BUILD_DIR set, and output
# teed to a separate log in ${T}.
#
# The function returns 0 if all commands return 0, or the first non-zero
# exit status otherwise. However, it performs all the invocations
# nevertheless. It is preferred to call 'die' inside of the passed
# function.
multibuild_foreach_variant() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MULTIBUILD_VARIANTS} ]] \
		|| die "MULTIBUILD_VARIANTS need to be set"

	local bdir=${BUILD_DIR:-${S}}

	# Avoid writing outside WORKDIR if S=${WORKDIR}.
	[[ ${bdir%%/} == ${WORKDIR%%/} ]] && bdir=${WORKDIR}/build

	local prev_id=${MULTIBUILD_ID:+${MULTIBUILD_ID}-}
	local ret=0 lret=0 v

	debug-print "${FUNCNAME}: initial build_dir = ${bdir}"

	for v in "${MULTIBUILD_VARIANTS[@]}"; do
		local MULTIBUILD_VARIANT=${v}
		local MULTIBUILD_ID=${prev_id}${v}
		local BUILD_DIR=${bdir%%/}-${v}
		local log_fd

		# redirect_alloc_fd accepts files only. so we need to open
		# a random file and then reuse the fd for logger process.
		redirect_alloc_fd log_fd /dev/null

		_multibuild_run() {
			# find the first non-private command
			local i=1
			while [[ ${!i} == _* ]]; do
				(( i += 1 ))
			done

			[[ ${i} -le ${#} ]] && einfo "${v}: running ${@:${i}}"
			"${@}"
		}

		# bash can't handle ${log_fd} in redirections,
		# we need to use eval to pass fd numbers directly.
		eval "
			exec ${log_fd}> >(exec tee -a \"\${T}/build-\${MULTIBUILD_ID}.log\")
			_multibuild_run \"\${@}\" >&${log_fd} 2>&1
			lret=\${?}
			exec ${log_fd}>&-
		"
	done
	[[ ${ret} -eq 0 && ${lret} -ne 0 ]] && ret=${lret}

	return ${ret}
}

# @FUNCTION: multibuild_parallel_foreach_variant
# @USAGE: [<argv>...]
# @DESCRIPTION:
# Run the passed command repeatedly for each of the enabled package
# variants alike multibuild_foreach_variant. Multiple invocations of the command
# will be performed in parallel, up to MULTIBUILD_JOBS tasks.
#
# The function returns 0 if all commands return 0, or the first non-zero
# exit status otherwise. However, it performs all the invocations
# nevertheless. It is preferred to call 'die' inside of the passed
# function.
multibuild_parallel_foreach_variant() {
	debug-print-function ${FUNCNAME} "${@}"

	local ret lret

	_multibuild_parallel() {
		(
			multijob_child_init
			"${@}"
		) &
		multijob_post_fork
	}

	local opts
	if [[ ${MULTIBUILD_JOBS} ]]; then
		opts=-j${MULTIBUILD_JOBS}
	else
		opts=${MAKEOPTS}
	fi

	multijob_init "${opts}"
	multibuild_foreach_variant _multibuild_parallel "${@}"
	ret=${?}
	multijob_finish
	lret=${?}

	[[ ${ret} -eq 0 ]] && ret=${lret}
	return ${ret}
}

# @FUNCTION: run_in_build_dir
# @USAGE: <argv>...
# @DESCRIPTION:
# Run the given command in the directory pointed by BUILD_DIR.
run_in_build_dir() {
	debug-print-function ${FUNCNAME} "${@}"
	local ret

	[[ ${#} -ne 0 ]] || die "${FUNCNAME}: no command specified."
	[[ ${BUILD_DIR} ]] || die "${FUNCNAME}: BUILD_DIR not set."

	pushd "${BUILD_DIR}" >/dev/null || die
	"${@}"
	ret=${?}
	popd >/dev/null || die

	return ${ret}
}

_MULTIBUILD=1
fi
