# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/popfile/popfile-0.22.5.ebuild,v 1.3 2007/12/09 06:51:16 drac Exp $

DESCRIPTION="Anti-spam bayesian filter"
HOMEPAGE="http://popfile.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk ipv6 mysql ssl xmlrpc"

RDEPEND="virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	dev-perl/DBD-SQLite2
	dev-perl/HTML-Tagset
	dev-perl/HTML-Template
	dev-perl/TimeDate
	cjk? ( dev-perl/Encode-compat
		dev-perl/Text-Kakasi )
	mysql? ( dev-perl/DBD-mysql	)
	ipv6? (	dev-perl/IO-Socket-INET6 )
	ssl? ( dev-libs/openssl
		!=dev-perl/IO-Socket-SSL-0.97
	    dev-perl/Net-SSLeay	)
	xmlrpc? ( dev-perl/PlRPC )"
DEPEND="app-arch/unzip"

src_install() {
	dodoc *.change
	dohtml -r manual/*
	rm -rf manual *.change license
	insinto /usr/share/${PN}
	doins -r *
	fperms 755 /usr/share/${PN}/*.pl
	dosbin "${FILESDIR}"/${PN}
}
