# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/tear/tear-1.0_rc1.ebuild,v 1.2 2002/11/30 03:10:52 vapier Exp $

DESCRIPTION="T.E.A.R. Encodes And Rips CDs into mp3 or ogg files."
HOMEPAGE="http://tear.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

RDEPEND="sys-devel/perl
	>=dev-perl/CDDB_get-2.1.0
	>=dev-perl/MP3-Info-1.01
	lame? ( >=media-sound/lame-3.92 )
	>=media-sound/bladeenc-0.94.2 
	>=media-sound/gogo-3.10 
	oggvorbis? ( >=media-sound/vorbis-tools-1.0 )
	>=media-sound/cdparanoia-3.9.8"

src_unpack() {
	unpack ${A}
	cd ${S}	
	
	mv tearrc tear.conf
	
	mv man-tear tear.1
	/usr/bin/groff -man -Tascii tear.1 > /dev/null
}

src_install() {
	dobin tear

	insinto /etc
	doins tear.conf	
	
	doman tear.1
	dodoc LICENSE README Changes
}
