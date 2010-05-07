# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/flow-tools/flow-tools-0.68.5-r1.ebuild,v 1.2 2010/05/07 00:44:48 jer Exp $

EAPI="2"

inherit eutils

DESCRIPTION="library and programs to collect, send, process, and generate reports from NetFlow data"
HOMEPAGE="http://code.google.com/p/flow-tools/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="mysql postgres debug ssl"

RDEPEND="sys-apps/tcp-wrappers
	sys-libs/zlib
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	ssl? ( dev-libs/openssl )"

DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

pkg_setup() {
	enewgroup flows
	enewuser flows -1 -1 /var/lib/flows flows
}

src_configure() {
	local myconf="--sysconfdir=/etc/flow-tools"
	use mysql && myconf="${myconf} --with-mysql"
	if use postgres; then
		myconf="${myconf} --with-postgresql=yes"
	else
		myconf="${myconf} --with-postgresql=no"
	fi
	use ssl && myconf="${myconf} --with-openssl"
	econf ${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README SECURITY TODO

	keepdir /var/lib/flows
	keepdir /var/lib/flows/bin
	exeinto /var/lib/flows/bin
	doexe "${FILESDIR}"/linkme
	keepdir /var/run/flows

	newinitd "${FILESDIR}/flowcapture.initd" flowcapture
	newconfd "${FILESDIR}/flowcapture.confd" flowcapture

}

pkg_postinst() {
	chown flows:flows /var/run/flows
	chown flows:flows /var/lib/flows
	chown flows:flows /var/lib/flows/bin
	chmod 0755 /var/run/flows
	chmod 0755 /var/lib/flows
	chmod 0755 /var/lib/flows/bin
}
