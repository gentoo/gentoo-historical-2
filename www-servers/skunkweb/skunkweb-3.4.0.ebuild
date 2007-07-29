# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/skunkweb/skunkweb-3.4.0.ebuild,v 1.9 2007/07/29 17:45:36 phreak Exp $

inherit eutils

DESCRIPTION="robust Python web application server"
HOMEPAGE="http://skunkweb.sourceforge.net/"
MY_P=${P/_beta/b}
S=${WORKDIR}/${MY_P}
SRC_URI="mirror://sourceforge/skunkweb/${MY_P}.tar.gz"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="apache2 doc"
DEPEND=">=dev-lang/python-2.2
		>=dev-python/egenix-mx-base-2.0.4
		apache2? ( >=www-servers/apache-2.0.47 )"

pkg_setup() {
	enewgroup skunkweb
	enewuser skunkweb -1 -1 /usr/share/skunkweb skunkweb
}

src_compile() {
	local myconf
	if use apache2 ; then
		myconf="${myconf} --with-apxs=/usr/sbin/apxs2"
	else
		myconf="${myconf} --without-mod_skunkweb"
	fi
	econf \
		--with-user=skunkweb \
		--with-group=skunkweb \
		--localstatedir=/var/lib/skunkweb \
		--bindir=/usr/bin \
		--libdir=/usr/lib/skunkweb \
		--sysconfdir=/etc/skunkweb \
		--prefix=/usr/share/skunkweb \
		--with-cache=/var/lib/skunkweb/cache \
		--with-docdir=/usr/share/doc/${P} \
		--with-logdir=/var/log/skunkweb \
		--with-python=/usr/bin/python \
		${myconf} || die "configure failed"

	emake || die
}

src_install() {
	INSTALLING="yes"
	make DESTDIR=${D} APXSFLAGS="-c" install || die
	if use apache2 ; then
		exeinto /usr/lib/apache2-extramodules
		doexe SkunkWeb/mod_skunkweb/.libs/mod_skunkweb.so
		insinto /etc/apache2/conf/modules.d
		newins SkunkWeb/mod_skunkweb/httpd_conf.stub mod_skunkweb.conf
	fi
	# dirs --------------------------------------------------------------
	mkdir -p ${D}/var/{lib,log}/${PN}
	chown skunkweb:skunkweb ${D}/var/{lib,log}/${PN}
	mkdir -p ${D}/var/lib/${PN}/run
	# scripts------------------------------------------------------------
	newinitd ${FILESDIR}/skunkweb-init skunkweb
	exeinto /etc/cron.daily
		newexe ${FILESDIR}/skunkweb-cron-cache_cleaner skunkweb-cache_cleaner
	# docs --------------------------------------------------------------
	dodoc README ChangeLog NEWS HACKING ACKS INSTALL
	if use doc; then
		dodir /usr/share/doc/${PF}
		cp docs/paper-letter/*.pdf ${D}/usr/share/doc/${PF}
		ewarn "Some docs are still in upstream cvs (i.e.: formlib, pydo2)"
	fi
}
