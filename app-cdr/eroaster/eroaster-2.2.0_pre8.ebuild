# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/eroaster/eroaster-2.2.0_pre8.ebuild,v 1.1 2004/05/08 10:03:57 lanius Exp $

inherit eutils

IUSE="xmms encode oggvorbis"

MY_P=${P/_pre/-0.}

DESCRIPTION="A graphical frontend for cdrecord and mkisofs written in gnome-python"
HOMEPAGE="http://eclipt.uni-klu.ac.at/eroaster.php"
SRC_URI="mirror://sourceforge/eroaster/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc sparc"
S="${WORKDIR}/${MY_P}"

DEPEND=">=dev-lang/python-2.0
	>=dev-python/gnome-python-1.4.2
	app-cdr/cdrtools"

RDEPEND="${DEPEND}
	app-cdr/bchunk
	xmms? ( media-sound/xmms )
	encode? ( media-sound/lame
		media-sound/sox )
	oggvorbis? ( media-sound/vorbis-tools )
	app-cdr/cdrdao"

src_install() {
	einstall \
		gnorbadir=${D}/usr/share/eroaster || die
}

