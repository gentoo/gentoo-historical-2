# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvsd/cvsd-1.0.7.ebuild,v 1.5 2005/08/10 23:39:47 ka0ttic Exp $

inherit eutils

DESCRIPTION="CVS pserver daemon."
HOMEPAGE="http://ch.tudelft.nl/~arthur/cvsd/"
SRC_URI="http://ch.tudelft.nl/~arthur/cvsd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE="tcpd"

DEPEND="virtual/libc
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"
RDEPEND="${DEPEND}
	>=dev-lang/perl-5.8.0
	>=dev-util/cvs-1.11.6"

pkg_setup() {
	enewgroup cvsd
	enewuser cvsd -1 /bin/false /var/lib/cvsd cvsd
}

src_compile() {
	econf $(use_with tcpd libwrap) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dosed 's:^Repos:# Repos:g' /etc/cvsd/cvsd.conf
	keepdir /var/lib/cvsd

	dodoc AUTHORS COPYING ChangeLog FAQ INSTALL NEWS README TODO

	newinitd ${FILESDIR}/cvsd.rc6 ${PN}
}

pkg_postinst() {
	einfo "To configure cvsd please read /usr/share/doc/${PF}/README.gz"
}
