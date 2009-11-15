# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/python.eclass,v 1.79 2009/11/15 22:00:47 arfrever Exp $

# @ECLASS: python.eclass
# @MAINTAINER:
# python@gentoo.org
# @BLURB: A utility eclass that should be inherited by anything that deals with Python or Python modules.
# @DESCRIPTION:
# Some useful functions for dealing with Python.

inherit multilib

if [[ -n "${NEED_PYTHON}" ]]; then
	PYTHON_ATOM=">=dev-lang/python-${NEED_PYTHON}"
	DEPEND="${PYTHON_ATOM}"
	RDEPEND="${DEPEND}"
else
	PYTHON_ATOM="dev-lang/python"
fi

DEPEND+=" >=app-admin/eselect-python-20090804
	>=app-shells/bash-3.2"

__python_eclass_test() {
	__python_version_extract 2.3
	echo -n "2.3 -> PYVER: $PYVER PYVER_MAJOR: $PYVER_MAJOR"
	echo " PYVER_MINOR: $PYVER_MINOR PYVER_MICRO: $PYVER_MICRO"
	__python_version_extract 2.3.4
	echo -n "2.3.4 -> PYVER: $PYVER PYVER_MAJOR: $PYVER_MAJOR"
	echo " PYVER_MINOR: $PYVER_MINOR PYVER_MICRO: $PYVER_MICRO"
	__python_version_extract 2.3.5
	echo -n "2.3.5 -> PYVER: $PYVER PYVER_MAJOR: $PYVER_MAJOR"
	echo " PYVER_MINOR: $PYVER_MINOR PYVER_MICRO: $PYVER_MICRO"
	__python_version_extract 2.4
	echo -n "2.4 -> PYVER: $PYVER PYVER_MAJOR: $PYVER_MAJOR"
	echo " PYVER_MINOR: $PYVER_MINOR PYVER_MICRO: $PYVER_MICRO"
	__python_version_extract 2.5b3
	echo -n "2.5b3 -> PYVER: $PYVER PYVER_MAJOR: $PYVER_MAJOR"
	echo " PYVER_MINOR: $PYVER_MINOR PYVER_MICRO: $PYVER_MICRO"
}

# @FUNCTION: python_version
# @DESCRIPTION:
# Run without arguments and it will export the version of python
# currently in use as $PYVER; sets PYVER/PYVER_MAJOR/PYVER_MINOR
__python_version_extract() {
	local verstr=$1
	export PYVER_MAJOR=${verstr:0:1}
	export PYVER_MINOR=${verstr:2:1}
	if [[ ${verstr:3:1} == . ]]; then
		export PYVER_MICRO=${verstr:4}
	fi
	export PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"
}

python_version() {
	[[ -n "${PYVER}" ]] && return 0
	local tmpstr
	python=${python:-/usr/bin/python}
	tmpstr="$(${python} -V 2>&1 )"
	export PYVER_ALL="${tmpstr#Python }"
	__python_version_extract $PYVER_ALL
}

# @FUNCTION: PYTHON
# @USAGE: [-a|--absolute-path] [--] <Python_ABI="${PYTHON_ABI}">
# @DESCRIPTION:
# Get Python interpreter filename for specified Python ABI. If Python_ABI argument
# is ommitted, then PYTHON_ABI environment variable must be set and is used.
PYTHON() {
	local absolute_path="0" slot=

	while (($#)); do
		case "$1" in
			-a|--absolute-path)
				absolute_path="1"
				;;
			--)
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option $1"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -eq "0" ]]; then
		if [[ -n "${PYTHON_ABI}" ]]; then
			slot="${PYTHON_ABI}"
		else
			die "${FUNCNAME}(): Invalid usage"
		fi
	elif [[ "$#" -eq "1" ]]; then
		slot="$1"
	else
		die "${FUNCNAME}(): Invalid usage"
	fi

	if [[ "${absolute_path}" == "1" ]]; then
		echo -n "/usr/bin/python${slot}"
	else
		echo -n "python${slot}"
	fi

	if [[ -n "${ABI}" && "${ABI}" != "${DEFAULT_ABI}" && "${DEFAULT_ABI}" != "default" ]]; then
		echo -n "-${ABI}"
	fi
}

unset PYTHON_ABIS
unset PYTHON_ABIS_SANITY_CHECKS

