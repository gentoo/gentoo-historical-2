# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/smartmontools/smartmontools-5.33.ebuild,v 1.11 2005/08/24 02:48:29 vapier Exp $

inherit flag-o-matic

DESCRIPTION="control and monitor storage systems using the Self-Monitoring, Analysis and Reporting Technology System (S.M.A.R.T.)"
HOMEPAGE="http://smartmontools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="static"

RDEPEND=""
DEPEND=">=sys-apps/portage-2.0.51"

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

	insinto /etc
	doins smartd.conf

	dodir /etc/init.d /etc/conf.d
	newinitd ${FILESDIR}/smartd.rc smartd
	newconfd ${FILESDIR}/smartd.confd smartd
}
