# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrtools/cdrtools-2.01-r2.ebuild,v 1.3 2005/03/02 16:04:06 pylon Exp $

inherit eutils gcc gnuconfig versionator

MY_CRYPT_VERS="$(get_version_component_range 1-2 )-encrypt-1.0rc1"

DESCRIPTION="A set of tools for CD recording, including cdrecord"
HOMEPAGE="http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html"
SRC_URI="ftp://ftp.berlios.de/pub/cdrecord/${P}.tar.bz2
	crypt? ( http://burbon04.gmxhome.de/linux/files/${PN}-${MY_CRYPT_VERS}.diff.gz )"

LICENSE="GPL-2 freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~x86"
IUSE="crypt unicode"

DEPEND="virtual/libc
	!app-cdr/dvdrtools"
RDEPEND="crypt? ( sys-fs/cryptsetup )"
PROVIDE="virtual/cdrtools"

S=${WORKDIR}/${PN}-2.01

src_unpack() {
	unpack ${A}
	cd ${S}

	# CAN-2004-0806 - Bug 63187
	epatch ${FILESDIR}/${PN}-2.01-scsi-remote.patch || die "Can't apply SCSI-remote patch"

	# UTF-8 support, see Bug #28369
	if use unicode; then
		epatch ${FILESDIR}/mkisofs-iconv-10.patch || die "Can't apply utf-8 patch"
	fi

	# Add support for On-The-Fly AES encryption
	# http://burbon04.gmxhome.de/linux/CDREncryption.html
	if use crypt; then
		epatch ${DISTDIR}/${PN}-${MY_CRYPT_VERS}.diff.gz || die "Can't apply encryption patch"
	fi

	cd ${S}/DEFAULTS
	use ppc-macos && MYARCH="mac-os10" || MYARCH="linux"
	sed -i "s:/opt/schily:/usr:g" Defaults.${MYARCH}
	sed -i "s:/usr/src/linux/include::g" Defaults.${MYARCH}

	cd ${S}/librscg
	sed -i "s:/opt/schily:/usr:g" scsi-remote.c

	cd ${S}/RULES
	ln -sf i386-linux-cc.rul x86_64-linux-cc.rul
	ln -sf i386-linux-gcc.rul x86_64-linux-gcc.rul
	ln -sf ppc-linux-cc.rul ppc64-linux-cc.rul
	ln -sf mips-linux-cc.rul mips64-linux-cc.rul
}

src_compile() {
	gnuconfig_update

	emake CC="$(gcc-getCC) -D__attribute_const__=const" COPTX="${CFLAGS}" CPPOPTX="${CPPFLAGS}" LDOPTX="${LDFLAGS}" || die
}

src_install() {
	cd ${S}

	dobin cdda2wav/OBJ/*-*-cc/cdda2wav || die "cdda2wav"
	dobin cdrecord/OBJ/*-*-cc/cdrecord  || die "cdrecord"
	dobin mkisofs/OBJ/*-*-cc/mkisofs || die "mkisofs"
	dobin readcd/OBJ/*-*-cc/readcd || die "readcd"
	dosbin rscsi/OBJ/*-*-cc/rscsi || die "rscsi"

	insinto /usr/include
	doins incs/*-*-cc/align.h incs/*-*-cc/avoffset.h incs/*-*-cc/xconfig.h || die "include"

	cd mkisofs/diag/OBJ/*-*-cc
	dobin devdump isodump isoinfo isovfy || die "dobin"

	cd ${S}
	insinto /etc/default
	doins rscsi/rscsi.dfl
	doins cdrecord/cdrecord.dfl

	cd ${S}/libs/*-*-cc
	dolib.a *.a || die "dolib failed"

	cd ${S}
	insinto /usr/include/scsilib
	doins include/*.h
	insinto /usr/include/scsilib/scg
	doins include/scg/*.h

	cd ${S}
	dodoc ABOUT Changelog README README.{ATAPI,audio,cdplus,cdrw,cdtext,cdclone,copy,DiskT@2,linux,linux-shm,multi,parallel,raw,rscsi,sony,verify} START
	doman */*.1
	doman */*.8

	cd ${S}/doc
	dodoc cdrecord-1.8.1_de-doc_0.1.tar
	docinto print
	dodoc *.ps
}

pkg_postinst() {
	einfo "Note the special license on cdrecord/cdrecord.c starting from line 4648."
	if use ppc-macos ; then
		einfo ""
		einfo "Darwin/OS X use the following device names: "
		einfo ""
		einfo "CD burners: (probably) ./cdrecord dev=IOCompactDiscServices "
		einfo ""
		einfo "DVD burners: (probably) ./cdrecord dev=IODVDServices "
		einfo ""
	else
	echo
	einfo "The command line option 'dev=ATAPI:' should be used for IDE CD writers."
	fi
}
