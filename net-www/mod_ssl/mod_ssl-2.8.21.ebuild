# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_ssl/mod_ssl-2.8.21.ebuild,v 1.5 2004/10/29 17:23:12 blubb Exp $

MY_P=${P}-1.3.32
S=${WORKDIR}/${MY_P}
DESCRIPTION="An SSL module for the Apache Web server"
SRC_URI="http://www.modssl.org/source/${MY_P}.tar.gz"
HOMEPAGE="http://www.modssl.org/"

KEYWORDS="x86 ppc sparc ~alpha ~hppa ~mips ~amd64"
LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND="|| ( =net-www/apache-1.3.32* =net-www/apache-1.3.33* )
	>=dev-libs/openssl-0.9.6k"

src_unpack() {
	unpack ${A} ; cd ${S}
	# proper path to openssl
	cp pkg.contrib/cca.sh pkg.contrib/cca.sh.orig
	sed -e 's%^\(openssl=\).*%\1"/usr/bin/openssl"%' \
		pkg.contrib/cca.sh.orig > pkg.contrib/cca.sh
}

src_compile() {
	myconf=""

	if has_version '=sys-libs/gdbm-1.8.3*' ; then
	     myconf="--enable-rule=SSL_SDBM"
	fi

	if has_version '=net-www/apache-1.3.33' ; then
		myconf="${myconf} --force"
	fi

	SSL_BASE=SYSTEM \
	./configure \
		--with-apxs=/usr/sbin/apxs ${myconf} || die "bad ./configure"
	make || die "compile problem"
}

src_install() {
	exeinto /usr/lib/apache-extramodules
	doexe pkg.sslmod/libssl.so

	exeinto /usr/lib/ssl/mod_ssl
	doexe pkg.contrib/*.sh ${FILESDIR}/gentestcrt.sh

	dodoc ANNOUNCE CHANGES CREDITS LICENSE NEWS README*
	dodir /usr/share/doc/${PF}/html
	cp -a pkg.ssldoc/* ${D}/usr/share/doc/${PF}/html

	insinto /etc/apache/conf/vhosts
	doins ${FILESDIR}/ssl.default-vhost.conf

	insinto /etc/apache/conf/addon-modules
	doins ${FILESDIR}/mod_ssl.conf
}

pkg_postinst() {
	install -d -o root -g root -m0755 ${ROOT}/etc/apache/conf/ssl

	einfo
	einfo "Execute \"ebuild /var/db/pkg/net-www/${PF}/${PF}.ebuild config\""
	einfo "to have your apache.conf auto-updated for use with this module."
	einfo "You should then edit your /etc/conf.d/apache file to suit."
	einfo

	cd ${ROOT}/etc/apache/conf/ssl
	einfo "Generating self-signed test certificate in /etc/apache/conf/ssl..."
	einfo "(Ignore any message from the yes command below)"
	yes "" | ${ROOT}/usr/lib/ssl/mod_ssl/gentestcrt.sh >/dev/null 2>&1
	einfo
}

pkg_config() {
	${ROOT}/usr/sbin/apacheaddmod \
		${ROOT}/etc/apache/conf/apache.conf \
		extramodules/libssl.so mod_ssl.c ssl_module \
		define=SSL addconf=conf/addon-modules/mod_ssl.conf

	echo "Include  conf/vhosts/ssl.default-vhost.conf" \
		>> ${ROOT}/etc/apache/conf/apache.conf
}
