# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/dumb/dumb-0.9.2-r2.ebuild,v 1.6 2005/09/13 18:34:25 agriffis Exp $

IUSE="debug"

inherit eutils

S="${WORKDIR}/${PN}"
DESCRIPTION="IT/XM/S3M/MOD player library with click removal and IT filters"
HOMEPAGE="http://dumb.sourceforge.net/"
SRC_URI="mirror://sourceforge/dumb/${P}-fixed.tar.gz"

KEYWORDS="alpha amd64 ia64 ppc x86"
LICENSE="DUMB-0.9.2"
SLOT="0"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	cat << EOF > make/config.txt
include make/unix.inc
ALL_TARGETS := core core-examples core-headers
PREFIX := /usr
EOF

	epatch ${FILESDIR}/${P}-PIC.patch
}

src_compile() {
	emake OFLAGS="${CFLAGS}" all || die "emake failed"
}

src_install() {
	dobin examples/dumbout
	dolib.so lib/unix/libdumb.so

	use debug && lib/unix/libdumbd.so

	insinto /usr/include
	doins include/dumb.h

	dodoc readme.txt release.txt docs/* || die "dodoc failed"
}

pkg_postinst() {
	einfo
	einfo "DUMB's core has been installed. This will enable you to convert module"
	einfo "files to PCM data (ready for sending to /dev/dsp, writing to a .wav"
	einfo "file, piping through oggenc, etc.)."
	einfo
	einfo "If you are using Allegro, you will also want to 'emerge aldumb'. This"
	einfo "provides you with a convenient API for playing module files through"
	einfo "Allegro's sound system, and also enables DUMB to integrate with"
	einfo "Allegro's datafile system so you can add modules to datafiles."
	einfo
	einfo "As a developer, when you distribute your game and write your docs, be"
	einfo "aware that 'dumb' and 'aldumb' actually come from the same download."
	einfo "People who don't use Gentoo will only have to download and install one"
	einfo "package. See /usr/share/doc/${PF}/readme.txt.gz for details on"
	einfo "how DUMB would be compiled manually."
	einfo
}
