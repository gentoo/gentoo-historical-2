# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ftpd/ftpd-0.17-r4.ebuild,v 1.5 2006/10/14 16:58:26 agriffis Exp $

inherit eutils ssl-cert

DESCRIPTION="The netkit FTP server with optional SSL support"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/linux-${P}.tar.gz
	mirror://gentoo/linux-${P}-ssl.patch"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ~sparc x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}
	virtual/inetd"

S=${WORKDIR}/linux-${P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	use ssl && epatch "${DISTDIR}/linux-${P}-ssl.patch"
	epatch "${FILESDIR}/${P}-shadowfix.patch"

	# fixes gcc 4.1 compatibility
	epatch "${FILESDIR}/${P}-gcc41.patch"

	# setguid fix
	epatch "${FILESDIR}"/${P}-setguid.patch
}

src_compile() {
	./configure --prefix=/usr || die "configure failed"
	cp MCONFIG MCONFIG.orig
	sed -e "s:-pipe -O2:${CFLAGS}:" MCONFIG.orig > MCONFIG
	emake || die "parallel make failed"
}

src_install() {
	dobin ftpd/ftpd
	doman ftpd/ftpd.8
	dodoc README ChangeLog
	insinto /etc/xinetd.d
	newins "${FILESDIR}/ftp.xinetd" ftp
	if use ssl; then
		insinto /etc/ssl/certs/
		docert ftpd
	fi
}

pkg_postinst() {
	if use ssl; then
		einfo "In order to start the server with SSL support"
		einfo "You need a certificate /etc/ssl/certs/ftpd.pem."
		einfo "A temporary certificiate has been created."
	fi
}
