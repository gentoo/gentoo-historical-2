# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/monkeyd/monkeyd-0.8.4.ebuild,v 1.4 2004/07/08 03:14:58 weeve Exp $

WEBROOT=/var/www/localhost

MY_P="${PN/d}-${PV}-2"
DESCRIPTION="fast, efficient, (REALLY) small, and easy to configure web server"
HOMEPAGE="http://monkeyd.sourceforge.net/"
SRC_URI="http://monkeyd.sourceforge.net/versions/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="php"

DEPEND="virtual/libc"
RDEPEND="virtual/libc
	php? ( dev-php/php-cgi )"

S=${WORKDIR}/${MY_P}

src_compile() {
	# monkey has it's own funky script ... cant use econf
	./configure \
		--prefix=/usr \
		--bindir=/usr/bin \
		--cgibin=${WEBROOT}/cgi-bin \
		--sysconfdir=/etc/${PN} \
		--datadir=${WEBROOT}/htdocs \
		--logdir=/var/log/${PN} \
		--lang=en \
		|| die
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	make \
		PREFIX=${D}/usr \
		BINDIR=${D}/usr/bin \
		CGIBIN=${D}${WEBROOT}/cgi-bin \
		SYSCONFDIR=${D}/etc/${PN} \
		DATADIR=${D}${WEBROOT}/htdocs \
		LOGDIR=${D}/var/log/${PN} \
		install \
		|| die
	if use php ; then
		dosed '/^#AddScript application\/x-httpd-php/s:^#::' /etc/monkeyd/monkey.conf
		dosed 's:/home/my_home/php/bin/php:/usr/bin/php-cgi:' /etc/monkeyd/monkey.conf
	fi
	[ -e ${ROOT}/${WEBROOT}/htdocs/index.html ] && mv ${D}${WEBROOT}/htdocs/{index,index-monkey}.html
	dosed "s:/var/log/monkeyd/monkey.pid:/var/run/monkey.pid:" /etc/monkeyd/monkey.conf
	exeinto /etc/init.d ; newexe ${FILESDIR}/monkeyd.init.d monkeyd
	insinto /etc/conf.d ; newins ${FILESDIR}/monkeyd.conf.d monkeyd
	dodoc MODULES HowItWorks.txt README ChangeLog
}
