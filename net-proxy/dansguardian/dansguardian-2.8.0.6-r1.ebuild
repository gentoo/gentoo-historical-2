# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/dansguardian/dansguardian-2.8.0.6-r1.ebuild,v 1.1 2005/12/08 22:15:11 mrness Exp $

inherit eutils

DESCRIPTION="Web content filtering via proxy"
HOMEPAGE="http://dansguardian.org"
SRC_URI="http://mirror.dansguardian.org/downloads/2/Stable/${P}.source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="!net-proxy/dansguardian-dgav
	virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/dansguardian-xnaughty-2.7.6-1.diff
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	./configure \
		--prefix= \
		--installprefix="${D}" \
		--mandir=/usr/share/man/ \
		--cgidir=/var/www/localhost/cgi-bin/ \
		--logrotatedir="${D}/etc/logrotate.d" || die "./configure failed"
	emake OPTIMISE="${CFLAGS}" || die "emake failed"
}

src_install() {
	make install || die "make install failed"

	newinitd ${FILESDIR}/dansguardian.init dansguardian

	insinto /etc/logrotate.d
	newins ${FILESDIR}/${PN}.logrotate ${PN}

	doman dansguardian.8
	dodoc README
}
