# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kadu/kadu-0.3.3_rc3.ebuild,v 1.2 2003/07/13 12:44:50 aliz Exp $

MY_PV=${PV/_/-}
DESCRIPTION="KDE version of popular in Poland Gadu-Gadu IM network"
HOMEPAGE="http://kadu.net/"
SRC_URI="http://kadu.net/releases/${PN}-${MY_PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86"

IUSE="kde"

DEPEND=">=x11-libs/qt-3.0.1
	kde? ( kde-base/arts )"

S=${WORKDIR}/kadu

src_compile() {

	econf
	emake || die
}

src_install() {
	make \
		DESTDIR=${D} \
		install || die
}
