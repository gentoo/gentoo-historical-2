# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sobby/sobby-0.3.0_rc1.ebuild,v 1.1 2005/11/20 00:24:50 humpback Exp $

inherit eutils

MY_P=${P/_rc/rc}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Standalone Obby server"
HOMEPAGE="http://darcs.0x539.de/gobby"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
SRC_URI="http://releases.0x539.de/${PN}/${MY_P}.tar.gz"

DEPEND=">=dev-cpp/glibmm-2.6
	>=dev-libs/libsigc++-2.0
	>=dev-libs/gmp-4.1.4
	>=net-libs/net6-1.1.0
	>=net-libs/obby-0.3.0_rc1"

RDEPEND=""

src_compile() {
	econf || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die

	insinto /etc/conf.d/
	newins ${FILESDIR}/sobby-conf-0.2.0 sobby

	exeinto /etc/init.d/
	newexe ${FILESDIR}/sobby-init-0.2.0 sobby
}

pkg_postinst() {
	if built_with_use net-libs/obby howl
	then
		einfo "Zeroconf support has been enabled for sobby"
	else
		einfo "net-libs/obby was not build with zeroconf support,"
		einfo "thus	zeroconf is not enabled for ${PN}."
		einfo ""
		einfo "To get zeroconf support, rebuild net-libs/obby"
		einfo "with \"howl\" in your USE flags."
		einfo "Try USE=\"howl\" emerge net-libs/obby net-misc/sobby,"
		einfo "or add \"howl\" to your USE string in /etc/make.conf and"
		einfo "emerge net-libs/obby"
	fi

	echo
	einfo "To start sobby, you can use the init script:"
	einfo "    /etc/init.d/sobby start"
	einfo ""
	einfo "Please check the configuration in /etc/conf.d/sobby"
	einfo "before you start sobby"
}

