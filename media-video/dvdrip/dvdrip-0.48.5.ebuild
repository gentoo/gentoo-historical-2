# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdrip/dvdrip-0.48.5.ebuild,v 1.2 2003/02/10 14:12:38 seemant Exp $

IUSE="oggvorbis cdr gnome"

inherit perl-module

MY_P=${P/dvdr/Video-DVDR}
# Next three lines are to handle PRE versions
MY_P=${MY_P/_pre/_}
MY_URL="dist"
[ "${P/pre}" != "${P}" ] && MY_URL="dist/pre"

S=${WORKDIR}/${MY_P}
DESCRIPTION="dvd::rip is a graphical frontend for transcode"
SRC_URI="http://www.exit1.org/${PN}/${MY_URL}/${MY_P}.tar.gz"
HOMEPAGE="http://www.exit1.org/dvdrip/"
SLOT="0"
LICENSE="Artistic GPL-2"
KEYWORDS="~x86"

DEPEND="oggvorbis? ( media-sound/ogmtools )
	gnome? ( gnome-extra/gtkhtml )
	cdr? ( >=media-video/vcdimager-0.7.12
		>=app-cdr/cdrdao-1.1.7
		app-cdr/cdrtools )
	>=media-video/transcode-0.6.2
	media-gfx/imagemagick
	dev-perl/gtk-perl
	dev-perl/Storable
	dev-perl/Event"

RDEPEND=">=net-analyzer/fping-2.3"

src_install () {
	perl-module_src_install
	cp -a ${S}/contrib ${D}/usr/share/doc/${P}
}
