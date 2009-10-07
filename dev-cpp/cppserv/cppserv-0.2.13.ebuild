# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/cppserv/cppserv-0.2.13.ebuild,v 1.2 2009/10/07 06:48:18 iluxa Exp $

inherit eutils apache-module multilib

DESCRIPTION="CPPSERV is an application server providing Servlet-like API in C++ and a C++ Server Pages parser."
HOMEPAGE="http://www.total-knowledge.com/progs/cppserv"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~x86 ~mips ~amd64"
IUSE="debug"

APACHE2_MOD_CONF="75_mod_cserv"
APACHE2_MOD_DEFINE="CPPSERV"

DEPEND="net-libs/socket++
	=dev-cpp/sptk-3.5*
	>=www-servers/apache-2
	>=dev-libs/apr-1.2
	dev-libs/boost
"
RDEPEND="${DEPEND}"

need_apache2

cppserv_build_flags() {
	local CPPSERV_DBG_FLAG
	use debug && CPPSERV_DBG_FLAG="CPPFLAGS=-DMODCSERV_DEBUG"
	echo PREFIX=/usr LIB=/$(get_libdir) ADON_VERBOSE=1 ADON_BUILD=release APRCFG_PATH=/usr/bin/apr-1-config  ${CPPSERV_DBG_FLAG}
}

src_compile() {
	emake $(cppserv_build_flags) || die "emake failed. Bug iluxa on #cppserv on irc.freenode.net immediately"
}

src_install() {
	emake $(cppserv_build_flags) DESTDIR="${D}" ${CPPSERV_DBG_FLAG} install || die "emake install failed. Bug iluxa on #cppserv on irc.freenode.net immediately"
	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${FILESDIR}/${APACHE2_MOD_CONF}.conf" || die "internal ebuild error: \"${FILESDIR}/${APACHE2_MOD_CONF}.conf\" not found. Bug iluxa on #cppserv on irc.freenode.net immediately"
}

src_test() {
	emake $(cppserv_build_flags) check
}
