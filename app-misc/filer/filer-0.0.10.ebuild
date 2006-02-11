# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/filer/filer-0.0.10.ebuild,v 1.3 2006/02/11 21:14:11 mcummings Exp $

DESCRIPTION="Small file-manager written in perl"
HOMEPAGE="http://blog.perldude.de/projects/filer/"
SRC_URI="http://perldude.de/projects/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	dev-perl/gtk2-gladexml
	dev-perl/File-MimeInfo
	virtual/perl-File-Temp
	dev-perl/TimeDate
	dev-perl/glib-perl
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig
	>=x11-libs/gtk+-2.6
	x11-misc/shared-mime-info
	dev-perl/Stat-lsMode"
DEPEND="sys-apps/findutils"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	find ${S} -type d -name .svn | xargs rm -rf
}

src_compile() {
	true
}

src_install() {
	dodir /usr/bin
	dodir /usr/lib
	make install PREFIX=${D}/usr/
	dodoc AUTHORS COPYING README ChangeLog  || die "dodoc failed"
}
