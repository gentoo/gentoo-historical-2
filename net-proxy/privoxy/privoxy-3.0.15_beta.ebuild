# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/privoxy/privoxy-3.0.15_beta.ebuild,v 1.1 2009/10/22 21:32:10 mrness Exp $

EAPI="2"

inherit eutils toolchain-funcs autotools

[ "${PV##*_}" = "beta" ] &&
	PRIVOXY_STATUS="beta" ||
	PRIVOXY_STATUS="stable"

HOMEPAGE="http://www.privoxy.org
	http://sourceforge.net/projects/ijbswa/"
DESCRIPTION="A web proxy with advanced filtering capabilities for protecting privacy against Internet junk"
SRC_URI="mirror://sourceforge/ijbswa/${P%_*}-${PRIVOXY_STATUS}-src.tar.gz"

IUSE="selinux threads zlib"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
LICENSE="GPL-2"

DEPEND="dev-libs/libpcre
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-privoxy )"

S="${WORKDIR}/${P%_*}-${PRIVOXY_STATUS}"

pkg_setup() {
	enewgroup privoxy
	enewuser privoxy -1 -1 /etc/privoxy privoxy
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	# autoreconf needs to be called even if we don't modify any autotools source files
	# See main makefile
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	export CC=$(tc-getCC)
	econf \
		$(use_enable zlib) \
		$(use_enable threads pthread) \
		--enable-dynamic-pcre \
		--with-user=privoxy \
		--with-group=privoxy \
		--sysconfdir=/etc/privoxy \
		--docdir=/usr/share/doc/${PF} \
		|| die "econf failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}/privoxy.initd" privoxy
	insinto /etc/logrotate.d
	newins "${FILESDIR}/privoxy.logrotate" privoxy

	diropts -m 0750 -g privoxy -o privoxy
	keepdir /var/log/privoxy
}
