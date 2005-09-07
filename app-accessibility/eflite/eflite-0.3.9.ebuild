# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/eflite/eflite-0.3.9.ebuild,v 1.1 2005/09/07 05:10:14 williamh Exp $

IUSE=""

inherit eutils

DESCRIPTION="A speech server for emacspeek and other screen readers that allows them to interact with festival lite."
HOMEPAGE="http://eflite.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"

RDEPEND=">=app-accessibility/flite-1.2"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:/etc/es.conf:/etc/eflite/es.conf:g' *
	econf || die "configuration failed"
}

src_compile() {
	emake || die "compile failed"
}

src_install() {
	einstall || die
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
