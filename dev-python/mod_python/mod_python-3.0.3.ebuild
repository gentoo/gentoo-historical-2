# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mod_python/mod_python-3.0.3.ebuild,v 1.4 2003/12/13 03:04:17 kloeri Exp $


DESCRIPTION="An Apache2 DSO providing an embedded Python interpreter"
HOMEPAGE="http://www.modpython.org/"
SRC_URI="http://www.apache.org/dist/httpd/modpython/${P}.tgz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lang/python >=net-www/apache-2.0"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	epatch ${FILESDIR}/${P}-dest1.diff
	epatch ${FILESDIR}/${P}-dest2.diff

	# Fix compilation when using Python-2.3
	has_version ">=dev-lang/python-2.3" && \
		sed -i -e 's:LONG_LONG:PY_LONG_LONG:g' \
		"${S}/src/requestobject.c"
}

src_compile() {
	./configure --with-apxs=/usr/sbin/apxs2 || die
	make OPT="`apxs2 -q CFLAGS` -fPIC" || die
}

src_install() {
	dodir /usr/lib/{apache2,apache2-extramodules}
	make install DESTDIR=${D} || die
	mv ${D}/usr/lib/apache2/${PN}.so ${D}/usr/lib/apache2-extramodules
	rm -rf ${D}/usr/lib/apache2
	insinto /etc/apache2/conf/modules.d
	doins ${FILESDIR}/16_mod_python.conf
	dodoc ${FILESDIR}/16_mod_python.conf README NEWS CREDITS COPYRIGHT
	dohtml doc-html/*
	insinto /usr/share/doc/${P}/html/icons
	doins doc-html/icons/*
}

pkg_postinst() {
	einfo "To have Apache run python programs, please do the following:"
	einfo "Edit /etc/conf.d/apache2 (/etc/conf.d/apache if you're using"
	einfo "apache 1.x) and add \"-D PYTHON\""
	einfo "That will setup Apache to load python when it starts."
	einfo
	einfo "If you're new to mod_python there's a manual and tutorial"
	einfo "installed in /usr/share/doc/${P}/html/index.html."
}

