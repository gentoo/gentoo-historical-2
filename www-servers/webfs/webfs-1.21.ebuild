# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/webfs/webfs-1.21.ebuild,v 1.3 2007/03/01 07:38:09 bangert Exp $

DESCRIPTION="Lightweight HTTP server for static content"
SRC_URI="http://dl.bytesex.org/releases/${PN}/${P}.tar.gz"
HOMEPAGE="http://linux.bytesex.org/misc/webfs.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~alpha ~ppc ~amd64"
IUSE="ssl threads"

DEPEND="ssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}
	app-misc/mime-types"

src_compile() {
	local myconf
	use ssl || myconf="${myconf} USE_SSL=no"
	use threads && myconf="${myconf} USE_THREADS=yes"

	emake prefix=/usr ${myconf} || die "emake failed"
}

src_install() {
	local myconf
	use ssl || myconf="${myconf} USE_SSL=no"
	use threads && myconf="${myconf} USE_THREADS=yes"
	einstall ${myconf} mandir=${D}/usr/share/man || die "make install failed"
	newinitd ${FILESDIR}/${PN}.initd ${PN} || die "newinitd failed"
	newconfd ${FILESDIR}/${PN}.confd ${PN} || die "newconfd failed"
	dodoc README COPYING
}
