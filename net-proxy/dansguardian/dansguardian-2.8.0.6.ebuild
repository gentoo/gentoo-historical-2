# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/dansguardian/dansguardian-2.8.0.6.ebuild,v 1.3 2005/10/06 19:04:31 hansmi Exp $

inherit eutils

DESCRIPTION="Web content filtering via proxy"
HOMEPAGE="http://dansguardian.org"
SRC_URI="http://mirror.dansguardian.org/downloads/2/Stable/${P}.source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~ppc64 ~sparc x86"
IUSE=""
DEPEND="!net-proxy/dansguardian-dgav
	virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/dansguardian-xnaughty-2.7.6-1.diff
}

src_compile() {
	./configure \
		--prefix= \
		--installprefix=${D} \
		--mandir=/usr/share/man/ \
		--cgidir=/var/www/localhost/cgi-bin/ || die "./configure failed"
	emake OPTIMISE="${CFLAGS}" || die "emake failed"
}

src_install() {
	if [ -d "/etc/logrotate.d" ]; then
		dodir /etc/logrotate.d
	fi
	make install || die "make install failed"

	exeinto /etc/init.d
	newexe ${FILESDIR}/dansguardian.init dansguardian

	rm -rf ${D}/etc/rc.d

	#Fixing location of initscript
	sed -i -e 's/rc.d\///' ${D}/etc/dansguardian/logrotation

	dodoc README
}
