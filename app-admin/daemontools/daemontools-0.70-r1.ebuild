# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/daemontools/daemontools-0.70-r1.ebuild,v 1.5 2000/11/10 16:00:11 achim Exp $

P=daemontools-0.70
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Collection of tools for managing UNIX services"
SRC_URI="http://cr.yp.to/daemontools/"${A}
HOMEPAGE="http://cr.yp.to/daemontools.html"

DEPEND=">=sys-libs/glibc-2.1.3"

src_unpack() {
  unpack ${A}
  cd ${S}
  echo "${TPREF}gcc ${CFLAGS}" > conf-cc
  echo "${TPREF}gcc -s" > conf-ld
}

src_compile() {                           
  cd ${S}
  echo $PATH
  try make
}

src_install() {                               
  cd ${S}
  into /usr
  for i in svscan supervise svc svok svstat fghack multilog tai64n \
	   tai64nlocal softlimit setuidgid envuidgid envdir setlock
  do
    dobin $i
  done
  dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION
}



