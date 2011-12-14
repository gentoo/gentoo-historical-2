# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/autotools-utils.eclass,v 1.30 2011/12/14 14:55:03 mgorny Exp $

# @ECLASS: autotools-utils.eclass
# @MAINTAINER:
# Maciej Mrozowski <reavertm@gentoo.org>
# Michał Górny <mgorny@gentoo.org>
# @BLURB: common ebuild functions for autotools-based packages
# @DESCRIPTION:
# autotools-utils.eclass is autotools.eclass(5) and base.eclass(5) wrapper
# providing all inherited features along with econf arguments as Bash array,
# out of source build with overridable build dir location, static archives
# handling, libtool files removal.
#
# Please note note that autotools-utils does not support mixing of its phase
# functions with regular econf/emake calls. If necessary, please call
# autotools-utils_src_compile instead of the latter.
#
# @EXAMPLE:
# Typical ebuild using autotools-utils.eclass:
#
# @CODE
# EAPI="2"
#
# inherit autotools-utils
#
# DESCRIPTION="Foo bar application"
# HOMEPAGE="http://example.org/foo/"
# SRC_URI="mirror://sourceforge/foo/${P}.tar.bz2"
#
# LICENSE="LGPL-2.1"
# KEYWORDS=""
# SLOT="0"
# IUSE="debug doc examples qt4 static-libs tiff"
#
# CDEPEND="
# 	media-libs/libpng:0
# 	qt4? (
# 		x11-libs/qt-core:4
# 		x11-libs/qt-gui:4
# 	)
# 	tiff? ( media-libs/tiff:0 )
# "
# RDEPEND="${CDEPEND}
# 	!media-gfx/bar
# "
# DEPEND="${CDEPEND}
# 	doc? ( app-doc/doxygen )
# "
#
# # bug 123456
# AUTOTOOLS_IN_SOURCE_BUILD=1
#
# DOCS=(AUTHORS ChangeLog README "Read me.txt" TODO)
#
# PATCHES=(
# 	"${FILESDIR}/${P}-gcc44.patch" # bug 123458
# 	"${FILESDIR}/${P}-as-needed.patch"
# 	"${FILESDIR}/${P}-unbundle_libpng.patch"
# )
#
# src_configure() {
# 	local myeconfargs=(
# 		$(use_enable debug)
# 		$(use_with qt4)
# 		$(use_enable threads multithreading)
# 		$(use_with tiff)
# 	)
# 	autotools-utils_src_configure
# }
#
# src_compile() {
# 	autotools-utils_src_compile
# 	use doc && autotools-utils_src_compile docs
# }
#
# src_install() {
# 	use doc && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}/apidocs/html/")
# 	autotools-utils_src_install
# 	if use examples; then
# 		dobin "${AUTOTOOLS_BUILD_DIR}"/foo_example{1,2,3} \\
# 			|| die 'dobin examples failed'
# 	fi
# }
#
# @CODE

# Keep variable names synced with cmake-utils and the other way around!

case ${EAPI:-0} in
	2|3|4) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit autotools eutils libtool

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install src_test

# @ECLASS-VARIABLE: AUTOTOOLS_BUILD_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# Build directory, location where all autotools generated files should be
# placed. For out of source builds it defaults to ${WORKDIR}/${P}_build.

# @ECLASS-VARIABLE: AUTOTOOLS_IN_SOURCE_BUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to enable in-source build.

# @ECLASS-VARIABLE: ECONF_SOURCE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specify location of autotools' configure script. By default it uses ${S}.

# @ECLASS-VARIABLE: myeconfargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional econf arguments as Bash array. Should be defined before calling src_configure.
# @CODE
# src_configure() {
# 	local myeconfargs=(
# 		--disable-readline
# 		--with-confdir="/etc/nasty foo confdir/"
# 		$(use_enable debug cnddebug)
# 		$(use_enable threads multithreading)
# 	)
# 	autotools-utils_src_configure
# }
# @CODE

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dodoc command.
#
# Example:
# @CODE
# DOCS=( NEWS README )
# @CODE

# @ECLASS-VARIABLE: HTML_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dohtml command.
#
# Example:
# @CODE
# HTML_DOCS=( doc/html/ )
# @CODE

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# PATCHES array variable containing all various patches to be applied.
#
# Example:
# @CODE
# PATCHES=( "${FILESDIR}"/${P}-mypatch.patch )
# @CODE

# Determine using IN or OUT source build
_check_build_dir() {
	: ${ECONF_SOURCE:=${S}}
	if [[ -n ${AUTOTOOLS_IN_SOURCE_BUILD} ]]; then
		AUTOTOOLS_BUILD_DIR="${ECONF_SOURCE}"
	else
		: ${AUTOTOOLS_BUILD_DIR:=${WORKDIR}/${P}_build}
	fi
	echo ">>> Working in BUILD_DIR: \"$AUTOTOOLS_BUILD_DIR\""
}

