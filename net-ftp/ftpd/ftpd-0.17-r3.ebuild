# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ftpd/ftpd-0.17-r3.ebuild,v 1.4 2005/11/10 22:22:27 yoswink Exp $

inherit eutils ssl-cert

IUSE="ssl"

S=${WORKDIR}/linux-${P}
DESCRIPTION="The netkit FTP server with optional SSL support"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/linux-${P}.tar.gz
		mirror://gentoo/linux-${P}-ssl.patch"

SLOT="0"
LICENSE="as-is"
KEYWORDS="alpha ~amd64 ~ppc sparc x86"

DEPEND="ssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}
	virtual/inetd"

src_unpack() {
	unpack ${A}
	cd ${S}
	if use ssl; then
		epatch ${DISTDIR}/linux-${P}-ssl.patch
	fi
	epatch ${FILESDIR}/${P}-shadowfix.patch
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
	if use ssl;
	then
		insinto /etc/ssl/certs/
		docert ftpd
	fi
}

pkg_postinst() {
	if use ssl;
	then
		einfo "In order to start the server with SSL support"
		einfo "You need a certificate /etc/ssl/certs/ftpd.pem."
		einfo "A temporary certificiate has been created."
	fi
}
