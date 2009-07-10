# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/monit/monit-4.8.1.ebuild,v 1.6 2009/07/10 20:40:19 gengor Exp $

DESCRIPTION="a utility for monitoring and managing daemons or similar programs running on a Unix system."
HOMEPAGE="http://mmonit.com/monit/"
SRC_URI="http://mmonit.com/monit/dist/old/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="ssl"

RDEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/^INSTALL_PROG/s/-s//' Makefile.in || die "sed failed in Makefile.in"
}

src_compile() {
	econf $(use_with ssl) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc CHANGES.txt CONTRIBUTORS FAQ.txt README* STATUS UPGRADE.txt
	dohtml -r doc/*

	insinto /etc; insopts -m700; doins monitrc || die "doins monitrc failed"
	newinitd "${FILESDIR}"/monit.initd-${PV} monit || die "newinitd failed"
}

pkg_postinst() {
	elog "Sample configurations are available at:"
	elog "http://mmonit.com/monit/documentation/"
}
