# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/conkeror/conkeror-0.9_pre20090724.ebuild,v 1.1 2009/08/08 17:23:23 ulm Exp $

inherit eutils fdo-mime

DESCRIPTION="A Mozilla-based web browser whose design is inspired by GNU Emacs"
HOMEPAGE="http://conkeror.org"
# snapshot from http://repo.or.cz/w/conkeror.git?a=snapshot;h=master;sf=tgz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-libs/xulrunner-1.9"

S="${WORKDIR}/${PN}"

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	insinto /usr/lib/${PN}
	doins -r branding chrome components content defaults help locale modules \
		search-engines style tests || die
	doins application.ini Info.plist || die

	exeinto /usr/lib/${PN}
	doexe conkeror-spawn-helper || die
	exeinto /usr/lib/${PN}/contrib
	doexe contrib/run-conkeror || die
	dosym /usr/lib/${PN}/contrib/run-conkeror /usr/bin/conkeror || die
	domenu "${FILESDIR}/conkeror.desktop" || die

	doman contrib/man/conkeror.1 || die
	dodoc CREDITS || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
