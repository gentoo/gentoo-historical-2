# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/omni/omni-0.9.0.ebuild,v 1.8 2004/06/15 03:15:12 agriffis Exp $

DESCRIPTION="Omni provides support for many printers with a pluggable framework (easy to add devices)"
HOMEPAGE="http://sourceforge.net/projects/omniprint"
SRC_URI="mirror://sourceforge/omniprint/${P/o/O}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86"
DEPEND=""
RDEPEND="virtual/ghostscript
	>=dev-libs/libxml-1.8.6
	dev-libs/glib
	cups? ( >=net-print/cups-1.1.14 )
	X? ( >=dev-cpp/gtkmm-1.2.5 )
	>=dev-libs/libsigc++-1.01
	foomaticdb? ( net-print/foomatic-db-engine )"

S=${WORKDIR}/Omni

IUSE="cups X ppds foomaticdb static"

src_compile() {
	local myconf=" \
		$(use_enable X jobdialog) \
		$(use_enable cups) \
		$(use_enable static)"

	./setupOmni ${myconf} || die

	if use ppds || use cups; then
		sed -i -e "s/model\/foomatic/model\/omni/g" CUPS/Makefile \
			|| die 'sed failed'
		make -C CUPS generateBuildPPDs || die
	fi

	if use foomaticdb; then
		make -C Foomatic generateFoomaticData || die
	fi
}

src_install () {
	make DESTDIR=${D} install || die

	if use foomaticdb; then
		make -C Foomatic DESTDIR=${D} localInstall || die
	fi
}
