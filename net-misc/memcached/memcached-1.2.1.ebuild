# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/memcached/memcached-1.2.1.ebuild,v 1.5 2007/11/18 15:03:03 robbat2 Exp $

inherit eutils

MY_PV="${PV/_pre/-pre}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load"
HOMEPAGE="http://www.danga.com/memcached/"
SRC_URI="http://www.danga.com/memcached/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~sh sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="static perl doc"

DEPEND=">=dev-libs/libevent-0.6
		perl? ( dev-perl/Cache-Memcached )"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf=""
	use static || myconf="--disable-static ${myconf}"
	econf ${myconf} || die "econf failed"
	emake || die
}

src_install() {
	dobin "${S}"/memcached
	dodoc "${S}"/{AUTHORS,COPYING,ChangeLog,INSTALL,NEWS,README}

	newconfd "${FILESDIR}/1.1.12/conf" memcached

	newinitd "${FILESDIR}/1.1.12/init" memcached

	doman "${S}"/doc/memcached.1

	if use doc; then
	  dodoc "${S}"/doc/{memory_management.txt,protocol.txt}
	fi
}

pkg_postinst() {
	enewuser memcached -1 -1 /dev/null daemon
	einfo "With this version of Memcached Gentoo now supporst multiple instances."
	einfo "To enable this you must create a symlink in /etc/init.d/ for each instance"
	einfo "to /etc/init.d/memcached and create the matching conf files in /etc/conf.d/"
	einfo "Please see Gentoo bug #122246 for more info"
}