# @FUNCTION: validate_PYTHON_ABIS
# @DESCRIPTION:
# Ensure that PYTHON_ABIS variable has valid value.
validate_PYTHON_ABIS() {
	# Ensure that some functions cannot be accidentally successfully used in EAPI <= 2 without setting SUPPORT_PYTHON_ABIS variable.
	if has "${EAPI:-0}" 0 1 2 && [[ -z "${SUPPORT_PYTHON_ABIS}" ]]; then
		die "${FUNCNAME}() cannot be used in this EAPI without setting SUPPORT_PYTHON_ABIS variable"
	fi

	# Ensure that /usr/bin/python and /usr/bin/python-config are valid.
	if [[ "$(readlink /usr/bin/python)" != "python-wrapper" ]]; then
		die "'/usr/bin/python' isn't valid symlink"
	fi
	if [[ "$(</usr/bin/python-config)" != *"Gentoo python-config wrapper script"* ]]; then
		die "'/usr/bin/python-config' isn't valid script"
	fi

	# USE_${ABI_TYPE^^} and RESTRICT_${ABI_TYPE^^}_ABIS variables hopefully will be included in EAPI >= 4.
	if [[ "$(declare -p PYTHON_ABIS 2> /dev/null)" != "declare -x PYTHON_ABIS="* ]] && has "${EAPI:-0}" 0 1 2 3; then
		local PYTHON_ABI python2_supported_versions python3_supported_versions restricted_ABI support_ABI supported_PYTHON_ABIS=
		PYTHON_ABI_SUPPORTED_VALUES="2.4 2.5 2.6 2.7 3.0 3.1 3.2"
		python2_supported_versions="2.4 2.5 2.6 2.7"
		python3_supported_versions="3.0 3.1 3.2"

		if [[ "$(declare -p USE_PYTHON 2> /dev/null)" == "declare -x USE_PYTHON="* ]]; then
			local python2_enabled="0" python3_enabled="0"

			if [[ -z "${USE_PYTHON}" ]]; then
				die "USE_PYTHON variable is empty"
			fi

			for PYTHON_ABI in ${USE_PYTHON}; do
				if ! has "${PYTHON_ABI}" ${PYTHON_ABI_SUPPORTED_VALUES}; then
					die "USE_PYTHON variable contains invalid value '${PYTHON_ABI}'"
				fi

				if has "${PYTHON_ABI}" ${python2_supported_versions}; then
					python2_enabled="1"
				fi
				if has "${PYTHON_ABI}" ${python3_supported_versions}; then
					python3_enabled="1"
				fi

				support_ABI="1"
				for restricted_ABI in ${RESTRICT_PYTHON_ABIS}; do
					if [[ "${PYTHON_ABI}" == ${restricted_ABI} ]]; then
						support_ABI="0"
						break
					fi
				done
				[[ "${support_ABI}" == "1" ]] && supported_PYTHON_ABIS+=" ${PYTHON_ABI}"
			done
			export PYTHON_ABIS="${supported_PYTHON_ABIS# }"

			if [[ -z "${PYTHON_ABIS//[${IFS}]/}" ]]; then
				die "USE_PYTHON variable doesn't enable any version of Python supported by ${CATEGORY}/${PF}"
			fi

			if [[ "${python2_enabled}" == "0" ]]; then
				ewarn "USE_PYTHON variable doesn't enable any version of Python 2. This configuration is unsupported."
			fi
			if [[ "${python3_enabled}" == "0" ]]; then
				ewarn "USE_PYTHON variable doesn't enable any version of Python 3. This configuration is unsupported."
			fi
		else
			local python_version python2_version= python3_version= support_python_major_version

			python_version="$(/usr/bin/python -c 'from sys import version_info; print(".".join([str(x) for x in version_info[:2]]))')"

			if has_version "=dev-lang/python-2*"; then
				if [[ "$(readlink /usr/bin/python2)" != "python2."* ]]; then
					die "'/usr/bin/python2' isn't valid symlink"
				fi

				python2_version="$(/usr/bin/python2 -c 'from sys import version_info; print(".".join([str(x) for x in version_info[:2]]))')"

				for PYTHON_ABI in ${python2_supported_versions}; do
					support_python_major_version="1"
					for restricted_ABI in ${RESTRICT_PYTHON_ABIS}; do
						if [[ "${PYTHON_ABI}" == ${restricted_ABI} ]]; then
							support_python_major_version="0"
						fi
					done
					[[ "${support_python_major_version}" == "1" ]] && break
				done
				if [[ "${support_python_major_version}" == "1" ]]; then
					for restricted_ABI in ${RESTRICT_PYTHON_ABIS}; do
						if [[ "${python2_version}" == ${restricted_ABI} ]]; then
							die "Active version of Python 2 isn't supported by ${CATEGORY}/${PF}"
						fi
					done
				else
					python2_version=""
				fi
			fi

			if has_version "=dev-lang/python-3*"; then
				if [[ "$(readlink /usr/bin/python3)" != "python3."* ]]; then
					die "'/usr/bin/python3' isn't valid symlink"
				fi

				python3_version="$(/usr/bin/python3 -c 'from sys import version_info; print(".".join([str(x) for x in version_info[:2]]))')"

				for PYTHON_ABI in ${python3_supported_versions}; do
					support_python_major_version="1"
					for restricted_ABI in ${RESTRICT_PYTHON_ABIS}; do
						if [[ "${PYTHON_ABI}" == ${restricted_ABI} ]]; then
							support_python_major_version="0"
						fi
					done
					[[ "${support_python_major_version}" == "1" ]] && break
				done
				if [[ "${support_python_major_version}" == "1" ]]; then
					for restricted_ABI in ${RESTRICT_PYTHON_ABIS}; do
						if [[ "${python3_version}" == ${restricted_ABI} ]]; then
							die "Active version of Python 3 isn't supported by ${CATEGORY}/${PF}"
						fi
					done
				else
					python3_version=""
				fi
			fi

			if ! has "${python_version}" "${python2_version}" "${python3_version}"; then
				eerror "Python wrapper is configured incorrectly or /usr/bin/python2 or /usr/bin/python3 symlink"
				eerror "is set incorrectly. Use \`eselect python\` to fix configuration."
				die "Incorrect configuration of Python"
			fi

			PYTHON_ABIS="${python2_version} ${python3_version}"
			PYTHON_ABIS="${PYTHON_ABIS# }"
			export PYTHON_ABIS="${PYTHON_ABIS% }"
		fi
	fi

	if [[ "$(declare -p PYTHON_ABIS_SANITY_CHECKS 2> /dev/null)" != "declare -- PYTHON_ABIS_SANITY_CHECKS="* ]]; then
		local PYTHON_ABI
		for PYTHON_ABI in ${PYTHON_ABIS}; do
			# Ensure that appropriate Python version is installed.
			if ! has_version "dev-lang/python:${PYTHON_ABI}"; then
				die "dev-lang/python:${PYTHON_ABI} isn't installed"
			fi

			# Ensure that EPYTHON variable is respected.
			if [[ "$(EPYTHON="$(PYTHON)" python -c 'from sys import version_info; print(".".join([str(x) for x in version_info[:2]]))')" != "${PYTHON_ABI}" ]]; then
				eerror "python:                    '$(type -p python)'"
				eerror "ABI:                       '${ABI}'"
				eerror "DEFAULT_ABI:               '${DEFAULT_ABI}'"
				eerror "EPYTHON:                   '$(PYTHON)'"
				eerror "PYTHON_ABI:                '${PYTHON_ABI}'"
				eerror "Version of enabled Python: '$(EPYTHON="$(PYTHON)" python -c 'from sys import version_info; print(".".join([str(x) for x in version_info[:2]]))')'"
				die "'python' doesn't respect EPYTHON variable"
			fi
		done
		PYTHON_ABIS_SANITY_CHECKS="1"
	fi
}

