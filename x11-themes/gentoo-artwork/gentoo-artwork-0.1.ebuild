# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gentoo-artwork/gentoo-artwork-0.1.ebuild,v 1.8 2004/06/24 23:27:15 agriffis Exp $

DESCRIPTION="A collection of miscellaneous Gentoo Linux logos and artwork"
SRC_URI="mirror://gentoo/gentoo-artwork-${PV}.tar.bz2"
HOMEPAGE="http://www.gentoo.org/index-graphics.html"

KEYWORDS="~x86 ppc ~sparc"
LICENSE="GPL-2"
SLOT="0"
IUSE="kde"

DEPEND=""
RDEPEND="kde? ( >=x11-libs/qt-3.0.5
	   >=kde-base/kdebase-3.0.2 )"

src_install() {
	# pixmaps
	dodir /usr/share/pixmaps/gentoo/{800x600,1024x768,1280x1024}

	for DIR in ${S}/pixmaps/{800x600,1024x768,1280x1024}; do
		insinto /usr/share/pixmaps/gentoo/$(basename $DIR);
		doins $DIR/*.png;
		doins $DIR/*.jpg;
	done

	# console splash images - to come
#	dodir /usr/share/pixmaps/gentoo/{800x600,1024x768,1280x1024}
#
#	for DIR in ${S}/pixmaps/{800x600,1024x768,1280x1024}; do
#		insinto /usr/share/pixmaps/gentoo/$(basename $DIR);
#		doins $DIR/*.png;
#		doins $DIR/*.jpg;
#	done
#
	if use kde ; then
		insinto ${KDEDIR}/share/apps/kdisplay/color-schemes
		doins ${S}/misc/Gentoo.kcsrc

		dodir ${KDEDIR}/share/icons/gentoo
		cp -pR ${S}/icons/gentoo/* ${D}/${KDEDIR}/share/icons/gentoo/
	fi

	# grub splash images:
	dodir /usr/share/grub/splashimages

	insinto /usr/share/grub/splashimages
	doins ${S}/grub/*.xpm.gz

#	dodir /usr/share/${P}
}
