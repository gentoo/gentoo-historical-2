# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pms/pms-0.94.ebuild,v 1.12 2005/07/10 19:59:09 swegener Exp $

inherit eutils

DESCRIPTION="Password Management System"
HOMEPAGE="http://passwordms.sourceforge.net/"
SRC_URI="mirror://sourceforge/passwordms/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="sys-libs/ncurses
	dev-libs/cdk"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/ui.diff
}

src_install() {
	dobin bin/{pms,pms_export,pms_import,pms_passwd} || die "dobin failed"
	dodoc AUTHORS BUGS ChangeLog NOTES README TODO CONFIGURE.problems
}