# @FUNCTION: python_copy_sources
# @USAGE: [--no-link] [--] [directory]
# @DESCRIPTION:
# Copy unpacked sources of given package for each Python ABI.
python_copy_sources() {
	local dir dirs=() no_link="0" PYTHON_ABI

	while (($#)); do
		case "$1" in
			--no-link)
				no_link="1"
				;;
			--)
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -eq "0" ]]; then
		if [[ "${WORKDIR}" == "${S}" ]]; then
			die "${FUNCNAME}() cannot be used"
		fi
		dirs="${S}"
	else
		dirs="$@"
	fi

	validate_PYTHON_ABIS
	for PYTHON_ABI in ${PYTHON_ABIS}; do
		for dir in "${dirs[@]}"; do
			if [[ "${no_link}" == "1" ]]; then
				cp -pr "${dir}" "${dir}-${PYTHON_ABI}" > /dev/null || die "Copying of sources failed"
			else
				cp -lpr "${dir}" "${dir}-${PYTHON_ABI}" > /dev/null || die "Copying of sources failed"
			fi
		done
	done
}

# @FUNCTION: python_set_build_dir_symlink
# @USAGE: [directory="build"]
# @DESCRIPTION:
# Create build directory symlink.
python_set_build_dir_symlink() {
	local dir="$1"

	[[ -z "${PYTHON_ABI}" ]] && die "PYTHON_ABI variable not set"
	[[ -z "${dir}" ]] && dir="build"

	# Don't delete preexistent directories.
	rm -f "${dir}" || die "Deletion of '${dir}' failed"
	ln -s "${dir}-${PYTHON_ABI}" "${dir}" || die "Creation of '${dir}' directory symlink failed"
}

