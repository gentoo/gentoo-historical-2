# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/eroaster/eroaster-2.2.0_pre6.ebuild,v 1.11 2005/01/01 12:12:58 eradicator Exp $

inherit eutils

IUSE="xmms encode oggvorbis"

MY_P=${P/_pre/-0.}

DESCRIPTION="A graphical frontend for cdrecord and mkisofs written in gnome-python"
HOMEPAGE="http://eclipt.uni-klu.ac.at/eroaster.php"
SRC_URI="mirror://sourceforge/eroaster/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"
S="${WORKDIR}/${MY_P}"

# cdrecord and mkisofs are needed or configure fails
DEPEND=">=dev-lang/python-2.0
	>=dev-python/gnome-python-1.4.2
	app-cdr/cdrtools"

# xmms, lame and vorbis-tools are just runtime conveniences
# not a bulild dep.
RDEPEND="${DEPEND}
	app-cdr/bchunk
	xmms? ( media-sound/xmms )
	encode? ( media-sound/lame
		media-sound/sox )
	oggvorbis? ( media-sound/vorbis-tools )
	app-cdr/cdrdao"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_install() {
	einstall \
		gnorbadir=${D}/usr/share/eroaster || die
}

