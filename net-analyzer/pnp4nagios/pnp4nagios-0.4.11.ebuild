# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/pnp4nagios/pnp4nagios-0.4.11.ebuild,v 1.1 2008/09/29 18:04:20 dertobi123 Exp $

inherit confutils

MY_P=pnp-${PV}

DESCRIPTION="A performance data analyzer for nagios"
HOMEPAGE="http://www.pnp4nagios.org"

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64 ~ppc"

DEPEND=">=dev-lang/php-4.3
	>=net-analyzer/rrdtool-1.2
	net-analyzer/nagios-core"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	confutils_require_built_with_all dev-lang/php gd pcre xml zlib
}

src_compile() {
	econf \
		--sysconfdir=/etc/pnp \
		--datarootdir=/usr/share/pnp \
		--with-perfdata-dir=/var/nagios/perfdata \
		--with-perfdata-spool-dir=/var/spool/pnp  || die "econf failed"
	emake all || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" fullinstall || die "emake install failed"
}