# @FUNCTION: python_execute_function
# @USAGE: [--action-message message] [-d|--default-function] [--failure-message message] [--nonfatal] [-q|--quiet] [-s|--separate-build-dirs] [--] <function> [arguments]
# @DESCRIPTION:
# Execute specified function for each value of PYTHON_ABIS, optionally passing additional
# arguments. The specified function can use PYTHON_ABI and BUILDDIR variables.
python_execute_function() {
	local action action_message action_message_template= default_function="0" failure_message failure_message_template= function nonfatal="0" previous_directory previous_directory_stack previous_directory_stack_length PYTHON_ABI quiet="0" separate_build_dirs="0"

	while (($#)); do
		case "$1" in
			--action-message)
				action_message_template="$2"
				shift
				;;
			-d|--default-function)
				default_function="1"
				;;
			--failure-message)
				failure_message_template="$2"
				shift
				;;
			--nonfatal)
				nonfatal="1"
				;;
			-q|--quiet)
				quiet="1"
				;;
			-s|--separate-build-dirs)
				separate_build_dirs="1"
				;;
			--)
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "${default_function}" == "0" ]]; then
		if [[ "$#" -eq "0" ]]; then
			die "${FUNCNAME}(): Missing function name"
		fi
		function="$1"
		shift

		if [[ -z "$(type -t "${function}")" ]]; then
			die "${FUNCNAME}(): '${function}' function isn't defined"
		fi
	else
		if [[ "$#" -ne "0" ]]; then
			die "${FUNCNAME}(): '--default-function' option and function name cannot be specified simultaneously"
		fi
		if has "${EAPI:-0}" 0 1; then
			die "${FUNCNAME}(): '--default-function' option cannot be used in this EAPI"
		fi

		if [[ "${EBUILD_PHASE}" == "configure" ]]; then
			if has "${EAPI}" 2; then
				python_default_function() {
					econf
				}
			else
				python_default_function() {
					nonfatal econf
				}
			fi
		elif [[ "${EBUILD_PHASE}" == "compile" ]]; then
			python_default_function() {
				emake
			}
		elif [[ "${EBUILD_PHASE}" == "test" ]]; then
			python_default_function() {
				if emake -j1 -n check &> /dev/null; then
					emake -j1 check
				elif emake -j1 -n test &> /dev/null; then
					emake -j1 test
				fi
			}
		elif [[ "${EBUILD_PHASE}" == "install" ]]; then
			python_default_function() {
				emake DESTDIR="${D}" install
			}
		else
			die "${FUNCNAME}(): --default-function option cannot be used in this ebuild phase"
		fi
		function="python_default_function"
	fi

	if [[ "${quiet}" == "0" ]]; then
		[[ "${EBUILD_PHASE}" == "setup" ]] && action="Setting up"
		[[ "${EBUILD_PHASE}" == "unpack" ]] && action="Unpacking"
		[[ "${EBUILD_PHASE}" == "prepare" ]] && action="Preparation"
		[[ "${EBUILD_PHASE}" == "configure" ]] && action="Configuration"
		[[ "${EBUILD_PHASE}" == "compile" ]] && action="Building"
		[[ "${EBUILD_PHASE}" == "test" ]] && action="Testing"
		[[ "${EBUILD_PHASE}" == "install" ]] && action="Installation"
		[[ "${EBUILD_PHASE}" == "preinst" ]] && action="Preinstallation"
		[[ "${EBUILD_PHASE}" == "postinst" ]] && action="Postinstallation"
		[[ "${EBUILD_PHASE}" == "prerm" ]] && action="Preuninstallation"
		[[ "${EBUILD_PHASE}" == "postrm" ]] && action="Postuninstallation"
	fi

	local RED GREEN BLUE NORMAL
	if [[ "${NOCOLOR:-false}" =~ ^(false|no)$ ]]; then
		RED=$'\e[1;31m'
		GREEN=$'\e[1;32m'
		BLUE=$'\e[1;34m'
		NORMAL=$'\e[0m'
	else
		RED=
		GREEN=
		BLUE=
		NORMAL=
	fi

	validate_PYTHON_ABIS
	for PYTHON_ABI in ${PYTHON_ABIS}; do
		if [[ "${quiet}" == "0" ]]; then
			if [[ -n "${action_message_template}" ]]; then
				action_message="$(eval echo -n "${action_message_template}")"
			else
				action_message="${action} of ${CATEGORY}/${PF} with Python ${PYTHON_ABI}..."
			fi
			echo " ${GREEN}*${NORMAL} ${BLUE}${action_message}${NORMAL}"
		fi

		if [[ "${separate_build_dirs}" == "1" ]]; then
			export BUILDDIR="${S}-${PYTHON_ABI}"
			pushd "${BUILDDIR}" > /dev/null || die "pushd failed"
		else
			export BUILDDIR="${S}"
		fi

		previous_directory="$(pwd)"
		previous_directory_stack="$(dirs -p)"
		previous_directory_stack_length="$(dirs -p | wc -l)"

		if ! has "${EAPI}" 0 1 2 && has "${PYTHON_ABI}" ${FAILURE_TOLERANT_PYTHON_ABIS}; then
			EPYTHON="$(PYTHON)" nonfatal "${function}" "$@"
		else
			EPYTHON="$(PYTHON)" "${function}" "$@"
		fi

		if [[ "$?" != "0" ]]; then
			if [[ -n "${failure_message_template}" ]]; then
				failure_message="$(eval echo -n "${failure_message_template}")"
			else
				failure_message="${action} failed with Python ${PYTHON_ABI} in ${function}() function"
			fi

			if [[ "${nonfatal}" == "1" ]]; then
				if [[ "${quiet}" == "0" ]]; then
					ewarn "${RED}${failure_message}${NORMAL}"
				fi
			elif has "${PYTHON_ABI}" ${FAILURE_TOLERANT_PYTHON_ABIS}; then
				if [[ "${EBUILD_PHASE}" != "test" ]] || ! has test-fail-continue ${FEATURES}; then
					local enabled_PYTHON_ABIS= other_PYTHON_ABI
					for other_PYTHON_ABI in ${PYTHON_ABIS}; do
						[[ "${other_PYTHON_ABI}" != "${PYTHON_ABI}" ]] && enabled_PYTHON_ABIS+=" ${other_PYTHON_ABI}"
					done
					export PYTHON_ABIS="${enabled_PYTHON_ABIS# }"
				fi
				if [[ "${quiet}" == "0" ]]; then
					ewarn "${RED}${failure_message}${NORMAL}"
				fi
				if [[ -z "${PYTHON_ABIS}" ]]; then
					die "${function}() function failed with all enabled versions of Python"
				fi
			else
				die "${failure_message}"
			fi
		fi

		# Ensure that directory stack hasn't been decreased.
		if [[ "$(dirs -p | wc -l)" -lt "${previous_directory_stack_length}" ]]; then
			die "Directory stack decreased illegally"
		fi

		# Avoid side effects of earlier returning from the specified function.
		while [[ "$(dirs -p | wc -l)" -gt "${previous_directory_stack_length}" ]]; do
			popd > /dev/null || die "popd failed"
		done

		# Ensure that the bottom part of directory stack hasn't been changed. Restore
		# previous directory (from before running of the specified function) before
		# comparison of directory stacks to avoid mismatch of directory stacks after
		# potential using of 'cd' to change current directory. Restoration of previous
		# directory allows to safely use 'cd' to change current directory in the
		# specified function without changing it back to original directory.
		cd "${previous_directory}"
		if [[ "$(dirs -p)" != "${previous_directory_stack}" ]]; then
			die "Directory stack changed illegally"
		fi

		if [[ "${separate_build_dirs}" == "1" ]]; then
			popd > /dev/null || die "popd failed"
		fi
		unset BUILDDIR
	done

	if [[ "${default_function}" == "1" ]]; then
		unset -f python_default_function
	fi
}

