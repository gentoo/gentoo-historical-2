# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ace/ace-5.4-r1.ebuild,v 1.2 2004/11/15 12:15:13 tantive Exp $

S=${WORKDIR}/ACE_wrappers
DESCRIPTION="The Adaptive Communications Environment"
SRC_URI="http://deuce.doc.wustl.edu/old_distribution/ACE-${PV}.tar.bz2"
HOMEPAGE="http://www.cs.wustl.edu/~schmidt/ACE.html"

SLOT="0"
LICENSE="BSD as-is"
KEYWORDS="x86 ~sparc ~ppc ~alpha ~amd64"
IUSE="ipv6"
DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}/ace
	use ipv6 && sed -e "s/#define ACE_HAS_PTHREADS$/#define ACE_HAS_PTHREADS\n#define ACE_HAS_IPV6/" config-linux.h >config.h
	use ipv6 || cp config-linux.h config.h
	cd ${S}/include/makeinclude
	sed -e "s:-O3:${CFLAGS}:" platform_linux.GNU >platform_macros.GNU
}

src_compile() {
	export ACE_ROOT=${S}
	cd ${S}/ace
	emake static_libs=1 || die
}

src_install() {
	dodir /usr/include/ace /usr/lib /usr/share/man/man3
	cd ${S}/ace
	cp libACE.so ${D}/usr/lib/libACE.so.${PV}
	cp libACE.a ${D}/usr/lib/libACE.a
	cp libACE_RMCast.so ${D}/usr/lib/libACE_RMCast.so.${PV}
	cp libACE_RMCast.a ${D}/usr/lib/libACE_RMCast.a
	cd ${D}/usr/lib
# 	ln -s libACE.so.${PV} libACE.so.`echo ${PV} | cut -f1 -d.`
	ln -s libACE.so.${PV} libACE.so
	ln -s libACE.so.${PV} libACE.so.${PV}.0
# 	ln -s libACE_RMCast.so.${PV} libACE_RMCast.so.`echo ${PV} | cut -f1 -d.`
	ln -s libACE_RMCast.so.${PV} libACE_RMCast.so
	ln -s libACE_RMCast.so.${PV} libACE_RMCast.so.${PV}.0

	cd ${S}/ace
	#don't really need the .cpp's after it's built
	cp -r *.{h,hpp,i,inl} ${D}/usr/include/ace
# 	cp -r * ${D}/usr/include/ace/
	chmod -R 644 ${D}/usr/include/ace/*
	cd ${D}/usr/include/ace/
	find -type d -exec chmod 755 \{\} \;

	cd ${S}/man
	cp -r man? ${D}/usr/share/man
	chmod 644 ${D}/usr/share/man/man?/*
	gzip -q ${D}/usr/share/man/man?/*

	cd ${S}
	dodoc ACE-INSTALL* AUTHORS COPYING FAQ PROBLEM-REPORT-FORM README
	dodoc THANKS TODO VERSION
	cd ${S}/docs
	dodoc *
	cd ${S}
	docinto ChangeLogs
	dodoc ChangeLog
	cd ${S}/ChangeLogs
	dodoc *
}

pkg_postinst() {
	# This is required, as anything trying to compile against ACE will have
	# problems with conflicting OS.h files if this is not done.

	local CC_MACHINE=`gcc -dumpmachine`
	local CC_VERSION=`gcc -dumpversion`
	if [ -d "/usr/lib/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace" ]; then
		mv "/usr/lib/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace" \
			"/usr/lib/gcc-lib/${CC_MACHINE}/${CC_VERSION}/include/ace.old"
	fi
}
