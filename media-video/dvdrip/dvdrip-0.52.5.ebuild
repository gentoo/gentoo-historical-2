# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdrip/dvdrip-0.52.5.ebuild,v 1.1 2005/05/19 20:38:09 luckyduck Exp $

inherit perl-module eutils

MY_P=${P/dvdr/Video-DVDR}
# Next three lines are to handle PRE versions
MY_P=${MY_P/_pre/_}
MY_URL="dist"
[ "${P/pre}" != "${P}" ] && MY_URL="dist/pre"

S=${WORKDIR}/${MY_P}
DESCRIPTION="Dvd::rip is a graphical frontend for transcode"
HOMEPAGE="http://www.exit1.org/dvdrip/"
SRC_URI="http://www.exit1.org/${PN}/${MY_URL}/${MY_P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
# ~ppc needs subtitleripper
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="cdr gnome xvid rar mplayer ogg fping subtitles"

DEPEND="gnome? ( gnome-extra/libgtkhtml )
	cdr? ( >=media-video/vcdimager-0.7.19
		>=app-cdr/cdrdao-1.1.7
		virtual/cdrtools
		>=media-video/mjpegtools-1.6.0 )
	xvid? ( media-video/xvid4conf )
	rar? ( app-arch/rar )
	mplayer? ( media-video/mplayer )
	>=media-video/transcode-0.6.14
	>=media-gfx/imagemagick-5.5.3
	dev-perl/gtk-perl
	dev-perl/Storable
	dev-perl/Event"
RDEPEND="${DEPEND}
	fping? ( >=net-analyzer/fping-2.3 )
	ogg? ( >=media-sound/ogmtools-1.000 )
	subtitles? ( media-video/subtitleripper )
	sys-apps/eject
	dev-perl/libintl-perl"

pkg_setup() {
	built_with_use transcode dvdread || die "transcode needs dvdread support builtin.  Please re-emerge transcode with the dvdread USE flag."
}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:cc :$(CC) :' src/Makefile || die "sed failed"
}

src_install() {
	perl-module_src_install
}

pkg_postinst() {
	einfo "If you want to use the cluster-mode, you need to SUID fping"
	einfo "chmod u+s /usr/sbin/fping"
	einfo
	einfo "for Perl 5.8.x you have to set PERLIO to read TOC properly"
	einfo "for bash: export PERLIO=stdio"
	einfo "for csh:  setenv PERLIO stdio"
	einfo "into your /.${shell}rc"
}
