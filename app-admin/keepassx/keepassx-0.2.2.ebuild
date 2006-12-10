# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/keepassx/keepassx-0.2.2.ebuild,v 1.3 2006/12/10 19:58:27 welp Exp $

inherit eutils

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="http://keepassx.sourceforge.net/"
SRC_URI="mirror://sourceforge/keepassx/KeePassX-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=x11-libs/qt-4.1"
RDEPEND="${DEPEND}"

src_compile() {
	/usr/bin/qmake || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	dobin bin/keepass
	insinto /usr/share/
	doins -r share/*
	domenu "${FILESDIR}/keepassx.desktop"
}