# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/privoxy/privoxy-3.0.8.ebuild,v 1.1 2008/01/29 11:18:31 mrness Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit toolchain-funcs autotools

HOMEPAGE="http://www.privoxy.org
	http://sourceforge.net/projects/ijbswa/"
DESCRIPTION="A web proxy with advanced filtering capabilities for protecting privacy against Internet junk"
SRC_URI="mirror://sourceforge/ijbswa/${P}-stable-src.tar.gz"

IUSE="pcre selinux"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
LICENSE="GPL-2"

DEPEND="pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-privoxy )"

S="${WORKDIR}/${P}-stable"

pkg_setup() {
	enewgroup privoxy
	enewuser privoxy -1 -1 /etc/privoxy privoxy
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	sed -e 's:confdir .:confdir /etc/privoxy:' \
		-e 's:logdir .:logdir /var/log/privoxy:' \
		-e 's:logfile logfile:logfile privoxy.log:' \
		-i config || die "sed failed."
	sed -e 's:^\+set-image-blocker{pattern}:+set-image-blocker{blank}:' \
		-i default.action.master || die "sed 2 failed."
	eautoreconf || die "autoreconf failed"
}

src_compile() {
	export CC=$(tc-getCC)
	econf \
		$(use_enable pcre dynamic-pcre) \
		--with-user=privoxy \
		--with-group=privoxy \
		--sysconfdir=/etc/privoxy \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install () {
	dosbin privoxy
	newinitd "${FILESDIR}/privoxy.initd" privoxy
	insinto /etc/logrotate.d
	newins "${FILESDIR}/privoxy.logrotate" privoxy

	insinto /etc/privoxy
	doins default.action default.filter config standard.action trust user.action
	insinto /etc/privoxy/templates
	doins templates/*

	doman privoxy.1
	dodoc README AUTHORS doc/text/faq.txt ChangeLog
	cd doc/webserver
	dohtml -r developer-manual faq man-page user-manual

	diropts -m 0750 -g privoxy -o privoxy
	keepdir /var/log/privoxy
}