# @FUNCTION: python_convert_shebangs
# @USAGE: [-q|--quiet] [-r|--recursive] [-x|--only-executables] [--] <Python_version> <file|directory> [files|directories]
# @DESCRIPTION:
# Convert shebangs in specified files. Directories can be specified only with --recursive option.
python_convert_shebangs() {
	local argument file files=() only_executables="0" python_version quiet="0" recursive="0"

	while (($#)); do
		case "$1" in
			-r|--recursive)
				recursive="1"
				;;
			-q|--quiet)
				quiet="1"
				;;
			-x|--only-executables)
				only_executables="1"
				;;
			--)
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -eq 0 ]]; then
		die "${FUNCNAME}(): Missing Python version and files or directories"
	elif [[ "$#" -eq 1 ]]; then
		die "${FUNCNAME}(): Missing files or directories"
	fi

	python_version="$1"
	shift

	for argument in "$@"; do
		if [[ ! -e "${argument}" ]]; then
			die "${FUNCNAME}(): '${argument}' doesn't exist"
		elif [[ -f "${argument}" ]]; then
			files+=("${argument}")
		elif [[ -d "${argument}" ]]; then
			if [[ "${recursive}" == "1" ]]; then
				if [[ "${only_executables}" == "1" ]]; then
					files+=($(find "${argument}" -perm /111 -type f))
				else
					files+=($(find "${argument}" -type f))
				fi
			else
				die "${FUNCNAME}(): '${argument}' isn't a regular file"
			fi
		else
			die "${FUNCNAME}(): '${argument}' isn't a regular file or a directory"
		fi
	done

	for file in "${files[@]}"; do
		file="${file#./}"
		[[ "${only_executables}" == "1" && ! -x "${file}" ]] && continue

		if [[ "$(head -n1 "${file}")" =~ ^'#!'.*python ]]; then
			[[ "${quiet}" == "0" ]] && einfo "Converting shebang in '${file}'"
			sed -e "1s/python\([[:digit:]]\+\(\.[[:digit:]]\+\)\?\)\?/python${python_version}/" -i "${file}" || die "Conversion of shebang in '${file}' failed"

			# Delete potential whitespace after "#!".
			sed -e '1s/\(^#!\)[[:space:]]*/\1/' -i "${file}" || die "sed '${file}' failed"
		fi
	done
}

# @ECLASS-VARIABLE: PYTHON_USE_WITH
# @DESCRIPTION:
# Set this to a space separated list of use flags
# the python slot in use must be built with.

# @ECLASS-VARIABLE: PYTHON_USE_WITH_OR
# @DESCRIPTION:
# Set this to a space separated list of use flags
# of which one must be turned on for the slot of
# in use.

# @ECLASS-VARIABLE: PYTHON_USE_WITH_OPT
# @DESCRIPTION:
# Set this if you need to make either PYTHON_USE_WITH or
# PYTHON_USE_WITH_OR atoms conditional under a use flag.

# @FUNCTION: python_pkg_setup
# @DESCRIPTION:
# Makes sure PYTHON_USE_WITH or PYTHON_USE_WITH_OR listed use flags
# are respected. Only exported if one of those variables is set.
if ! has "${EAPI:-0}" 0 1 && [[ -n ${PYTHON_USE_WITH} || -n ${PYTHON_USE_WITH_OR} ]]; then
	python_pkg_setup() {
		python_pkg_setup_fail() {
			eerror "${1}"
			die "${1}"
		}

		[[ ${PYTHON_USE_WITH_OPT} ]] && use !${PYTHON_USE_WITH_OPT} && return

		python_pkg_setup_check_USE_flags() {
			local pyatom use
			if [[ -n "${PYTHON_ABI}" ]]; then
				pyatom="dev-lang/python:${PYTHON_ABI}"
			else
				python_version
				pyatom="dev-lang/python:${PYVER}"
			fi

			for use in ${PYTHON_USE_WITH}; do
				if ! has_version "${pyatom}[${use}]"; then
					python_pkg_setup_fail "Please rebuild ${pyatom} with the following USE flags enabled: ${PYTHON_USE_WITH}"
				fi
			done

			for use in ${PYTHON_USE_WITH_OR}; do
				if has_version "${pyatom}[${use}]"; then
					return
				fi
			done

			if [[ ${PYTHON_USE_WITH_OR} ]]; then
				python_pkg_setup_fail "Please rebuild ${pyatom} with at least one of the following USE flags enabled: ${PYTHON_USE_WITH_OR}"
			fi
		}

		if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
			python_execute_function -q python_pkg_setup_check_USE_flags
		else
			python_pkg_setup_check_USE_flags
		fi
	}

	EXPORT_FUNCTIONS pkg_setup

	if [[ -n "${PYTHON_USE_WITH}" ]]; then
		PYTHON_USE_WITH_ATOM="${PYTHON_ATOM}[${PYTHON_USE_WITH/ /,}]"
	elif [[ -n "${PYTHON_USE_WITH_OR}" ]]; then
		PYTHON_USE_WITH_ATOM="|| ( "
		for use in ${PYTHON_USE_WITH_OR}; do
			PYTHON_USE_WITH_ATOM+=" ${PYTHON_ATOM}[${use}]"
		done
		unset use
		PYTHON_USE_WITH_ATOM+=" )"
	fi
	if [[ -n "${PYTHON_USE_WITH_OPT}" ]]; then
		PYTHON_USE_WITH_ATOM="${PYTHON_USE_WITH_OPT}? ( ${PYTHON_USE_WITH_ATOM} )"
	fi
	DEPEND+=" ${PYTHON_USE_WITH_ATOM}"
	RDEPEND+=" ${PYTHON_USE_WITH_ATOM}"
