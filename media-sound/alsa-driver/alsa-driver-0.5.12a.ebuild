# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-driver/alsa-driver-0.5.12a.ebuild,v 1.3 2002/02/09 01:44:32 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Advanced Linux Sound Architecture modules"
SRC_URI="ftp://ftp.alsa-project.org/pub/driver/alsa-driver-${PV}.tar.bz2"
HOMEPAGE="http://www.alsa-project.org"

#virtual/glibc should depend on specific kernel headers
DEPEND="sys-devel/autoconf virtual/glibc"
PROVIDE="virtual/alsa"
KV=""

pkg_setup() {
	KV=`readlink /usr/src/linux`
	if [ $? -ne 0 ] ; then
		echo
		echo "/usr/src/linux symlink does not exist; cannot continue."
		echo
		die
	else
		#alsa-driver will compile modules for the kernel pointed to by /usr/src/linux
		KV=${KV/linux-/}
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	cp configure.in configure.in.orig
	sed -e 's/-m.86//g' configure.in.orig > configure.in
	autoconf
}

src_compile() {
	try ./configure --with-kernel="${ROOT}usr/src/linux-${KV}" --with-isapnp=yes --with-sequencer=yes --with-oss=yes --with-cards=all
	try emake
}

src_install () {
	#point this to the kernel headers in the future, not the kernel sources
	insinto /usr/include/linux
	cd ${S}/include
	doins asound.h asoundid.h asequencer.h ainstr_*.h
	dodoc INSTALL FAQ
	dodir /lib/modules/${KV}/misc
	cp ${S}/modules/*.o ${D}/lib/modules/${KV}/misc
	insinto /etc/modules.d
	doins ${FILESDIR}/alsa
	#this is the new modular modules system (from Debian) :)
}

pkg_postinst() {
	/usr/sbin/update-modules || return 0
}
