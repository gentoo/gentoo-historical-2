# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-proxy/privoxy/privoxy-3.0.2.ebuild,v 1.2 2004/08/15 18:35:46 stuart Exp $

inherit eutils

S="${WORKDIR}/${P}-stable"
HOMEPAGE="http://www.privoxy.org"
DESCRIPTION="A web proxy with advanced filtering capabilities for protecting privacy against internet junk."
SRC_URI="mirror://sourceforge/ijbswa/${P}-stable-src.tar.gz"
RESTRICT="nomirror"

IUSE="selinux"
SLOT="2"
KEYWORDS="x86 ~ppc alpha sparc"
LICENSE="GPL-2"

DEPEND=">=sys-apps/sed-4"
RDEPEND="selinux? ( sec-policy/selinux-privoxy )"

pkg_setup() {
	enewgroup privoxy
	enewuser privoxy -1 /bin/false /etc/privoxy privoxy
}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:confdir .:confdir /etc/privoxy:' config
	sed -i 's:logdir .:logdir /var/log/privoxy:' config
	sed -i 's:logfile logfile:logfile privoxy.log:' config
	sed -i 's:set-image-blocker{pattern}:set-image-blocker{blank}:' default.action.master

	autoheader || die "autoheader failed"
	autoconf || die "autoconf failed"
}

src_compile() {
	econf \
		--sysconfdir=/etc/privoxy || die "econf failed"

	emake || die "make failed."
}

src_install () {
	diropts -m 0750 -g privoxy -o privoxy
	dodir /var/log/privoxy
	keepdir /var/log/privoxy
	dodir /etc/privoxy /etc/privoxy/templates

	insopts -m 0640 -g privoxy -o privoxy
	insinto /etc/privoxy
	doins default.action default.filter config standard.action trust user.action

	insinto /etc/privoxy/templates
	doins templates/*

	doman privoxy.1

	dodoc LICENSE README AUTHORS doc/text/faq.txt ChangeLog

	insopts
	for i in developer-manual faq man-page user-manual
	do
		insinto /usr/share/doc/${PF}/$i
		doins doc/webserver/$i/*
	done

	insopts -m 0750 -g root -o root
	insinto /usr/sbin
	doins privoxy
	insinto /etc/init.d
	newins ${FILESDIR}/privoxy.rc6 privoxy
}
