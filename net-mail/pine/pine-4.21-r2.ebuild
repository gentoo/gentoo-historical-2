# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/pine/pine-4.21-r2.ebuild,v 1.2 2001/04/29 22:44:00 achim Exp $

P=pine-4.21
A=pine4.21.tar.gz
S=${WORKDIR}/pine4.21
DESCRIPTION="Pine, Pico, Pilot, imapd"
SRC_URI="ftp://ftp.cac.washington.edu/pine/"${A}
HOMEPAGE="http://www.washington.edu/pine/"

DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/gpm-1.19.3
	>=sys-libs/ncurses-5.1
	>=sys-libs/pam-0.72"

src_unpack() {
  unpack ${A}
  cd ${S}/pine
  cp makefile.lnx makefile.orig
  sed -e "s:-g -DDEBUG:${CFLAGS}:" makefile.orig > makefile.lnx

     cp ${FILESDIR}/os.c osdep/os-lnx.c
     cp ${FILESDIR}/filter.c filter.c

  cd ${S}/pico
  cp makefile.lnx makefile.orig
  sed -e "s:-g -DDEBUG:${CFLAGS}:" makefile.orig > makefile.lnx

  
}

src_compile() {                           
  try ./build lnp
}

src_install() {                               
  cd ${S}
  into /usr
  dobin bin/pine bin/pico bin/pilot bin/mtest
  dosbin bin/imapd

  doman doc/pico.1 doc/pine.1

  insinto /etc
  doins doc/mime.types
  donewins doc/mailcap.unx mailcap

  dodoc CPYRIGHT README doc/brochure.txt doc/tech-notes.txt
  docinto imap
  dodoc imap/docs/*.txt imap/docs/CONFIG imap/docs/FAQ imap/docs/RELNOTES
  docinto imap/rfc
  dodoc imap/docs/rfc/*.txt
  docinto html/tech-notes
  dodoc doc/tech-notes/*.html
}



