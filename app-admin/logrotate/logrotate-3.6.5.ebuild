# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/logrotate/logrotate-3.6.5.ebuild,v 1.10 2003/09/23 20:20:55 aliz Exp $

inherit eutils

DESCRIPTION="Rotates, compresses, and mails system logs"
HOMEPAGE="http://packages.debian.org/unstable/admin/logrotate.html"
SRC_URI="mirror://debian/pool/main/l/logrotate/${P/-/_}.orig.tar.gz
	selinux? http://www.nsa.gov/selinux/patches/${P}-2003011510.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~alpha"
IUSE="selinux"

DEPEND=">=sys-apps/portage-2.0.47-r10
	>=dev-libs/popt-1.5
	selinux? ( >=sys-apps/selinux-small-2003011510-r2 )"

src_compile() {
	use selinux && epatch ${DISTDIR}/${P}-2003011510.patch.gz

	sed -i -e "s:CFLAGS += -g:CFLAGS += -g ${CFLAGS}:" Makefile
	make || die
}

src_install() {
	insinto /usr
	dosbin logrotate
	doman logrotate.8
	dodoc examples/logrotate*
}

pkg_postinst() {
	einfo "If you wish to have logrotate e-mail you updates, please"
	einfo "emerge net-mail/mailx"
}
