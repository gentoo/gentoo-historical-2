# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/x-modular.eclass,v 1.32 2005/12/12 01:56:08 spyderous Exp $
#
# Author: Donnie Berkholz <spyderous@gentoo.org>
#
# This eclass is designed to reduce code duplication in the modularized X11
# ebuilds.
#
# Using this eclass:
#
# Inherit it. If you need to run autoreconf for any reason (e.g., your patches
# apply to the autotools files rather than configure), set SNAPSHOT="yes". Set
# CONFIGURE_OPTIONS to everything you want to pass to the configure script.
#
# If you have any patches to apply, set PATCHES to their locations and epatch
# will apply them. It also handles epatch-style bulk patches, if you know how to
# use them and set the correct variables. If you don't, read eutils.eclass.
#
# If you're creating a font package and the suffix of PN is not equal to the
# subdirectory of /usr/share/fonts/ it should install into, set FONT_DIR to that
# directory or directories.
#
# Pretty much everything else should be automatic.

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_preinst pkg_postinst pkg_postrm

inherit eutils libtool toolchain-funcs

# Directory prefix to use for everything
XDIR="/usr"

# Set up default patchset version(s) if necessary
# x11-driver-patches
if [[ -z "${XDPVER}" ]]; then
	XDPVER="1"
fi

IUSE=""
HOMEPAGE="http://xorg.freedesktop.org/"
SRC_URI="http://xorg.freedesktop.org/releases/X11R7.0-RC3/everything/${P}.tar.bz2
	http://xorg.freedesktop.org/releases/X11R7.0-RC2/everything/${P}.tar.bz2
	http://xorg.freedesktop.org/releases/X11R7.0-RC1/everything/${P}.tar.bz2
	http://xorg.freedesktop.org/releases/X11R7.0-RC0/everything/${P}.tar.bz2"
LICENSE="X11"
SLOT="0"

# Set up shared dependencies
if [[ -n "${SNAPSHOT}" ]]; then
# FIXME: What's the minimal libtool version supporting arbitrary versioning?
	DEPEND="${DEPEND}
		>=sys-devel/autoconf-2.57
		>=sys-devel/automake-1.7
		>=sys-devel/libtool-1.5
		>=sys-devel/m4-1.4"
fi

