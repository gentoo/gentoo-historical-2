# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/tinyca/tinyca-0.6.6.ebuild,v 1.1 2005/02/02 10:13:54 dragonheart Exp $

DESCRIPTION="Simple Perl/Tk GUI to manage a small certification authority"
HOMEPAGE="http://tinyca.sm-zone.net/"
SRC_URI="http://tinyca.sm-zone.net/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE=""

RDEPEND=">=dev-libs/openssl-0.9.6i
	dev-perl/Locale-gettext
	>=dev-perl/MIME-Base64-2.12
	dev-perl/gtk-perl
	>=dev-perl/perl-tk-800.024"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	# this app was written to be run from cwd and not meant to be installed
	# this little hack fixes that... pretty silly if you ask me
	sed -i \
		-e "s:\./lib:/usr/share/tinyca/lib:" \
		-e "s:\./template:/usr/share/tinyca/template:" \
		tinyca
}

src_install() {
	dodir /usr/bin
	exeinto /usr/share/tinyca/
	doexe tinyca
	dosym /usr/share/tinyca/tinyca /usr/bin/tinyca
	insinto /usr/share/tinyca/lib
	doins lib/*.pm
	insinto /usr/share/tinyca/lib/GUI
	doins lib/GUI/*.pm
	insinto /usr/share/tinyca/templates
	doins templates/*
}
