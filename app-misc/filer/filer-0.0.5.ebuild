# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/filer/filer-0.0.5.ebuild,v 1.4 2004/08/10 13:01:46 fmccor Exp $

DESCRIPTION="Small file-manager written in perl"
HOMEPAGE="http://public.rz.fh-wolfenbuettel.de/~luedickj/"
SRC_URI="http://public.rz.fh-wolfenbuettel.de/~luedickj/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	dev-perl/gtk2-gladexml
	dev-perl/File-MimeInfo
	dev-perl/File-Temp
	dev-perl/TimeDate
	dev-perl/Stat-lsMode"

S=${WORKDIR}/${PN}

src_install() {
	dobin filer.pl || die
	dodir /usr/lib/filer
	cp -R filer.glade filer.gladep Filer icons lib.pl ${D}/usr/lib/filer
}
