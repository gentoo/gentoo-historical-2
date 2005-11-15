# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mozconfig-2.eclass,v 1.2 2005/11/15 10:48:23 azarah Exp $
#
# mozconfig.eclass: the new mozilla.eclass

inherit multilib flag-o-matic

IUSE="debug gnome ipv6 truetype xinerama xprint mozsvg"

RDEPEND="virtual/x11
	!moznoxft? ( virtual/xft )
	>=media-libs/fontconfig-2.1
	>=sys-libs/zlib-1.1.4
	>=media-libs/jpeg-6b
	>=media-libs/libmng-1.0.0
	>=media-libs/libpng-1.2.1
	>=sys-apps/portage-2.0.36
	dev-libs/expat
	app-arch/zip
	app-arch/unzip
	>=www-client/mozilla-launcher-1.42
	>=x11-libs/gtk+-2.8.6
	>=dev-libs/glib-2.8.2
	>=x11-libs/pango-1.10.1
	>=dev-libs/libIDL-0.8.0
	gnome? ( >=gnome-base/gnome-vfs-2.3.5 
		 >=gnome-base/libgnomeui-2.2.0 )
	mozsvg? ( !<x11-base/xorg-x11-6.7.0-r2
		    >=x11-libs/cairo-1.0.0
		    >=media-libs/glitz-0.4.4)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

# Set by configure (plus USE_AUTOCONF=1), but useful for NSPR
export MOZILLA_CLIENT=1
export BUILD_OPT=1
export NO_STATIC_LIB=1
export USE_PTHREADS=1

mozconfig_init() {
	declare enable_optimize pango_version myext x
	declare MOZ=$([[ ${PN} == mozilla || ${PN} == gecko-sdk ]] && echo true || echo false)
	declare FF=$([[ ${PN} == *firefox ]] && echo true || echo false)
	declare TB=$([[ ${PN} == *thunderbird ]] && echo true || echo false)
	declare SB=$([[ ${PN} == *sunbird ]] && echo true || echo false)

	####################################
	#
	# Setup the initial .mozconfig
	# See http://www.mozilla.org/build/configure-build.html
	#
	####################################

	case ${PN} in
		mozilla|gecko-sdk)
			# The other builds have an initial --enable-extensions in their
			# .mozconfig.  The "default" set in configure applies to mozilla
			# specifically.
			: >.mozconfig || die "initial mozconfig creation failed"
			mozconfig_annotate "" --enable-extensions=default ;;
		*firefox)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		*thunderbird)
			cp mail/config/mozconfig .mozconfig \
				|| die "cp mail/config/mozconfig failed" ;;
		*sunbird)
			cp calendar/sunbird/config/mozconfig .mozconfig \
				|| die "cp calendar/sunbird/config/mozconfig failed" ;;
	esac

	####################################
	#
	# CFLAGS setup and ARCH support
	#
	####################################

	# Set optimization level based on CFLAGS
	if is-flag -O0; then
		mozconfig_annotate "from CFLAGS" --enable-optimize=-O0
	elif [[ ${ARCH} == hppa ]]; then
		mozconfig_annotate "more than -O0 causes segfaults on hppa" --enable-optimize=-O0
	elif [[ ${ARCH} == alpha || ${ARCH} == ia64 || ${ARCH} == ppc64 ]]; then
		mozconfig_annotate "more than -O1 causes segfaults on 64-bit (bug 33767)" \
			--enable-optimize=-O1
	elif is-flag -O1; then
		mozconfig_annotate "from CFLAGS" --enable-optimize=-O1
	else
		mozconfig_annotate "mozilla fallback" --enable-optimize=-O2
	fi

	# Now strip optimization from CFLAGS so it doesn't end up in the
	# compile string
	filter-flags '-O*'

	# Strip over-aggressive CFLAGS - Mozilla supplies its own
	# fine-tuned CFLAGS and shouldn't be interfered with..  Do this
	# AFTER setting optimization above since strip-flags only allows
	# -O -O1 and -O2
	strip-flags

	# Additional ARCH support
	case "${ARCH}" in
	alpha)
		# Historically we have needed to add -fPIC manually for 64-bit.
		# Additionally, alpha should *always* build with -mieee for correct math
		# operation
		append-flags -fPIC -mieee
		;;

	amd64|ia64)
		# Historically we have needed to add this manually for 64-bit
		append-flags -fPIC
		;;

	ppc64)
		append-flags -fPIC -mminimal-toc
		;;

	ppc)
		# Fix to avoid gcc-3.3.x micompilation issues.
		if [[ $(gcc-major-version).$(gcc-minor-version) == 3.3 ]]; then
			append-flags -fno-strict-aliasing
		fi
		;;

	sparc)
		# Sparc support ...
		replace-sparc64-flags
		;;

	x86)
		if [[ $(gcc-major-version) -eq 3 ]]; then
			# gcc-3 prior to 3.2.3 doesn't work well for pentium4
			# see bug 25332
			if [[ $(gcc-minor-version) -lt 2 ||
				( $(gcc-minor-version) -eq 2 && $(gcc-micro-version) -lt 3 ) ]]
			then
				replace-flags -march=pentium4 -march=pentium3
				filter-flags -msse2
			fi
		fi
		;;
	esac

	if [[ $(gcc-major-version) -eq 3 ]]; then
		# Enable us to use flash, etc plugins compiled with gcc-2.95.3
		mozconfig_annotate "building with >=gcc-3" --enable-old-abi-compat-wrappers

		# Needed to build without warnings on gcc-3
		CXXFLAGS="${CXXFLAGS} -Wno-deprecated"
	fi

	# Go a little faster; use less RAM
	append-flags "$MAKEEDIT_FLAGS"

	####################################
	#
	# mozconfig setup
	#
	####################################

	mozconfig_annotate gentoo \
		--disable-installer \
		--disable-pedantic \
		--enable-crypto \
		--with-system-jpeg \
		--with-system-png \
		--with-system-zlib \
		--without-system-nspr \
		--disable-updater \
		--enable-single-profile \
		--disable-profilesharing \
		--disable-profilelocking \
		--enable-default-toolkit=gtk2

	mozconfig_use_enable ipv6
	mozconfig_use_enable xinerama
	mozconfig_use_enable xprint

	# We use --enable-xft and --enable-pango to do truetype fonts
	mozconfig_annotate gentoo --disable-freetype2

	if use debug; then
		mozconfig_annotate +debug \
			--enable-debug \
			--enable-tests \
			--disable-reorder \
			--disable-strip \
			--disable-strip-libs \
			--enable-debugger-info-modules=ALL_MODULES
	else
		mozconfig_annotate -debug \
			--disable-debug \
			--disable-tests \
			--enable-reorder \
			--enable-strip \
			--enable-strip-libs

		# Currently --enable-elf-dynstr-gc only works for x86 and ppc,
		# thanks to Jason Wever <weeve@gentoo.org> for the fix.
		if use x86 || use ppc && [[ ${enable_optimize} != -O0 ]]; then
			mozconfig_annotate "${ARCH} optimized build" --enable-elf-dynstr-gc
		fi
	fi

	if ! use gnome; then
		mozconfig_annotate -gnome --disable-gnomevfs
		mozconfig_annotate -gnome --disable-gnomeui
 	fi

	if use mozsvg; then
		mozconfig_annotate mozsvg --enable-svg
		mozconfig_annotate mozsvg --enable-canvas
		mozconfig_annotate mozsvg --enable-svg-renderer=cairo
		mozconfig_annotate mozsvg --enable-glitz
	fi

	# Here is a strange one...
	if is-flag '-mcpu=ultrasparc*' || is-flag '-mtune=ultrasparc*'; then
		mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
	fi

	# Check if we should enable Xft support...
	if ! use truetype; then
		mozconfig_annotate "disabling xft2 by request (-truetype)" --disable-xft
	else
		if [[ -x /usr/bin/pkg-config ]] && pkg-config xft; then
			mozconfig_annotate "-moznoxft" --enable-xft --enable-pango
		else
			mozconfig_annotate "no pkg-config xft" --disable-xft
		fi
	fi
}

