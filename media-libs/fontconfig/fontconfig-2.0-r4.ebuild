# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fontconfig/fontconfig-2.0-r4.ebuild,v 1.3 2002/11/30 23:23:42 azarah Exp $

inherit debug eutils

S="${WORKDIR}/fcpackage.${PV/\./_}/fontconfig"
DESCRIPTION="A library for configuring and customizing font access."
SRC_URI="http://fontconfig.org/release/fcpackage.${PV/\./_}.tar.gz"
HOMEPAGE="http://fontconfig.org/"

LICENSE="fontconfig"
SLOT="1.0"
KEYWORDS="x86 alpha ppc sparc sparc64"

DEPEND=">=media-libs/freetype-2.0.9
	>=dev-libs/expat-1.95.3
	>=sys-apps/ed-0.2"


pkg_setup() {
	# Do not use 'cc' to compile
	[ ! -n "${CC}" ] && export CC="gcc" || :
}

src_unpack() {
	unpack ${A}

	cd ${S}
	local PPREFIX="${FILESDIR}/patch/${PN}"
	#einfo "Applying patches..."
	# Some patches from Redhat
	epatch ${PPREFIX}-2.0-defaultconfig.patch
	epatch ${PPREFIX}-0.0.1.020811.1151-slighthint.patch
	# Blacklist certain fonts that freetype can't handle
	epatch ${PPREFIX}-0.0.1.020826.1330-blacklist.patch
	# Patch from Keith Packard to fix problem where 
	# subdirectories could get lost from ~/.fonts.cache
	epatch ${PPREFIX}-2.0-subdir.patch
	# Fix problem with italic fonts if no map file present
#	epatch ${PPREFIX}-2.0-font-matrix.patch
	# Fix config script to alway include X11 fontpath and remove date
	epatch ${PPREFIX}-2.0-x11fontpath-date-configure.patch 
}

src_compile() {
	econf \
		--x-includes=/usr/X11R6/include \
		--x-libraries=/usr/X11R6/lib || die
	
	emake || die
}

src_install() {
	einstall confdir=${D}/etc/fonts \
		datadir=${D}/usr/share || die

	insinto /etc/fonts
	doins ${S}/fonts.conf

	cd ${S}
	
	mv fc-cache/fc-cache.man fc-cache/fc-cache.1
	mv fc-list/fc-list.man fc-list/fc-list.1
	mv src/fontconfig.man src/fontconfig.3
	for x in fc-cache/fc-cache.1 fc-list/fc-list.1 src/fontconfig.3
	do
		doman ${x}
	done

	dodoc AUTHORS COPYING ChangeLog NEWS README
}

pkg_postinst() {
	if [ "${ROOT}" = "/" ]
	then
		einfo "Creating font cache..."
		HOME="/root" /usr/bin/fc-cache -f
	fi
}

