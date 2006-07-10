# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk2-traymanager/gtk2-traymanager-0.05.ebuild,v 1.7 2006/07/10 23:17:55 agriffis Exp $

inherit perl-module

MY_P=Gtk2-TrayManager-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Perl bindings for EggTrayManager"
SRC_URI="mirror://cpan/authors/id/B/BO/BORUP/${MY_P}.tar.gz"
HOMEPAGE="http://gtk2-perl.sf.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ia64 ppc x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2
	>=dev-perl/glib-perl-1.012
	>=dev-perl/gtk2-perl-1.012
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig"
RDEPEND="${DEPEND}"