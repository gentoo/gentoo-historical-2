# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/eflite/eflite-0.3.8-r2.ebuild,v 1.10 2004/10/05 10:33:48 pvdabeel Exp $

IUSE=""

inherit eutils

DESCRIPTION="A speech server for emacspeek and other screen readers that allows them to interact with festival lite."
HOMEPAGE="http://eflite.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ppc amd64 sparc"

RDEPEND=">=app-accessibility/flite-1.2"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.58
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-shared_flite.patch
	epatch ${FILESDIR}/${P}-daemon.patch
	epatch ${FILESDIR}/${P}-read_pipe.patch

	sed -i 's:/etc/es.conf:/etc/eflite/es.conf:g' *

	WANT_AUTOCONF=2.5 autoconf
}

src_install() {
	dobin eflite || die
	dodoc ChangeLog README INSTALL eflite_test.txt

	insinto /etc/eflite
	doins ${FILESDIR}/es.conf

	exeinto /etc/init.d
	newexe ${FILESDIR}/eflite.rc eflite
}

pkg_postinst() {
	enewgroup speech
	einfo "To test eflite, you can run:"
	einfo "gzcat /usr/share/doc/${PF}/eflite_test.txt.gz | eflite"
}
