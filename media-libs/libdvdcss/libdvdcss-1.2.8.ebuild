# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdcss/libdvdcss-1.2.8.ebuild,v 1.2 2003/08/12 22:45:45 weeve Exp $

IUSE=""

DESCRIPTION="A portable abstraction library for DVD decryption"
SRC_URI="http://developers.videolan.org/pub/videolan/libdvdcss/${PV}/${P}.tar.bz2"
HOMEPAGE="http://developers.videolan.org/pub/videolan/libdvdcss/"

SLOT="1.2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND="virtual/glibc"

pkg_preinst() {
	# these could cause problems if they exist from
	# earlier builds
	for x in libdvdcss.so.0 libdvdcss.so.1
	do
		if [ -f /usr/lib/${x} ] || [ -L /usr/lib/${x} ]
		then
			rm -f /usr/lib/${x}
		fi
	done
}

src_compile() {
	# Dont use custom optimiziations, as it gives problems
	# on some archs
	unset CFLAGS
	unset CXXFLAGS

	econf || die
		    
	make || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
	
	##
	## 0.0.3.* and 1.0.0 compat
	##

	# NOTE: this should be the last code in src_install() !!!

	if [ -L ${D}/usr/lib/libdvdcss.so ]
	then
		# on some locales the name of the file a symlink points to, is in the
		# tenth field, and not the eleventh (bug #2908)
		LC_ALL='C'
		local realname="$(ls -l ${D}/usr/lib/libdvdcss.so |gawk '{print $11}')"
		[ -z "${realname}" ] && \
			realname="$(ls -l ${D}/usr/lib/libdvdcss.so |gawk '{print $10}')"
		[ -z "${realname}" ] && return 0
	
		for x in libdvdcss.so.0 libdvdcss.so.1
		do
			dosym ${realname} /usr/lib/${x}
		done
	fi
}

