# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nspr/nspr-4.6.3.ebuild,v 1.10 2006/09/27 16:25:16 ferdy Exp $

inherit eutils gnuconfig

DESCRIPTION="Netscape Portable Runtime"
HOMEPAGE="http://www.mozilla.org/projects/nspr/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${PV}/src/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="ipv6"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	mkdir build inst
	epatch "${FILESDIR}"/${PN}-4.6.1-config.patch
	epatch "${FILESDIR}"/${PN}-4.6.1-config-1.patch
	epatch "${FILESDIR}"/${PN}-4.6.1-lang.patch
	epatch "${FILESDIR}"/${PN}-4.6.1-prtime.patch
	epatch "${FILESDIR}"/${PN}-4.6.3-fbsd62.patch
	gnuconfig_update
}

src_compile() {
	cd build

	if use amd64 || use ppc64 || use ia64 || use s390; then
		myconf="${myconf} --enable-64bit"
	else
		myconf=""
	fi

	if use ipv6; then
		myconf="${myconf} --enable-ipv6"
	fi

	../mozilla/nsprpub/configure \
		--build=${CBUILD:-${CHOST}} \
		--host=${CHOST} \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir)/nspr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myconf} || die "./configure failed"
	make || die
}

src_install () {
	# Their build system is royally fucked, as usual
	MINOR_VERSION=6
	cd ${S}/build
	make install
	insinto /usr
	doins -r dist/*
	rm -rf ${D}/usr/bin/lib*.so

	#removing includes/nspr/md as per fedora spec
	# i.e a waste of space!
	rm -rf ${D}/usr/include/nspr/md

	# there have been /usr/lib/nspr changes (like the ldpath below), but never
	# have I seen any libraries end up in this directory. lets fix that.
	# note: I tried doing this fix via the build system. It wont work.
	if [ ! -e ${D}/usr/lib/nspr ] ; then
		mkdir -p ${D}/usr/lib/nspr
		mv ${D}/usr/lib/*so* ${D}/usr/lib/nspr
		mv ${D}/usr/lib/*\.a ${D}/usr/lib/nspr
	fi
	# and while we're at it, lets make it actually use the arch's libdir damnit
	if [ "lib" != "$(get_libdir)" ] ; then
		mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	fi
	#and while at it move them to files with versions-ending
	#and link them back :)
	cd ${D}/usr/$(get_libdir)/nspr
	for file in *.so; do
		mv ${file} ${file}.${MINOR_VERSION}
		ln -s ${file}.${MINOR_VERSION} ${file}
	done
	# cope with libraries being in /usr/lib/nspr
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/nspr" > ${D}/etc/env.d/08nspr

	# install nspr-config
	insinto	 /usr/bin
	doins ${S}/build/config/nspr-config
	chmod a+x ${D}/usr/bin/nspr-config

	# create pkg-config file
	insinto /usr/$(get_libdir)/pkgconfig/
	doins ${S}/build/config/nspr.pc
}
