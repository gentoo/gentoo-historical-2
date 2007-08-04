# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/font.eclass,v 1.26 2007/08/04 06:04:07 dirtyepic Exp $

# Author: foser <foser@gentoo.org>

# Font Eclass
#
# Eclass to make font installation uniform

inherit eutils

#
# Variable declarations
#

FONT_SUFFIX=""	# Space delimited list of font suffixes to install

FONT_S="${S}" # Dir containing the fonts

FONT_PN="${PN}" # Last part of $FONTDIR

FONTDIR="/usr/share/fonts/${FONT_PN}" # This is where the fonts are installed

FONT_CONF=""  # Space delimited list of fontconfig-2.4 file(s) to install

DOCS="" # Docs to install

IUSE="X"

DEPEND="X? ( x11-apps/mkfontdir )
		media-libs/fontconfig"

#
# Public functions
#

font_xfont_config() {
	# create Xfont files
	if use X ; then
		einfo "Creating fonts.scale & fonts.dir ..."
		mkfontscale "${D}${FONTDIR}"
		mkfontdir \
			-e /usr/share/fonts/encodings \
			-e /usr/share/fonts/encodings/large \
			"${D}${FONTDIR}"
		if [ -e "${FONT_S}/fonts.alias" ] ; then
			doins "${FONT_S}/fonts.alias"
		fi
	fi
}

font_xft_config() {
	if ! has_version '>=media-libs/fontconfig-2.4'; then
		# create fontconfig cache
		einfo "Creating fontconfig cache ..."
		# Mac OS X has fc-cache at /usr/X11R6/bin
		HOME="/root" fc-cache -f "${D}${FONTDIR}"
	fi
}

font_fontconfig() {
	local conffile
	if [[ -n ${FONT_CONF} ]]; then
		if has_version '>=media-libs/fontconfig-2.4'; then
			insinto /etc/fonts/conf.avail/
			for conffile in "${FONT_CONF}"; do
				[[ -e  ${conffile} ]] && doins ${conffile}
			done
		fi
	fi
}

#
# Public inheritable functions
#

font_src_install() {
	local suffix commondoc

	cd "${FONT_S}"

	insinto "${FONTDIR}"

	for suffix in ${FONT_SUFFIX}; do
		doins *.${suffix}
	done

	rm -f fonts.{dir,scale} encodings.dir

	font_xfont_config
	font_xft_config
	font_fontconfig

	cd "${S}"
	dodoc ${DOCS} 2> /dev/null

	# install common docs
	for commondoc in COPYRIGHT README NEWS AUTHORS BUGS ChangeLog; do
		[[ -s ${commondoc} ]] && dodoc ${commondoc}
	done
}

font_pkg_setup() {
	# make sure we get no collisions
	# setup is not the nicest place, but preinst doesn't cut it
	[[ -e "${FONTDIR}/fonts.cache-1" ]] && rm -f "${FONTDIR}/fonts.cache-1"
}

font_pkg_postinst() {
	if has_version '>=media-libs/fontconfig-2.4'; then
		if [ ${ROOT} == "/" ]; then
			ebegin "Updating global fontcache"
			fc-cache -fs
			eend $?
		fi
	fi
}

font_pkg_postrm() {
	if has_version '>=media-libs/fontconfig-2.4'; then
		if [ ${ROOT} == "/" ]; then
			ebegin "Updating global fontcache"
			fc-cache -fs
			eend $?
		fi
	fi
}

EXPORT_FUNCTIONS src_install pkg_setup pkg_postinst pkg_postrm