# @FUNCTION: remove_libtool_files
# @USAGE: [all]
# @DESCRIPTION:
# Determines unnecessary libtool files (.la) and libtool static archives (.a)
# and removes them from installation image.
#
# To unconditionally remove all libtool files, pass 'all' as argument.
# Otherwise, libtool archives required for static linking will be preserved.
#
# In most cases it's not necessary to manually invoke this function.
# See autotools-utils_src_install for reference.
remove_libtool_files() {
	debug-print-function ${FUNCNAME} "$@"
	local removing_all
	[[ ${#} -le 1 ]] || die "Invalid number of args to ${FUNCNAME}()"
	if [[ ${#} -eq 1 ]]; then
		case "${1}" in
			all)
				removing_all=1
				;;
			*)
				die "Invalid argument to ${FUNCNAME}(): ${1}"
		esac
	fi

	local pc_libs=()
	if [[ ! ${removing_all} ]]; then
		local arg
		for arg in $(find "${D}" -name '*.pc' -exec \
					sed -n -e 's;^Libs:;;p' {} +); do
			[[ ${arg} == -l* ]] && pc_libs+=(lib${arg#-l}.la)
		done
	fi

	local f
	find "${D}" -type f -name '*.la' -print0 | while read -r -d '' f; do
		local shouldnotlink=$(sed -ne '/^shouldnotlink=yes$/p' "${f}")
		local archivefile=${f/%.la/.a}
		[[ "${f}" != "${archivefile}" ]] || die 'regex sanity check failed'

		# Remove static libs we're not supposed to link against.
		if [[ ${shouldnotlink} ]]; then
			einfo "Removing unnecessary ${archivefile#${D%/}}"
			rm -f "${archivefile}" || die
			# The .la file may be used by a module loader, so avoid removing it
			# unless explicitly requested.
			[[ ${removing_all} ]] || continue
		fi

		# Remove .la files when:
		# - user explicitly wants us to remove all .la files,
		# - respective static archive doesn't exist,
		# - they are covered by a .pc file already,
		# - they don't provide any new information (no libs & no flags).
		local removing
		if [[ ${removing_all} ]]; then removing='forced'
		elif [[ ! -f ${archivefile} ]]; then removing='no static archive'
		elif has "$(basename "${f}")" "${pc_libs[@]}"; then
			removing='covered by .pc'
		elif [[ ! $(sed -n -e \
			"s/^\(dependency_libs\|inherited_linker_flags\)='\(.*\)'$/\2/p" \
			"${f}") ]]; then removing='no libs & flags'
		fi

		if [[ ${removing} ]]; then
			einfo "Removing unnecessary ${f#${D%/}} (${removing})"
			rm -f "${f}" || die
		fi
	done

	# check for invalid eclass use
	# this is the most commonly used function, so do it here
	_check_build_dir
	if [[ ! -d "${AUTOTOOLS_BUILD_DIR}" ]]; then
		eqawarn "autotools-utils used but autotools-utils_src_configure was never called."
		eqawarn "This is not supported and never was. Please report a bug against"
		eqawarn "the offending ebuild. This will become a fatal error in a near future."
	fi
}

# @FUNCTION: autotools-utils_src_prepare
# @DESCRIPTION:
# The src_prepare function.
#
# Supporting PATCHES array and user patches. See base.eclass(5) for reference.
autotools-utils_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${PATCHES} ]] && epatch "${PATCHES[@]}"
	epatch_user

	elibtoolize --patch-only
}

# @FUNCTION: autotools-utils_src_configure
# @DESCRIPTION:
# The src_configure function. For out of source build it creates build
# directory and runs econf there. Configuration parameters defined
# in myeconfargs are passed here to econf. Additionally following USE
# flags are known:
#
# IUSE="static-libs" passes --enable-shared and either --disable-static/--enable-static
# to econf respectively.
autotools-utils_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${myeconfargs+1} || $(declare -p myeconfargs) == 'declare -a'* ]] \
		|| die 'autotools-utils.eclass: myeconfargs has to be an array.'

	# Common args
	local econfargs=()

	# Handle static-libs found in IUSE, disable them by default
	if in_iuse static-libs; then
		econfargs+=(
			--enable-shared
			$(use_enable static-libs static)
		)
	fi

	# Append user args
	econfargs+=("${myeconfargs[@]}")

	_check_build_dir
	mkdir -p "${AUTOTOOLS_BUILD_DIR}" || die "mkdir '${AUTOTOOLS_BUILD_DIR}' failed"
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
	econf "${econfargs[@]}" "$@"
	popd > /dev/null
}

# @FUNCTION: autotools-utils_src_compile
# @DESCRIPTION:
# The autotools src_compile function, invokes emake in specified AUTOTOOLS_BUILD_DIR.
autotools-utils_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
	emake "$@" || die 'emake failed'
	popd > /dev/null
}

# @FUNCTION: autotools-utils_src_install
# @DESCRIPTION:
# The autotools src_install function. Runs emake install, unconditionally
# removes unnecessary static libs (based on shouldnotlink libtool property)
# and removes unnecessary libtool files when static-libs USE flag is defined
# and unset.
#
# DOCS and HTML_DOCS arrays are supported. See base.eclass(5) for reference.
autotools-utils_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
	emake DESTDIR="${D}" "$@" install || die "emake install failed"
	popd > /dev/null

	# XXX: support installing them from builddir as well?
	if [[ ${DOCS} ]]; then
		dodoc "${DOCS[@]}" || die "dodoc failed"
	fi
	if [[ ${HTML_DOCS} ]]; then
		dohtml -r "${HTML_DOCS[@]}" || die "dohtml failed"
	fi

	# Remove libtool files and unnecessary static libs
	remove_libtool_files
}

# @FUNCTION: autotools-utils_src_test
# @DESCRIPTION:
# The autotools src_test function. Runs emake check in build directory.
autotools-utils_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
	# Run default src_test as defined in ebuild.sh
	default_src_test
	popd > /dev/null
}