fi

# @ECLASS-VARIABLE: PYTHON_DEFINE_DEFAULT_FUNCTIONS
# @DESCRIPTION:
# Set this to define default functions for the following ebuild phases:
# src_prepare, src_configure, src_compile, src_test, src_install.
if ! has "${EAPI:-0}" 0 1 && [[ -n "${PYTHON_DEFINE_DEFAULT_FUNCTIONS}" ]]; then
	python_src_prepare() {
		python_copy_sources
	}

	for python_default_function in src_configure src_compile src_test src_install; do
		eval "python_${python_default_function}() { python_execute_function -d -s; }"
	done
	unset python_default_function

	EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
fi

# @FUNCTION: python_disable_pyc
# @DESCRIPTION:
# Tell Python not to automatically recompile modules to .pyc/.pyo
# even if the timestamps/version stamps don't match. This is done
# to protect sandbox.
python_disable_pyc() {
	export PYTHONDONTWRITEBYTECODE="1"
}

# @FUNCTION: python_enable_pyc
# @DESCRIPTION:
# Tell Python to automatically recompile modules to .pyc/.pyo if the
# timestamps/version stamps have changed.
python_enable_pyc() {
	unset PYTHONDONTWRITEBYTECODE
}

# @FUNCTION: python_need_rebuild
# @DESCRIPTION: Run without arguments, specifies that the package should be
# rebuilt after a python upgrade.
python_need_rebuild() {
	python_version
	export PYTHON_NEED_REBUILD=${PYVER}
}

# @FUNCTION: python_get_includedir
# @DESCRIPTION:
# Run without arguments, returns the Python include directory.
python_get_includedir() {
	if [[ -n "${PYTHON_ABI}" ]]; then
		echo "/usr/include/python${PYTHON_ABI}"
	else
		python_version
		echo "/usr/include/python${PYVER}"
	fi
}

# @FUNCTION: python_get_libdir
# @DESCRIPTION:
# Run without arguments, returns the Python library directory.
python_get_libdir() {
	if [[ -n "${PYTHON_ABI}" ]]; then
		echo "/usr/$(get_libdir)/python${PYTHON_ABI}"
	else
		python_version
		echo "/usr/$(get_libdir)/python${PYVER}"
	fi
}

# @FUNCTION: python_get_sitedir
# @DESCRIPTION:
# Run without arguments, returns the Python site-packages directory.
python_get_sitedir() {
	echo "$(python_get_libdir)/site-packages"
}

# @FUNCTION: python_tkinter_exists
# @DESCRIPTION:
# Run without arguments, checks if python was compiled with Tkinter
# support.  If not, prints an error message and dies.
python_tkinter_exists() {
	if ! python -c "import Tkinter" >/dev/null 2>&1; then
		eerror "You need to recompile python with Tkinter support."
		eerror "Try adding: 'dev-lang/python tk'"
		eerror "in to /etc/portage/package.use"
		echo
		die "missing tkinter support with installed python"
	fi
}

# @FUNCTION: python_mod_exists
# @USAGE: <module>
# @DESCRIPTION:
# Run with the module name as an argument. it will check if a
# python module is installed and loadable. it will return
# TRUE(0) if the module exists, and FALSE(1) if the module does
# not exist.
#
# Example:
#         if python_mod_exists gtk; then
#             echo "gtk support enabled"
#         fi
python_mod_exists() {
	[[ "$1" ]] || die "${FUNCNAME} requires an argument!"
	python -c "import $1" &>/dev/null
}

