# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/hyperdex/hyperdex-0.4.0.ebuild,v 1.1 2012/08/18 14:22:54 patrick Exp $
EAPI=4

inherit eutils python

DESCRIPTION="A searchable distributed Key-Value Store"

HOMEPAGE="http://hyperdex.org"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="trace-player +python"
# need to add coverage and java useflags too

DEPEND="dev-cpp/glog
	dev-libs/cityhash
	dev-libs/libpo6
	dev-libs/libe
	dev-libs/busybee
	dev-libs/popt
	trace-player? ( dev-libs/libbsd )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable trace-player)
		$(use_enable python)
}

src_install() {
	emake DESTDIR="${D}" install || die "Failed to install"
	newinitd "${FILESDIR}/hyperdex.initd" hyperdex || die "Failed to install init script"
	newconfd "${FILESDIR}/hyperdex.confd" hyperdex || die "Failed to install config file"
}
