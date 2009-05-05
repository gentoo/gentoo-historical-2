# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/xsp/xsp-9999.ebuild,v 1.1 2009/05/05 11:59:06 loki_val Exp $

EAPI=2

inherit go-mono mono autotools

PATCHDIR="${FILESDIR}/2.2/"

DESCRIPTION="XSP is a small web server that can host ASP.NET pages"
HOMEPAGE="http://www.go-mono.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_preinst() {
	enewgroup aspnet
	# Give aspnet home dir of /tmp since it must create ~/.wapi
	enewuser aspnet -1 -1 /tmp aspnet
}

src_install() {
	mv_command="cp -ar" go-mono_src_install
	newinitd "${PATCHDIR}"/xsp.initd xsp || die
	newinitd "${PATCHDIR}"/mod-mono-server.initd mod-mono-server || die
	newconfd "${PATCHDIR}"/xsp.confd xsp || die
	newconfd "${PATCHDIR}"/mod-mono-server.confd mod-mono-server || die

	keepdir /var/run/aspnet
}

pkg_postinst() {
	chown aspnet:aspnet /var/run/aspnet
}
