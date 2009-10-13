# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/pconsole/pconsole-1.0-r2.ebuild,v 1.3 2009/10/13 18:46:17 haubi Exp $

inherit autotools eutils

DESCRIPTION="Tool for managing multiple xterms simultaneously."
HOMEPAGE="http://www.heiho.net/pconsole/"
SRC_URI="http://www.xs4all.nl/~walterj/pconsole/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="virtual/ssh"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch ${FILESDIR}/${P}-exit-warn.patch || einfo "Never mind.."
	sed -i \
		-e "s:\(CCOPTS=\).*:\1'${CFLAGS}':g" \
		"${S}"/configure.in
	eautoreconf
}

src_install() {
	einstall bindir="${D}/usr/bin" || die "install failed"
	fperms 4111 /usr/bin/pconsole
	dodoc ChangeLog public_html/pconsole.html README.pconsole
}

pkg_postinst() {
	ewarn
	ewarn "Warning:"
	ewarn "pconsole installed with suid root!"
	ewarn
}
