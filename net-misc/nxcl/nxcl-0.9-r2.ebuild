# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxcl/nxcl-0.9-r2.ebuild,v 1.1 2010/02/19 17:27:15 voyageur Exp $

EAPI=2

inherit autotools

MY_P="freenx-client-${PV}"
DESCRIPTION="A library for building NX clients"
HOMEPAGE="http://developer.berlios.de/projects/freenx/"
SRC_URI="mirror://berlios/freenx/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc nxclient"

RDEPEND=">=net-misc/nx-3.2.0-r5
	dbus? ( sys-apps/dbus )
	nxclient? ( net-misc/nxclient )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
S="${WORKDIR}/${MY_P}/${PN}"

src_prepare() {
	# Incorrect version
	sed -i -e "s#1.0#0.9#" configure.ac || die "version sed failed"
	# And doc path
	sed -i -e "/^docdir =/s#doc/.*#share/doc/${PF}#" doc/Makefile.am ||
		die "doc path sed failed"
	if ! use nxclient; then
		# Patch to use standard ssh instead of nxssh from nxclient
		epatch "${FILESDIR}"/${P}-no_nxssh.patch
	fi
	epatch "${FILESDIR}"/${P}-gcc43.patch
	eautoreconf
}

src_configure() {
	econf $(use_with doc doxygen) || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
