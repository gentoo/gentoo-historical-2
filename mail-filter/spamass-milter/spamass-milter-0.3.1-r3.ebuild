# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/spamass-milter/spamass-milter-0.3.1-r3.ebuild,v 1.1 2009/08/23 00:11:45 mrness Exp $

inherit eutils

IUSE=""

DESCRIPTION="A milter for SpamAssassin"
HOMEPAGE="http://savannah.nongnu.org/projects/spamass-milt/"
SRC_URI="http://savannah.nongnu.org/download/spamass-milt/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )
	>=mail-filter/spamassassin-3.1.0"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 /var/lib/milter milter
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	newinitd "${FILESDIR}"/spamass-milter.rc3 spamass-milter
	newconfd "${FILESDIR}"/spamass-milter.conf3 spamass-milter
	dodir /var/run/milter
	keepdir /var/run/milter
	fowners milter:milter /var/run/milter
	dodir /var/lib/milter
	keepdir /var/lib/milter
	fowners milter:milter /var/lib/milter

	dodoc AUTHORS NEWS README ChangeLog "${FILESDIR}/README.gentoo"
}

pkg_postinst() {
	elog
	elog "Documentation is in /usr/share/doc/${P}"
	elog "Check README.gentoo.gz there for some basic gentoo installation instructions"
	elog
}
