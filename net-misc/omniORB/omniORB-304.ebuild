# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# /home/cvsroot/gentoo-x86/berlin-base/omniORB/omniORB-303.ebuild,v 1.7 2001/05/28 05:24:13 achim Exp

A="${PN}_${PV}.tar.gz omniORBpy_1_4.tar.gz omniNotify11b1.tar.gz"
S=${WORKDIR}/omni
DESCRIPTION="a robust, high-performance CORBA 2 ORB"
SRC_URI="ftp://ftp.uk.research.att.com/pub/omniORB/omniORB3/${PN}_${PV}.tar.gz
	 ftp://ftp.uk.research.att.com/pub/omniORB/omniORBpy/${PN}py_1_4.tar.gz
	 ftp://ftp.uk.research.att.com/pub/omniNotify/omniNotify1/omniNotify11b1.tar.gz"
HOMEPAGE="http://www.uk.research.att.com/omniORB/"

DEPEND="virtual/glibc dev-lang/python"

PLT="i586_linux_2.0_glibc2.1"

src_unpack() {

  unpack ${PN}_${PV}.tar.gz
  cd ${S}/src/lib
  unpack ${PN}py_1_4.tar.gz
  cd ${S}/src/services
  unpack omniNotify11b1.tar.gz

  cd ${S}/config
  cp config.mk config.mk.orig
  sed -e "s:#platform = ${PLT}:platform = ${PLT}:" \
  config.mk.orig > config.mk

  cd ${S}/mk
  cp unix.mk unix.mk.orig
  sed -e "s:^MKDIRHIER.*:MKDIRHIER = mkdir -p:" unix.mk.orig > unix.mk

  cd platforms
  cp ${PLT}.mk ${PLT}.orig
  sed -e "s:#PYTHON = /usr.*:PYTHON=/usr/bin/python:" \
      ${PLT}.orig > ${PLT}.mk

}


src_compile() {

    cd ${S}/src
    try make export
    cd ${S}/src/lib/omniORBpy
    try make export
    cd ${S}/src/services/omniNotify
    try make export
}

src_install () {

    T=/usr
    into ${T}
    cd ${S}
    dodir /usr/share/omniORB/bin/scripts
    cp -af bin/scripts/* ${D}/usr/share/omniORB/bin/scripts
    dobin bin/${PLT}/* 
    insinto ${T}/idl
    doins idl/*.idl
    insinto ${T}/idl/COS
    doins idl/COS/*.idl
    cp -af include ${D}/${T}
    dodir /usr/lib/python2.0/site-packages
    cd ${S}
    cp -af  lib/${PLT}/_* ${D}/usr/lib/python2.0/site-packages
    dolib lib/${PLT}/*.{a,so*}
    rm ${D}/usr/lib/_*.*
    exeinto ${T}/lib
    doexe lib/${PLT}/omnicpp
    dodir /usr/lib/python2.0
    cp -af lib/python/* ${D}/usr/lib/python2.0/
    doman man/man[15]/*.[15]

    exeinto /etc/rc.d/init.d
    doexe ${FILESDIR}/omniORB

    dodoc CHANGES* COPYING* CREDITS PORTING README* ReleaseNote_omniORB_304 THIS_IS_omniORB_3_0_4
    cd doc
    docinto print
    dodoc *.ps
    dodoc *.tex
    dodoc *.pdf

    docinto html
    dodoc *.html
    docinto html/omniORB
    dodoc omniORB/*.{gif,html}

    dodir /etc/env.d/
    echo "PATH=/usr/share/omniORB/bin/scripts" > ${D}/etc/env.d/90omniORB
#    echo "PYTHONPATH=/usr/share/omniORB/python" >> ${D}/etc/env.d/90omniORB
}
pkg_postinst() {
  if [ ! -f "${ROOT}etc/omniORB.cfg" ] ; then
    echo "ORBInitialHost `uname -n`" > ${ROOT}etc/omniORB.cfg
    echo "ORBInitialPort 2809" >> ${ROOT}etc/omniORB.cfg
  fi
}