# If we're a font package, but not the font.alias one
if [[ "${PN/#font-}" != "${PN}" ]] \
	&& [[ "${PN}" != "font-alias" ]] \
	&& [[ "${PN}" != "font-util" ]]; then
	# Activate font code in the rest of the eclass
	FONT="yes"

	RDEPEND="${RDEPEND}
		media-fonts/encodings"
	DEPEND="${DEPEND}
		x11-apps/mkfontscale
		x11-apps/mkfontdir"
	PDEPEND="${PDEPEND}
		media-fonts/font-alias"

	# Starting with 7.0RC3, we can specify the font directory
	# But oddly, we can't do the same for encodings or font-alias

	# Wrap in `if` so ebuilds can set it too
	if [[ -z ${FONT_DIR} ]]; then
		FONT_DIR=${PN##*-}

	fi

	# Fix case of font directories
	FONT_DIR=${FONT_DIR/ttf/TTF}
	FONT_DIR=${FONT_DIR/otf/OTF}
	FONT_DIR=${FONT_DIR/type1/Type1}
	FONT_DIR=${FONT_DIR/speedo/Speedo}

	# Set up configure option
	FONT_OPTIONS="--with-fontdir=\"/usr/share/fonts/${FONT_DIR}\""

	if [[ -n "${FONT}" ]]; then
		if [[ ${PN##*-} = misc ]] || [[ ${PN##*-} = 75dpi ]] || [[ ${PN##*-} = 100dpi ]]; then
			IUSE="${IUSE} nls"
		fi
	fi
fi

# If we're a driver package
if [[ "${PN/#xf86-video}" != "${PN}" ]] || [[ "${PN/#xf86-input}" != "${PN}" ]]; then
	# Don't build static driver modules
	DRIVER_OPTIONS="--disable-static"

	# Enable driver code in the rest of the eclass
	DRIVER="yes"

	# Add driver patchset to SRC_URI
	SRC_URI="${SRC_URI} 
		http://dev.gentoo.org/~joshuabaergen/distfiles/x11-driver-patches-${XDPVER}.tar.bz2"
fi

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.18
	>=x11-misc/util-macros-0.99.2"

# >=sys-apps/man-1.6b-r2 required to look in [0-8]x/ directories
RDEPEND="${RDEPEND}
	!<=x11-base/xorg-x11-6.9
	>=sys-apps/man-1.6b-r2"
# Provides virtual/x11 for temporary use until packages are ported
#	x11-base/x11-env"

x-modular_unpack_source() {
	unpack ${A}
	cd ${S}

	if [[ -n ${FONT_OPTIONS} ]]; then
		einfo "Detected font directory: ${FONT_DIR}"
	fi
}

x-modular_patch_source() {
	# Use standardized names and locations with bulk patching
	# Patch directory is ${WORKDIR}/patch
	# See epatch() in eutils.eclass for more documentation
	if [[ -z "${EPATCH_SUFFIX}" ]] ; then
		EPATCH_SUFFIX="patch"
	fi

	# If this is a driver package we need to fix man page install location.
	# Running autoreconf will use the patched util-macros to make the
	# change for us, so we only need to patch if it is not going to run.
	if [[ -n "${DRIVER}" ]] && [[ "${SNAPSHOT}" != "yes" ]]; then
		PATCHES="${PATCHES} ${DISTDIR}/x11-driver-patches-${XDPVER}.tar.bz2"
	fi

	# For specific list of patches
	if [[ -n "${PATCHES}" ]] ; then
		for PATCH in ${PATCHES}
		do
			epatch ${PATCH}
		done
	# For non-default directory bulk patching
	elif [[ -n "${PATCH_LOC}" ]] ; then
		epatch ${PATCH_LOC}
	# For standard bulk patching
	elif [[ -d "${EPATCH_SOURCE}" ]] ; then
		epatch
	fi
}

x-modular_reconf_source() {
	# Run autoreconf for CVS snapshots only
	if [[ "${SNAPSHOT}" = "yes" ]]
	then
		# If possible, generate configure if it doesn't exist
		if [ -f "${S}/configure.ac" ]
		then
			einfo "Running autoreconf..."
			autoreconf -v --force --install
		fi
	fi

}

x-modular_src_unpack() {
	if [[ ${PN:0:11} = "xorg-server" ]] || [[ -n "${DRIVER}" ]]; then
		if gcc-specs-now; then
			msg="Do not emerge ${PN} without vanilla gcc!"
			eerror "$msg"
			die "$msg"
		fi
	fi

	x-modular_unpack_source
	x-modular_patch_source
	x-modular_reconf_source

	# Joshua Baergen - October 23, 2005
	# Fix shared lib issues on MIPS, FBSD, etc etc
	elibtoolize
}

x-modular_font_configure() {
	if [[ -n "${FONT}" ]]; then
		# Might be worth adding an option to configure your desired font
		# and exclude all others. Also, should this USE be nls or minimal?
		if ! use nls; then
			FONT_OPTIONS="${FONT_OPTIONS}
				--disable-iso8859-2
				--disable-iso8859-3
				--disable-iso8859-4
				--disable-iso8859-5
				--disable-iso8859-6
				--disable-iso8859-7
				--disable-iso8859-8
				--disable-iso8859-9
				--disable-iso8859-10
				--disable-iso8859-11
				--disable-iso8859-12
				--disable-iso8859-13
				--disable-iso8859-14
				--disable-iso8859-15
				--disable-iso8859-16
				--disable-jisx0201
				--disable-koi8-r"
		fi
	fi
}

x-modular_src_configure() {
	x-modular_font_configure

	# If prefix isn't set here, .pc files cause problems
	if [[ -x ./configure ]]; then
		econf --prefix=${XDIR} \
			--datadir=${XDIR}/share \
			${FONT_OPTIONS} \
			${DRIVER_OPTIONS} \
			${CONFIGURE_OPTIONS}
	fi
}

x-modular_src_make() {
	emake || die "emake failed"
}

x-modular_src_compile() {
	x-modular_src_configure
	x-modular_src_make
}

x-modular_src_install() {
	# Install everything to ${XDIR}
	make \
		DESTDIR="${D}" \
		install
# Shouldn't be necessary in XDIR=/usr
# einstall forces datadir, so we need to re-force it
#		datadir=${XDIR}/share \
#		mandir=${XDIR}/share/man \

	# Don't install libtool archives for server modules
	if [[ -e ${D}/usr/lib/xorg/modules ]]; then
		find ${D}/usr/lib/xorg/modules -name '*.la' \
			| xargs rm -f
	fi
}

x-modular_pkg_preinst() {
	if [[ -n "${FONT}" ]]; then
		discover_font_dirs
	fi
}

x-modular_pkg_postinst() {
	if [[ -n "${FONT}" ]]; then
		setup_fonts
	fi
}

x-modular_pkg_postrm() {
	if [[ -n "${FONT}" ]]; then
		cleanup_fonts
	fi
}

cleanup_fonts() {
	local ALLOWED_FILES="encodings.dir fonts.cache-1 fonts.dir fonts.scale"
	for DIR in ${FONT_DIR}; do
		unset KEEP_FONTDIR
		REAL_DIR=${ROOT}usr/share/fonts/${DIR}

		ebegin "Checking ${REAL_DIR} for useless files"
		pushd ${REAL_DIR} &> /dev/null
		for FILE in *; do
			unset MATCH
			for ALLOWED_FILE in ${ALLOWED_FILES}; do
				if [[ ${FILE} = ${ALLOWED_FILE} ]]; then
					# If it's allowed, then move on to the next file
					MATCH="yes"
					break
				fi
			done
			# If we found a match in allowed files, move on to the next file
			if [[ -n ${MATCH} ]]; then
				continue
			fi
			# If we get this far, there wasn't a match in the allowed files
			KEEP_FONTDIR="yes"
			# We don't need to check more files if we're already keeping it
			break
		done
		popd &> /dev/null
		# If there are no files worth keeping, then get rid of the dir
		if [[ -z "${KEEP_FONTDIR}" ]]; then
			rm -rf ${REAL_DIR}
		fi
		eend 0
	done
}

setup_fonts() {
	if [[ ! -n "${FONT_DIRS}" ]]; then
		msg="FONT_DIRS is empty. The ebuild should set it to at least one subdir of /usr/share/fonts."
		eerror "${msg}"
		die "${msg}"
	fi

	create_fonts_scale
	create_fonts_dir
	fix_font_permissions
	create_font_cache
}

discover_font_dirs() {
	pushd ${IMAGE}/usr/share/fonts
	FONT_DIRS="$(find . -maxdepth 1 -mindepth 1 -type d)"
	FONT_DIRS="$(echo ${FONT_DIRS} | sed -e 's:./::g')"
	popd
}

create_fonts_scale() {
	ebegin "Creating fonts.scale files"
		local x
		for FONT_DIR in ${FONT_DIRS}; do
			x=${ROOT}/usr/share/fonts/${FONT_DIR}
			[[ -z "$(ls ${x}/)" ]] && continue
			[[ "$(ls ${x}/)" = "fonts.cache-1" ]] && continue

			# Only generate .scale files if truetype, opentype or type1
			# fonts are present ...

			# First truetype (ttf,ttc)
			# NOTE: ttmkfdir does NOT work on type1 fonts (#53753)
			# Also, there is no way to regenerate Speedo/CID fonts.scale
			# <spyderous@gentoo.org> 2 August 2004
			if [[ "${x/encodings}" = "${x}" ]] \
				&& [[ -n "$(find ${x} -iname '*.tt[cf]' -print)" ]]; then
				if [[ -x ${ROOT}/usr/bin/ttmkfdir ]]; then
					LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/$(get_libdir)" \
					${ROOT}/usr/bin/ttmkfdir -x 2 \
						-e ${ROOT}/usr/share/fonts/encodings/encodings.dir \
						-o ${x}/fonts.scale -d ${x}
					# ttmkfdir fails on some stuff, so try mkfontscale if it does
					local ttmkfdir_return=$?
				else
					# We didn't use ttmkfdir at all
					local ttmkfdir_return=2
				fi
				if [[ ${ttmkfdir_return} -ne 0 ]]; then
					LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/$(get_libdir)" \
					${ROOT}/usr/bin/mkfontscale \
						-a /usr/share/fonts/encodings/encodings.dir \
						-- ${x}
				fi
			# Next type1 and opentype (pfa,pfb,otf,otc)
			elif [[ "${x/encodings}" = "${x}" ]] \
				&& [[ -n "$(find ${x} -iname '*.[po][ft][abcf]' -print)" ]]; then
				LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/$(get_libdir)" \
				${ROOT}/usr/bin/mkfontscale \
					-a ${ROOT}/usr/share/fonts/encodings/encodings.dir \
					-- ${x}
			fi
		done
	eend 0
}

create_fonts_dir() {
	ebegin "Generating fonts.dir files"
		for FONT_DIR in ${FONT_DIRS}; do
			x=${ROOT}/usr/share/fonts/${FONT_DIR}
			[[ -z "$(ls ${x}/)" ]] && continue
			[[ "$(ls ${x}/)" = "fonts.cache-1" ]] && continue

			if [[ "${x/encodings}" = "${x}" ]]; then
				LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/$(get_libdir)" \
				${ROOT}/usr/bin/mkfontdir \
					-e ${ROOT}/usr/share/fonts/encodings \
					-e ${ROOT}/usr/share/fonts/encodings/large \
					-- ${x}
			fi
		done
	eend 0
}

fix_font_permissions() {
	ebegin "Fixing permissions"
		for FONT_DIR in ${FONT_DIRS}; do
			find ${ROOT}/usr/share/fonts/${FONT_DIR} -type f -name 'font.*' \
				-exec chmod 0644 {} \;
		done
	eend 0
}

create_font_cache() {
	# danarmak found out that fc-cache should be run AFTER all the above
	# stuff, as otherwise the cache is invalid, and has to be run again
	# as root anyway
	if [[ -x ${ROOT}/usr/bin/fc-cache ]]; then
		ebegin "Creating FC font cache"
			HOME="/root" ${ROOT}/usr/bin/fc-cache
		eend 0
	fi
}
