# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/archway/archway-0.2.1.ebuild,v 1.2 2008/07/03 04:09:42 darkside Exp $

inherit eutils

DESCRIPTION="A GUI for GNU Arch"
HOMEPAGE="http://www.nongnu.org/archway/"
SRC_URI="http://savannah.nongnu.org/download/archway/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

#"ArchWay requires gtk-2.4 and gtk2-perl." -$HOMEPAGE
#DEPEND=">=dev-util/tla-1.1
#	>=dev-lang/perl-5.8.0
#	>=dev-perl/gtk2-perl-1.040
#	>=dev-perl/glib-perl-1.040
#	>=x11-libs/gtk+-2.4.0"

DEPEND=""
RDEPEND=">=x11-libs/gtk+-2
	>=dev-perl/gtk2-perl-1.040"

src_install() {
	make DESTDIR=${D} prefix=/usr install || die
}
