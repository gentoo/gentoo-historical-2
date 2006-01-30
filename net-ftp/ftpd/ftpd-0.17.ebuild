# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ftpd/ftpd-0.17.ebuild,v 1.13 2006/01/30 19:03:56 blubb Exp $

inherit eutils

IUSE="ssl"

S=${WORKDIR}/linux-${P}
DESCRIPTION="The netkit FTP server with optional SSL support"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/linux-${P}.tar.gz
		ssl? ( mirror://gentoo/${P}-ssl.diff.gz )"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~sparc amd64"

DEPEND="ssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}
	virtual/inetd"

src_unpack() {
	unpack ${A}
	cd ${S}
	if use ssl; then
		epatch ${WORKDIR}/${P}-ssl.diff
	fi
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
	newins ${FILESDIR}/ftp.xinetd ftp
}

pkg_postinst() {
	einfo "In order to start the server with SSL support"
	einfo "You need to create a certificate and place it"
	einfo "in SSLCERTDIR..."
	einfo "<=openssl-0.9.6g - SSLCERTDIR=/usr/lib/ssl/certs"
	einfo ">=openssl-0.9.6g-r1 - SSLCERTDIR=/etc/ssl/certs"
	einfo ""
	einfo "cd SSLCERTDIR"
	einfo "openssl req -new -x509 -nodes -out ftpd.pem -keyout ftpd.pem"
	einfo ""
}
