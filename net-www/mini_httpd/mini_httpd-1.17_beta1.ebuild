# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mini_httpd/mini_httpd-1.17_beta1.ebuild,v 1.3 2004/06/25 00:59:04 agriffis Exp $

MY_P=${P/_beta/beta}
DESCRIPTION="Small forking webserver with optional ssl and ipv6 support"
HOMEPAGE="http://www.acme.com/software/mini_httpd/"
SRC_URI="http://www.acme.com/software/mini_httpd/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
IUSE="ssl ipv6"

DEPEND="virtual/glibc
	ssl? ( dev-libs/openssl )"

S=${WORKDIR}/${MY_P}

src_compile() {
	## we need to hack a bit to have the correct install-dir -- no autoconf :(
	mv Makefile Makefile.org
	cat Makefile.org | sed -e "s@/usr/local/sbin@${D}/usr/sbin@; \
		s@/usr/local/man@${D}/usr/share/man@; \
		s@-mkdir -p \${BINDIR}@& \${MANDIR}/man8 \${MANDIR}/man1@" > \
		Makefile || die "error rewriting Makefile"
	rm -f Makefile.org

	## for ssl-support we need another Makefile-patch:
	if [ "$(use ssl)" ]; then
		mv Makefile Makefile.org
		cat Makefile.org | sed -e "s@^#\(SSL_TREE.*=\)\(.*$\)@\1 /usr@; \
			s@^#\(SSL_DEFS.*$\)@\1@; \
			s@^#\(SSL_INC.*$\)@\1@; \
			s@^#\(SSL_LIBS.*$\)@\1@" > \
			Makefile || die "error rewriting Makefile"
		rm -f Makefile.org
	fi

	## ipv6-support: normally this is auto-detected at compile time ... so we
	## need to force a bit ;)
	if [ ! "$(use ipv6)" ]; then
		mv mini_httpd.c mini_httpd.c.org
		cat mini_httpd.c.org | sed -e 's@#define USE_IPV6@#undef USE_IPV6@' > \
			mini_httpd.c || die "error rewriting mini_httpd.c"
		rm -f mini_httpd.c.org
	fi
	emake || die
}

src_install() {
	make install || die
	mv ${D}/usr/sbin/{,mini_}htpasswd
	mv ${D}/usr/share/man/man1/{,mini_}htpasswd.1

	exeinto /etc/init.d
	newexe ${FILESDIR}/mini_httpd.init mini_httpd
	insinto /etc/conf.d
	newins ${FILESDIR}/mini_httpd.confd mini_httpd
	dodoc README ${FILESDIR}/mini_httpd.conf.sample
}

pkg_postinst() {
	ewarn "Adjust MINI_HTTPD_DOCROOT in /etc/conf.d/mini_httpd !"
}
