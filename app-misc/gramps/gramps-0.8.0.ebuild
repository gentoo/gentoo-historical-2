# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gramps/gramps-0.8.0.ebuild,v 1.6 2002/11/30 20:37:20 vapier Exp $

DESCRIPTION="Genealogical Research and Analysis Management Programming System"
SRC_URI="mirror://sourceforge/gramps/${P}.tar.gz"
HOMEPAGE="http://gramps.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=dev-lang/python-2.0
	<=gnome-base/gnome-panel-1.5
	dev-python/gnome-python
	dev-python/PyXML
	dev-python/Imaging
	dev-python/ReportLab"

src_unpack() {
	unpack ${P}.tar.gz
	# Apply patch to avoid scrollkeeper update at install time
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff || die
}

src_compile() {
	export WANT_AUTOMAKE_1_6=1
	aclocal || die
	automake --gnu || die
	autoconf || die
	econf
	emake || die
}

src_install() {
	einstall
	dodoc COPYING NEWS README TODO
}

pkg_postinst() {
	scrollkeeper-rebuilddb -p ${D}/var/lib/scrollkeeper
}
