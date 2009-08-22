# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/mimedefang/mimedefang-2.67.ebuild,v 1.1 2009/08/22 23:45:11 mrness Exp $

inherit eutils

DESCRIPTION="Antispam, antivirus and other customizable filtering for MTAs with Milter support"
HOMEPAGE="http://www.mimedefang.org/"
SRC_URI="http://www.mimedefang.org/static/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clamav poll"

DEPEND="dev-perl/MIME-tools
	virtual/perl-MIME-Base64
	dev-perl/Digest-SHA1
	clamav? ( app-antivirus/clamav )
	!<mail-mta/postfix-2.4
	|| ( mail-filter/libmilter mail-mta/sendmail )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup defang
	enewuser defang -1 -1 -1 defang
}

src_compile() {
	econf $(use_enable poll) \
		$(use_enable clamav) $(use_enable clamav clamd) || die "econf failed"
	emake unstripped || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	fowners defang:defang /etc/mail/mimedefang-filter
	fperms 644 /etc/mail/mimedefang-filter
	insinto /etc/mail/
	insopts -m 644
	newins "${S}"/SpamAssassin/spamassassin.cf sa-mimedefang.cf

	keepdir /var/spool/{MD-Quarantine,MIMEDefang}
	fowners defang:defang /var/spool/{MD-Quarantine,MIMEDefang}
	fperms 700 /var/spool/{MD-Quarantine,MIMEDefang}

	dodir /var/log/mimedefang
	keepdir /var/log/mimedefang

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	docinto examples
	dodoc examples/*
}
