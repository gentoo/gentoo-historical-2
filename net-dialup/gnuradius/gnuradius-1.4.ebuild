# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gnuradius/gnuradius-1.4.ebuild,v 1.3 2007/04/14 10:57:58 mrness Exp $

inherit libtool eutils

MY_P="${P#gnu}"

DESCRIPTION="GNU radius authentication server"
HOMEPAGE="http://www.gnu.org/software/radius/radius.html"
SRC_URI="mirror://gnu/radius/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="guile mysql postgres odbc dbm nls snmp pam static debug readline"

DEPEND="!net-dialup/freeradius
	!net-dialup/cistronradius
	guile? ( >=dev-scheme/guile-1.4 )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	odbc? ( || ( dev-db/unixODBC dev-db/libiodbc ) )
	readline? ( sys-libs/readline )
	dbm? ( sys-libs/gdbm )
	snmp? ( net-analyzer/net-snmp )
	pam? ( sys-libs/pam )"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-gcc41.patch"
	epatch "${FILESDIR}/${P}-implicit-decl.patch"
}

src_compile() {
	elibtoolize --reverse-deps

	local myconf="--enable-client \
		`use_with guile` \
		`use_with guile server-guile` \
		`use_with mysql` \
		`use_with postgres` \
		`use_with odbc` \
		`use_with readline` \
		`use_enable dbm` \
		`use_enable nls` \
		`use_enable snmp` \
		`use_enable pam` \
		`use_enable debug` \
		`use_enable static` "

	econf ${myconf} || die "configuration failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "installation failed"
}
