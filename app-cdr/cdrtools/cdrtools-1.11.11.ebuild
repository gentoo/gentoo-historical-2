# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# /space/gentoo/cvsroot/gentoo-x86/app-cdr/cdrtools/cdrtools-1.11.ebuild,v 1.2 2001/11/10 02:36:20 hallski Exp

S=${WORKDIR}/cdrtools-1.11
DESCRIPTION="cdrtools - A set of tools for CDR drives, including cdrecord"
SRC_URI="ftp://ftp.fokus.gmd.de:21/pub/unix/cdrecord/alpha/cdrtools-1.11a11.tar.gz"
HOMEPAGE="http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html"

DEPEND="virtual/glibc"

src_unpack() {

  unpack ${A}
  cd ${S}/DEFAULTS
  cp Defaults.linux Defaults.linux.bak
  sed -e "s:/opt/schily:/usr:g" Defaults.linux.bak > Defaults.linux
  cd ..

}


src_compile() {

  emake || die
}

src_install() {


  dobin cdda2wav/OBJ/*-linux-cc/cdda2wav
  dobin cdrecord/OBJ/*-linux-cc/cdrecord
  cd ${S}
  dobin mkisofs/OBJ/*-linux-cc/mkisofs
  dobin misc/OBJ/*-linux-cc/readcd
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