# @FUNCTION: python_mod_compile
# @USAGE: <file> [more files ...]
# @DESCRIPTION:
# Given filenames, it will pre-compile the module's .pyc and .pyo.
# This function should only be run in pkg_postinst()
#
# Example:
#         python_mod_compile /usr/lib/python2.3/site-packages/pygoogle.py
#
python_mod_compile() {
	if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		die "${FUNCNAME}() cannot be used in this EAPI"
	fi

	local f myroot myfiles=()

	# Check if phase is pkg_postinst()
	[[ ${EBUILD_PHASE} != postinst ]] &&\
		die "${FUNCNAME} should only be run in pkg_postinst()"

	# allow compiling for older python versions
	if [[ "${PYTHON_OVERRIDE_PYVER}" ]]; then
		PYVER=${PYTHON_OVERRIDE_PYVER}
	else
		python_version
	fi

	# strip trailing slash
	myroot="${ROOT%/}"

	# respect ROOT
	for f in "$@"; do
		[[ -f "${myroot}/${f}" ]] && myfiles+=("${myroot}/${f}")
	done

	if ((${#myfiles[@]})); then
		python${PYVER} ${myroot}/usr/$(get_libdir)/python${PYVER}/py_compile.py "${myfiles[@]}"
		python${PYVER} -O ${myroot}/usr/$(get_libdir)/python${PYVER}/py_compile.py "${myfiles[@]}" &> /dev/null
	else
		ewarn "No files to compile!"
	fi
}

# @FUNCTION: python_mod_optimize
# @USAGE: [options] [directory|file]
# @DESCRIPTION:
# If no arguments supplied, it will recompile not recursively all modules
# under sys.path (eg. /usr/lib/python2.6, /usr/lib/python2.6/site-packages).
#
# If supplied with arguments, it will recompile all modules recursively
# in the supplied directory.
# This function should only be run in pkg_postinst().
#
# Options passed to this function are passed to compileall.py.
#
# Example:
#         python_mod_optimize ctypesgencore
python_mod_optimize() {
	# Check if phase is pkg_postinst().
	[[ ${EBUILD_PHASE} != "postinst" ]] && die "${FUNCNAME} should only be run in pkg_postinst()"

	if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		local dir file options=() other_dirs=() other_files=() PYTHON_ABI return_code root site_packages_absolute_dirs=() site_packages_dirs=() site_packages_absolute_files=() site_packages_files=()

		# Strip trailing slash from ROOT.
		root="${ROOT%/}"

		# Respect ROOT and options passed to compileall.py.
		while (($#)); do
			case "$1" in
				-l|-f|-q)
					options+=("$1")
					;;
				-d|-x)
					options+=("$1" "$2")
					shift
					;;
				-*)
					ewarn "${FUNCNAME}: Ignoring compile option $1"
					;;
				*)
					if [[ "$1" =~ ^/usr/lib(32|64)?/python[[:digit:]]+\.[[:digit:]]+ ]]; then
						die "${FUNCNAME} doesn't support absolute paths of directories/files in site-packages directories"
					elif [[ "$1" =~ ^/ ]]; then
						if [[ -d "${root}/$1" ]]; then
							other_dirs+=("${root}/$1")
						elif [[ -f "${root}/$1" ]]; then
							other_files+=("${root}/$1")
						elif [[ -e "${root}/$1" ]]; then
							ewarn "'${root}/$1' is not a file or a directory!"
						else
							ewarn "'${root}/$1' doesn't exist!"
						fi
					else
						for PYTHON_ABI in ${PYTHON_ABIS}; do
							if [[ -d "${root}$(python_get_sitedir)/$1" ]]; then
								site_packages_dirs+=("$1")
								break
							elif [[ -f "${root}$(python_get_sitedir)/$1" ]]; then
								site_packages_files+=("$1")
								break
							elif [[ -e "${root}$(python_get_sitedir)/$1" ]]; then
								ewarn "'$1' is not a file or a directory!"
							else
								ewarn "'$1' doesn't exist!"
							fi
						done
					fi
					;;
			esac
			shift
		done

		# Set additional options.
		options+=("-q")

		for PYTHON_ABI in ${PYTHON_ABIS}; do
			if ((${#site_packages_dirs[@]})) || ((${#site_packages_files[@]})); then
				return_code="0"
				ebegin "Compilation and optimization of Python modules for Python ${PYTHON_ABI}"
				if ((${#site_packages_dirs[@]})); then
					for dir in "${site_packages_dirs[@]}"; do
						site_packages_absolute_dirs+=("${root}$(python_get_sitedir)/${dir}")
					done
					"$(PYTHON)" "${root}$(python_get_libdir)/compileall.py" "${options[@]}" "${site_packages_absolute_dirs[@]}" || return_code="1"
					"$(PYTHON)" -O "${root}$(python_get_libdir)/compileall.py" "${options[@]}" "${site_packages_absolute_dirs[@]}" &> /dev/null || return_code="1"
				fi
				if ((${#site_packages_files[@]})); then
					for file in "${site_packages_files[@]}"; do
						site_packages_absolute_files+=("${root}$(python_get_sitedir)/${file}")
					done
					"$(PYTHON)" "${root}$(python_get_libdir)/py_compile.py" "${site_packages_absolute_files[@]}" || return_code="1"
					"$(PYTHON)" -O "${root}$(python_get_libdir)/py_compile.py" "${site_packages_absolute_files[@]}" &> /dev/null || return_code="1"
				fi
				eend "${return_code}"
			fi
			unset site_packages_absolute_dirs site_packages_absolute_files
		done

		# Don't use PYTHON_ABI in next calls to python_get_libdir().
		unset PYTHON_ABI

		if ((${#other_dirs[@]})) || ((${#other_files[@]})); then
			return_code="0"
			ebegin "Compilation and optimization of Python modules placed outside of site-packages directories for Python ${PYVER}"
			if ((${#other_dirs[@]})); then
				python${PYVER} "${root}$(python_get_libdir)/compileall.py" "${options[@]}" "${other_dirs[@]}" || return_code="1"
				python${PYVER} -O "${root}$(python_get_libdir)/compileall.py" "${options[@]}" "${other_dirs[@]}" &> /dev/null || return_code="1"
			fi
			if ((${#other_files[@]})); then
				python${PYVER} "${root}$(python_get_libdir)/py_compile.py" "${other_files[@]}" || return_code="1"
				python${PYVER} -O "${root}$(python_get_libdir)/py_compile.py" "${other_files[@]}" &> /dev/null || return_code="1"
			fi
			eend "${return_code}"
		fi
	else
		local myroot mydirs=() myfiles=() myopts=() return_code="0"

		# strip trailing slash
		myroot="${ROOT%/}"

		# respect ROOT and options passed to compileall.py
		while (($#)); do
			case "$1" in
				-l|-f|-q)
					myopts+=("$1")
					;;
				-d|-x)
					myopts+=("$1" "$2")
					shift
					;;
				-*)
					ewarn "${FUNCNAME}: Ignoring compile option $1"
					;;
				*)
					if [[ -d "${myroot}"/$1 ]]; then
						mydirs+=("${myroot}/$1")
					elif [[ -f "${myroot}"/$1 ]]; then
						# Files are passed to python_mod_compile which is ROOT-aware
						myfiles+=("$1")
					elif [[ -e "${myroot}/$1" ]]; then
						ewarn "${myroot}/$1 is not a file or directory!"
					else
						ewarn "${myroot}/$1 doesn't exist!"
					fi
					;;
			esac
			shift
		done

		# allow compiling for older python versions
		if [ -n "${PYTHON_OVERRIDE_PYVER}" ]; then
			PYVER=${PYTHON_OVERRIDE_PYVER}
		else
			python_version
		fi

		# set additional opts
		myopts+=(-q)

		ebegin "Compilation and optimization of Python modules for Python ${PYVER}"
		if ((${#mydirs[@]})); then
			python${PYVER} \
				"${myroot}"/usr/$(get_libdir)/python${PYVER}/compileall.py \
				"${myopts[@]}" "${mydirs[@]}" || return_code="1"
			python${PYVER} -O \
				"${myroot}"/usr/$(get_libdir)/python${PYVER}/compileall.py \
				"${myopts[@]}" "${mydirs[@]}" &> /dev/null || return_code="1"
		fi

		if ((${#myfiles[@]})); then
			python_mod_compile "${myfiles[@]}"
		fi

		eend "${return_code}"
	fi
}

# @FUNCTION: python_mod_cleanup
# @USAGE: [directory|file]
# @DESCRIPTION:
# Run with optional arguments, where arguments are Python modules. If none given,
# it will look in /usr/lib/python[0-9].[0-9].
#
# It will recursively scan all compiled Python modules in the directories and
# determine if they are orphaned (i.e. their corresponding .py files are missing.)
# If they are, then it will remove their corresponding .pyc and .pyo files.
#
# This function should only be run in pkg_postrm().
python_mod_cleanup() {
	local path py_file PYTHON_ABI SEARCH_PATH=() root

	# Check if phase is pkg_postrm().
	[[ ${EBUILD_PHASE} != "postrm" ]] && die "${FUNCNAME} should only be run in pkg_postrm()"

	# Strip trailing slash from ROOT.
	root="${ROOT%/}"

	if (($#)); then
		if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
			while (($#)); do
				if [[ "$1" =~ ^/usr/lib(32|64)?/python[[:digit:]]+\.[[:digit:]]+ ]]; then
					die "${FUNCNAME} doesn't support absolute paths of directories/files in site-packages directories"
				elif [[ "$1" =~ ^/ ]]; then
					SEARCH_PATH+=("${root}/${1#/}")
				else
					for PYTHON_ABI in ${PYTHON_ABIS}; do
						SEARCH_PATH+=("${root}$(python_get_sitedir)/$1")
					done
				fi
				shift
			done
		else
			SEARCH_PATH=("${@#/}")
			SEARCH_PATH=("${SEARCH_PATH[@]/#/${root}/}")
		fi
	else
		local dir sitedir
		for dir in "${root}"/usr/lib*; do
			if [[ -d "${dir}" && ! -L "${dir}" ]]; then
				for sitedir in "${dir}"/python*/site-packages; do
					if [[ -d "${sitedir}" ]]; then
						SEARCH_PATH+=("${sitedir}")
					fi
				done
			fi
		done
	fi

	local BLUE CYAN NORMAL
	if [[ "${NOCOLOR:-false}" =~ ^(false|no)$ ]]; then
		BLUE=$'\e[34m'
		CYAN=$'\e[36m'
		NORMAL=$'\e[0m'
	else
		BLUE=
		CYAN=
		NORMAL=
	fi

	for path in "${SEARCH_PATH[@]}"; do
		if [[ -d "${path}" ]]; then
			find "${path}" -name '*.py[co]' -print0 | while read -rd ''; do
				py_file="${REPLY%[co]}"
				[[ -f "${py_file}" || (! -f "${py_file}c" && ! -f "${py_file}o") ]] && continue
				einfo "${BLUE}<<< ${py_file}[co]${NORMAL}"
				rm -f "${py_file}"[co]
			done

			# Attempt to delete directories, which may be empty.
			find "${path}" -type d | sort -r | while read -r dir; do
				rmdir "${dir}" 2>/dev/null && einfo "${CYAN}<<< ${dir}${NORMAL}"
			done
		elif [[ "${path}" == *.py && ! -f "${path}" && (-f "${path}c" || -f "${path}o") ]]; then
			einfo "${BLUE}<<< ${path}[co]${NORMAL}"
			rm -f "${path}"[co]
		fi
	done
}
