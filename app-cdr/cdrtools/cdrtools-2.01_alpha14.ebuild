# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrtools/cdrtools-2.01_alpha14.ebuild,v 1.5 2003/10/01 09:27:33 aliz Exp $

inherit eutils

DESCRIPTION="A set of tools for CDR drives, including cdrecord."
HOMEPAGE="http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html"
SRC_URI="ftp://ftp.berlios.de/pub/cdrecord/alpha/${P/_alpha/a}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc hppa amd64"

DEPEND="virtual/glibc"
PROVIDE="virtual/cdrtools"

S="${WORKDIR}/${PN}-2.01"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Add support for 2.5 kernels
	# <azarah@gentoo.org> (05 Feb 2003)
	epatch ${FILESDIR}/${PN}-2.01-kernel25-support.patch || die

	cd ${S}/DEFAULTS
	sed -i -e "s:/opt/schily:/usr:g" Defaults.linux

	cd ${S}/RULES
	cp i386-linux-cc.rul x86_64-linux-cc.rul
	cp i386-linux-gcc.rul x86_64-linux-gcc.rul
}

src_compile() {
	emake || die
}

src_install() {
	dobin cdda2wav/OBJ/*-linux-cc/cdda2wav
	dobin cdrecord/OBJ/*-linux-cc/cdrecord
	cd ${S}
	dobin mkisofs/OBJ/*-linux-cc/mkisofs
	dobin readcd/OBJ/*-linux-cc/readcd
	insinto /usr/include
	doins incs/*-linux-cc/align.h incs/*-linux-cc/avoffset.h

	cd mkisofs/diag/OBJ/*-linux-cc
	dobin devdump isodump isoinfo isovfy

	cd ${S}/libs/*-linux-cc
	dolib.a *.a

	cd  ${S}
	dodoc Changelog COPYING PORTING README* START

	cd ${S}/doc
	dodoc cdrecord-1.8.1_de-doc_0.1.tar
	docinto print
	dodoc *.ps
	newman cdda2wav.man cdda2wav.1
	newman cdrecord.man cdrecord.1
	newman readcd.man readcd.1
	newman isoinfo.man isoinfo.8
	newman mkisofs.man mkisofs.8
}
