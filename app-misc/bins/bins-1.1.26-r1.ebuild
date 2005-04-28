# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bins/bins-1.1.26-r1.ebuild,v 1.12 2005/04/28 21:08:37 mcummings Exp $

inherit eutils

DESCRIPTION="Static HTML photo album generator"
HOMEPAGE="http://bins.sautret.org/"
SRC_URI="http://jsautret.free.fr/BINS/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc alpha ppc amd64"
IUSE="gtk"

DEPEND=">=dev-lang/perl-5.6.1-r6
	>=media-gfx/imagemagick-6.2.2.0
	>=dev-perl/ImageSize-2.99
	>=dev-perl/ImageInfo-1.04-r1
	>=dev-perl/IO-String-1.01-r1
	>=dev-perl/HTML-Clean-0.8
	>=dev-perl/HTML-Parser-3.26-r1
	>=dev-perl/HTML-Template-2.6
	>=dev-perl/Locale-gettext-1.01
	>=dev-perl/Storable-2.04
	>=dev-perl/Text-Iconv-1.2
	>=dev-perl/URI-1.18
	>=dev-perl/libxml-perl-0.07-r1
	>=dev-perl/XML-DOM-1.39-r1
	>=dev-perl/XML-Grove-0.46_alpha
	>=dev-perl/XML-Handler-YAWriter-0.23
	gtk? ( dev-perl/gtk-perl-glade )
	>=dev-perl/XML-XQL-0.67
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-install.patch
}

src_install() {
	echo "" |env DESTDIR=${D} PREFIX="/usr" ./install.sh || die
	# Fix for pathing
	for i in `grep -l portage ${D}/usr/bin/*`; do
		sed -i -e  "s:${D}:/:" ${i}
	done

	mkdir ${D}/usr/local
	mv ${D}/usr/share ${D}/usr/local/

	sed -i -e "s:/usr/share:/usr/local/share:" ${D}/usr/bin/bins

}
