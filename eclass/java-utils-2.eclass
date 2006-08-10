# Base eclass for Java packages
#
# Copyright (c) 2004-2005, Thomas Matthijs <axxo@gentoo.org>
# Copyright (c) 2004, Karl Trygve Kalleberg <karltk@gentoo.org>
# Copyright (c) 2004-2005, Gentoo Foundation
#
# Licensed under the GNU General Public License, v2
#


# -----------------------------------------------------------------------------
# @eclass-begin
# @eclass-shortdesc Java Utility eclass
# @eclass-maintainer java@gentoo.org
#
# This eclass provides functionality which is used by 
# java-pkg.eclass and java-pkg-opt.eclass as well as from ebuilds.
#
# @warning 
#   You probably don't want to inherit this directly from an ebuild. Instead,
#   you should inherit java-ant for Ant-based Java packages, java-pkg for other 
#   Java packages, or java-pkg-opt for packages that have optional Java support.
#
# -----------------------------------------------------------------------------

inherit eutils versionator multilib

# -----------------------------------------------------------------------------
# @section-begin variables
# @section-title Variables
#
# Summary of variables which control the behavior of building Java packges.
# -----------------------------------------------------------------------------

# Make sure we use java-config-2
export WANT_JAVA_CONFIG="2"

# TODO document
JAVA_PKG_PORTAGE_DEP=">=sys-apps/portage-2.1_pre1"

# -----------------------------------------------------------------------------
# @variable-internal JAVA_PKG_E_DEPEND
#
# This is a convience variable to be used from the other java eclasses. This is
# the version of java-config we want to use. We also need a recent version 
# portage, that includes phase hooks.
# -----------------------------------------------------------------------------
JAVA_PKG_E_DEPEND=">=dev-java/java-config-2.0.19-r1 ${JAVA_PKG_PORTAGE_DEP}"

# -----------------------------------------------------------------------------
# @variable-external JAVA_PKG_ALLOW_VM_CHANGE
# @variable-default yes
#
# Allow this eclass to change the active VM?
# If your system VM isn't sufficient for the package, the build will fail.
# @note This is useful for testing specific VMs.
# -----------------------------------------------------------------------------
JAVA_PKG_ALLOW_VM_CHANGE=${JAVA_PKG_ALLOW_VM_CHANGE:="yes"}

# -----------------------------------------------------------------------------
# @variable-external JAVA_PKG_FORCE_VM
#
# Explicitly set a particular VM to use. If its not valid, it'll fall back to
# whatever /etc/java-config-2/build/jdk.conf would elect to use.
#
# Should only be used for testing and debugging.
#
# @example Use sun-jdk-1.5 to emerge foo
#	JAVA_PKG_FORCE_VM=sun-jdk-1.5 emerge foo
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @variable-external JAVA_PKG_WANT_SOURCE
#
# Specify a specific VM version to compile for to use for -source.
# Normally this is determined from DEPEND.
# See java-pkg_get-source function below.
#
# Should only be used for testing and debugging.
#
# @seealso java-pkg_get-source
#
# @example Use 1.4 source to emerge baz
#	JAVA_PKG_WANT_SOURCE=1.4 emerge baz
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @variable-external JAVA_PKG_WANT_TARGET
#
# Same as JAVA_PKG_WANT_SOURCE above but for -target.
# See java-pkg_get-target function below.
#
# Should only be used for testing and debugging.
#
# @seealso java-pkg_get-target
#
# @example emerge bar to be compatible with 1.3
#	JAVA_PKG_WANT_TARGET=1.3 emerge bar
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @variable-internal JAVA_PKG_COMPILER_DIR
# @default /usr/share/java-config-2/compiler
# 
# Directory where compiler settings are saved, without trailing slash.
# Probably shouldn't touch this variable.
# -----------------------------------------------------------------------------
JAVA_PKG_COMPILER_DIR=${JAVA_PKG_COMPILER_DIR:="/usr/share/java-config-2/compiler"}


# -----------------------------------------------------------------------------
# @variable-internal JAVA_PKG_COMPILERS_CONF
# @variable-default /etc/java-config-2/build/compilers.conf
#
# Path to file containing information about which compiler to use.
# Can be overloaded, but it should be overloaded for testing.
# -----------------------------------------------------------------------------
JAVA_PKG_COMPILERS_CONF=${JAVA_PKG_COMPILERS_CONF:="/etc/java-config-2/build/compilers.conf"}

# -----------------------------------------------------------------------------
# @variable-external JAVA_PKG_FORCE_COMPILER
#
# Explicitly set a list of compilers to use. This is normally read from
# JAVA_PKG_COMPILERS_CONF. 
#
# @note This should only be used internally or for testing.
# @example Use jikes and javac, in that order
#	JAVA_PKG_FORCE_COMPILER="jikes javac"
# -----------------------------------------------------------------------------

# TODO document me
JAVA_PKG_QA_VIOLATIONS=0

