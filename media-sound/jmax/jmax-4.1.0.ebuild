# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jmax/jmax-4.1.0.ebuild,v 1.9 2007/03/04 22:29:32 dirtyepic Exp $

WANT_AUTOMAKE="1.4"
WANT_AUTOCONF="2.5"

inherit eutils libtool autotools java-pkg-2

DESCRIPTION="jMax is a visual programming environment for building interactive real-time music and multimedia applications."
HOMEPAGE="http://freesoftware.ircam.fr/rubrique.php3?id_rubrique=2"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
		mirror://gentoo/jmax-m4-1.0.tar.bz2"

#-amd64, -sparc: 4.1.0: fts/linux.c has only code for ppc and ix86
KEYWORDS="-amd64 ~ppc -sparc x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="alsa jack"

RDEPEND="=virtual/jre-1.4*
	jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )"

DEPEND="${RDEPEND}
	=virtual/jdk-1.4*"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}"
	unpack jmax-m4-1.0.tar.bz2
	epatch "${FILESDIR}/${P}-otherArch.patch"
	epatch "${FILESDIR}/${P}-gcc34.patch"
	# fixed 57691
	epatch "${FILESDIR}/${P}-fix-java-check.patch"
	epatch "${FILESDIR}/${P}-gcc41.patch"
	epatch "${FILESDIR}/${P}-usercflags.patch"

	AT_M4DIR="${S}/m4" eautoreconf
}

src_compile() {
	econf \
		$(use_enable jack) || die "econf failed"
	# -j2 fails.  See bug #47978
	emake -j1 || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog JMAX-VERSION README
}

pkg_postinst() {
	echo
	einfo "To get started, have a look at the tutorials"
	einfo "in /usr/lib/jmax/tutorials/basics"
	echo
}
