# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrtools/cdrtools-2.01_alpha25.ebuild,v 1.16 2004/06/24 21:32:08 agriffis Exp $

inherit eutils gcc

DVDR_PATCH_P="cdrtools-2.01a25-dvd.patch"
DESCRIPTION="A set of tools for CDR drives, including cdrecord."
HOMEPAGE="http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html"
SRC_URI="ftp://ftp.berlios.de/pub/cdrecord/alpha/${P/_alpha/a}.tar.bz2
	dvdr? ( mirror://gentoo/${DVDR_PATCH_P}.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64"
IUSE="dvdr"

DEPEND="virtual/glibc"
PROVIDE="virtual/cdrtools"

S=${WORKDIR}/${PN}-2.01

src_unpack() {
	unpack ${A}
	use dvdr && unpack ${DVDR_PATCH_P}.bz2

	cd ${S}
	# Add support for 2.5 kernels
	# <azarah@gentoo.org> (05 Feb 2003)
	epatch ${FILESDIR}/${PN}-2.01-kernel25-support.patch

	use dvdr && epatch ${WORKDIR}/${DVDR_PATCH_P}

	cd ${S}/DEFAULTS
	sed -i -e "s:/opt/schily:/usr:g" Defaults.linux
	sed -i -e "s:/usr/src/linux/include::g" Defaults.linux

	cd ${S}/librscg
	sed -i -e "s:/opt/schily:/usr:g" scsi-remote.c

	cd ${S}/RULES
	cp i386-linux-cc.rul x86_64-linux-cc.rul
	cp i386-linux-gcc.rul x86_64-linux-gcc.rul
}

src_compile() {
	emake CC="$(gcc-getCC) -D__attribute_const__=const" || die
}

src_install() {
	cd ${S}
	dobin cdda2wav/OBJ/*-linux-cc/cdda2wav
	dobin cdrecord/OBJ/*-linux-cc/cdrecord
	dobin mkisofs/OBJ/*-linux-cc/mkisofs
	dobin readcd/OBJ/*-linux-cc/readcd
	dosbin rscsi/OBJ/*-linux-cc/rscsi
	insinto /usr/include
	doins incs/*-linux-cc/align.h incs/*-linux-cc/avoffset.h incs/*-linux-cc/xconfig.h

	cd mkisofs/diag/OBJ/*-linux-cc
	dobin devdump isodump isoinfo isovfy

	cd ${S}
	insinto /etc/default
	doins rscsi/rscsi.dfl

	cd ${S}/libs/*-linux-cc
	dolib.a *.a

	cd ${S}
	insinto /usr/include/scsilib
	doins include/*.h
	insinto /usr/include/scsilib/scg
	doins include/scg/*.h

	cd ${S}
	dodoc Changelog PORTING README* START

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
