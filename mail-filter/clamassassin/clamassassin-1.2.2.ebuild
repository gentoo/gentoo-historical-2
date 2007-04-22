# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/clamassassin/clamassassin-1.2.2.ebuild,v 1.7 2007/04/22 09:27:16 ticho Exp $

DESCRIPTION="clamassassin is a simple script for virus scanning (through clamav) an e-mail message as a
filter (like spamassassin)"
HOMEPAGE="http://jameslick.com/clamassassin/"
SRC_URI="http://jameslick.com/clamassassin/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ~sparc"
IUSE="subject-rewrite clamd"
DEPEND=">=app-antivirus/clamav-0.75.1
		sys-apps/debianutils
		sys-apps/which
		mail-filter/procmail"

src_compile() {
	econf \
		$(use_enable subject-rewrite) \
		$(use_enable clamd clamdscan) \
		|| die
	# Fix problems with Portage exporting TMP and breaking clamassassin. #61806
	sed -i -e "s:${TMP}:/tmp:" clamassassin
}

src_install() {
	dobin clamassassin
	dodoc CHANGELOG LICENSE README
}
