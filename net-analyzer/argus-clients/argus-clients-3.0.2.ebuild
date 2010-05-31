# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/argus-clients/argus-clients-3.0.2.ebuild,v 1.2 2010/05/31 17:31:11 phajdan.jr Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Clients for net-analyzer/argus"
HOMEPAGE="http://www.qosient.com/argus/"
SRC_URI="http://qosient.com/argus/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug geoip mysql"

#sasl? ( >=dev-libs/cyrus-sasl-1.5.24 )
MY_CDEPEND="net-libs/libpcap
	net-analyzer/rrdtool[perl]
	geoip? ( dev-libs/geoip )
	mysql? ( virtual/mysql )"

#	>=net-analyzer/argus-2.0.6[sasl?]"
RDEPEND="${MY_CDEPEND}
	>=net-analyzer/argus-3.0.2"

DEPEND="${MY_CDEPEND}
	>=sys-devel/bison-1.28
	>=sys-devel/flex-2.4.6"

src_configure() {
	use debug && touch .debug
	#	$(use_with sasl) \
	econf \
		$(use_with geoip GeoIP /usr/) \
		$(use_with mysql)
}

src_install() {
	# argus_parse.a and argus_common.a are supplied by net-analyzer/argus
	dobin bin/ra* || die "Failed to install ra*"
	dodoc ChangeLog CREDITS README doc/{CHANGES,FAQ,HOW-TO} || die
	doman man/man{1,5}/*
}
