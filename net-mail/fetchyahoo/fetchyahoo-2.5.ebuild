# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/fetchyahoo/fetchyahoo-2.5.ebuild,v 1.3 2004/06/24 23:22:31 agriffis Exp $

S=${WORKDIR}/${P}
IUSE=""
DESCRIPTION="Perl script that downloads mail from a Yahoo! webmail account to a local mail spool, an mbox file, or to procmail."
SRC_URI="http://fetchyahoo.twizzler.org/${P}.tar.gz"
HOMEPAGE="http://fetchyahoo.twizzler.org/"
LICENSE="LGPL-2.1"
KEYWORDS="x86"

SLOT="0"

DEPEND="dev-lang/perl
		dev-perl/libwww-perl
		dev-perl/HTML-Parser
		dev-perl/MIME-tools
		dev-perl/libnet
		dev-perl/Crypt-SSLeay
		dev-perl/URI
		dev-perl/MailTools
		dev-perl/IO-stringy
		dev-perl/MIME-Base64"

RDEPEND=""

src_install() {
	dobin fetchyahoo.pl
	doman fetchyahoo.1
	insinto /etc
	doins fetchyahoorc
	dodoc COPYING ChangeLog TODO Credits
	dohtml index.html
}

pkg_postinst() {
	einfo "Edit /etc/fetchyahoorc to configure fetchyahoo"
}
