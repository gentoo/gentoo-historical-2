# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/clamassassin/clamassassin-1.2.0-r1.ebuild,v 1.4 2004/10/16 00:30:06 ticho Exp $

DESCRIPTION="clamassassin is a simple script for virus scanning (through clamav) an e-mail message as a
filter (like spamassassin)"
HOMEPAGE="http://drivel.com/clamassassin/"
SRC_URI="http://drivel.com/clamassassin/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc"
IUSE="subject-rewrite"
DEPEND=">=app-antivirus/clamav-0.71
		sys-apps/debianutils
		sys-apps/which
		mail-filter/procmail"

src_compile() {
	econf $(use_enable subject-rewrite) || die
	# Fix problems with Portage exporting TMP and breaking clamassassin. #61806
	sed -i -e "s:${TMP}:/tmp:" clamassassin
}

src_install() {
	dobin clamassassin
	dodoc CHANGELOG LICENSE README
}
