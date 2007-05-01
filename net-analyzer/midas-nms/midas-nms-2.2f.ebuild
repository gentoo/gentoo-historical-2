# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/midas-nms/midas-nms-2.2f.ebuild,v 1.13 2007/05/01 17:54:00 genone Exp $

inherit webapp

S="${WORKDIR}/MIDAS-${PV}"
DESCRIPTION="Monitoring, Intrusion Detection, Administration System"
SRC_URI="mirror://sourceforge/midas-nms/MIDAS-${PV}.tar.gz"
HOMEPAGE="http://midas-nms.sf.net"
LICENSE="MIT"

KEYWORDS="~ppc ~x86"

DEPEND="virtual/mysql
	virtual/libpcap
	media-libs/gd"
RDEPEND="net-www/apache
	virtual/httpd-php"

pkg_setup() {
	webapp_pkg_setup
}

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install () {
	webapp_src_preinst

#	make DESTDIR=${D} install || die

	dodir /usr/etc
	dodir /usr/bin

	cp MIDASa/MIDASa.cf.dist ${D}/usr/etc
	cp MIDASb/MIDASb.cf.dist ${D}/usr/etc
	cp MIDASc/MIDASc.cf.dist ${D}/usr/etc
	cp MIDASd/MIDASd.cf.dist ${D}/usr/etc
	cp MIDASs/MIDASs.cf.dist ${D}/usr/etc
	cp MIDASn/MIDASn.cf.dist ${D}/usr/etc
	cp MIDASa/MIDASa ${D}/usr/bin
	cp MIDASb/MIDASb ${D}/usr/bin
	cp MIDASc/MIDASc ${D}/usr/bin
	cp MIDASd/MIDASd ${D}/usr/bin
	cp MIDASs/MIDASs ${D}/usr/bin
	cp MIDASn/MIDASn ${D}/usr/bin

	dodir /usr/share/midas-nms
	dodir /usr/share/midas-nms/sql
	insinto /usr/share/midas-nms/sql
	doins sql/* /usr/share/midas-nms/sql/

	# web
	cp -r MIDAS/* ${D}${MY_HTDOCSDIR}/
	webapp_serverowned ${MY_HTDOCSDIR}
	webapp_src_install

	# Install documentation.
	dodoc COPYING
	dodoc docs/CHANGELOG
	dodoc docs/INSTALL.txt

	# Init files
	newconfd ${FILESDIR}/midas-nms.conf midas-nms
	newinitd ${FILESDIR}/midas-nms.init midas-nms
}

pkg_postinst() {
	webapp_pkg_postinst
	chown -R :apache /var/www/localhost/htdocs/midas-nms/{inc/config,php-graph}
	chmod g+w /var/www/localhost/htdocs/midas-nms/{inc/config,php-graph}
	cp ${FILESDIR}/install.php /var/www/localhost/htdocs/midas-nms/install

	elog
	elog "To install the web interface go to:"
	elog "http://localhost/midas-nms/install/install.php"
	elog
	elog "The conf files are located in /usr/etc/MIDAS*.cf.dist"
	elog "Please read INSTALL.txt for more info."
	elog
	elog "To use the sniffer and IDS you need install snort too."
	elog
}