# Simulate the silly csh makemake script
makemake() {
	typeset m topdir
	for m in $(find . -name Makefile.in); do
		topdir=$(echo "$m" | sed -r 's:[^/]+:..:g')
		sed -e "s:@srcdir@:.:g" -e "s:@top_srcdir@:${topdir}:g" \
			< ${m} > ${m%.in} || die "sed ${m} failed"
	done
}

#
# The following functions are for manipulating mozconfig
#

# mozconfig_annotate: add an annotated line to .mozconfig
#
# Example:
# mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
# => ac_add_options --enable-js-ultrasparc # building on ultrasparc
mozconfig_annotate() {
	declare reason=$1 x ; shift
	[[ $# -gt 0 ]] || die "mozconfig_annotate missing flags for ${reason}\!"
	for x in ${*}; do
		echo "ac_add_options ${x} # ${reason}" >>.mozconfig
	done
}

# mozconfig_use_enable: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_enable truetype freetype2
# => ac_add_options --enable-freetype2 # +truetype
mozconfig_use_enable() {
	declare flag=$(use_enable "$@")
	mozconfig_annotate "$(useq $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_with: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_with kerberos gss-api /usr/$(get_libdir)
# => ac_add_options --with-gss-api=/usr/lib # +kerberos
mozconfig_use_with() {
	declare flag=$(use_with "$@")
	mozconfig_annotate "$(useq $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_extension: enable or disable an extension based on a USE-flag
#
# Example:
# mozconfig_use_extension gnome gnomevfs
# => ac_add_options --enable-extensions=gnomevfs
mozconfig_use_extension() {
	declare minus=$(useq $1 || echo -)
	mozconfig_annotate "${minus:-+}$1" --enable-extensions=${minus}${2}
}

# mozconfig_final: display a table describing all configuration options paired
# with reasons, then clean up extensions list
mozconfig_final() {
	declare ac opt hash reason
	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options .mozconfig | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	# Resolve multiple --enable-extensions down to one
	declare exts=$(sed -n 's/^ac_add_options --enable-extensions=\([^ ]*\).*/\1/p' \
		.mozconfig | xargs)
	sed -i '/^ac_add_options --enable-extensions/d' .mozconfig
	echo "ac_add_options --enable-extensions=${exts// /,}" >> .mozconfig
}