# -----------------------------------------------------------------------------
# @section-end variables
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# @section-begin install
# @section-summary Install functions
#
# These are used to install Java-related things, such as jars, Javadocs, JNI
# libraries, etc.
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_dojar
#
# Installs any number of jars.
# Jar's will be installed into /usr/share/${PN}(-${SLOT})/lib/ by default.
# You can use java-pkg_jarinto to change this path.
# You should never install a jar with a package version in the filename. 
# Instead, use java-pkg_newjar defined below.
#
# @example
#	java-pkg_dojar dist/${PN}.jar dist/${PN}-core.jar
#
# @param $* - list of jars to install
# ------------------------------------------------------------------------------
java-pkg_dojar() {
	debug-print-function ${FUNCNAME} $*

	[[ ${#} -lt 1 ]] && die "At least one argument needed"

	java-pkg_check-phase install
	java-pkg_init_paths_

	# Create JARDEST if it doesn't exist
	dodir ${JAVA_PKG_JARDEST}

	local jar
	# for each jar
	for jar in "$@"; do
		local jar_basename=$(basename "${jar}")

		java-pkg_check-versioned-jar ${jar_basename}

		# check if it exists
		if [[ -e "${jar}" ]] ; then
			# install it into JARDEST if it's a non-symlink
			if [[ ! -L "${jar}" ]] ; then
				INSDESTTREE="${JAVA_PKG_JARDEST}" \
					doins "${jar}" || die "failed to install ${jar}"
				java-pkg_append_ JAVA_PKG_CLASSPATH "${JAVA_PKG_JARDEST}/${jar_basename}"
				debug-print "installed ${jar} to ${D}${JAVA_PKG_JARDEST}"
			# make a symlink to the original jar if it's symlink
			else
				# TODO use dosym, once we find something that could use it
				# -nichoj
				ln -s "$(readlink "${jar}")" "${D}${JAVA_PKG_JARDEST}/${jar_basename}"
				debug-print "${jar} is a symlink, linking accordingly"
			fi
		else
			die "${jar} does not exist"
		fi
	done

	java-pkg_do_write_
}



# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_regjar
#
# Records an already installed jar in the package.env
# This would mostly be used if the package has make or a custom script to
# install things.
#
# Example:
#	java-pkg_regjar ${D}/opt/foo/lib/foo.jar
#
# WARNING:
#   if you want to use shell expansion, you have to use ${D}/... as the for in
#   this function will not be able to expand the path, here's an example:
#
#   java-pkg_regjar /opt/my-java/lib/*.jar
#
#   will not work, because:
#    * the `for jar in "$@"` can't expand the path to jar file names, as they
#      don't exist yet
#    * all `if ...` inside for will fail - the file '/opt/my-java/lib/*.jar'
#      doesn't exist
#   
#   you have to use it as:
#
#   java-pkg_regjar ${D}/opt/my-java/lib/*.jar
#
# @param $@ - jars to record
# ------------------------------------------------------------------------------
# TODO should we be making sure the jar is present on ${D} or wherever?
java-pkg_regjar() {
	debug-print-function ${FUNCNAME} $*

	java-pkg_check-phase install

	[[ ${#} -lt 1 ]] && die "at least one argument needed"

	java-pkg_init_paths_

	local jar jar_dir jar_file
	for jar in "$@"; do
		# TODO use java-pkg_check-versioned-jar
		if [[ -e "${jar}" ]]; then
			# nelchael: we should strip ${D} in this case too, here's why:
			# imagine such call:
			#    java-pkg_regjar ${D}/opt/java/*.jar
			# such call will fall into this case (-e ${jar}) and will
			# record paths with ${D} in package.env
			java-pkg_append_ JAVA_PKG_CLASSPATH	"${jar#${D}}"
		elif [[ -e "${D}${jar}" ]]; then
			java-pkg_append_ JAVA_PKG_CLASSPATH	"${jar#${D}}"
		else
			die "${jar} does not exist"
		fi
	done

	java-pkg_do_write_
}


# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_newjar
#
# Installs a jar with a new name
#
# @example: install a versioned jar without the version
#	java-pkg_newjar dist/${P}.jar ${PN}.jar
#
# @param $1 - jar to install
# @param $2 - new name for jar - defaults to ${PN}.jar if not specified
# ------------------------------------------------------------------------------
java-pkg_newjar() {
	debug-print-function ${FUNCNAME} $*

	local original_jar="${1}"
	local new_jar="${2:-${PN}.jar}"
	local new_jar_dest="${T}/${new_jar}"

	[[ -z ${original_jar} ]] && die "Must specify a jar to install"
	[[ ! -f ${original_jar} ]] && die "${original_jar} does not exist!"

	rm -f "${new_jar_dest}" || die "Failed to remove ${new_jar_dest}"
	cp "${original_jar}" "${new_jar_dest}" \
		|| die "Failed to copy ${original_jar} to ${new_jar_dest}"
	java-pkg_dojar "${new_jar_dest}"
}


# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_addcp
#
# Add something to the package's classpath. For jars, you should use dojar,
# newjar, or regjar. This is typically used to add directories to the classpath.
#
# TODO add example
# @param $@ - value to append to JAVA_PKG_CLASSPATH
# ------------------------------------------------------------------------------
java-pkg_addcp() {
	java-pkg_append_ JAVA_PKG_CLASSPATH "${@}"
	java-pkg_do_write_
}


# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_doso
# 
# Installs any number of JNI libraries
# They will be installed into /usr/lib by default, but java-pkg_sointo
# can be used change this path
#
# Example:
#	java-pkg_doso *.so
#
# @param $@ - JNI libraries to install
# ------------------------------------------------------------------------------
java-pkg_doso() {
	debug-print-function ${FUNCNAME} $*

	[[ ${#} -lt 1 ]] &&  "At least one argument required for ${FUNCNAME}"
	java-pkg_check-phase install

	[[ ${#} -lt 1 ]] &&  die "At least one argument required for ${FUNCNAME}"

	java-pkg_init_paths_

	local lib
	# for each lib
	for lib in "$@" ; do
		# if the lib exists...
		if [[ -e "${lib}" ]] ; then
			# install if it isn't a symlink
			if [[ ! -L "${lib}" ]] ; then
				INSDESTTREE="${JAVA_PKG_LIBDEST}" \
					INSOPTIONS="${LIBOPTIONS}" \
					doins "${lib}" || "failed to install ${lib}"
				java-pkg_append_ JAVA_PKG_LIBRARY "${JAVA_PKG_LIBDEST}"
				debug-print "Installing ${lib} to ${JAVA_PKG_LIBDEST}"
			# otherwise make a symlink to the symlink's origin
			else
				# TODO use dosym
				ln -s "$(readlink "${lib}")" "${D}${JAVA_PKG_LIBDEST}/$(basename "${lib}")"
				debug-print "${lib} is a symlink, linking accordanly"
			fi
		# otherwise die
		else
			die "${lib} does not exist"
		fi
	done

	java-pkg_do_write_
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_regso
#
# Registers an already JNI library in package.env.
#
# Example:
#	java-pkg_regso *.so /path/*.so
#
# @param $@ - JNI libraries to register
# ------------------------------------------------------------------------------
java-pkg_regso() {
	debug-print-function ${FUNCNAME} $*

	java-pkg_check-phase install

	[[ ${#} -lt 1 ]] &&  "at least one argument needed"

	java-pkg_init_paths_
	
	local lib target_dir
	for lib in "$@" ; do
		# Check the absolute path of the lib
		if [[ -e "${lib}" ]] ; then
			target_dir="$(java-pkg_expand_dir_ ${lib})"
			java-pkg_append_ JAVA_PKG_LIBRARY "/${target_dir#${D}}"
		# Check the path of the lib relative to ${D}
		elif [[ -e "${D}${lib}" ]]; then
			target_dir="$(java-pkg_expand_dir_ ${D}${lib})"
			java-pkg_append_ JAVA_PKG_LIBRARY "${target_dir}"
		else
			die "${lib} does not exist"
		fi
	done

	java-pkg_do_write_
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_jarinto
#
# Changes the path jars are installed into
#
# @param $1 - new location to install jars into.
# -----------------------------------------------------------------------------
java-pkg_jarinto() {
	debug-print-function ${FUNCNAME} $*

	JAVA_PKG_JARDEST="${1}"
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_sointo
#
# Changes the path that JNI libraries are installed into.
#
# @param $1 - new location to install JNI libraries into.
# ------------------------------------------------------------------------------
java-pkg_sointo() {
	debug-print-function ${FUNCNAME} $*

	JAVA_PKG_LIBDEST="${1}"
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_dohtml
#
# Install Javadoc HTML documentation
#
# @example
#	java-pkg_dohtml dist/docs/
#
# ------------------------------------------------------------------------------
java-pkg_dohtml() {
	debug-print-function ${FUNCNAME} $*

	[[ ${#} -lt 1 ]] &&  die "At least one argument required for ${FUNCNAME}"
	# TODO-nichoj find out what exactly -f package-list does
	dohtml -f package-list "$@"
	# this probably shouldn't be here but it provides
	# a reasonable way to catch # docs for all of the
	# old ebuilds.
	java-pkg_recordjavadoc
}

# TODO document
java-pkg_dojavadoc() {
	local dir="$1"

	java-pkg_check-phase install

	[[ -z "${dir}" ]] && die "Must specify a directory!"
	[[ ! -d "${dir}" ]] && die "${dir} does not exist, or isn't a directory!"

	local dir_to_install="${dir}"
	if [[ "$(basename "${dir}")" != "api" ]]; then
		dir_to_install="${T}/api"
		# TODO use doins
		cp -r "${dir}" "${dir_to_install}" || die "cp failed"
	fi

	java-pkg_dohtml -r ${dir_to_install}
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_dosrc
#
# Installs a zip containing the source for a package, so it can used in 
# from IDEs like eclipse and netbeans.
#
# Ebuild needs to DEPEND on app-arch/zip to use this.
#
# It also should be controlled by USE=source.
#
# @example:
#	java-pkg_dosrc src/*
#
# ------------------------------------------------------------------------------
# TODO change so it the arguments it takes are the base directories containing 
# 	source -nichoj
# TODO should we be able to handle multiple calls to dosrc? -nichoj
# TODO maybe we can take an existing zip/jar? -nichoj
# FIXME apparently this fails if you give it an empty directories
java-pkg_dosrc() {
	debug-print-function ${FUNCNAME} $*

	[ ${#} -lt 1 ] && die "At least one argument needed" 
	if ! hasq source ${IUSE}; then
		echo "Java QA Notice: ${FUNCNAME} called without source in IUSE"
	fi

	java-pkg_check-phase install

	[[ ${#} -lt 1 ]] && die "At least one argument needed" 

	java-pkg_init_paths_

	local zip_name="${PN}-src.zip"
	local zip_path="${T}/${zip_name}"
	local dir
	for dir in ${@}; do
		local dir_parent=$(dirname "${dir}")
		local dir_name=$(basename "${dir}")
		pushd ${dir_parent} > /dev/null || die "problem entering ${dir_parent}"
		zip -q -r ${zip_path} ${dir_name} -i '*.java'
		local result=$?
		# 12 means zip has nothing to do
		if [[ ${result} != 12 && ${result} != 0 ]]; then
			die "failed to zip ${dir_name}"
		fi
		popd >/dev/null
	done

	# Install the zip
	INSDESTTREE=${JAVA_PKG_SOURCESPATH} \
		doins ${zip_path} || die "Failed to install source"

	JAVA_SOURCES="${JAVA_PKG_SOURCESPATH}/${zip_name}"
	java-pkg_do_write_
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_dolauncher
#
# Make a wrapper script to lauch/start this package
# If necessary, the wrapper will switch to the appropriate VM.
#
# @param $1 - filename of launcher to create
# @param $2 - options, as follows:
#  --main the.main.class.too.start
#  --jar /the/jar/too/launch.jar
#  --java_args 'Extra arguments to pass too jave'
#  --pkg_args 'extra arguments too pass too the package'
#  --pwd
#  -into
#  -pre
# ------------------------------------------------------------------------------
java-pkg_dolauncher() {
	debug-print-function ${FUNCNAME} $*

	java-pkg_check-phase install

	[[ ${#} -lt 1 ]] && die "Need at least one argument"

	java-pkg_init_paths_

	local name="${1}"
	# TODO rename to launcher
	local target="${T}/${name}"
	local target_dir pre
	shift

	echo "#!/bin/bash" > "${target}"
	while [[ -n "${1}" && -n "${2}" ]]; do
		local var=${1} value=${2}
		if [[ "${var:0:2}" == "--" ]]; then 
			echo "gjl_${var:2}=\"${value}\"" >> "${target}"
		elif [[ "${var}" == "-into" ]]; then
			target_dir="${value}"
		elif [[ "${var}" == "-pre" ]]; then
			pre="${value}"
		fi
		shift 2
	done
	echo "gjl_package=${JAVA_PKG_NAME}" >> "${target}"
	[[ -n "${pre}" ]] && [[ -f "${pre}" ]] && cat "${pre}" >> "${target}"
	echo "source /usr/share/java-config-2/launcher/launcher.bash" >> "${target}"
	
	if [[ -n "${into}" ]]; then
		DESTTREE="${target_dir}" dobin "${target}"
		local ret=$?
		return ${ret}
	else
		dobin "${target}"
	fi
}

# ------------------------------------------------------------------------------
# Install war files.
# TODO document
# ------------------------------------------------------------------------------
java-pkg_dowar() {
	debug-print-function ${FUNCNAME} $*

	# Check for arguments
	[[ ${#} -lt 1 ]] && die "At least one argument needed"
	java-pkg_check-phase install

	java-pkg_init_paths_

	local war
	for war in $* ; do
		local warpath
		# TODO evaluate if we want to handle symlinks differently -nichoj
		# Check for symlink
		if [[ -L "${war}" ]] ; then
			cp "${war}" "${T}"
			warpath="${T}$(basename "${war}")"
		# Check for directory
		# TODO evaluate if we want to handle directories differently -nichoj
		elif [[ -d "${war}" ]] ; then
			echo "dowar: warning, skipping directory ${war}"
			continue
		else
			warpath="${war}"
		fi
	
		# Install those files like you mean it
		INSOPTIONS="-m 0644" \
			INSDESTTREE=${JAVA_PKG_WARDEST} \
			doins ${warpath}
	done
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_recordjavadoc
# Scan for JavaDocs, and record their existence in the package.env file
#
# TODO make sure this in the proper section
# ------------------------------------------------------------------------------
java-pkg_recordjavadoc()
{
	debug-print-function ${FUNCNAME} $*
	# the find statement is important
	# as some packages include multiple trees of javadoc
	JAVADOC_PATH="$(find ${D}/usr/share/doc/ -name allclasses-frame.html -printf '%h:')"
	# remove $D - TODO: check this is ok with all cases of the above
	JAVADOC_PATH="${JAVADOC_PATH//${D}}"
	if [[ -n "${JAVADOC_PATH}" ]] ; then
		debug-print "javadocs found in ${JAVADOC_PATH%:}"
		java-pkg_do_write_
	else
		debug-print "No javadocs found"
	fi
}

# ------------------------------------------------------------------------------
# @section-end install
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @begin-section query
# Use these to build the classpath for building a package.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_jar-from
#
# Makes a symlink to a jar from a certain package
# A lot of java packages include dependencies in a lib/ directory
# You can use this function to replace these bundled dependencies.
#
# Example: get all jars from xerces slot 2
#	java-pkg_jar-from xerces-2
# Example: get a specific jar from xerces slot 2
# 	java-pkg_jar-from xerces-2 xml-apis.jar
# Example get a specific jar from xerces slot 2, and name it diffrently
# 	java-pkg_jar-from xerces-2 xml-apis.jar xml.jar
#
# @param $1 - Package to get jars from.
# @param $2 - jar from package. If not specified, all jars will be used.
# @param $3 - When a single jar is specified, destination filename of the
#	symlink. Defaults to the name of the jar.
# ------------------------------------------------------------------------------
# TODO could probably be cleaned up a little
java-pkg_jar-from() {
	debug-print-function ${FUNCNAME} $*

	local target_pkg="${1}" target_jar="${2}" destjar="${3}" 
	
	[[ -z ${target_pkg} ]] && die "Must specify a package"

	# default destjar to the target jar
	[[ -z "${destjar}" ]] && destjar="${target_jar}"

	local classpath="$(java-config --classpath=${target_pkg})"
	[[ $? != 0 ]] && die "There was a problem getting the classpath for ${target_pkg}"

	local jar
	for jar in ${classpath//:/ }; do
		local jar_name=$(basename "${jar}")
		if [[ ! -f "${jar}" ]] ; then
			debug-print "${jar} from ${target_pkg} does not exist"
			die "Installation problems with jars in ${target_pkg} - is it installed?"
		fi
		# If no specific target jar was indicated, link it
		if [[ -z "${target_jar}" ]] ; then
			[[ -f "${target_jar}" ]]  && rm "${target_jar}"
			ln -snf "${jar}" \
				|| die "Failed to make symlink from ${jar} to ${jar_name}"
			java-pkg_record-jar_ "${target_pkg}" "${jar}"
		# otherwise, if the current jar is the target jar, link it
		elif [[ "${jar_name}" == "${target_jar}" ]] ; then
			[[ -f "${destjar}" ]]  && rm "${destjar}"
			ln -snf "${jar}" "${destjar}" \
				|| die "Failed to make symlink from ${jar} to ${destjar}"
			java-pkg_record-jar_ "${target_pkg}" "${jar}"
			return 0
		fi
	done
	# if no target was specified, we're ok
	if [[ -z "${target_jar}" ]] ; then
		return 0
	# otherwise, die bitterly
	else
		die "Failed to find ${target_jar:-jar} in ${target_pkg}"
	fi
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_jarfrom
#
# See java-pkg_jar-from
# ------------------------------------------------------------------------------
java-pkg_jarfrom() {
	java-pkg_jar-from "$@"
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_getjars
#
# Get the classpath provided by any number of packages
# Among other things, this can be passed to 'javac -classpath' or 'ant -lib'.
#
# Example: Get the classpath for xerces-2, 
#	java-pkg_getjars xerces-2 xalan
# Example Return:
#	/usr/share/xerces-2/lib/xml-apis.jar:/usr/share/xerces-2/lib/xmlParserAPIs.jar:/usr/share/xalan/lib/xalan.jar
#
# @param $@ - list of packages to get jars from
# ------------------------------------------------------------------------------
java-pkg_getjars() {
	debug-print-function ${FUNCNAME} $*

	[[ ${#} -lt 1 ]] && die "At least one argument needed"

	# NOTE could probably just pass $@ to java-config --classpath. and return it
	local classpath pkg
	for pkg in ${@//,/ }; do
	#for pkg in $(echo "$@" | tr ',' ' '); do
		jars="$(java-config --classpath=${pkg})"
		debug-print "${pkg}:${jars}"
		# TODO should we ensure jars exist?
		if [[ -z "${classpath}" ]]; then
			classpath="${jars}"
		else
			classpath="${classpath}:${jars}"
		fi
		java-pkg_record-jar_ "${pkg}"
	done
	echo "${classpath}"
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_getjar
#
# Get the filename of a single jar from a package
#
# @example
#	java-pkg_getjar xerces-2 xml-apis.jar
# @example-return
#	/usr/share/xerces-2/lib/xml-apis.jar
#
# @param $1 - package to use
# @param $2 - jar to get
# ------------------------------------------------------------------------------
java-pkg_getjar() {
	debug-print-function ${FUNCNAME} $*

	local pkg="${1}" target_jar="${2}" jar
	[[ -z ${pkg} ]] && die "Must specify package to get a jar from"
	[[ -z ${target_jar} ]] && die "Must specify jar to get"

	# TODO check that package is actually installed
	local classpath=$(java-config --classpath=${pkg})
	[[ $? != 0 ]] && die "There could not find classpath for ${pkg}. Are you sure its installed?"
	for jar in ${classpath//:/ }; do
		if [[ ! -f "${jar}" ]] ; then
			die "Installation problems with jars in ${pkg} - is it installed?"
		fi

		if [[ "$(basename ${jar})" == "${target_jar}" ]] ; then
			java-pkg_record-jar_ "${pkg}" "${jar}"
			echo "${jar}"
			return 0
		fi
	done
	
	die "Could not find ${target_jar} in ${pkg}"
	return 1
}

# This function reads stdin, and based on that input, figures out how to
# populate jars from the filesystem.
# Need to figure out a good way of making use of this, ie be able to use a
# string that was built instead of stdin
# NOTE: this isn't quite ready for primetime.
#java-pkg_populate-jars() {
#	local line
#
#	read line
#	while [[ -n "${line}" ]]; do
#		# Ignore comments
#		[[ ${line%%#*} == "" ]] && continue
#
#		# get rid of any spaces
#		line="${line// /}"
#
#		# format: path=jarinfo
#		local path=${line%%=*}
#		local jarinfo=${line##*=}
#	
#		# format: jar@package
#		local jar=${jarinfo%%@*}.jar
#		local package=${jarinfo##*@}
#		if [[ -n ${replace_only} ]]; then
#			[[ ! -f $path ]] && die "No jar exists at ${path}"
#		fi
#		if [[ -n ${create_parent} ]]; then
#			local parent=$(dirname ${path})
#			mkdir -p "${parent}"
#		fi
#		java-pkg_jar-from "${package}" "${jar}" "${path}"
#
#		read line
#	done
#}

# ------------------------------------------------------------------------------
# @section-end query
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @section-begin helper
# @section-summary Helper functions 
#
# Various other functions to use from an ebuild
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_need
#
# Adds virtual dependencies, which can optionally be controlled by a USE flag.
# Currently supported virtuals are:
#	javamail
#	jdbc-stdext
#	jaf
#	jdbc-rowset
#	jms
#
# @param $1 - Optionally indicate that the dependencies are controlled by 
#				a use flag by specifying '--use' Requires $2.
# @param $2 - USE flag which will enable the dependencies.
# @param $@ - virtual packages to add depenedencies for
# ------------------------------------------------------------------------------
# TODO rewrite to parse a line based declaration file instead -- karltk
#java-pkg_need() {
#	debug-print-function ${FUNCNAME} $*
#	local useflag
#	if [[ ${1} == "--use" ]]; then
#		useflag="${2}"
#		shift 2
#	fi
#
#	if [[ -z ${1} ]]; then
#		die "Must specify at least one virtual package."
#	fi
#
#	local depstr newdepstr
#
#	for virtual in ${@}; do
#		if has ${virtual} ${JAVA_PKG_VNEED}; then
#			debug-print "Already registered virtual ${virtual}"
#			continue
#		fi
#		case ${virtual} in
#			javamail)
#				debug-print "java-pkg_need: adding javamail dependencies"
#				newdepstr="|| ( dev-java/gnu-javamail dev-java/sun-javamail-bin )"
#				;;
#			jdbc-stdext)
#				debug-print "java-pkg_need: adding jdbc-stdext dependencies"
#				newdepstr="|| ( >=virtual/jdk-1.4 dev-java/jdbc2-stdext )"
#				;;
#			jaf)
#				debug-print "java-pkg_need: adding jaf dependencies"
#				newdepstr="|| ( dev-java/gnu-jaf dev-java/sun-jaf-bin )"
#				;;
#			jdbc-rowset)
#				debug-print "java-pkg_need: adding jdbc-rowset dependencies"
#			 	newdepstr="|| ( >=virtual/jdk-1.5 dev-java/sun-jdbc-rowset )"
#				;;
#			jms)
#				debug-print "java-pkg_need: adding jms dependencies"
#				newdepstr="|| ( dev-java/sun-jms dev-java/openjms )"
#				;;
#			*)
#				die "Invalid virtual: ${virtual}"
#		esac
#
#		export JAVA_PKG_VNEED="${JAVA_PKG_VNEED} ${virtual}"
#
#		if [[ -n ${useflag} ]]; then
#			depstr="${depstr} ${useflag}? ( ${newdepstr} )"
#		else
#			depstr="${depstr} ${newdepstr}"
#		fi
#	done
#
#	[[ -z ${JAVA_PKG_NV_DEPEND} ]] && export JAVA_PKG_NV_DEPEND="${DEPEND}"
#	[[ -z ${JAVA_PKG_NV_RDEPEND} ]] && export JAVA_PKG_NV_RDEPEND="${RDEPEND}"
#
#	export DEPEND="${DEPEND} ${depstr}"
#	export RDEPEND="${RDEPEND} ${depstr}"
#}

# This should be used after S has been populated with symlinks to jars
# TODO document
java-pkg_ensure-no-bundled-jars() {
	debug-print-function ${FUNCNAME} $*
	pushd ${WORKDIR} >/dev/null 2>/dev/null

	local bundled_jars=$(find . -name "*.jar" -type f)
	if [[ -n ${bundled_jars} ]]; then
		echo "Bundled jars found:"
		local jar
		for jar in ${bundled_jars}; do
			echo $(pwd)${jar/./}
		done
		die "Bundled jars found!"

	fi
	popd >/dev/null 2>/dev/null
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_ensure-vm-version-sufficient
#
# Checks if we have a sufficient VM and dies if we don't.
#
# ------------------------------------------------------------------------------
java-pkg_ensure-vm-version-sufficient() {
	debug-print-function ${FUNCNAME} $*

	if ! java-pkg_is-vm-version-sufficient; then
		debug-print "VM is not suffient"
		eerror "Current Java VM cannot build this package"
		einfo "Please use java-config -S to set the correct one"
		die "Active Java VM cannot build this package"
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_is-vm-version-sufficient
# 
# @return zero - VM is sufficient
# @return non-zero - VM is not sufficient
# ------------------------------------------------------------------------------
java-pkg_is-vm-version-sufficient() {
	debug-print-function ${FUNCNAME} $*

	depend-java-query --is-sufficient "${DEPEND}" > /dev/null
	return $?
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_ensure-vm-version-eq
#
# Die if the current VM is not equal to the argument passed.
#
# @param $@ - Desired VM version to ensure
# ------------------------------------------------------------------------------
java-pkg_ensure-vm-version-eq() {
	debug-print-function ${FUNCNAME} $*

	if ! java-pkg_is-vm-version-eq $@ ; then
		debug-print "VM is not suffient"
		eerror "This package requires a Java VM version = $@"
		einfo "Please use java-config -S to set the correct one"
		die "Active Java VM too old"
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_is-vm-version-eq 
# 
# @param $@ - VM version to compare current VM to
# @return zero - VM versions are equal
# @return non-zero - VM version are not equal
# ------------------------------------------------------------------------------
java-pkg_is-vm-version-eq() {
	debug-print-function ${FUNCNAME} $*

	local needed_version="$@"

	[[ -z "${needed_version}" ]] && die "need an argument"

	local vm_version="$(java-pkg_get-vm-version)"

	vm_version="$(get_version_component_range 1-2 "${vm_version}")"
	needed_version="$(get_version_component_range 1-2 "${needed_version}")"

	if [[ -z "${vm_version}" ]]; then
		debug-print "Could not get JDK version from DEPEND"
		return 1
	else
		if [[ "${vm_version}" == "${needed_version}" ]]; then
			debug-print "Detected a JDK(${vm_version}) = ${needed_version}"
			return 0
		else
			debug-print "Detected a JDK(${vm_version}) != ${needed_version}"
			return 1
		fi
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_ensure-vm-version-ge
#
# Die if the current VM is not greater than the desired version
#
# @param $@ - VM version to compare current to
# ------------------------------------------------------------------------------
java-pkg_ensure-vm-version-ge() {
	debug-print-function ${FUNCNAME} $*
	
	if ! java-pkg_is-vm-version-ge "$@" ; then
		debug-print "vm is not suffient"
		eerror "This package requires a Java VM version >= $@"
		einfo "Please use java-config -S to set the correct one"
		die "Active Java VM too old"
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_is-vm-version-ge 
# 
# @param $@ - VM version to compare current VM to
# @return zero - current VM version is greater than checked version
# @return non-zero - current VM version is not greater than checked version
# ------------------------------------------------------------------------------
java-pkg_is-vm-version-ge() {
	debug-print-function ${FUNCNAME} $*

	local needed_version=$@
	local vm_version=$(java-pkg_get-vm-version)
	if [[ -z "${vm_version}" ]]; then
		debug-print "Could not get JDK version from DEPEND"
		return 1
	else
		if version_is_at_least "${needed_version}" "${vm_version}"; then
			debug-print "Detected a JDK(${vm_version}) >= ${needed_version}"
			return 0
		else
			debug-print "Detected a JDK(${vm_version}) < ${needed_version}"
			return 1
		fi
	fi
}

java-pkg_set-current-vm() {
	export GENTOO_VM=${1}
}

java-pkg_get-current-vm() {
	echo ${GENTOO_VM}
}

java-pkg_current-vm-matches() {
	hasq $(java-pkg_get-current-vm) ${@}
	return $?
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_get-source
# 
# Determines what source version should be used, for passing to -source.
# Unless you want to break things you probably shouldn't set _WANT_SOURCE
#
# @return string - Either the lowest possible source, or JAVA_PKG_WANT_SOURCE
# ------------------------------------------------------------------------------
java-pkg_get-source() {
	echo ${JAVA_PKG_WANT_SOURCE:-$(depend-java-query --get-lowest "${DEPEND} ${RDEPEND}")}
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_get-target
#
# Determines what target version should be used, for passing to -target.
# If you don't care about lower versions, you can set _WANT_TARGET to the
# version of your JDK. 
# Remember doing this will mostly like cause things to break.
# Doesn't allow it to be lower then the one in depend.
# Doesn't allow it to be higher then the active vm.
#
# @return string - Either the lowest possible target, or JAVA_PKG_WANT_TARGET
# ------------------------------------------------------------------------------
java-pkg_get-target() {
	local min=$(depend-java-query --get-lowest "${DEPEND} ${RDEPEND}")	
	if [[ -n "${JAVA_PKG_WANT_TARGET}" ]]; then
		local max="$(java-config --select-vm "${GENTOO_VM}" -g PROVIDES_VERSION)"
		if version_is_at_least "${min}" "${JAVA_PKG_WANT_TARGET}" && version_is_at_least "${JAVA_PKG_WANT_TARGET}" "${max}"; then
			echo ${JAVA_PKG_WANT_TARGET}
		else
			echo ${min}
		fi
	else
		echo ${min}
	fi

	#echo ${JAVA_PKG_WANT_TARGET:-$(depend-java-query --get-lowest "${DEPEND}")}
}

java-pkg_get-javac() {
	debug-print-function ${FUNCNAME} $*

	java-pkg_init-compiler_
	local compiler="${GENTOO_COMPILER}"

	local compiler_executable
	if [[ "${compiler}" = "javac" ]]; then
		# nothing fancy needs to be done for javac
		compiler_executable="javac"
	else
		# for everything else, try to determine from an env file

		local compiler_env="/usr/share/java-config-2/compiler/${compiler}"
		if [[ -f ${compiler_env} ]]; then
			local old_javac=${JAVAC}
			unset JAVAC
			# try to get value of JAVAC
			compiler_executable="$(source ${compiler_env} 1>/dev/null 2>&1; echo ${JAVAC})"
			export JAVAC=${old_javac}

			[[ -z ${compiler_executable} ]] && die "JAVAC is empty or undefined in ${compiler_env}"
	
			# check that it's executable
			if [[ ! -x ${compiler_executable} ]]; then
				eerror "Could not find ${compiler_executable}!"
				die "${compiler_executable} doesn't exist, or isn't executable"
			fi
		else
			eerror "Could not find environment file for ${compiler}"
			die "Could not find ${compiler_env}"
		fi
	fi
	echo ${compiler_executable}
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_javac-args 
#
# If an ebuild uses javac directly, instead of using ejavac, it should call this
# to know what -source/-target to use.
#
# @return string - arguments to pass to javac, complete with -target and -source
# ------------------------------------------------------------------------------
java-pkg_javac-args() {
	debug-print-function ${FUNCNAME} $*

	local want_source="$(java-pkg_get-source)"
	local want_target="$(java-pkg_get-target)"

	local source_str="-source ${want_source}" 
	local target_str="-target ${want_target}"

	debug-print "want source: ${want_source}"
	debug-print "want target: ${want_target}"

	if [[ -z "${want_source}" || -z "${want_target}" ]]; then
		debug-print "could not find valid -source/-target values"
		die "Could not find valid -source/-target values"
	else
		if java-pkg_is-vm-version-ge "1.4"; then
			echo "${source_str} ${target_str}"
		else
			echo "${target_str}"
		fi
	fi
}

# TODO document
java-pkg_get-jni-cflags() {
	local flags="-I${JAVA_HOME}/include"

	# TODO do a check that the directories are valid
	# TODO figure out how to cope with other things than linux...
	flags="${flags} -I${JAVA_HOME}/include/linux"

	echo ${flags}
}

java-pkg_ensure-gcj() {
	if ! built_with_use sys-devel/gcc gcj ; then
		ewarn
		ewarn "You must build gcc with the gcj support to build with gcj"
		ewarn
		ebeep 5
		die "No GCJ support found!"
	fi
}

java-pkg_ensure-test() {
	if hasq test ${FEATURES} && ! hasq -test ${FEATURES} && ! use test; then
		eerror "You specified FEATURES=test, but USE=test is needed"
		eerror "to pull in the additional dependencies for testing"
		die "Need USE=test enabled"
	fi
}

# ------------------------------------------------------------------------------
# @section-end helper
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @section-begin build
# @section-summary Build functions
#
# These are some functions for building a package. In particular, it consists of
# wrappers for javac and ant.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @ebuild-function eant
#
# Ant wrapper function. Will use the appropriate compiler, based on user-defined
# compiler.
#
# ------------------------------------------------------------------------------
eant() {
	debug-print-function ${FUNCNAME} $*

	# FIXME get this working
#	if is-java-strict && [[ ! ${DEPEND} =~ "dev-java/ant" ]]; then
#		java-pkg_announce-qa-violation \
#			"Using eant, but not depending on dev-java/ant or dev-java/ant-core"
#	fi

	local antflags
	java-pkg_init-compiler_
	local compiler="${GENTOO_COMPILER}"

	local compiler_env="${JAVA_PKG_COMPILER_DIR}/${compiler}"

	local build_compiler="$(source ${compiler_env} 1>/dev/null 2>&1; echo ${ANT_BUILD_COMPILER})"
	if [[ "${compiler}" != "javac" && -z "${build_compiler}" ]]; then
		die "ANT_BUILD_COMPILER undefined in ${compiler_env}"
	fi

	if [[ ${compiler} != "javac" ]]; then
		antflags="-Dbuild.compiler=${build_compiler}"
		# Figure out any extra stuff to put on the classpath for compilers aside
		# from javac
		# ANT_BUILD_COMPILER_DEPS should be something that could be passed to
		# java-config -p
		local build_compiler_deps="$(source ${JAVA_PKG_COMPILER_DIR}/${compiler} 1>/dev/null 2>&1; echo ${ANT_BUILD_COMPILER_DEPS})"
		if [[ -n ${build_compiler_deps} ]]; then
			antflags="${antflags} -lib $(java-config -p ${build_compiler_deps})"
		fi
	fi

	if is-java-strict; then
		einfo "Disabling system classpath for ant"
		antflags="${antflags} -Dbuild.sysclasspath=ignore"
	fi
	
	if [[ -n ${JAVA_PKG_DEBUG} ]]; then
		antflags="${antflags} -debug"
	fi
	
	[[ -n ${JAVA_PKG_DEBUG} ]] && echo ant ${antflags} "${@}"
	ant ${antflags} "${@}" || die "eant failed"

}

# ------------------------------------------------------------------------------
# @ebuild-function ejavac
#
# Javac wrapper function. Will use the appropriate compiler, based on 
# /etc/java-config/compilers.conf
#
# @param $@ - Arguments to be passed to the compiler
# ------------------------------------------------------------------------------
ejavac() {
	debug-print-function ${FUNCNAME} $*

	# FIXME using get-javac ends up printing stuff with einfo
#	local compiler_executable=$(java-pkg_get-javac)
	local compiler_executable="javac"

	[[ -n ${JAVA_PKG_DEBUG} ]] && echo ${compiler_executable} $(java-pkg_javac-args) "${@}"
	${compiler_executable} $(java-pkg_javac-args) "${@}" || die "ejavac failed"
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_filter-compiler
# 
# Used to prevent the use of some compilers. Should be used in src_compile.
# Basically, it just appends onto JAVA_PKG_FILTER_COMPILER
#
# @param $@ - compilers to filter
# ------------------------------------------------------------------------------
java-pkg_filter-compiler() {
	JAVA_PKG_FILTER_COMPILER="${JAVA_PKG_FILTER_COMPILER} $@"
}

# ------------------------------------------------------------------------------
# @ebuild-function java-pkg_force-compiler
#
# Used to force the use of particular compilers. Should be used in src_compile.
# A common use of this would be to force ecj-3.1 to be used on amd64, to avoid
# OutOfMemoryErrors that may come up.
#
# @param $@ - compilers to force
# ------------------------------------------------------------------------------
java-pkg_force-compiler() {
	JAVA_PKG_FORCE_COMPILER="$@"
}

# ------------------------------------------------------------------------------
# @ebuild-function use_doc
#
# Helper function for getting ant to build javadocs. If the user has USE=doc,
# then 'javadoc' or the argument are returned. Otherwise, there is no return.
# 
# The output of this should be passed to ant.
#
# Example: build javadocs by calling 'javadoc' target
#	eant $(use_doc)
# Example: build javadocs by calling 'apidoc' target
#	eant $(use_doc apidoc)
#
# @param $@ - Option value to return. Defaults to 'javadoc'
# @return string - Name of the target to create javadocs
# ------------------------------------------------------------------------------
use_doc() {
	use doc && echo ${@:-javadoc}
}

# ------------------------------------------------------------------------------
# @section-end build
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
# @section-begin internal
# @section-summary Internal functions 
#
# Do __NOT__ use any of these from an ebuild! These are only to be used from
# within the java eclasses.
# ------------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @function-internal java-pkg_init
# 
# The purpose of this function, as the name might imply, is to initialize the
# Java environment. It ensures that that there aren't any environment variables
# that'll muss things up. It initializes some variables, which are used
# internally. And most importantly, it'll switch the VM if necessary.
#
# This shouldn't be used directly. Instead, java-pkg and java-pkg-opt will
# call it during each of the phases of the merge process.
#
# -----------------------------------------------------------------------------
java-pkg_init() {
	unset JAVAC
	unset JAVA_HOME
	java-pkg_init_paths_
	java-pkg_switch-vm
	PATH=${JAVA_HOME}/bin:${PATH}

	# TODO we will probably want to set JAVAC and JAVACFLAGS

	# Do some QA checks
	java-pkg_check-jikes

	# When users have crazy classpaths some packages can fail to compile. 
	# and everything should work with empty CLASSPATH.
	# This also helps prevent unexpected dependencies on random things
	# from the CLASSPATH.
	unset CLASSPATH 
}

# ------------------------------------------------------------------------------
# @function-internal java-pkg-init-compiler_
#
# This function attempts to figure out what compiler should be used. It does
# this by reading the file at JAVA_PKG_COMPILERS_CONF, and checking the 
# COMPILERS variable defined there.
# This can be overridden by a list in JAVA_PKG_FORCE_COMPILER
# 
# It will go through the list of compilers, and verify that it supports the
# target and source that are needed. If it is not suitable, then the next
# compiler is checked. When JAVA_PKG_FORCE_COMPILER is defined, this checking
# isn't done.
#
# Once the which compiler to use has been figured out, it is set to
# GENTOO_COMPILER.
#
# If you hadn't guessed, JAVA_PKG_FORCE_COMPILER is for testing only.
#
# If the user doesn't defined anything in JAVA_PKG_COMPILERS_CONF, or no
# suitable compiler was found there, then the default is to use javac provided
# by the current VM.
#
#
# @return name of the compiler to use
# ------------------------------------------------------------------------------
java-pkg_init-compiler_() {
	debug-print-function ${FUNCNAME} $*

	if [[ -n ${GENTOO_COMPILER} ]]; then
		debug-print "GENTOO_COMPILER already set"
		return
	fi

	local compilers;
	if [[ -z ${JAVA_PKG_FORCE_COMPILER} ]]; then
		compilers="$(source ${JAVA_PKG_COMPILERS_CONF} 1>/dev/null 2>&1; echo	${COMPILERS})"
	else
		compilers=${JAVA_PKG_FORCE_COMPILER}
	fi
	
	debug-print "Read \"${compilers}\" from ${JAVA_PKG_COMPILERS_CONF}"

	# Figure out if we should announce what compiler we're using
	local compiler
	for compiler in ${compilers}; do
		debug-print "Checking ${compiler}..."
		# javac should always be alright
		if [[ ${compiler} = "javac" ]]; then
			debug-print "Found javac... breaking"
			export GENTOO_COMPILER="javac"
			break
		fi
	
		if has ${compiler} ${JAVA_PKG_FILTER_COMPILER}; then
			if [[ -z ${JAVA_PKG_FORCE_COMPILER} ]]; then
				einfo "Filtering ${compiler}"
				continue
			fi
		fi
		
		# for non-javac, we need to make sure it supports the right target and
		# source
		local compiler_env="${JAVA_PKG_COMPILER_DIR}/${compiler}"
		if [[ -f ${compiler_env} ]]; then
			local desired_target="$(java-pkg_get-target)"
			local desired_source="$(java-pkg_get-source)"


			# Verify that the compiler supports target
			local supported_target=$(source ${compiler_env} 1>/dev/null 2>&1; echo ${SUPPORTED_TARGET})
			if ! has ${desired_target} ${supported_target}; then
				ewarn "${compiler} does not support -target ${desired_target},	skipping"
				continue
			fi

			# -source was introduced in 1.3, so only check 1.3 and on
			if version_is_at_least "${desired_soure}" "1.3"; then
				# Verify that the compiler supports source
				local supported_source=$(source ${compiler_env} 1>/dev/null 2>&1; echo ${SUPPORTED_SOURCE})
				if ! has ${desired_source} ${supported_source}; then
					ewarn "${compiler} does not support -source ${desired_source}, skipping"
					continue
				fi
			fi

			# if you get here, then the compiler should be good to go
			export GENTOO_COMPILER="${compiler}"
			break
		else
			ewarn "Could not find configuration for ${compiler}, skipping"
			ewarn "Perhaps it is not installed?"
			continue
		fi
	done

	# If it hasn't been defined already, default to javac
	if [[ -z ${GENTOO_COMPILER} ]]; then
		if [[ -n ${compilers} ]]; then
			einfo "No suitable compiler found: defaulting javac for compilation"
		else
			# probably don't need to notify users about the default.
			:;#einfo "Defaulting to javac for compilation"
		fi
		export GENTOO_COMPILER=javac
	else
		einfo "Using ${GENTOO_COMPILER} for compilation"
	fi

}

# ------------------------------------------------------------------------------
# @internal-function init_paths_
#
# Initializes some variables that will be used. These variables are mostly used
# to determine where things will eventually get installed.
# ------------------------------------------------------------------------------
java-pkg_init_paths_() {
	debug-print-function ${FUNCNAME} $*

	local pkg_name
	if [[ "$SLOT" == "0" ]] ; then
		JAVA_PKG_NAME="${PN}"
	else
		JAVA_PKG_NAME="${PN}-${SLOT}"
	fi

	JAVA_PKG_SHAREPATH="${DESTTREE}/share/${JAVA_PKG_NAME}"
	JAVA_PKG_SOURCESPATH="${JAVA_PKG_SHAREPATH}/sources/"
	JAVA_PKG_ENV="${D}${JAVA_PKG_SHAREPATH}/package.env"

	[[ -z "${JAVA_PKG_JARDEST}" ]] && JAVA_PKG_JARDEST="${JAVA_PKG_SHAREPATH}/lib"
	[[ -z "${JAVA_PKG_LIBDEST}" ]] && JAVA_PKG_LIBDEST="${DESTTREE}/$(get_libdir)/${JAVA_PKG_NAME}"
	[[ -z "${JAVA_PKG_WARDEST}" ]] && JAVA_PKG_WARDEST="${JAVA_PKG_SHAREPATH}/webapps"


	# TODO maybe only print once?
	debug-print "JAVA_PKG_SHAREPATH: ${JAVA_PKG_SHAREPATH}"
	debug-print "JAVA_PKG_ENV: ${JAVA_PKG_ENV}"
	debug-print "JAVA_PKG_JARDEST: ${JAVA_PKG_JARDEST}"
	debug-print "JAVA_PKG_LIBDEST: ${JAVA_PKG_LIBDEST}"
	debug-print "JAVA_PKG_WARDEST: ${JAVA_PKG_WARDEST}"
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_do_write_
#
# Writes the package.env out to disk.
#
# ------------------------------------------------------------------------------
# TODO change to do-write, to match everything else
java-pkg_do_write_() {
	# Create directory for package.env
	dodir "${JAVA_PKG_SHAREPATH}"
	if [[ -n "${JAVA_PKG_CLASSPATH}" || -n "${JAVA_PKG_LIBRARY}" || -f "${JAVA_PKG_DEPEND}" ]]; then
		# Create package.env
		(
			echo "DESCRIPTION=\"${DESCRIPTION}\""
			echo "GENERATION=\"2\""

			[[ -n "${JAVA_PKG_CLASSPATH}" ]] && echo "CLASSPATH=\"${JAVA_PKG_CLASSPATH}\""
			[[ -n "${JAVA_PKG_LIBRARY}" ]] && echo "LIBRARY_PATH=\"${JAVA_PKG_LIBRARY}\""
			[[ -n "${JAVA_PROVIDE}" ]] && echo "PROVIDES=\"${JAVA_PROVIDE}\""
			[[ -f "${JAVA_PKG_DEPEND}" ]] && echo "DEPEND=\"$(cat ${JAVA_PKG_DEPEND} | uniq | tr '\n' ':')\""
			echo "VM=\"$(echo ${RDEPEND} ${DEPEND} | sed -e 's/ /\n/g' | sed -n -e '/virtual\/\(jre\|jdk\)/ { p;q }')\"" # TODO cleanup !
		) > "${JAVA_PKG_ENV}"
		
		# register target/source
		local target="$(java-pkg_get-target)"
		local source="$(java-pkg_get-source)"
		[[ -n ${target} ]] && echo "TARGET=\"${target}\"" >> "${JAVA_PKG_ENV}"
		[[ -n ${source} ]] && echo "SOURCE=\"${source}\"" >> "${JAVA_PKG_ENV}"

		# register javadoc info
		[[ -n ${JAVADOC_PATH} ]] && echo "JAVADOC_PATH=\"${JAVADOC_PATH}\"" \
			>> ${JAVA_PKG_ENV}
		# register source archives
		[[ -n ${JAVA_SOURCES} ]] && echo "JAVA_SOURCES=\"${JAVA_SOURCES}\"" \
			>> ${JAVA_PKG_ENV}


		echo "MERGE_VM=\"${GENTOO_VM}\"" >> "${JAVA_PKG_ENV}"
		[[ -n ${GENTOO_COMPILER} ]] && echo "MERGE_COMPILER=\"${GENTOO_COMPILER}\"" >> "${JAVA_PKG_ENV}"

		# Strip unnecessary leading and trailing colons
		# TODO try to cleanup if possible
		sed -e "s/=\":/=\"/" -e "s/:\"$/\"/" -i "${JAVA_PKG_ENV}" || die "Did you forget to call java_init ?"
	fi
}


# ------------------------------------------------------------------------------
# @internal-function java-pkg_record-jar_
#
# Record a dependency to the package.env
#
# ------------------------------------------------------------------------------
JAVA_PKG_DEPEND="${T}/java-pkg-depend"

java-pkg_record-jar_() {
	debug-print-function ${FUNCNAME} $*

	local pkg=${1} jar=${2} append
	if [[ -z "${jar}" ]]; then
		append="${pkg}"
	else
		append="$(basename ${jar})@${pkg}"
	fi

	echo ${append} >> ${JAVA_PKG_DEPEND}
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_append_
#
# Appends a value to a variable
#
# Example: java-pkg_append_ CLASSPATH foo.jar
# @param $1 variable name to modify
# @param $2 value to append
# ------------------------------------------------------------------------------
java-pkg_append_() {
	debug-print-function ${FUNCNAME} $*

	local var="${1}" value="${2}"
	if [[ -z "${!var}" ]] ; then
		export ${var}="${value}"
	else
		local oldIFS=${IFS} cur haveit
		IFS=':'
		for cur in ${!var}; do
			if [[ ${cur} == ${value} ]]; then
				haveit="yes"
				break
			fi
		done
		[[ -z ${haveit} ]] && export ${var}="${!var}:${value}"
		IFS=${oldIFS}
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_expand_dir_
# 
# Gets the full path of the file/directory's parent.
# @param $1 - file/directory to find parent directory for
# @return - path to $1's parent directory
# ------------------------------------------------------------------------------
java-pkg_expand_dir_() {
	pushd "$(dirname "${1}")" >/dev/null 2>&1
	pwd
	popd >/dev/null 2>&1
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_func-exists
#
# Does the indicated function exist?
#
# @return 0 - function is declared
# @return 1 - function is undeclared
# ------------------------------------------------------------------------------
java-pkg_func-exists() {
	if [[ -n "$(declare -f ${1})" ]]; then
		return 0
	else
		return 1
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_setup-vm
#
# Sets up the environment for a specific VM
#
# ------------------------------------------------------------------------------
java-pkg_setup-vm() {
	debug-print-function ${FUNCNAME} $*

	local vendor="$(java-pkg_get-vm-vendor)"
	if [[ "${vendor}" == "sun" ]] && java-pkg_is-vm-version-ge 1 5; then
		addpredict "/dev/random"
	elif [[ "${vendor}" == "ibm" ]]; then
		addpredict "/proc/self/maps"
		addpredict "/proc/cpuinfo"
		export LANG="C" LC_ALL="C"
	elif [[ "${vendor}" == "jrockit" ]]; then
		addpredict "/proc/cpuinfo"
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_needs-vm
#
# Does the current package depend on virtual/jdk?
#
# @return 0 - Package depends on virtual/jdk
# @return 1 - Package does not depend on virtual/jdk
# ------------------------------------------------------------------------------
java-pkg_needs-vm() {
	debug-print-function ${FUNCNAME} $*

	if [[ -n "$(echo ${DEPEND} | sed -e '\:virtual/jdk:!d')" ]]; then
		return 0
	fi

	return 1
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_get-current-vm
#
# @return - The current VM being used
# ------------------------------------------------------------------------------
java-pkg_get-current-vm() {
	java-config -f
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_get-vm-vendor
#
# @return - The vendor of the current VM
# ------------------------------------------------------------------------------
java-pkg_get-vm-vendor() {
	debug-print-function ${FUNCNAME} $*

	local vm="$(java-pkg_get-current-vm)"
	vm="${vm/-*/}"
	echo "${vm}"
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_get-vm-version
#
# @return - The version of the current VM
# ------------------------------------------------------------------------------
java-pkg_get-vm-version() {
	debug-print-function ${FUNCNAME} $*

	java-pkg_get-current-vm | sed -e "s/.*-\([0-9.]\+\).*/\1/"
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_switch-vm
#
# Switch VM if we're allowed to (controlled by JAVA_PKG_ALLOW_VM_CHANGE), and 
# verify that the current VM is sufficient.
# Setup the environment for the VM being used.
# ------------------------------------------------------------------------------
java-pkg_switch-vm() {
	if java-pkg_needs-vm; then
		# Use the VM specified by JAVA_PKG_FORCE_VM
		if [[ -n ${JAVA_PKG_FORCE_VM} ]]; then
			# If you're forcing the VM, I hope you know what your doing...
			export GENTOO_VM="${JAVA_PKG_FORCE_VM}"
		# if we're allowed to switch the vm...
		elif [[ "${JAVA_PKG_ALLOW_VM_CHANGE}" == "yes" ]]; then
			debug-print "depend-java-query:  NV_DEPEND:	${JAVA_PKG_NV_DEPEND:-${DEPEND}} VNEED: ${JAVA_PKG_VNEED}"
			if [[ -n ${JAVA_PKG_VNEED} ]]; then
				export GENTOO_VM="$(depend-java-query --need-virtual "${JAVA_PKG_VNEED}" --get-vm "${JAVA_PKG_NV_DEPEND:-${DEPEND}}")"
			else
				export GENTOO_VM="$(depend-java-query --get-vm "${JAVA_PKG_NV_DEPEND:-${DEPEND}}")"
			fi
		# otherwise just make sure the current VM is sufficient
		else
			java-pkg_ensure-vm-version-sufficient
		fi
		debug-print "Using: $(java-config -f)"
		
		java-pkg_setup-vm

		export JAVA=$(java-config --java)
		export JAVAC=$(java-config --javac)
		export JAVACFLAGS="$(java-pkg_javac-args)" 
		[[ -n ${JAVACFLAGS_EXTRA} ]] && export JAVACFLAGS="${JAVACFLAGS_EXTRA} ${JAVACFLAGS}"

		export JAVA_HOME="$(java-config -g JAVA_HOME)"
		export JDK_HOME=${JAVA_HOME}

		#TODO If you know a better solution let us know.
		java-pkg_append_ LD_LIBRARY_PATH "$(java-config -g LDPATH)"
	
		local tann="${T}/announced-vm"
		if [[ -n "${JAVA_PKG_DEBUG}" ]] || [[ ! -f "${tann}" ]] ; then
			# Add a check for setup/preinst phase... to avoid duplicate outputs
			# for when FEATURES=buildpkg
			if [[ ${EBUILD_PHASE} != "setup" && ${EBUILD_PHASE} != "preinst" && ${EBUILD_PHASE} != "postinst" ]];
			then
				einfo "Using: $(java-config -f)"
				[[ ! -f "${tann}" ]] && touch "${tann}"
			fi
		fi

	else
		[[ -n "${JAVA_PKG_DEBUG}" ]] && ewarn "!!! This package inherits java-pkg but doesn't depend on a JDK. -bin or broken dependency!!!"
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_die
#
# Enhanced die for Java packages, which displays some information that may be
# useful for debugging bugs on bugzilla.
# ------------------------------------------------------------------------------
#register_die_hook java-pkg_die
if ! hasq java-pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS="${EBUILD_DEATH_HOOKS} java-pkg_die"
fi

java-pkg_die() {
	echo "!!! When you file a bug report, please include the following information:" >&2
	echo "GENTOO_VM=${GENTOO_VM}  CLASSPATH=\"${CLASSPATH}\" JAVA_HOME=\"${JAVA_HOME}\"" >&2
	echo "JAVACFLAGS=\"${JAVACFLAGS}\" COMPILER=\"${GENTOO_COMPILER}\"" >&2
	echo "and of course, the output of emerge --info" >&2
}


# TODO document
# List jars in the source directory, ${S}
java-pkg_jar-list() {
	if [[ -n "${JAVA_PKG_DEBUG}" ]]; then
		einfo "Linked Jars"
		find "${S}" -type l -name '*.jar' -print0 | xargs -0 -r -n 500 ls -ald | sed -e "s,${WORKDIR},\${WORKDIR},"
		einfo "Jars"
		find "${S}" -type f -name '*.jar' -print0 | xargs -0 -r -n 500 ls -ald | sed -e "s,${WORKDIR},\${WORKDIR},"
		einfo "Classes"
		find "${S}" -type f -name '*.class' -print0 | xargs -0 -r -n 500 ls -ald | sed -e "s,${WORKDIR},\${WORKDIR},"
	fi
}

# TODO document
# Verify that the classes were compiled for the right source / target
java-pkg_verify-classes() {
	ebegin "Verifying java class versions"
	#$(find ${D} -type f -name '*.jar' -o -name '*.class')
	class-version-verify.py -t $(java-pkg_get-target) -r ${D} 
	result=$?
	eend ${result}
	if [[ ${result} == 0 ]]; then
		einfo "All good"
	else
		ewarn "Possible problem"
		die "Bad class files found"
	fi
}


# ------------------------------------------------------------------------------
# @section-end internal
# ------------------------------------------------------------------------------

java-pkg_check-phase() {
	local phase=${1}
	local funcname=${2}
	if is-java-strict && [[ ${EBUILD_PHASE} != ${phase} ]]; then
		java-pkg_announce-qa-violation \
			"${funcname} used outside of src_${phase}"
	fi
}

java-pkg_check-versioned-jar() {
	local jar=${1}

	if [[ ${jar} =~ ${PV} ]]; then
		java-pkg_announce-qa-violation "installing versioned jar '${jar}'"
	fi
}

java-pkg_check-jikes() {
	if hasq jikes ${IUSE}; then
		java-pkg_announce-qa-violation "deprecated USE flag 'jikes' in IUSE"
	fi
}

java-pkg_announce-qa-violation() {
	if is-java-strict; then
		echo "Java QA Notice: $@" >&2
		increment-qa-violations
	fi
}

increment-qa-violations() {
	let "JAVA_PKG_QA_VIOLATIONS+=1"
	export JAVA_PKG_QA_VIOLATIONS
}

is-java-strict() {
	[[ -n ${JAVA_PKG_STRICT} ]]
	return $?
}

# ------------------------------------------------------------------------------
# @eclass-end
# ------------------------------------------------------------------------------
