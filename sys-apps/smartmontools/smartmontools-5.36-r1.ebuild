# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/smartmontools/smartmontools-5.36-r1.ebuild,v 1.8 2006/10/14 17:01:59 plasmaroo Exp $

inherit eutils flag-o-matic

DESCRIPTION="control and monitor storage systems using the Self-Monitoring, Analysis and Reporting Technology System (S.M.A.R.T.)"
HOMEPAGE="http://smartmontools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc ppc-macos sparc x86"
IUSE="static"

RDEPEND=""
DEPEND=">=sys-apps/portage-2.0.51"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-utf8.patch
}

src_compile() {
	use static && append-ldflags -static
	econf || die
	emake || die
}

src_install() {
	dosbin smart{ctl,d} || die "dosbin"
	doman *.[58]
	dodoc AUTHORS CHANGELOG NEWS README TODO WARNINGS
	newdoc smartd.conf smartd.conf.example
	docinto examplescripts
	dodoc examplescripts/*
	rm -f "${D}"/usr/share/doc/${PF}/examplescripts/Makefile*

	insinto /etc
	doins smartd.conf

	newinitd "${FILESDIR}"/smartd.rc smartd
	newconfd "${FILESDIR}"/smartd.confd smartd
}

pkg_postinst() {
	elog "You need the 'mail' command if you configured smartd to send reports"
	elog "via email, 'emerge virtual/mailx' to get a mailer"
}
